Return-Path: <SRS0=e//N=EM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3534FC55178
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Nov 2020 23:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E18FD2078B
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Nov 2020 23:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgKFXCq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Nov 2020 18:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728390AbgKFXCp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Nov 2020 18:02:45 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7085FC0613CF;
        Fri,  6 Nov 2020 15:02:45 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kbAkY-0006y4-OY; Sat, 07 Nov 2020 00:02:30 +0100
Date:   Sat, 7 Nov 2020 00:02:30 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, Xin Liu <xinxliu@microsoft.com>,
        Guohan Lu <lguohan@gmail.com>,
        Kiran Kella <kiran.kella@broadcom.com>,
        Akhilesh Samineni <akhilesh.samineni@broadcom.com>
Subject: Re: [PATCH] netfilter: nf_nat: Support fullcone NAT
Message-ID: <20201106230230.GA23619@breakpoint.cc>
References: <20201106220106.80432-1-pmenzel@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201106220106.80432-1-pmenzel@molgen.mpg.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> From: Kiran Kella <kiran.kella@broadcom.com>
> 
> Changes done in the kernel to ensure 3-tuple uniqueness of the conntrack
> entries for the fullcone nat functionality.
> 
> *   Hashlist is maintained for the 3-tuple unique keys (Protocol/Source
>     IP/Port) for all the conntrack entries.
> 
> *   When NAT table rules are created with the fullcone option, the
>     SNAT/POSTROUTING stage ensures the ports from the pool are picked up in
>     such a way that the 3-tuple is uniquely assigned.
> 
> *   In the DNAT/POSTROUTING stage, the fullcone behavior is ensured by checking
>     and reusing the 3-tuple for the Source IP/Port in the original direction.
> 
> *   When the pool is exhausted of the 3-tuple assignments, the packets are
>     dropped, else, they will be going out of the router they being 5-tuple
>     unique (which is not intended).
> 
> *   Passing fullcone option using iptables is part of another PR (in
>     sonic-buildimage repo).

These are way too many changes for a single patch.
Please consider splitting this ino multiple chunks, e.g. at least
separate functional fullcone from the boilerplate changes.

> The kernel changes mentioned above are done to counter the challenges
> explained in the section *3.4.2.1 Handling NAT model mismatch between
> the ASIC and the Kernel* in the NAT HLD [1].

And please add the relevant explanations from this

> [1]: https://github.com/kirankella/SONiC/blob/nat_doc_changes/doc/nat/nat_design_spec.md

... to the commit message.

> This is taken from switch network operating system (NOS) SONiC’s Linux
> repository, where the support was added in September 2019 [1], and
> forwarded ported to Linux 4.19 by Akhilesh in June 2020 [2].

> I am sending it upstream as a request for comments, before effort
> is put into forward porting it to Linux master.

I don't see any huge problems from a technical pov.
But I don't see why this functionality is needed from a pure SW
point of view.

AFAICS SONiC uses a propritary (or at least, custom) offload mechanism
to place nat entries into HW.

Netfilter already has a forwarding offload mechanism, described in
Documentation/networking/nf_flowtable.rst , so I'm not sure it makes
sense to accept this without patches to support the needed offload
support as well.

AFAIU passing fullcone makes no sense unless using offload HW that
doesn't support the current nat port allocation scheme.

And current kernel doesn't support any such HW.

Nevertheless, some comments below.

> +/* Is this 3-tuple already taken? (not by us)*/
> +int
> +nf_nat_used_3_tuple(const struct nf_conntrack_tuple *tuple,
> +		    const struct nf_conn *ignored_conntrack,
> +		    enum nf_nat_manip_type maniptype);
> +
>  	 */
> -	void (*unique_tuple)(const struct nf_nat_l3proto *l3proto,
> +	int  (*unique_tuple)(const struct nf_nat_l3proto *l3proto,
>  			     struct nf_conntrack_tuple *tuple,
>  			     const struct nf_nat_range2 *range,
>  			     enum nf_nat_manip_type maniptype,

The above change should be done in a separate patch, so its
in a isolated change.  This will ease review of the fullcone part.

>  /* generate unique tuple ... */
> -static void
> +static int
>  gre_unique_tuple(const struct nf_nat_l3proto *l3proto,
>  		 struct nf_conntrack_tuple *tuple,
>  		 const struct nf_nat_range2 *range,
> @@ -52,7 +52,7 @@ gre_unique_tuple(const struct nf_nat_l3proto *l3proto,
>  	/* If there is no master conntrack we are not PPTP,
>  	   do not change tuples */
>  	if (!ct->master)
> -		return;
> +		return 0;
>  
>  	if (maniptype == NF_NAT_MANIP_SRC)
>  		keyptr = &tuple->src.u.gre.key;
> @@ -73,11 +73,11 @@ gre_unique_tuple(const struct nf_nat_l3proto *l3proto,
>  	for (i = 0; ; ++key) {
>  		*keyptr = htons(min + key % range_size);
>  		if (++i == range_size || !nf_nat_used_tuple(tuple, ct))
> -			return;
> +			return 1;
>  	}

I suggest you use 'bool' type for this rather than int, unless you plan
to use errno codes here in some future change.

> @@ -155,6 +156,31 @@ hash_by_src(const struct net *n, const struct nf_conntrack_tuple *tuple)
>  	return reciprocal_scale(hash, nf_nat_htable_size);
>  }
>  
> +static inline unsigned int
> +hash_by_dst(const struct net *n, const struct nf_conntrack_tuple *tuple)

please avoid inline keyword in .c files for new submissions.

> +{
> +	unsigned int hash;
> +
> +	get_random_once(&nf_nat_hash_rnd, sizeof(nf_nat_hash_rnd));

get_random_once can't be called from multiple places for the same random
value.

[ I did not check if thats the case since patch doesn't apply to current
nf ].

> +static inline int
> +same_reply_dst(const struct nf_conn *ct,
> +	       const struct nf_conntrack_tuple *tuple)
> +{
> +	const struct nf_conntrack_tuple *t;
> +
> +	t = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
> +	return (t->dst.protonum == tuple->dst.protonum &&
> +		nf_inet_addr_cmp(&t->dst.u3, &tuple->dst.u3) &&
> +		t->dst.u.all == tuple->dst.u.all);
> +}

Please run patches through scripts/checkpatch.pl before submission,
we try to avoid '()' in return (...);

> +/* Only called for DST manip */
> +static int
> +find_appropriate_dst(struct net *net,
> +		     const struct nf_conntrack_zone *zone,
> +		     const struct nf_nat_l3proto *l3proto,
> +		     const struct nf_nat_l4proto *l4proto,
> +		     const struct nf_conntrack_tuple *tuple,
> +		     struct nf_conntrack_tuple *result)
> +{
> +	struct nf_conntrack_tuple reply;
> +	unsigned int h;
> +	const struct nf_conn *ct;

Silly, but some maintainers prefer reverse-xmas-tree, i.e.

   	struct nf_conntrack_tuple reply;
   	const struct nf_conn *ct;
   	unsigned int h;

> @@ -327,8 +421,11 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
>  	const struct nf_conntrack_zone *zone;
>  	const struct nf_nat_l3proto *l3proto;
>  	const struct nf_nat_l4proto *l4proto;
> +	struct nf_nat_range2 nat_range;
>  	struct net *net = nf_ct_net(ct);
>  
> +        memcpy(&nat_range, range, sizeof(struct nf_nat_range2));

	nat_range = *range ?

> @@ -1055,9 +1188,14 @@ static int __init nf_nat_init(void)
>  	if (!nf_nat_bysource)
>  		return -ENOMEM;
>  
> +	nf_nat_by_manip_src = nf_ct_alloc_hashtable(&nf_nat_htable_size, 0);
> +	if (!nf_nat_by_manip_src)
> +		return -ENOMEM;

This lacks error unwind for nf_nat_bysource.
