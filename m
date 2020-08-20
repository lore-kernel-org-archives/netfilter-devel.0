Return-Path: <SRS0=xTVu=B6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F511C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 12:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CEF1207BB
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 12:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730358AbgHTMNg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Aug 2020 08:13:36 -0400
Received: from correo.us.es ([193.147.175.20]:54396 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbgHTMNX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Aug 2020 08:13:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3DA521BFA82
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 14:13:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FD98DA78C
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 14:13:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2592CDA730; Thu, 20 Aug 2020 14:13:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D79F8DA704
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 14:13:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Aug 2020 14:13:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id C57C042EE38E
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 14:13:18 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/2] netfilter: nf_tables: incorrect enum nft_list_attributes definition
Date:   Thu, 20 Aug 2020 14:12:55 +0200
Message-Id: <20200820121255.25047-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200820121255.25047-1-pablo@netfilter.org>
References: <20200820121255.25047-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This should be NFTA_LIST_UNSPEC instead of NFTA_LIST_UNPEC, all other
similar attribute definitions are postfixed with _UNSPEC.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 42f351c1f5c5..2b8e12f7a4a6 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -133,7 +133,7 @@ enum nf_tables_msg_types {
  * @NFTA_LIST_ELEM: list element (NLA_NESTED)
  */
 enum nft_list_attributes {
-	NFTA_LIST_UNPEC,
+	NFTA_LIST_UNSPEC,
 	NFTA_LIST_ELEM,
 	__NFTA_LIST_MAX
 };
-- 
2.20.1

