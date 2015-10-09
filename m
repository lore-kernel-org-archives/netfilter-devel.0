From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC nft PATCH 0/3] new test suite
Date: Fri, 09 Oct 2015 14:38:06 +0200
Message-ID: <20151009123529.32207.81925.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de, kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:51458 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933328AbbJINsF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Oct 2015 09:48:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I suggest a testsuite like this, which can test higher level operations,
so more tests can be performed to the code apart of the regression tests:
 * listings/filterings
 * deletions/flushes
 * monitor operations
 * ruleset loadings with -f
 * interactive interface with -i (perhaps)

In patch 1/3 there is a description of this simple testbed.

If you like the idea I would be happy to add more tests cases.

---

Arturo Borrero Gonzalez (3):
      tests: add operations test-suite
      tests/operations: add maps tests cases
      tests/operations: add tests for handles and comments


 tests/operations/README                            |   23 ++++++
 tests/operations/run-operations-tests.sh           |   72 ++++++++++++++++++++
 .../operations/testcases/maps/anonymous_snat_map_0 |    7 ++
 tests/operations/testcases/maps/named_snat_map_0   |    9 +++
 tests/operations/testcases/optionals/comments_0    |    9 +++
 .../testcases/optionals/comments_handles_0         |   11 +++
 .../testcases/optionals/comments_handles_monitor_0 |   21 ++++++
 tests/operations/testcases/optionals/handles_0     |    9 +++
 tests/operations/testcases/optionals/handles_1     |    9 +++
 9 files changed, 170 insertions(+)
 create mode 100644 tests/operations/README
 create mode 100755 tests/operations/run-operations-tests.sh
 create mode 100755 tests/operations/testcases/maps/anonymous_snat_map_0
 create mode 100755 tests/operations/testcases/maps/named_snat_map_0
 create mode 100755 tests/operations/testcases/optionals/comments_0
 create mode 100755 tests/operations/testcases/optionals/comments_handles_0
 create mode 100755 tests/operations/testcases/optionals/comments_handles_monitor_0
 create mode 100755 tests/operations/testcases/optionals/handles_0
 create mode 100755 tests/operations/testcases/optionals/handles_1

--
