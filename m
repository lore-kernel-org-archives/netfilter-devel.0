From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH conntrack 5/5 v2] tests: conntrack: add netmask tests
Date: Mon, 25 Jan 2016 11:15:48 +0000
Message-ID: <1453720548-14413-5-git-send-email-ast@fiberby.dk>
References: <1453720548-14413-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:36689 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324AbcAYLQH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2016 06:16:07 -0500
In-Reply-To: <1453720548-14413-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---
 tests/conntrack/testsuite/01delete | 6 ++++++
 tests/conntrack/testsuite/02filter | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/tests/conntrack/testsuite/01delete b/tests/conntrack/tests=
uite/01delete
index 3c38ac5..566b89f 100644
--- a/tests/conntrack/testsuite/01delete
+++ b/tests/conntrack/testsuite/01delete
@@ -4,3 +4,9 @@
 -D -s 2.2.2.2 -p tcp --sport 10 --dport 20 ; BAD
 # delete by source
 -D -s 1.1.1.1 ; OK
+# re-create dummy
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -=
u SEEN_REPLY -t 50 ; OK
+# delete by netmask
+-D -s 1.1.1.0 --mask-src 255.255.255.0 -d 2.2.2.0 --mask-dst 255.255.2=
55.0 ; OK
+# fails due to 0 matches
+-D -s 1.1.1.0 --mask-src 255.255.255.0 -d 2.2.2.0 --mask-dst 255.255.2=
55.0 ; BAD
diff --git a/tests/conntrack/testsuite/02filter b/tests/conntrack/tests=
uite/02filter
index 204c4e8..5d2270b 100644
--- a/tests/conntrack/testsuite/02filter
+++ b/tests/conntrack/testsuite/02filter
@@ -19,5 +19,7 @@ conntrack -L -f ipv4 ; OK
 # filter by mark
 conntrack -L --mark 0 ; OK
 conntrack -L --mark 0/0xffffffff; OK
+# filter by netmask
+conntrack -L -s 1.1.1.0 --mask-src 255.255.255.0 -d 2.0.0.0 --mask-dst=
 255.0.0.0 ; OK
 # delete dummy
 conntrack -D -d 2.2.2.2 ; OK
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
