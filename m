Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37A6C001B0
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Aug 2023 11:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbjHILQx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 07:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbjHILQw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 07:16:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D53172A;
        Wed,  9 Aug 2023 04:16:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7F3662841;
        Wed,  9 Aug 2023 11:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8055C433C7;
        Wed,  9 Aug 2023 11:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1691579811;
        bh=KaaLgaKfLr+MtyI+szDyMC5AbVhnpQgr+qqtE/3DtJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQbuGqCFpGvzAgpk75aqJcYbuAPTwSzsfj8VLmnVZI4Ob/mTxChxgoqKpV/liml2p
         J6NfD/cjcFwqM1+xnH5/kcYpS8q1YS3Zblp4doA3SEH1zN0mlU2aIlKtlou9r8Ag4a
         6KlsFza/N1m2+w+2Ws0M6z8XAtY/9WhrfWzWGgH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+2570f2c036e3da5db176@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 124/323] netfilter: nf_tables: fix nat hook table deletion
Date:   Wed,  9 Aug 2023 12:39:22 +0200
Message-ID: <20230809103703.799831783@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ 1e9451cbda456a170518b2bfd643e2cb980880bf ]

sybot came up with following transaction:
 add table ip syz0
 add chain ip syz0 syz2 { type nat hook prerouting priority 0; policy accept; }
 add table ip syz0 { flags dormant; }
 delete chain ip syz0 syz2
 delete table ip syz0

which yields:
hook not found, pf 2 num 0
WARNING: CPU: 0 PID: 6775 at net/netfilter/core.c:413 __nf_unregister_net_hook+0x3e6/0x4a0 net/netfilter/core.c:413
[..]
 nft_unregister_basechain_hooks net/netfilter/nf_tables_api.c:206 [inline]
 nft_table_disable net/netfilter/nf_tables_api.c:835 [inline]
 nf_tables_table_disable net/netfilter/nf_tables_api.c:868 [inline]
 nf_tables_commit+0x32d3/0x4d70 net/netfilter/nf_tables_api.c:7550
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:486 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:544 [inline]
 nfnetlink_rcv+0x14a5/0x1e50 net/netfilter/nfnetlink.c:562
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]

Problem is that when I added ability to override base hook registration
to make nat basechains register with the nat core instead of netfilter
core, I forgot to update nft_table_disable() to use that instead of
the 'raw' hook register interface.

In syzbot transaction, the basechain is of 'nat' type. Its registered
with the nat core.  The switch to 'dormant mode' attempts to delete from
netfilter core instead.

After updating nft_table_disable/enable to use the correct helper,
nft_(un)register_basechain_hooks can be folded into the only remaining
caller.

Because nft_trans_table_enable() won't do anything when the DORMANT flag
is set, remove the flag first, then re-add it in case re-enablement
fails, else this patch breaks sequence:

add table ip x { flags dormant; }
/* add base chains */
add table ip x

The last 'add' will remove the dormant flags, but won't have any other
effect -- base chains are not registered.
Then, next 'set dormant flag' will create another 'hook not found'
splat.

Reported-by: syzbot+2570f2c036e3da5db176@syzkaller.appspotmail.com
Fixes: 4e25ceb80b58 ("netfilter: nf_tables: allow chain type to override hook register")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
(cherry picked from commit 1e9451cbda456a170518b2bfd643e2cb980880bf)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -743,7 +743,7 @@ static void nft_table_disable(struct net
 		if (cnt && i++ == cnt)
 			break;
 
-		nf_unregister_net_hook(net, &nft_base_chain(chain)->ops);
+		nf_tables_unregister_hook(net, table, chain);
 	}
 }
 
@@ -758,7 +758,7 @@ static int nf_tables_table_enable(struct
 		if (!nft_is_base_chain(chain))
 			continue;
 
-		err = nf_register_net_hook(net, &nft_base_chain(chain)->ops);
+		err = nf_tables_register_hook(net, table, chain);
 		if (err < 0)
 			goto err;
 
@@ -802,11 +802,12 @@ static int nf_tables_updtable(struct nft
 		nft_trans_table_enable(trans) = false;
 	} else if (!(flags & NFT_TABLE_F_DORMANT) &&
 		   ctx->table->flags & NFT_TABLE_F_DORMANT) {
+		ctx->table->flags &= ~NFT_TABLE_F_DORMANT;
 		ret = nf_tables_table_enable(ctx->net, ctx->table);
-		if (ret >= 0) {
-			ctx->table->flags &= ~NFT_TABLE_F_DORMANT;
+		if (ret >= 0)
 			nft_trans_table_enable(trans) = true;
-		}
+		else
+			ctx->table->flags |= NFT_TABLE_F_DORMANT;
 	}
 	if (ret < 0)
 		goto err;


