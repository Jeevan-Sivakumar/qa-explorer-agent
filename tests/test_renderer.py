import importlib.util
from pathlib import Path
import unittest
spec=importlib.util.spec_from_file_location('renderer',Path(__file__).resolve().parents[1]/'scripts'/'render_report.py')
module=importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

class RendererTests(unittest.TestCase):
    def test_escapes_untrusted_content(self):
        out=module.render({'run_id':'<script>alert(1)</script>','findings':[{'status':'confirmed','title':'<img src=x onerror=alert(1)>','network':[]}], 'coverage':[]})
        self.assertNotIn('<script>',out)
        self.assertNotIn('<img src=x',out)
        self.assertIn('&lt;script&gt;',out)
    def test_evidence_paths(self):
        for value in ['javascript:alert(1)','file:///secret','../secret','https://remote.test/data','C:\\secret']:
            self.assertNotIn('<a ',module.evidence_link(value))
        self.assertIn('<a ',module.evidence_link('evidence/page.png'))
    def test_ticket_requires_https(self):
        out=module.render({'coverage':[],'findings':[{'jira_url':'javascript:alert(1)'}]})
        self.assertNotIn('Open Jira ticket',out)
        out=module.render({'coverage':[],'findings':[{'jira_url':'https://example.atlassian.net/browse/QA-1'}]})
        self.assertIn('Open Jira ticket',out)
    def test_empty_template_does_not_invent_results(self):
        out=module.render({'coverage':[],'findings':[],'verdict':'Not run'})
        self.assertIn('0 listed checks',out)
        self.assertIn('Not run',out)
        self.assertIn('pass: 0',out)

if __name__=='__main__':unittest.main()
