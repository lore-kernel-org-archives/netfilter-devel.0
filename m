Return-Path: <SRS0=RRXz=6T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1AA2C47259
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 19:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDE23206B9
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 19:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgEETFN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 15:05:13 -0400
Received: from correo.us.es ([193.147.175.20]:50968 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbgEETFM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 15:05:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5532B3066A0
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:05:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 465831158EB
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:05:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 434401158E9; Tue,  5 May 2020 21:05:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45E762132B
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:05:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 05 May 2020 21:05:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3204B42EE38E
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:05:08 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] src: ct_timeout: release policy string and state list
Date:   Tue,  5 May 2020 21:05:03 +0200
Message-Id: <20200505190503.11891-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200505190503.11891-1-pablo@netfilter.org>
References: <20200505190503.11891-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

=================================================================
==19037==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 18 byte(s) in 2 object(s) allocated from:
    #0 0x7ff6ee6f9810 in strdup (/usr/lib/x86_64-linux-gnu/libasan.so.5+0x3a810)
    #1 0x7ff6ee22666d in xstrdup /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:75
    #2 0x7ff6ee28cce9 in nft_parse /home/pablo/devel/scm/git-netfilter/nftables/src/parser_bison.c:5792
    #3 0x4b903f302c8010a  (<unknown module>)

Direct leak of 16 byte(s) in 1 object(s) allocated from:
    #0 0x7ff6ee7a8330 in __interceptor_malloc (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe9330)
    #1 0x7ff6ee226578 in xmalloc /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:36

SUMMARY: AddressSanitizer: 34 byte(s) leaked in 3 allocation(s).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c     | 1 +
 src/parser_bison.y | 1 +
 2 files changed, 2 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 4cf28987049b..9aa283fd2e12 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3902,6 +3902,7 @@ static int ct_timeout_evaluate(struct eval_ctx *ctx, struct obj *obj)
 
 		ct->timeout[ts->timeout_index] = ts->timeout_value;
 		list_del(&ts->head);
+		xfree(ts->timeout_str);
 		xfree(ts);
 	}
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 4369ece60ed0..39d3eac83b16 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3954,6 +3954,7 @@ ct_timeout_config	:	PROTOCOL	ct_l4protoname	stmt_separator
 
 				ct = &$<obj>0->ct_timeout;
 				list_splice_tail($4, &ct->timeout_list);
+				xfree($4);
 			}
 			|	L3PROTOCOL	family_spec_explicit	stmt_separator
 			{
-- 
2.20.1

