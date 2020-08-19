Return-Path: <SRS0=iLnO=B5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07731C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 23:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEFB720758
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 23:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgHSXID (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Aug 2020 19:08:03 -0400
Received: from correo.us.es ([193.147.175.20]:33626 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgHSXIC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 19:08:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93C46DA702
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 01:08:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85168DA722
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 01:08:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7AB43DA704; Thu, 20 Aug 2020 01:08:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1577FDA730
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 01:07:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Aug 2020 01:07:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 02E74426CCB9
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 01:07:57 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] mergesort: unbreak listing with binops
Date:   Thu, 20 Aug 2020 01:07:33 +0200
Message-Id: <20200819230733.439-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

tcp flags == {syn, syn|ack}
tcp flags & (fin|syn|rst|psh|ack|urg) == {ack, psh|ack, fin, fin|psh|ack}

results in:

BUG: Unknown expression binop
nft: mergesort.c:47: expr_msort_cmp: Assertion `0' failed.
Aborted (core dumped)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mergesort.c             |  2 ++
 tests/py/inet/tcp.t         |  2 ++
 tests/py/inet/tcp.t.payload | 21 +++++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/src/mergesort.c b/src/mergesort.c
index 649b7806a7af..02094b486aeb 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -43,6 +43,8 @@ static int expr_msort_cmp(const struct expr *e1, const struct expr *e2)
 		return concat_expr_msort_cmp(e1, e2);
 	case EXPR_MAPPING:
 		return expr_msort_cmp(e1->left, e2->left);
+	case EXPR_BINOP:
+		return expr_msort_cmp(e1->left, e2->left);
 	default:
 		BUG("Unknown expression %s\n", expr_name(e1));
 	}
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index e0a83e2b4152..29f06f5ae484 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -79,6 +79,8 @@ tcp flags != cwr;ok
 tcp flags == syn;ok
 tcp flags & (syn|fin) == (syn|fin);ok;tcp flags & (fin | syn) == fin | syn
 tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr;ok;tcp flags == 0xff
+tcp flags { syn, syn | ack };ok
+tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack };ok
 
 tcp window 22222;ok
 tcp window 22;ok
diff --git a/tests/py/inet/tcp.t.payload b/tests/py/inet/tcp.t.payload
index 55f1bc2eff87..076e562a623c 100644
--- a/tests/py/inet/tcp.t.payload
+++ b/tests/py/inet/tcp.t.payload
@@ -680,3 +680,24 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000080 ]
 
+# tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack }
+__set%d test-inet 3
+__set%d test-inet 0
+        element 00000001  : 0 [end]     element 00000010  : 0 [end]     element 00000018  : 0 [end]     element 00000019  : 0 [end]
+ip
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000003f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# tcp flags { syn, syn | ack }
+__set%d test-inet 3
+__set%d test-inet 0
+        element 00000002  : 0 [end]     element 00000012  : 0 [end]
+inet
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
-- 
2.20.1

