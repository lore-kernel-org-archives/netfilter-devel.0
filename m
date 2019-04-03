Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96ACCC4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 21:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 629C42082C
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 21:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfDCVl4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 17:41:56 -0400
Received: from mail.us.es ([193.147.175.20]:40910 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbfDCVl4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 17:41:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4A87411EB32
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2019 23:41:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C9B4DA701
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2019 23:41:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3227CDA70D; Wed,  3 Apr 2019 23:41:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CDA29DA701;
        Wed,  3 Apr 2019 23:41:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Apr 2019 23:41:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9049B4265A32;
        Wed,  3 Apr 2019 23:41:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mirq-boogs@rere.qmqm.pl, ffmancera@riseup.net, arturo@debian.org
Subject: [PATCH nft] parser_bison: missing tproxy syntax with port only for inet family
Date:   Wed,  3 Apr 2019 23:41:46 +0200
Message-Id: <20190403214146.12630-1-pablo@netfilter.org>
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
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1310
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 6 ++++++
 1 file changed, 6 insertions(+)

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
-- 
2.11.0

