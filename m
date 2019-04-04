Return-Path: <SRS0=UjrQ=SG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD1FC4360F
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 11:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B453D206C0
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 11:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbfDDLjv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Apr 2019 07:39:51 -0400
Received: from mail.us.es ([193.147.175.20]:58328 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfDDLjv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Apr 2019 07:39:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9F24E12BFF6
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Apr 2019 13:39:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90DD8DA70C
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Apr 2019 13:39:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8697EDA70B; Thu,  4 Apr 2019 13:39:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3E3ADA702;
        Thu,  4 Apr 2019 13:39:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 04 Apr 2019 13:39:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B605E40705C0;
        Thu,  4 Apr 2019 13:39:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mirq-boogs@rere.qmqm.pl, ffmancera@riseup.net, arturo@debian.org
Subject: [PATCH nft 1/2,v2] parser_bison: missing tproxy syntax with port only for inet family
Date:   Thu,  4 Apr 2019 13:39:41 +0200
Message-Id: <20190404113942.26263-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # nft add rule inet filter divert ip daddr 0.0.0.0/0 meta l4proto tcp tproxy ip to :2000
 Error: syntax error, unexpected colon
 add rule inet filter divert ip daddr 0.0.0.0/0 meta l4proto tcp tproxy ip to :2000
                                                                              ^

Syntax with no protocol for tproxy complains with:

 # nft add rule inet filter divert ip daddr 0.0.0.0/0 meta l4proto tcp tproxy to :2000
 Error: Conflicting network layer protocols.
 add rule inet filter divert ip daddr 0.0.0.0/0 meta l4proto tcp tproxy to :2000
                                                                 ^^^^^^^^^^^^^^^

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1310
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y             |  6 ++++++
 tests/py/inet/tproxy.t         |  5 +++--
 tests/py/inet/tproxy.t.payload | 26 ++++++++++++++++++++++++++
 tests/py/ip/tproxy.t           |  2 +-
 tests/py/ip/tproxy.t.payload   |  8 ++++++++
 tests/py/ip6/tproxy.t          |  2 +-
 tests/py/ip6/tproxy.t.payload  |  7 +++++++
 7 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 65b3fb3ebac2..50642b4e02f4 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2687,6 +2687,12 @@ tproxy_stmt		:	TPROXY TO stmt_expr
 				$$->tproxy.addr = $4;
 				$$->tproxy.port = $6;
 			}
+			|	TPROXY nf_key_proto	TO COLON stmt_expr
+			{
+				$$ = tproxy_stmt_alloc(&@$);
+				$$->tproxy.family = $2;
+				$$->tproxy.port = $5;
+			}
 			;
 
 primary_stmt_expr	:	symbol_expr		{ $$ = $1; }
diff --git a/tests/py/inet/tproxy.t b/tests/py/inet/tproxy.t
index f80f77347b86..0ba78ef1826a 100644
--- a/tests/py/inet/tproxy.t
+++ b/tests/py/inet/tproxy.t
@@ -15,6 +15,7 @@ meta l4proto 6 tproxy ip6 to [2001:db8::1];ok
 meta l4proto 17 tproxy ip6 to [2001:db8::1]:50080;ok
 ip6 nexthdr 6 tproxy ip to 192.0.2.1;fail
 
-meta l4proto 17 tproxy ip to :50080;fail
-meta l4proto 17 tproxy ip6 to :50080;fail
+meta l4proto 17 tproxy ip to :50080;ok
+meta l4proto 17 tproxy ip6 to :50080;ok
 meta l4proto 17 tproxy to :50080;ok
+ip daddr 0.0.0.0/0 meta l4proto tcp tproxy ip to :2000;ok
diff --git a/tests/py/inet/tproxy.t.payload b/tests/py/inet/tproxy.t.payload
index 4b18460d8b8d..8a6ba0365605 100644
--- a/tests/py/inet/tproxy.t.payload
+++ b/tests/py/inet/tproxy.t.payload
@@ -35,3 +35,29 @@ inet x y
   [ immediate reg 1 0x0000a0c3 ]
   [ tproxy port reg 1 ]
 
+# meta l4proto 17 tproxy ip to :50080
+inet x y 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ immediate reg 1 0x0000a0c3 ]
+  [ tproxy ip port reg 1 ]
+
+# meta l4proto 17 tproxy ip6 to :50080
+inet x y 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ immediate reg 1 0x0000a0c3 ]
+  [ tproxy ip6 port reg 1 ]
+
+# ip daddr 0.0.0.0/0 meta l4proto tcp tproxy ip to :2000
+inet x y 
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000000 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x0000d007 ]
+  [ tproxy ip port reg 1 ]
+
diff --git a/tests/py/ip/tproxy.t b/tests/py/ip/tproxy.t
index dbd8f5e90a04..966898c037b2 100644
--- a/tests/py/ip/tproxy.t
+++ b/tests/py/ip/tproxy.t
@@ -11,4 +11,4 @@ meta l4proto 6 tproxy to 192.0.2.1:50080;ok
 ip protocol 6 tproxy to :50080;ok
 meta l4proto 17 tproxy ip to 192.0.2.1;ok;meta l4proto 17 tproxy to 192.0.2.1
 meta l4proto 6 tproxy ip to 192.0.2.1:50080;ok;meta l4proto 6 tproxy to 192.0.2.1:50080
-ip protocol 6 tproxy ip to :50080;fail
+ip protocol 6 tproxy ip to :50080;ok
diff --git a/tests/py/ip/tproxy.t.payload b/tests/py/ip/tproxy.t.payload
index 035651f48cb3..dfe830ec3715 100644
--- a/tests/py/ip/tproxy.t.payload
+++ b/tests/py/ip/tproxy.t.payload
@@ -34,3 +34,11 @@ ip x y
   [ immediate reg 1 0x010200c0 ]
   [ immediate reg 2 0x0000a0c3 ]
   [ tproxy ip addr reg 1 port reg 2 ]
+
+# ip protocol 6 tproxy ip to :50080
+ip x y 
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x0000a0c3 ]
+  [ tproxy ip port reg 1 ]
+
diff --git a/tests/py/ip6/tproxy.t b/tests/py/ip6/tproxy.t
index 4e48d81f13cc..48fe4ca76505 100644
--- a/tests/py/ip6/tproxy.t
+++ b/tests/py/ip6/tproxy.t
@@ -11,4 +11,4 @@ meta l4proto 17 tproxy to [2001:db8::1]:50080;ok
 meta l4proto 6 tproxy to :50080;ok
 meta l4proto 6 tproxy ip6 to [2001:db8::1];ok;meta l4proto 6 tproxy to [2001:db8::1]
 meta l4proto 17 tproxy ip6 to [2001:db8::1]:50080;ok;meta l4proto 17 tproxy to [2001:db8::1]:50080
-meta l4proto 6 tproxy ip6 to :50080;fail
+meta l4proto 6 tproxy ip6 to :50080;ok
diff --git a/tests/py/ip6/tproxy.t.payload b/tests/py/ip6/tproxy.t.payload
index c78c8a1dd20a..9f28e80b4142 100644
--- a/tests/py/ip6/tproxy.t.payload
+++ b/tests/py/ip6/tproxy.t.payload
@@ -35,3 +35,10 @@ ip6 x y
   [ immediate reg 2 0x0000a0c3 ]
   [ tproxy ip6 addr reg 1 port reg 2 ]
 
+# meta l4proto 6 tproxy ip6 to :50080
+ip6 x y 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x0000a0c3 ]
+  [ tproxy ip6 port reg 1 ]
+
-- 
2.11.0

