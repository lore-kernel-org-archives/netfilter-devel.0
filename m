From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC] netfilter: nf_tables: defer all object release via
 rcu
Date: Thu, 10 Apr 2014 14:39:49 +0200
Message-ID: <20140410123949.GA3954@localhost>
References: <1397130696-3760-1-git-send-email-pablo@netfilter.org>
 <5346882B.30605@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55477 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030279AbaDJMj5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:39:57 -0400
Content-Disposition: inline
In-Reply-To: <5346882B.30605@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 10, 2014 at 03:01:47PM +0300, Tomasz Bursztyka wrote:
> Hi  Pablo,
> 
> 2 minor issues.
> 
> >  include/net/netfilter/nf_tables.h |    2 +
> >  net/netfilter/nf_tables_api.c     |  100 ++++++++++++++++++++++---------------
> >  2 files changed, 62 insertions(+), 40 deletions(-)
> >
> >diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> >index b08f2a9..65656f7 100644
> >--- a/include/net/netfilter/nf_tables.h
> >+++ b/include/net/netfilter/nf_tables.h
> >@@ -391,12 +391,14 @@ struct nft_rule {
> >  /**
> >   *	struct nft_trans - nf_tables object update in transaction
> >   *
> >+ *	rcu_head: rcu head to defer release of transaction data
> 
> an '@' is missing

Right.

> >   *	@list: used internally
> >   *	@msg_type: message type
> >   *	@ctx: transaction context
> >   *	@data: internal information related to the transaction
> >   */
> >  struct nft_trans {
> >+	struct rcu_head			rcu_head;
> >  	struct list_head		list;
> >  	int				msg_type;
> >  	struct nft_ctx			ctx;
> >diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> >index 5606ae30..fd03212 100644
> >--- a/net/netfilter/nf_tables_api.c
> >+++ b/net/netfilter/nf_tables_api.c
> >@@ -2612,7 +2612,8 @@ static void nft_set_destroy(struct nft_set *set)
> >  static void nf_tables_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
> >  {
> >  	list_del(&set->list);
> >-	nf_tables_set_notify(ctx, set, NFT_MSG_DELSET);
> >+	if (!set->flags & NFT_SET_ANONYMOUS)
> >+		nf_tables_set_notify(ctx, set, NFT_MSG_DELSET);
> 
> It's a fix for anonymous set, so it's should be on another patch.

Not a fix, we currently have anonymous set notifications which are
possible.  Please, have a look at the changelog in this patch, it
discusses the reason for this and alternative solutions.
