From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] netfilter: nf_tables: fix transaction race condition
Date: Wed, 4 Mar 2015 18:01:02 +0100
Message-ID: <20150304170102.GA7589@salvia>
References: <1425413060-6187-1-git-send-email-kaber@trash.net>
 <1425413060-6187-2-git-send-email-kaber@trash.net>
 <20150304161801.GA3878@salvia>
 <20150304162612.GS29506@acer.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36029 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758655AbbCDQ50 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Mar 2015 11:57:26 -0500
Content-Disposition: inline
In-Reply-To: <20150304162612.GS29506@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 04, 2015 at 04:26:13PM +0000, Patrick McHardy wrote:
> On 04.03, Pablo Neira Ayuso wrote:
> > On Tue, Mar 03, 2015 at 08:04:18PM +0000, Patrick McHardy wrote:
> > > A race condition exists in the rule transaction code for rules that
> > > get added and removed within the same transaction.
> > > 
> > > The new rule starts out as inactive in the current and active in the
> > > next generation and is inserted into the ruleset. When it is deleted,
> > > it is additionally set to inactive in the next generation as well.
> > > 
> > > On commit the next generation is begun, then the actions are finalized.
> > > For the new rule this would mean clearing out the inactive bit for
> > > the previously current, now next generation.
> > > 
> > > However nft_rule_clear() clears out the bits for *both* generations,
> > > activating the rule in the current generation, where it should be
> > > deactivated due to being deleted. The rule will thus be active until
> > > the deletion is finalized, removing the rule from the ruleset.
> > > 
> > > Similarly, when aborting a transaction for the same case, the undo
> > > of insertion will remove it from the RCU protected rule list, the
> > > deletion will clear out all bits. However until the next RCU
> > > synchronization after all operations have been undone, the rule is
> > > active on CPUs which can still see the rule on the list.
> > > 
> > > Generally, there may never be any modifications of the current
> > > generations' inactive bit since this defeats the entire purpose of
> > > atomicity. Change nft_rule_clear() to only touch the next generations
> > > bit to fix this.
> > 
> > I think we can get rid of the nft_rule_clear() call from the error
> > path of nf_tables_newrule() too.
> 
> I don't think so, we deactivate the old rule for NLM_F_REPLACE and
> need to undo that on error.

Right.

> Or are you talking about getting rid of the entire error handling
> for NLM_F_REPLACE and have it taken care of by the abort() path?

Yes, that error handling I think we can get rid of it. It's actually
not correct because it's deleting the old rule.

--2fHTh5uZTiUOsy+g
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_tables-fix-error-handling-of-rule-repla.patch"

>From f4ab0cab91e2968652745dc883d46da61421f560 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 4 Mar 2015 17:55:27 +0100
Subject: [PATCH] netfilter: nf_tables: fix error handling of rule replacement

In general, if a transaction object is added to the list successfully,
we can rely on the abort path to undo what we've done. This allows us to
simplify the error handling of the rule replacement path in
nf_tables_newrule().

This implicitly fixes an unnecessary removal of the old rule removal,
which needs to be left in place if we fail to replace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a8c9462..6668adb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2031,12 +2031,6 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 
 err3:
 	list_del_rcu(&rule->list);
-	if (trans) {
-		list_del_rcu(&nft_trans_rule(trans)->list);
-		nft_rule_clear(net, nft_trans_rule(trans));
-		nft_trans_destroy(trans);
-		chain->use++;
-	}
 err2:
 	nf_tables_rule_destroy(&ctx, rule);
 err1:
-- 
1.7.10.4


--2fHTh5uZTiUOsy+g--
