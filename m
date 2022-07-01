Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361BFC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Jul 2022 22:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbiGAWjh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Jul 2022 18:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiGAWjg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Jul 2022 18:39:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BDF471243
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2022 15:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656715173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UiY+aLCI++leoXVnKpGGP7y6FQN5Wey7/i7NOoH4uQI=;
        b=Lv3g2B7rzt4SeXP0cXBql0L9/cG8vekStsyKft32+YteQlQRT3BwAu3odyg7K6tL8SPVkP
        LCV1KUYQnbi12p92SgJ/sKEZNEgfxnGpFkb2uIhtw9LYvxcxHcl0t8Oa4OiKttzcp0vvwz
        D9eCOKlZBnVFJcZZZ2QvDYwPiOf2v+E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-KmyZkFEXP-mGiqqYlHsoQA-1; Fri, 01 Jul 2022 18:39:31 -0400
X-MC-Unique: KmyZkFEXP-mGiqqYlHsoQA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85A7529324BC;
        Fri,  1 Jul 2022 22:39:31 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 39B0D18EB7;
        Fri,  1 Jul 2022 22:39:31 +0000 (UTC)
Date:   Sat, 2 Jul 2022 00:39:28 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: release elements in clone
 from abort path
Message-ID: <20220702003928.1ae75aaa@elisabeth>
In-Reply-To: <20220628164527.101413-1-pablo@netfilter.org>
References: <20220628164527.101413-1-pablo@netfilter.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, 28 Jun 2022 18:45:27 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> New elements that reside in the clone are not released in case that the
> transaction is aborted.
> 
> [16302.231754] ------------[ cut here ]------------
> [16302.231756] WARNING: CPU: 0 PID: 100509 at net/netfilter/nf_tables_api.c:1864 nf_tables_chain_destroy+0x26/0x127 [nf_tables]
> [...]
> [16302.231882] CPU: 0 PID: 100509 Comm: nft Tainted: G        W         5.19.0-rc3+ #155
> [...]
> [16302.231887] RIP: 0010:nf_tables_chain_destroy+0x26/0x127 [nf_tables]
> [16302.231899] Code: f3 fe ff ff 41 55 41 54 55 53 48 8b 6f 10 48 89 fb 48 c7 c7 82 96 d9 a0 8b 55 50 48 8b 75 58 e8 de f5 92 e0 83 7d 50 00 74 09 <0f> 0b 5b 5d 41 5c 41 5d c3 4c 8b 65 00 48 8b 7d 08 49 39 fc 74 05
> [...]
> [16302.231917] Call Trace:
> [16302.231919]  <TASK>
> [16302.231921]  __nf_tables_abort.cold+0x23/0x28 [nf_tables]
> [16302.231934]  nf_tables_abort+0x30/0x50 [nf_tables]
> [16302.231946]  nfnetlink_rcv_batch+0x41a/0x840 [nfnetlink]
> [16302.231952]  ? __nla_validate_parse+0x48/0x190
> [16302.231959]  nfnetlink_rcv+0x110/0x129 [nfnetlink]
> [16302.231963]  netlink_unicast+0x211/0x340
> [16302.231969]  netlink_sendmsg+0x21e/0x460
> 
> Add nft_set_pipapo_match_destroy() helper function to release the
> elements in the lookup tables.
> 
> Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Hi Stefano,
> 
> I triggered this splat with this test.nft file:
> 
>   table inet test {
>         chain x {
>         }
> 
>         chain y {
>                 udp length . @th,160,128 vmap { 47-63 . 0xe373135363130333131303735353203 : goto x }
>         }
>   }
> 
> then, exercise the abort path with -c:
> 
>   # nft -c -f test.nft
> 
> I don't see the splat anymore here.
> 
> This bug uncovered with the -o/--optimize infrastructure, which has a
> test similar to the file described above.

Thanks for catching this.

> priv->dirty seems to be a safe indication that this is in the abort path
> when calling .destroy().

I'm not sure about that, it looks quite difficult to me to prove.

However, is it relevant? The point here is that if priv->dirty is set,
we might (should) have at least one different element in priv->clone
compared to priv->match, so we should go ahead and destroy elements
also found there. The issue you discovered might even happen on
non-abort paths I guess.

>  net/netfilter/nft_set_pipapo.c | 43 ++++++++++++++++++++++------------
>  1 file changed, 28 insertions(+), 15 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 2c8051d8cca6..02f6cc061a2e 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -2124,6 +2124,27 @@ static int nft_pipapo_init(const struct nft_set *set,
>  	return err;
>  }
>  
> +static void nft_set_pipapo_match_destroy(const struct nft_set *set,
> +					 struct nft_pipapo_match *m)

For consistency (and perhaps clarity), I would also add a kernel-doc
comment for this one:

/**
 * nft_set_pipapo_match_destroy() - Destroy elements from key mapping array
 * @set:	nftables API set representation
 * @m:		matching data pointing to key mapping array
 */

> +{
> +	struct nft_pipapo_field *f;
> +	int i, r;
> +
> +	for (i = 0, f = m->f; i < m->field_count - 1; i++, f++)
> +		;
> +
> +	for (r = 0; r < f->rules; r++) {
> +		struct nft_pipapo_elem *e;
> +
> +		if (r < f->rules - 1 && f->mt[r + 1].e == f->mt[r].e)
> +			continue;
> +
> +		e = f->mt[r].e;
> +
> +		nft_set_elem_destroy(set, e, true);
> +	}
> +}
> +
>  /**
>   * nft_pipapo_destroy() - Free private data for set and all committed elements
>   * @set:	nftables API set representation
> @@ -2132,26 +2153,13 @@ static void nft_pipapo_destroy(const struct nft_set *set)
>  {
>  	struct nft_pipapo *priv = nft_set_priv(set);
>  	struct nft_pipapo_match *m;
> -	struct nft_pipapo_field *f;
> -	int i, r, cpu;
> +	int cpu;
>  
>  	m = rcu_dereference_protected(priv->match, true);
>  	if (m) {
>  		rcu_barrier();
>  
> -		for (i = 0, f = m->f; i < m->field_count - 1; i++, f++)
> -			;
> -
> -		for (r = 0; r < f->rules; r++) {
> -			struct nft_pipapo_elem *e;
> -
> -			if (r < f->rules - 1 && f->mt[r + 1].e == f->mt[r].e)
> -				continue;
> -
> -			e = f->mt[r].e;
> -
> -			nft_set_elem_destroy(set, e, true);
> -		}
> +		nft_set_pipapo_match_destroy(set, m);
>  
>  #ifdef NFT_PIPAPO_ALIGN
>  		free_percpu(m->scratch_aligned);
> @@ -2165,6 +2173,11 @@ static void nft_pipapo_destroy(const struct nft_set *set)
>  	}
>  
>  	if (priv->clone) {
> +		m = priv->clone;
> +
> +		if (priv->dirty)
> +			nft_set_pipapo_match_destroy(set, m);
> +
>  #ifdef NFT_PIPAPO_ALIGN
>  		free_percpu(priv->clone->scratch_aligned);
>  #endif

Other than that, it looks good to me.

I would also specify in the commit message that we additionally look
for elements pointers in the cloned matching data if priv->dirty is
set, because that means that cloned data might point to additional
elements we didn't commit to the working copy yet (such as the abort
path case, but perhaps not limited to it).

-- 
Stefano

