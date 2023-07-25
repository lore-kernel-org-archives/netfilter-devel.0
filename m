Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84373C04A6A
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jul 2023 11:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbjGYLo0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jul 2023 07:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235088AbjGYLn7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2023 07:43:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D748199D;
        Tue, 25 Jul 2023 04:43:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B9536169A;
        Tue, 25 Jul 2023 11:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA3CC433C7;
        Tue, 25 Jul 2023 11:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1690285437;
        bh=hlSLYnyHE2PYsIS1TTQrcdNBUBX6wvATSShZmvwchk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYdiUK9yWeFoaML+5aY+QqZqXDMU9AWYMjRZM+4eQegP191+6Qdmmq19gTbcEN1Ru
         XOjCUvxqew7kltp7wqlPblYAGbKc4uL9wKV80m2EFICJIDYHnIUdAKjZ1NbPGnVfDB
         6sjmNJX6Z0cpTLfP+DYRrNCxzCXYqgkHRSpQPZlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 187/313] netfilter: nf_tables: unbind non-anonymous set if rule construction fails
Date:   Tue, 25 Jul 2023 12:45:40 +0200
Message-ID: <20230725104529.052399107@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ 3e70489721b6c870252c9082c496703677240f53 ]

Otherwise a dangling reference to a rule object that is gone remains
in the set binding list.

Fixes: 26b5a5712eb8 ("netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3987,6 +3987,8 @@ void nf_tables_deactivate_set(const stru
 		nft_set_trans_unbind(ctx, set);
 		if (nft_set_is_anonymous(set))
 			nft_deactivate_next(ctx->net, set);
+		else
+			list_del_rcu(&binding->list);
 
 		set->use--;
 		break;


