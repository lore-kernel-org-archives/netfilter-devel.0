Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76299C432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 15:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53A6420885
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 15:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbfKTPGQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 10:06:16 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48246 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728030AbfKTPGQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 10:06:16 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iXRYX-0005wH-Df; Wed, 20 Nov 2019 16:06:09 +0100
Date:   Wed, 20 Nov 2019 16:06:09 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-15?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Jay Ligatti <ligatti@usf.edu>,
        Ori Rottenstreich <or@cs.technion.ac.il>,
        Kirill Kogan <kirill.kogan@gmail.com>
Subject: Re: [PATCH nf-next 3/8] nf_tables: Add set type for arbitrary
 concatenation of ranges
Message-ID: <20191120150609.GB20235@breakpoint.cc>
References: <cover.1574119038.git.sbrivio@redhat.com>
 <6da551247fd90666b0eca00fb4467151389bf1dc.1574119038.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6da551247fd90666b0eca00fb4467151389bf1dc.1574119038.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Stefano Brivio <sbrivio@redhat.com> wrote:
> +static bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
> +			      const u32 *key, const struct nft_set_ext **ext)
> +{
> +	struct nft_pipapo *priv = nft_set_priv(set);
> +	unsigned long *res_map, *fill_map;
> +	u8 genmask = nft_genmask_cur(net);
> +	const u8 *rp = (const u8 *)key;
> +	struct nft_pipapo_match *m;
> +	struct nft_pipapo_field *f;
> +	bool map_index;
> +	int i;
> +
> +	map_index = raw_cpu_read(nft_pipapo_scratch_index);

I'm afraid this will need local_bh_disable to prevent reentry from
softirq processing.

> +	rcu_read_lock();

All netfilter hooks run inside rcu read section, so this isn't needed.

> +static int pipapo_realloc_scratch(struct nft_pipapo_match *m,
> +				  unsigned long bsize_max)
> +{
> +	int i;
> +
> +	for_each_possible_cpu(i) {
> +		unsigned long *scratch;
> +
> +		scratch = kzalloc_node(bsize_max * sizeof(*scratch) * 2,
> +				       GFP_KERNEL, cpu_to_node(i));
> +		if (!scratch)
> +			return -ENOMEM;

No need to handle partial failures on the other cpu / no rollback?
AFAICS ->destroy will handle it correctly, i.e. next insertion may
enter this again and allocate a same-sized chunk, so AFAICS its fine.

But still, it looks odd -- perhaps add a comment that there is no need
to rollback earlier allocs.

> +
> +		kfree(*per_cpu_ptr(m->scratch, i));

I was about to ask what would prevent nft_pipapo_lookup() from accessing
m->scratch.  Its because "m" is the private clone.  Perhaps add a
comment here to that effect.

> + * @net:	Network namespace
> + * @set:	nftables API set representation
> + * @elem:	nftables API element representation containing key data
> + * @flags:	If NFT_SET_ELEM_INTERVAL_END is passed, this is the end element
> + * @ext2:	Filled with pointer to &struct nft_set_ext in inserted element
> + *
> + * In this set implementation, this functions needs to be called twice, with
> + * start and end element, to obtain a valid entry insertion. Calls to this
> + * function are serialised, so we can store element and key data on the first
> + * call with start element, and use it on the second call once we get the end
> + * element too.

What guaranttess this?
AFAICS userspace could send a single element, with either
NFT_SET_ELEM_INTERVAL_END, or only the start element.
