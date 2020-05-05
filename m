Return-Path: <SRS0=RRXz=6T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D342AC47247
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 19:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA579206B9
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 19:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgEETFL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 15:05:11 -0400
Received: from correo.us.es ([193.147.175.20]:50926 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728932AbgEETFK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 15:05:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 447C03066B4
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:05:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 336D04F0CB
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:05:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 325E94EA8F; Tue,  5 May 2020 21:05:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3382611541C
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:05:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 05 May 2020 21:05:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 16B6042EE38E
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:05:06 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/3] parser_bison: release extended priority string after parsing
Date:   Tue,  5 May 2020 21:05:01 +0200
Message-Id: <20200505190503.11891-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

==29581==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 1034 byte(s) in 152 object(s) allocated from:
    #0 0x7f7b55f1b810 in strdup (/usr/lib/x86_64-linux-gnu/libasan.so.5+0x3a810)
    #1 0x7f7b559597e0 in xstrdup /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:75
    #2 0x7f7b55a494a0 in nft_lex /home/pablo/devel/scm/git-netfilter/nftables/src/scanner.l:641
    #3 0x7f7b559cec25 in nft_parse /home/pablo/devel/scm/git-netfilter/nftables/src/parser_bison.c:5792
    #4 0x7f7b5597e318 in nft_parse_bison_filename /home/pablo/devel/scm/git-netfilter/nftables/src/libnftables.c:392
    #5 0x7f7b5597f864 in nft_run_cmd_from_filename /home/pablo/devel/scm/git-netfilter/nftables/src/libnftables.c:495
    #6 0x562a25bbce71 in main /home/pablo/devel/scm/git-netfilter/nftables/src/main.c:457
    #7 0x7f7b5457509a in __libc_start_main ../csu/libc-start.c:308

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3cd0559b2912..0190dbb88c97 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2167,6 +2167,7 @@ extended_prio_spec	:	int_num
 								BYTEORDER_HOST_ENDIAN,
 								strlen(str) * BITS_PER_BYTE,
 								str);
+				xfree($1);
 				$$ = spec;
 			}
 			;
-- 
2.20.1

