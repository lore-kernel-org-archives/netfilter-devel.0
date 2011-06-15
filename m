From: Florian Westphal <fw@strlen.de>
Subject: [PATCH conntrack-tools] testsuite: add tests for --mark option
Date: Wed, 15 Jun 2011 22:29:10 +0200
Message-ID: <1308169750-1509-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:56855 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753741Ab1FOU3j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:29:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 qa/testsuite/02filter |    3 +++
 qa/testsuite/05mark   |   27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)
 create mode 100644 qa/testsuite/05mark

diff --git a/qa/testsuite/02filter b/qa/testsuite/02filter
index 1ae9abd..204c4e8 100644
--- a/qa/testsuite/02filter
+++ b/qa/testsuite/02filter
@@ -16,5 +16,8 @@ conntrack -U -s 1.1.1.1 -m 1 ; OK
 conntrack -L -m 1 ; OK
 # filter by layer 3 protocol
 conntrack -L -f ipv4 ; OK
+# filter by mark
+conntrack -L --mark 0 ; OK
+conntrack -L --mark 0/0xffffffff; OK
 # delete dummy
 conntrack -D -d 2.2.2.2 ; OK
diff --git a/qa/testsuite/05mark b/qa/testsuite/05mark
new file mode 100644
index 0000000..4d99dea
--- /dev/null
+++ b/qa/testsuite/05mark
@@ -0,0 +1,27 @@
+# create with a mark
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 --mark 42 ; OK
+# find it again using mark
+-L -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --mark 42 ; OK
+-L --mark 42; OK
+# ct already exists
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 --mark 42/0xffffffff ; BAD
+# delete by mark
+-D -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --mark 42/0xffffffff ; OK
+# try again after del
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 --mark 417889/0xffffffff ; OK
+# delete by mark
+-D --mark 417889 ; OK
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 --mark 0xffffffff ; OK
+# zap top 16.
+-U -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --mark 0/0xffff0000 ; OK
+-L -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --mark 0x0000ffff ; OK
+-U -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --mark 42/0xffff ; OK
+-L -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --mark 42/0x0000ffff ; OK
+-L -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --mark 42/42 ; OK
+-L -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --mark 2/2 ; OK
+-L -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --mark 2/3 ; OK
+# OK, but no flow entries should be shown here:
+-L -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --mark 2/0xf ; OK
+# BAD, because no updates done (mark is already 42).
+-U -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --mark 42 ; BAD
+-D -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --mark 42 ; OK
-- 
1.7.3.4

