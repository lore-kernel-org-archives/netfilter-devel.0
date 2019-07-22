Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB94C7618F
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 21:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1832521900
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 21:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbfGVV0D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 17:26:03 -0400
Received: from mail.us.es ([193.147.175.20]:41128 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728822AbfGVV0D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 17:26:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A55CC80D06
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 23:26:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 928C54CA35
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 23:26:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8827FDA708; Mon, 22 Jul 2019 23:26:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B610DA708;
        Mon, 22 Jul 2019 23:25:59 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Jul 2019 23:25:59 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.183.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B54CB4265A31;
        Mon, 22 Jul 2019 23:25:58 +0200 (CEST)
Date:   Mon, 22 Jul 2019 23:25:56 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH nft 3/3] src: evaluate: return immediately if no op was
 requested
Message-ID: <20190722212556.gnxhgqlnrqt2epgg@salvia>
References: <20190721001406.23785-1-fw@strlen.de>
 <20190721001406.23785-4-fw@strlen.de>
 <20190721184901.n5ea7kpn246bddnb@salvia>
 <20190721185040.5ueush32pe7zta2k@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sbyboaasd55nixmf"
Content-Disposition: inline
In-Reply-To: <20190721185040.5ueush32pe7zta2k@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--sbyboaasd55nixmf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 21, 2019 at 08:50:40PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sun, Jul 21, 2019 at 02:14:07AM +0200, Florian Westphal wrote:
> > > This makes nft behave like 0.9.0 -- the ruleset
> > > 
> > > flush ruleset
> > > table inet filter {
> > > }
> > > table inet filter {
> > >       chain test {
> > >         counter
> > >     }
> > > }
> > > 
> > > loads again without generating an error message.
> > > I've added a test case for this, without this it will create an error,
> > > and with a checkout of the 'fixes' tag we get crash.
> > > 
> > > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1351
> > > Fixes: e5382c0d08e3c ("src: Support intra-transaction rule references")
> > 
> > This one is causing the cache corruption, right?
> 
> There is no cache corruption.  This patch makes us enter a code
> path that we did not take before.

Sorry, I mean, this is a cache bug :-)

cache_flush() is cheating, it sets flags to CACHE_FULL, hence this
enters this codepath we dit not take before. This propagates from the
previous logic, as a workaround.

I made this patch, to skip the cache in case "flush ruleset" is
requested.

This breaks testcases/transactions/0024rule_0, which is a recent test
from Phil to check for intra-transaction references, I don't know yet
what makes this code unhappy with my changes.

Phil, would you help me have a look at what assumption breaks? Thanks.

--sbyboaasd55nixmf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/cache.h b/include/cache.h
index d3502a8a6039..526f6ca57f74 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -30,6 +30,7 @@ enum cache_level_flags {
 				  NFT_CACHE_CHAIN_BIT |
 				  NFT_CACHE_RULE_BIT,
 	NFT_CACHE_FULL		= __NFT_CACHE_MAX_BIT - 1,
+	NFT_CACHE_FLUSHED	= (1 << 31),
 };
 
 #endif /* _NFT_CACHE_H_ */
diff --git a/include/rule.h b/include/rule.h
index 67c3d3314953..d66e03456ad2 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -679,7 +679,6 @@ extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd);
 extern unsigned int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds);
 extern int cache_update(struct nft_ctx *ctx, enum cmd_ops cmd,
 			struct list_head *msgs);
-extern void cache_flush(struct nft_ctx *ctx, struct list_head *msgs);
 extern void cache_release(struct nft_cache *cache);
 extern bool cache_is_complete(struct nft_cache *cache, enum cmd_ops cmd);
 
diff --git a/src/cache.c b/src/cache.c
index e04ead85c830..2f16eee17780 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -72,6 +72,8 @@ static unsigned int evaluate_cache_flush(struct cmd *cmd, unsigned int flags)
 		flags |= NFT_CACHE_SET;
 		break;
 	case CMD_OBJ_RULESET:
+		flags |= NFT_CACHE_FLUSHED;
+		break;
 	default:
 		flags = NFT_CACHE_EMPTY;
 		break;
diff --git a/src/evaluate.c b/src/evaluate.c
index c6cc6ccad75d..b83c77ae4991 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3776,7 +3776,6 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 
 	switch (cmd->obj) {
 	case CMD_OBJ_RULESET:
-		cache_flush(ctx->nft, ctx->msgs);
 		break;
 	case CMD_OBJ_TABLE:
 		/* Flushing a table does not empty the sets in the table nor remove
diff --git a/src/rule.c b/src/rule.c
index b957b4571249..d8a243342434 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -234,6 +234,11 @@ static bool cache_is_updated(struct nft_cache *cache, uint16_t genid)
 	return genid && genid == cache->genid;
 }
 
+static bool cache_is_flushed(struct nft_cache *cache)
+{
+	return cache->flags & NFT_CACHE_FLUSHED;
+}
+
 int cache_update(struct nft_ctx *nft, unsigned int flags, struct list_head *msgs)
 {
 	struct netlink_ctx ctx = {
@@ -255,6 +260,9 @@ replay:
 	if (cache->genid)
 		cache_release(cache);
 
+	if (cache_is_flushed(cache))
+		goto skip;
+
 	ret = cache_init(&ctx, flags);
 	if (ret < 0) {
 		cache_release(cache);
@@ -270,7 +278,7 @@ replay:
 		cache_release(cache);
 		goto replay;
 	}
-
+skip:
 	cache->genid = genid;
 	cache->flags = flags;
 	return 0;
@@ -286,20 +294,6 @@ static void __cache_flush(struct list_head *table_list)
 	}
 }
 
-void cache_flush(struct nft_ctx *nft, struct list_head *msgs)
-{
-	struct netlink_ctx ctx = {
-		.list		= LIST_HEAD_INIT(ctx.list),
-		.nft		= nft,
-		.msgs		= msgs,
-	};
-	struct nft_cache *cache = &nft->cache;
-
-	__cache_flush(&cache->list);
-	cache->genid = mnl_genid_get(&ctx);
-	cache->flags = NFT_CACHE_FULL;
-}
-
 void cache_release(struct nft_cache *cache)
 {
 	__cache_flush(&cache->list);

--sbyboaasd55nixmf--
