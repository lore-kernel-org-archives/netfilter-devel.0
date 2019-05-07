Return-Path: <SRS0=SeaY=TH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259C6C004C9
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 May 2019 16:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C0D2054F
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 May 2019 16:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfEGQVg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 May 2019 12:21:36 -0400
Received: from mail.us.es ([193.147.175.20]:47958 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEGQVg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 May 2019 12:21:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 25053303D06
        for <netfilter-devel@vger.kernel.org>; Tue,  7 May 2019 18:21:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18057DA705
        for <netfilter-devel@vger.kernel.org>; Tue,  7 May 2019 18:21:34 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0CFCEDA707; Tue,  7 May 2019 18:21:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 022EBDA705;
        Tue,  7 May 2019 18:21:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 07 May 2019 18:21:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C5ADA4265A31;
        Tue,  7 May 2019 18:21:31 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     sveyret@gmail.com
Subject: [PATCH nf] netfilter: nf_tables: remove NFT_CT_TIMEOUT
Date:   Tue,  7 May 2019 18:21:26 +0200
Message-Id: <20190507162126.31176-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Never used anywhere in the code.

Fixes: 7e0b2b57f01d ("netfilter: nft_ct: add ct timeout support")
Reported-by: Stéphane Veyret <sveyret@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 061bb3eb20c3..983d11d7db05 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -966,7 +966,6 @@ enum nft_socket_keys {
  * @NFT_CT_DST_IP: conntrack layer 3 protocol destination (IPv4 address)
  * @NFT_CT_SRC_IP6: conntrack layer 3 protocol source (IPv6 address)
  * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
- * @NFT_CT_TIMEOUT: connection tracking timeout policy assigned to conntrack
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -992,7 +991,6 @@ enum nft_ct_keys {
 	NFT_CT_DST_IP,
 	NFT_CT_SRC_IP6,
 	NFT_CT_DST_IP6,
-	NFT_CT_TIMEOUT,
 	__NFT_CT_MAX
 };
 #define NFT_CT_MAX		(__NFT_CT_MAX - 1)
-- 
2.11.0

