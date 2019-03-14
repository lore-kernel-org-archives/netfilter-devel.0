Return-Path: <SRS0=rsEJ=RR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D04C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 10:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2C602064A
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 10:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfCNKSQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 06:18:16 -0400
Received: from mail.us.es ([193.147.175.20]:50642 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbfCNKSQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 06:18:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 813251F4B84
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 11:18:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D544DA86E
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 11:18:14 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6B0AEDA864; Thu, 14 Mar 2019 11:18:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B022FDA86F;
        Thu, 14 Mar 2019 11:18:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 Mar 2019 11:18:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7B3974265A4C;
        Thu, 14 Mar 2019 11:18:11 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     nevola@gmail.com
Subject: [PATCH nft] parser_bison: no need for statement separator for ct object commands
Date:   Thu, 14 Mar 2019 11:18:08 +0100
Message-Id: <20190314101808.5231-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise, this forces user to place a double semi-colon to skip a
parser error in a multi-line commands:

 # nft add "ct helper ip filter test { type \"ftp\" protocol tcp; };add rule filter test ct helper set \"ftp\""
 Error: syntax error, unexpected add, expecting end of file or newline or semicolon
 add ct helper ip filter test { type "ftp" protocol tcp; };add rule filter test ct helper set "ftp"
                                                           ^^^

Reported-by: Laura Garcia <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index b20be3a896b0..48e44e5adc40 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -986,12 +986,12 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
-			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_helper_block '}'	stmt_separator
+			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_helper_block '}'
 			{
 
 				$$ = cmd_alloc_obj_ct(CMD_ADD, NFT_OBJECT_CT_HELPER, &$3, &@$, $4);
 			}
-			|	CT	TIMEOUT obj_spec	ct_obj_alloc	'{' ct_timeout_block '}' stmt_separator
+			|	CT	TIMEOUT obj_spec	ct_obj_alloc	'{' ct_timeout_block '}'
 			{
 				$$ = cmd_alloc_obj_ct(CMD_ADD, NFT_OBJECT_CT_TIMEOUT, &$3, &@$, $4);
 			}
@@ -1076,11 +1076,11 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
-			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_helper_block '}'	stmt_separator
+			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_helper_block '}'
 			{
 				$$ = cmd_alloc_obj_ct(CMD_CREATE, NFT_OBJECT_CT_HELPER, &$3, &@$, $4);
 			}
-			|	CT	TIMEOUT obj_spec	ct_obj_alloc	'{' ct_timeout_block '}' stmt_separator
+			|	CT	TIMEOUT obj_spec	ct_obj_alloc	'{' ct_timeout_block '}'
 			{
 				$$ = cmd_alloc_obj_ct(CMD_CREATE, NFT_OBJECT_CT_TIMEOUT, &$3, &@$, $4);
 			}
-- 
2.11.0

