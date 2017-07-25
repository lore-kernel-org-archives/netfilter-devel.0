From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 6/6] tests/monitor: Add a small README
Date: Tue, 25 Jul 2017 16:56:29 +0200
Message-ID: <20170725145629.20974-7-phil@nwl.cc>
References: <20170725145629.20974-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:39711 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752252AbdGYO5B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 10:57:01 -0400
In-Reply-To: <20170725145629.20974-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/README | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 tests/monitor/README

diff --git a/tests/monitor/README b/tests/monitor/README
new file mode 100644
index 0000000000000..9c5e37f5c75c9
--- /dev/null
+++ b/tests/monitor/README
@@ -0,0 +1,48 @@
+Simple NFT MONITOR Testsuite
+============================
+
+The purpose of this suite of tests is to assert correct 'nft monitor' output for
+known input. The suite consists of the single shell script 'run-tests.sh' which
+performs the tests and a number of test definition files in 'testcases/'. The
+latter have to be suffixed '.t' in order to be recognized as such.
+
+Test Case Syntax
+----------------
+
+Each testcase defines a number of commands to pass on to 'nft' binary and an
+associated 'nft monitor' output definition. Prerequisites for each command have
+to be established manually, i.e. in order to test monitor output when adding a
+chain, the table containing it has to be created first. In between each
+testcase, rule set is flushed completely.
+
+Input and output lines are prefixed by 'I' and 'O', respectively. The prefix has
+to be separated from the rest of the line by whitespace. Consecutive input lines
+are passed to 'nft' together, hence lead to a single transaction.
+
+Since in most cases output should be equal to input, there is a shortcut: If a
+line consists of 'O -' only, the test script uses all previous input lines as
+expected output directly.
+
+Empty lines and those starting with '#' are ignored.
+
+Test Script Semantics
+---------------------
+
+The script iterates over all test case files, reading them line by line. It
+assumes that sections of 'I' lines alternate with sections of 'O' lines. After
+stripping the prefix, each line is appended to a temporary file. There are
+separate files for input and output lines.
+
+If a set of input and output lines is complete (i.e. upon encountering either a
+new input line or end of file), a testrun is performed: 'nft monitor' is run in
+background, redirecting the output into a third file. The input file is passed
+to 'nft -f'. Finally 'nft monitor' is killed and it's output compared to the
+output file created earlier. If the files differ, a unified diff is printed and
+test execution aborts.
+
+After each testrun, input and output files are cleared.
+
+Note: Running 'nft monitor' in background is prone to race conditions. Hence
+an artificial delay is introduced before calling 'nft -f' to allow for 'nft
+monitor' to complete initialization and another one before comparing the output
+to allow for 'nft monitor' to process the netlink events.
-- 
2.13.1

