From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Wed, 25 Nov 2015 23:15:57 +0000
Message-ID: <20151125231557.GC20093@macbook.localdomain>
References: <20151124111029.GH1740@breakpoint.cc>
 <20151124113341.GO2310@macbook.localdomain>
 <20151124151542.GA20972@breakpoint.cc>
 <20151124152649.GK14478@macbook.localdomain>
 <20151124153550.GC20972@breakpoint.cc>
 <20151124154241.GL14478@macbook.localdomain>
 <20151125150640.GE18449@macbook.localdomain>
 <20151125162424.GJ23215@breakpoint.cc>
 <20151125164629.GB30712@macbook.localdomain>
 <20151125225256.GL23215@breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:62478 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752499AbbKYXQD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 18:16:03 -0500
Content-Disposition: inline
In-Reply-To: <20151125225256.GL23215@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 25.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> 
> > > Looks fantastic, I am leaning towards dropping the header formatting
> > > from libnftl patch entirely.
> > 
> > I agree, we could drop the header part and only print the meta data. So we
> > can see that something is happening and associate the events with decoded
> > messages, but full decoding seems unnecessary.
> 
> I could also get rid of all formatting of course, i.e. remove the
> libnftnl_trace_*printf functions, so libnftnl would just provide
> the nftnl_trace struct to nftables frontend and the internal translation
> of netlink messages to that struct.

I think having some printing is useful to trace/debug netlink communication
itself, IOW the basic data. Just the full header decoding seems rather
unnecessary.

> > > The limitation (same as with my patch) is that if we don't know the
> > > value then we cannot pretty-print that L2 header.
> > > I don't think thats a problem, we can just move on to NH.
> > 
> > It depends, f.i. for bridging we can infer it from the hook values. In fact
> > proto_ctx_init() already does that correctly for bridging.
> 
> Yes, this DEV_TYPE attribute is only included for NFPROTO_NETDEV where L2
> could be anything ...

I actually changed that in my local version to include it whenever we have
pkt->in so we can decode ARP using dev_proto_desc(). I'm also including the
LL header whenever present so its now also used for f.i. incoming IPv4/v6
packets:

trace id 847cdc00 ip packet: iif ens3 ether daddr c9:4b:a9:00:54:52 ether saddr 63:f6:4b:00:54:52 ip hdrlength 4 ip version 5 ip tos 16 ip length 60 ip id 44588 ip frag-off 16384 ip ttl 64 ip checksum 5849 ip saddr 192.168.122.1 ip daddr 192.168.122.84 tcp sport 43178 tcp dport 10000

I've attached that change to the mail. At least the DEV_TYPE part is needed
to make sense out of the ARP ll header in a generic way.

> > > > +	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_VERDICT))
> > > > +		printf("verdict %u ", nftnl_trace_get_u32(nlt, NFTNL_TRACE_VERDICT));
> > > 
> > > I am working on this.
> > > 
> > > Dissecting the verdict will happen in libnftnl, so NFTNL_TRACE_VERDICT will return
> > > a verdict without extra information.
> > > 
> > > I'll add NFTNL_TRACE_NFQUEUE_ID to store the upper 16 bits for QUEUE verdicts.
> > 
> > I don't think that's necessary. All the other verdict parts (actually nft_data)
> > simply return the numeric verdict code and also accept them, both for encoded
> > DROP_ERRNOS and queue numbers. Is there any reason to diverge from this?
> 
> Hmm, to clarify:  The kernel will dump the verdict as-is.
> But I don't see why nftables (nft) should have to start dissecting this
> to e.g. get the nfqueue number.  So I'd rather put something like the
> following into libnftnl and provide accessors for nft rather than
> stuff it into the frontend tool:
> 
> verdict = mnl_get_ (netlink_data);
> switch (verdict) {
> case NFT_GOTO:
> case NFT_JUMP: t->targetchain = get_target_chain(netlink_data);
> case NFT_CONTINUE:
> // all other known verdicts here
> 	trace->verdict = verdict;
> 	break;
> default: /* unknown verdict, or extra data in upper bits */
>      switch (verdict & 0xff) {
>      case NF_QUEUE:
>         trace->verdict = verdict & 0xff;
>         trace->queue_id = verdict >> 16;
>         break;
>      }
>  }
> 
> Without it, simple tasks like 'translate verdict to string' in nft
> require extra exercise to strip away the irrelevant parts of the
> verdict code.
> 
> Does that seem reasonable?

Yeah, that seems fine. I though we already did that disection in
verdict_type_print(), but it was in fact only a local change queued
in my tree.

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="x.diff"

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e22e929..3a0e22b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -518,20 +518,9 @@ trace_notify_put_packet(struct sk_buff *nlskb, const struct nft_pktinfo *pkt)
 				   skb, pkt->xt.thoff, plen))
 		return false;
 
-	switch (pkt->pf) {
-	case NFPROTO_ARP: /* fallthrough */
-	case NFPROTO_BRIDGE:
-		break;
-	case NFPROTO_NETDEV:
-		if (WARN_ON_ONCE(!skb->dev))
-			break;
-		if (nla_put_be16(nlskb, NFTA_TRACE_DEV_TYPE,
-				 htons(skb->dev->type)))
-			return false;
-		break;
-	default:
-		return true;
-	}
+	if (pkt->in &&
+	    nla_put_be16(nlskb, NFTA_TRACE_DEV_TYPE, htons(pkt->in->type)))
+		return false;
 
 	if (skb_vlan_tag_get(skb) &&
 	    !nla_put_be16(nlskb, NFTA_TRACE_VLAN_TAG,
@@ -688,6 +677,7 @@ void nf_tables_trace_notify(const struct nft_pktinfo *pkt,
 	WARN_ON_ONCE(1);
 	kfree_skb(skb);
 }
+EXPORT_SYMBOL_GPL(nf_tables_trace_notify);
 
 static int nf_tables_dump_tables(struct sk_buff *skb,
 				 struct netlink_callback *cb)
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index c2a60ac..9342779 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -350,6 +350,7 @@ void nft_meta_set_destroy(const struct nft_ctx *ctx,
 	if (priv->key == NFT_META_NFTRACE)
 		static_key_slow_dec(&nft_trace_enabled);
 }
+EXPORT_SYMBOL_GPL(nft_meta_set_destroy);
 
 static struct nft_expr_type nft_meta_type;
 static const struct nft_expr_ops nft_meta_get_ops = {

--oyUTqETQ0mS9luUI--
