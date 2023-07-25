Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C618C0015E
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jul 2023 11:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbjGYL05 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jul 2023 07:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbjGYL04 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2023 07:26:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6D2A6;
        Tue, 25 Jul 2023 04:26:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 396D46168E;
        Tue, 25 Jul 2023 11:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A7EC433C8;
        Tue, 25 Jul 2023 11:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1690284414;
        bh=buOdSrwBY2i9Z3LLwxVY+Rr6q8F4NyizMsrrqrJmxcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bV2siBkqi244jcje+UmxtaD2ZE2qGoHczlkC3djc1lcHTVtpUdB3xDV3fgFYPkOcT
         rjI/7V9qBBsQLUuAuXOxc1WF6+4FDaoA3w4Zp3/8jr7TwJkGLHAgQdmDnfB2nEVZlO
         sJGyIsKg5JYNnHTm2j/fk2eF+m1r4UwRR6aPbl78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 318/509] netfilter: nf_tables: reject unbound chain set before commit phase
Date:   Tue, 25 Jul 2023 12:44:17 +0200
Message-ID: <20230725104608.265852367@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 62e1e94b246e685d89c3163aaef4b160e42ceb02 ]

Use binding list to track set transaction and to check for unbound
chains before entering the commit phase.

Bail out if chain binding remain unused before entering the commit
step.

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -360,6 +360,11 @@ static void nft_trans_commit_list_add_ta
 		if (nft_set_is_anonymous(nft_trans_set(trans)))
 			list_add_tail(&trans->binding_list, &nft_net->binding_list);
 		break;
+	case NFT_MSG_NEWCHAIN:
+		if (!nft_trans_chain_update(trans) &&
+		    nft_chain_binding(nft_trans_chain(trans)))
+			list_add_tail(&trans->binding_list, &nft_net->binding_list);
+		break;
 	}
 
 	list_add_tail(&trans->list, &nft_net->commit_list);
@@ -8043,6 +8048,14 @@ static int nf_tables_commit(struct net *
 				return -EINVAL;
 			}
 			break;
+		case NFT_MSG_NEWCHAIN:
+			if (!nft_trans_chain_update(trans) &&
+			    nft_chain_binding(nft_trans_chain(trans)) &&
+			    !nft_trans_chain_bound(trans)) {
+				pr_warn_once("nftables ruleset with unbound chain\n");
+				return -EINVAL;
+			}
+			break;
 		}
 	}
 


