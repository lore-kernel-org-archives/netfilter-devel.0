Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E7463B9
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 23:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748560890; cv=none; b=Q5DSrK2BWnyjeBRR5xWz4b4j8w3mzD4enfvsWrXjL2BqnbME+NWhnt1LmSvVW03G7aGKdTEjNW2qfuKwy9gPIZ+/gpfmXDq5R5ZMIMBrNIKfWyIYdVODzqEWgs29t0rE21CdTqAbTfPceGU5WSB1SjQbKlqRSk0jl0nij+mbTQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748560890; c=relaxed/simple;
	bh=w6BKbrmQzNPK+sMOGDMSC04IsxtjLv4NftKTd3xbwaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fHdlr+9bjGENL4lZINDvE4lmA7wHmjRK39QreCtdK6UJrqfAqMw1LTsBlLsimQSB0JxhmCnkp7pCDkgSh9VOjI1Gp5yUdxWL+sbp0BpyZT95qYN48iybsTrz72Qc0dmQ7AVGITcwEMGVOaCLnrJ4QEc69h3dVjwY/finQsU3L7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A1FE76048F; Fri, 30 May 2025 01:21:19 +0200 (CEST)
Date: Fri, 30 May 2025 02:45:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Shaun Brady <brady.1345@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, pablo@netfilter.org,
	kadlec@netfilter.org, David Miller <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
Message-ID: <aDj_oGBSNIUFEZFF@strlen.de>
References: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
 <aDeftvfuOufo5kdw@fedora>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aDeftvfuOufo5kdw@fedora>

Shaun Brady <brady.1345@gmail.com> wrote:
> On Wed, May 28, 2025 at 05:03:56PM +0800, Yafang Shao wrote:
> > diff --git a/net/netfilter/nf_conntrack_core.c
> > b/net/netfilter/nf_conntrack_core.c
> > index 7bee5bd22be2..3481e9d333b0 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -1245,9 +1245,9 @@ __nf_conntrack_confirm(struct sk_buff *skb)
> > 
> >         chainlen = 0;
> >         hlist_nulls_for_each_entry(h, n,
> > &nf_conntrack_hash[reply_hash], hnnode) {
> > -               if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
> > -                                   zone, net))
> > -                       goto out;
> > +               //if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
> > +               //                  zone, net))
> > +               //      goto out;
> >                 if (chainlen++ > max_chainlen) {
> >  chaintoolong:
> >                         NF_CT_STAT_INC(net, chaintoolong);
> 
> Forgive me for jumping in with very little information, but on a hunch I
> tried something.  I applied the above patch to another bug I've been
> investigating:
> 
> https://bugzilla.netfilter.org/show_bug.cgi?id=1795
> and Ubuntu reference
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2109889
> 
> The Ubuntu reproduction steps where easier to follow, so I mimicked
> them:
> 
> # cat add_ip.sh 
> ip addr add 10.0.1.200/24 dev enp1s0
> # cat nft.sh 
> nft -f - <<EOF
> table ip dnat-test {
>  chain prerouting {
>   type nat hook prerouting priority dstnat; policy accept;
>   ip daddr 10.0.1.200 udp dport 1234 counter dnat to 10.0.1.180:1234
>  }
> }
> EOF
> # cat listen.sh 
> echo pong|nc -l -u 10.0.1.180 1234
> # ./add_ip.sh ; ./nft.sh ; listen.sh (and then just ./listen.sh again)

We don't have a selftest for this, I'll add one.

Following patch should help, we fail to check for reverse collision
before concluding we don't need PAT to handle this.

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -248,7 +248,7 @@ static noinline bool
 nf_nat_used_tuple_new(const struct nf_conntrack_tuple *tuple,
 		      const struct nf_conn *ignored_ct)
 {
-	static const unsigned long uses_nat = IPS_NAT_MASK | IPS_SEQ_ADJUST_BIT;
+	static const unsigned long uses_nat = IPS_NAT_MASK | IPS_SEQ_ADJUST;
 	const struct nf_conntrack_tuple_hash *thash;
 	const struct nf_conntrack_zone *zone;
 	struct nf_conn *ct;
@@ -287,8 +287,14 @@ nf_nat_used_tuple_new(const struct nf_conntrack_tuple *tuple,
 	zone = nf_ct_zone(ignored_ct);
 
 	thash = nf_conntrack_find_get(net, zone, tuple);
-	if (unlikely(!thash)) /* clashing entry went away */
-		return false;
+	if (unlikely(!thash)) {
+		struct nf_conntrack_tuple reply;
+
+		nf_ct_invert_tuple(&reply, tuple);
+		thash = nf_conntrack_find_get(net, zone, &reply);
+		if (!thash) /* clashing entry went away */
+			return false;
+	}
 
 	ct = nf_ct_tuplehash_to_ctrack(thash);
 
