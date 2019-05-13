Return-Path: <SRS0=R8c+=TN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89AC7C04AB1
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 09:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C4E720989
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 09:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbfEMJ4s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 May 2019 05:56:48 -0400
Received: from mail.us.es ([193.147.175.20]:34240 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728796AbfEMJ4r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 May 2019 05:56:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C94E04DE734
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2019 11:56:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9CC9DA715
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2019 11:56:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AF756DA713; Mon, 13 May 2019 11:56:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3703DA70B;
        Mon, 13 May 2019 11:56:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 May 2019 11:56:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7EAF14265A31;
        Mon, 13 May 2019 11:56:42 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 12/13] netfilter: nf_tables: remove NFT_CT_TIMEOUT
Date:   Mon, 13 May 2019 11:56:29 +0200
Message-Id: <20190513095630.32443-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190513095630.32443-1-pablo@netfilter.org>
References: <20190513095630.32443-1-pablo@netfilter.org>
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
index a66c8de006cc..92bb1e2b2425 100644
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

