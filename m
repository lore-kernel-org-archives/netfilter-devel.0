Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242C73D170D
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2026 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777050557; cv=none; b=omKY3zJJ8vj6lN/MgBB87o3L4pXzG+KVlQbXZXcaN4Oy6W86GOxTgv+VKeSfWynmQyi1RkynhvXrppALpcCgCRNXB+ECa4doBjCiFN3GO5+qxQ6/+zvDy9kREr/c961RiZrPwiRZh8CT2uTzRrzdXm/UFtX68RYJrq3ZIy6qEGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777050557; c=relaxed/simple;
	bh=CPUHQ0VilTcpkG/4//7ZPTQu1Le1ZTBMB0TMiCE5Mds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dYIWiyi7tAkhENI/1+blSdt3j/jmX7xAUxXcXyDOi89OYJe/wkjE9riixdi77CkiVhcMoQCXqRJHPbmI/WfZG2asTdRRuU9ZlIrSA8ZVrrDE2uivUAYLzSHH/lt8/mAn9ZbrdXC8yKwRkZhHqD9snVbzmQLhhHJrLLU0gMEKIaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LEoOOmBY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LEoOOmBY"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 73ACB60178;
	Fri, 24 Apr 2026 19:09:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777050551;
	bh=2LvpyaAj+wVuPOtIVLBPZdOY9BlTBolMm0ThcrCR2rA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LEoOOmBY9ghBfRITkt6WnEM1Tr7JgTT3eeGI6jeJowhOYtaG0nrL0lQ+e74DTIiCV
	 UeoJw1tJanIbalU/Q9gxfMsu1rTImcSXjLGRjQSVpnXTsHTNFAX/UQlRY96ckXOfCM
	 kONWOHGfZSEjtU2/V3S64nHWGH8oOHei/DRQWVtmTfVqmVzchdC+0QSD1iP52NxsHF
	 gYgVakm+V5MMXKEf6e8ua09bpRVPxt4ql8ci6pgwQWJhMl2bwCipHFRl632MhbYm1r
	 LEiMumbFS7+VbgW318G42vazinVUL6eerAIs7lSGYu8cc9yeTGHfwKI7DSC++zmy/u
	 Y8DNYrqfrdWkg==
Date: Fri, 24 Apr 2026 19:09:08 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	ecklm94@gmail.com, phil@nwl.cc, fw@strlen.de
Subject: Re: [PATCH 3/3 nf v3] netfilter: xtables: fix L4 header parsing for
 non-first fragments
Message-ID: <aeujtL4s2wI7ILuA@chamomile>
References: <20260421104409.5452-1-fmancera@suse.de>
 <20260421104409.5452-3-fmancera@suse.de>
 <aetWRt8_AlLabPtm@chamomile>
 <463e0514-686b-4680-8d84-7cda0dbba121@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <463e0514-686b-4680-8d84-7cda0dbba121@suse.de>

On Fri, Apr 24, 2026 at 04:33:56PM +0200, Fernando Fernandez Mancera wrote:
> On 4/24/26 1:38 PM, Pablo Neira Ayuso wrote:
> > On Tue, Apr 21, 2026 at 12:44:09PM +0200, Fernando Fernandez Mancera wrote:
> > > Multiple targets and matches relies on L4 header to operate. For
> > > fragmented packets, every fragment carries the transport protocol
> > > identifier, but only the first fragment contains the L4 header.
> > > 
> > > As the 'raw' table can be configured to run at priority -450 (before
> > > defragmentation at -400), the target/match can be reached before
> > > reassembly. In this case, non-first fragments have their payload
> > > incorrectly parsed as a TCP/UDP header. This would be of course a
> > > misconfiguration scenario. In most of the cases this just lead to a
> > > unreliable behavior for fragmented traffic.
> > > 
> > > Add a fragment check to ensure target/match only evaluates unfragmented
> > > packets or the first fragment in the stream.
> > 
> 
> Hi Pablo,
> 
> > AI reports xt_hashlimit could be a good candidate to check for
> > fragoff, I think it is, so I would suggest to expand it there to cover
> > this.
> > 
> 
> This seems like a good catch. I will work on this.
> 
> > It also mentions synproxy as another candidate but IPv6 synproxy does
> > not do ipv6_find_hdr() on purpose I think (it assumed nexthdr is TCP)
> > for SYN and ACK packets, so checking for fragoff there is not
> > possible. Given this is to deal with flood, I think think it is worth
> > the fragoff validation.
> > 
> 
> I don't think it makes sense for SYNPROXY. SYNPROXY requires conntrack to
> work both ipt_SYNPROXY and nft_synproxy and only allows LOCAL_IN and FORWARD
> hooks so it should be fine AFAIU. I don't understand how someone could skip
> defragmentation here.
> 
> Maybe something extra to add to ipt_SYNPROXY is a restriction for TCP
> protocol only. As the code currently assumes the transport layer is TCP
> which isn't enforced.
> 
> But that would be kind of a different fix. What do you think?

My suggestion is to update xt_hashlimit to handle fragoff.

Regarding synproxy, it is a right indeed that this depends on
nf_defrag so no changes are needed there.

So please send a v4 including xt_hashlimit.

Thanks Fernando.

> > > Fixes: 902d6a4c2a4f ("netfilter: nf_defrag: Skip defrag if NOTRACK is set")
> > > Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> > > ---
> > > v2: handled ecn, socket and tcpmss matches
> > > v3: extracted socket to its own patch with a generic solution for
> > > nft/xt, added a comment specifying that par->fragoff is fine for
> > > ecn/tcpmss ipv6 as they enforce -p tcp. Keep on mind that osf only
> > > supports ipv4.
> > > ---
> > >   net/netfilter/xt_TPROXY.c | 11 +++++++++--
> > >   net/netfilter/xt_ecn.c    |  4 ++++
> > >   net/netfilter/xt_osf.c    |  3 +++
> > >   net/netfilter/xt_tcpmss.c |  4 ++++
> > >   4 files changed, 20 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
> > > index e4bea1d346cf..5f60e7298a1e 100644
> > > --- a/net/netfilter/xt_TPROXY.c
> > > +++ b/net/netfilter/xt_TPROXY.c
> > > @@ -86,6 +86,9 @@ tproxy_tg4_v0(struct sk_buff *skb, const struct xt_action_param *par)
> > >   {
> > >   	const struct xt_tproxy_target_info *tgi = par->targinfo;
> > > +	if (par->fragoff)
> > > +		return NF_DROP;
> > > +
> > >   	return tproxy_tg4(xt_net(par), skb, tgi->laddr, tgi->lport,
> > >   			  tgi->mark_mask, tgi->mark_value);
> > >   }
> > > @@ -95,6 +98,9 @@ tproxy_tg4_v1(struct sk_buff *skb, const struct xt_action_param *par)
> > >   {
> > >   	const struct xt_tproxy_target_info_v1 *tgi = par->targinfo;
> > > +	if (par->fragoff)
> > > +		return NF_DROP;
> > > +
> > >   	return tproxy_tg4(xt_net(par), skb, tgi->laddr.ip, tgi->lport,
> > >   			  tgi->mark_mask, tgi->mark_value);
> > >   }
> > > @@ -106,6 +112,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
> > >   {
> > >   	const struct ipv6hdr *iph = ipv6_hdr(skb);
> > >   	const struct xt_tproxy_target_info_v1 *tgi = par->targinfo;
> > > +	unsigned short fragoff = 0;
> > >   	struct udphdr _hdr, *hp;
> > >   	struct sock *sk;
> > >   	const struct in6_addr *laddr;
> > > @@ -113,8 +120,8 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
> > >   	int thoff = 0;
> > >   	int tproto;
> > > -	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
> > > -	if (tproto < 0)
> > > +	tproto = ipv6_find_hdr(skb, &thoff, -1, &fragoff, NULL);
> > > +	if (tproto < 0 || fragoff)
> > >   		return NF_DROP;
> > >   	hp = skb_header_pointer(skb, thoff, sizeof(_hdr), &_hdr);
> > > diff --git a/net/netfilter/xt_ecn.c b/net/netfilter/xt_ecn.c
> > > index b96e8203ac54..a8503f5d26bf 100644
> > > --- a/net/netfilter/xt_ecn.c
> > > +++ b/net/netfilter/xt_ecn.c
> > > @@ -30,6 +30,10 @@ static bool match_tcp(const struct sk_buff *skb, struct xt_action_param *par)
> > >   	struct tcphdr _tcph;
> > >   	const struct tcphdr *th;
> > > +	/* this is fine for IPv6 as ecn_mt_check6() enforces -p tcp */
> > > +	if (par->fragoff)
> > > +		return false;
> > > +
> > >   	/* In practice, TCP match does this, so can't fail.  But let's
> > >   	 * be good citizens.
> > >   	 */
> > > diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
> > > index dc9485854002..e8807caede68 100644
> > > --- a/net/netfilter/xt_osf.c
> > > +++ b/net/netfilter/xt_osf.c
> > > @@ -27,6 +27,9 @@
> > >   static bool
> > >   xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
> > >   {
> > > +	if (p->fragoff)
> > > +		return false;
> > > +
> > >   	return nf_osf_match(skb, xt_family(p), xt_hooknum(p), xt_in(p),
> > >   			    xt_out(p), p->matchinfo, xt_net(p), nf_osf_fingers);
> > >   }
> > > diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
> > > index 0d32d4841cb3..b9da8269161d 100644
> > > --- a/net/netfilter/xt_tcpmss.c
> > > +++ b/net/netfilter/xt_tcpmss.c
> > > @@ -32,6 +32,10 @@ tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
> > >   	u8 _opt[15 * 4 - sizeof(_tcph)];
> > >   	unsigned int i, optlen;
> > > +	/* this is fine for IPv6 as xt_tcpmss enforces -p tcp */
> > > +	if (par->fragoff)
> > > +		return false;
> > > +
> > >   	/* If we don't have the whole header, drop packet. */
> > >   	th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
> > >   	if (th == NULL)
> > > -- 
> > > 2.53.0
> > > 
> > 
> 
