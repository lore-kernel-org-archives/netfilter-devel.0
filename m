Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D002272E5A
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Nov 2025 22:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763590485; cv=none; b=CQhPXOknrLOqcLxs8oytxwFWyVqBG5gA49jo3S5dPdul9HF6BfhlCVMjuY/v+vvUoJzP96bcK38WFLaPbtANcr4gSqiq3r1apfe06mPbf9kTwUzCffEguS4TjIFGYhAKTjOpJGAiZH+neT5KenzVPiIqEgSFhaRXlQMWuvj/5MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763590485; c=relaxed/simple;
	bh=/sQwZDHgBu7ou3LjR7spwBQsexzUaEYEJE6/3MmE/ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ftFn4DXwGfM9UoAQA/mgoViXbmcPcGANPXSfVIwK6rfv/phKiK7b96O1ojQ5OJG0mLieW0TPG73zJFJyuGJNojglqZV83Kw/iG0jvEGL5UnEvBbUWPU5KIxzvIl5uxpzSrrNVcjBcWn+2wF0DKf2B4vrP5/h+BP9TOJxzETlAkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=iTqiiTd0; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iTqiiTd0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FIMUHUvyU+nu5YFNEjpjnGdDLpSojPTwxMCoDHT8L34=; b=iTqiiTd0NAhX4PkefRBxDfRVn+
	uIRjL795iOPErph/DSf1lSMNOiABunBKUnzx/H0AKsRi3b/SPk/FWXdS96zEvEqZakF/VjTjeiV7c
	28r+hzh9mKktkVBV1NZV1AyzOnMqDPNoJAkuBr08SrJq7h6vOri0sTX/du8eNCI44/awo/H96OCYy
	uC3wbWzTz2vQ2352rJDjq5LFZ1hiwgEZEV+ztWGQYiP1BJMi1L3HRNNp60e9EDkFPMpUm/nokKAhk
	+RMTqQhhGeeEmlTxQ969W2HJ4P0x0jXOPP62PmyvkHiHZSC7L7HVa/cdBmDY/5xHfTSY5mKWyidsd
	CW7hbAPg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vLqRj-000000007AE-0o33;
	Wed, 19 Nov 2025 23:14:39 +0100
Date: Wed, 19 Nov 2025 23:14:39 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/3] netfilter: nft_set_rbtree: use cloned tree
 for insertions and removal
Message-ID: <aR5BT0-HnwPEkBR5@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org
References: <20251118111657.12003-1-fw@strlen.de>
 <9a4e63da-6d36-4365-8c08-547961c9bfa7@suse.de>
 <aR29ddgmrjWcayAV@orbyte.nwl.cc>
 <aR3osq6hSxh7JwVm@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5ErCiTN128aH+wtb"
Content-Disposition: inline
In-Reply-To: <aR3osq6hSxh7JwVm@strlen.de>


--5ErCiTN128aH+wtb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 19, 2025 at 04:56:34PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > 200K elements ~ avg. time insertion before 510ms after 744ms
> > > 500K elements ~ avg. time insertion before 5460ms after 7730ms
> > 
> > I wonder if nft_rbtree_maybe_clone() could run a simpler copying
> > algorithm than properly inserting every element from the old tree into
> > the new one since the old tree is already correctly organized -
> > basically leveraging the existing knowledge of every element's correct
> > position.
> 
> Yes, but I doubt its going to help much.
> 
> And I don't see how this can be done without relying on implementation
> details of rb_node struct.
> 
> > Or is there a need to traverse the new tree with each element instead of
> > copying the whole thing as-is?
> 
> What do you mean?

So I gave it a try and to my big surprise nftables test suite does not
cause a kernel crash and inserting elements into a large set seems to be
faster (0.07s vs. 0.1s per 'nft add element' call).

Where's the rub? Fernando, care to give it a try?

Thanks, Phil

--5ErCiTN128aH+wtb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="quick_tree_copy.diff"

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index a2396cd03f71..33f2ec84d150 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include <linux/rbtree_augmented.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
@@ -509,26 +510,44 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	return 0;
 }
 
+static void nft_rbtree_copy(const struct nft_set *set, struct rb_node *parent,
+			    struct rb_node **pos, struct nft_rbtree_elem *elem)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+	u8 genbit = nft_rbtree_genbit_copy(priv);
+
+	rb_link_node_rcu(&elem->node[genbit], parent, pos);
+	rb_set_parent_color(&elem->node[genbit], parent,
+			    rb_color(&elem->node[!genbit]));
+
+	if (elem->node[!genbit].rb_left)
+		nft_rbtree_copy(set, &elem->node[genbit],
+				&elem->node[genbit].rb_left,
+				rb_entry(elem->node[!genbit].rb_left,
+					 struct nft_rbtree_elem,
+					 node[!genbit]));
+	if (elem->node[!genbit].rb_right)
+		nft_rbtree_copy(set, &elem->node[genbit],
+				&elem->node[genbit].rb_right,
+				rb_entry(elem->node[!genbit].rb_right,
+					 struct nft_rbtree_elem,
+					 node[!genbit]));
+}
+
 static void nft_rbtree_maybe_clone(const struct net *net, const struct nft_set *set)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 genbit = nft_rbtree_genbit_live(priv);
-	struct nft_rbtree_elem *rbe;
-	struct rb_node *node, *next;
 
 	lockdep_assert_held_once(&nft_pernet(net)->commit_mutex);
 
 	if (priv->cloned)
 		return;
 
-	for (node = rb_first(&priv->root[genbit]); node ; node = next) {
-		next = rb_next(node);
-		rbe = rb_entry(node, struct nft_rbtree_elem, node[genbit]);
-
-		/* No need to acquire a lock, this is the future tree, not
-		 * exposed to packetpath.
-		 */
-		__nft_rbtree_insert_do(set, rbe);
+	if (priv->root[genbit].rb_node) {
+		nft_rbtree_copy(set, NULL, &priv->root[!genbit].rb_node,
+				rb_entry(priv->root[genbit].rb_node,
+					 struct nft_rbtree_elem, node[genbit]));
 	}
 	priv->cloned = true;
 }

--5ErCiTN128aH+wtb--
