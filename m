From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH conntrack 4/4] tests: conntrack: add tests for CIDR notation
Date: Mon,  1 Feb 2016 13:30:07 +0000
Message-ID: <1454333407-6335-4-git-send-email-ast@fiberby.dk>
References: <1454333407-6335-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:47413 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223AbcBANin (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 08:38:43 -0500
In-Reply-To: <1454333407-6335-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---
 tests/conntrack/testsuite/01delete | 4 ++++
 tests/conntrack/testsuite/02filter | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/tests/conntrack/testsuite/01delete b/tests/conntrack/tests=
uite/01delete
index 566b89f..194d999 100644
--- a/tests/conntrack/testsuite/01delete
+++ b/tests/conntrack/testsuite/01delete
@@ -10,3 +10,7 @@
 -D -s 1.1.1.0 --mask-src 255.255.255.0 -d 2.2.2.0 --mask-dst 255.255.2=
55.0 ; OK
 # fails due to 0 matches
 -D -s 1.1.1.0 --mask-src 255.255.255.0 -d 2.2.2.0 --mask-dst 255.255.2=
55.0 ; BAD
+# re-create dummy
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -=
u SEEN_REPLY -t 50 ; OK
+# try same command again but with CIDR
+-D -s 1.1.1.0/24 -d 2.2.2.0/24 ; OK
diff --git a/tests/conntrack/testsuite/02filter b/tests/conntrack/tests=
uite/02filter
index 5d2270b..58ed070 100644
--- a/tests/conntrack/testsuite/02filter
+++ b/tests/conntrack/testsuite/02filter
@@ -21,5 +21,7 @@ conntrack -L --mark 0 ; OK
 conntrack -L --mark 0/0xffffffff; OK
 # filter by netmask
 conntrack -L -s 1.1.1.0 --mask-src 255.255.255.0 -d 2.0.0.0 --mask-dst=
 255.0.0.0 ; OK
+conntrack -L -s 1.1.1.4/24 -d 2.3.4.5/8 ; OK
+conntrack -L -s 1.1.2.0/24 -d 2.3.4.5/8 ; BAD
 # delete dummy
 conntrack -D -d 2.2.2.2 ; OK
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
