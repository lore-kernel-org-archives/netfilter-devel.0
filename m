Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4778C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Jan 2021 22:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1CEE2339E
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Jan 2021 22:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbhANWlm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Jan 2021 17:41:42 -0500
Received: from correo.us.es ([193.147.175.20]:45960 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728452AbhANWlm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Jan 2021 17:41:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 12555303D03
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Jan 2021 23:40:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02660DA789
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Jan 2021 23:40:14 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EBD3EDA722; Thu, 14 Jan 2021 23:40:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0F4DDA722;
        Thu, 14 Jan 2021 23:40:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 Jan 2021 23:40:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7F25E42DC700;
        Thu, 14 Jan 2021 23:40:11 +0100 (CET)
Date:   Thu, 14 Jan 2021 23:40:57 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     jpl+netfilter-devel@plutex.de
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Reverse nft_set_lookup_byid list traversal
Message-ID: <20210114224057.GA5392@salvia>
References: <21ed8188-a202-f578-6f8b-303dec37a266@plutex.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <21ed8188-a202-f578-6f8b-303dec37a266@plutex.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan-Phillip,

On Thu, Jan 07, 2021 at 09:56:42AM +0100, Jan-Philipp Litza wrote:
> When loading a large ruleset with many anonymous sets,
> nft_set_lookup_global is called once for each added set element, which
> in turn calls nft_set_lookup_byid if the set was only added in this
> transaction.
> 
> The longer this transaction's queue of unapplied netlink messages gets,
> the longer it takes to traverse it in search for the set referenced by
> ID that was probably added near the end if it is an anonymous set. This
> patch hence searches the list of unapplied netlink messages in reverse
> order, finding the just-added anonymous set faster.
> 
> On some reallife ruleset of ~6000 statements and ~1000 anonymous sets,
> this patch roughly halves the system time on loading:
> 
> Before: 0,06s user 0,39s system 97% cpu 0,459 total
> After:  0,06s user 0,20s system 97% cpu 0,268 total
> 
> The downside might be that newly added non-anonymous named sets are
> probably added at the beginning of a transaction, and looking for them
> when adding elements later on takes longer. However, I reckon that named
> sets too are more often filled right after their creation. Furthermore,
> for named sets, users can optimize their rule structure to add elements
> right after set creation, whereas it's impossible to first create all
> anonymous sets at the beginning of the transaction to optimize for the
> current approach.

If the .nft file contains lots of (linear syntax):

add rule x y ... { ... }
...
add rule x y ... { ... }

then, this patch is a real gain. In this case, nft currently places
the new anonymous set right before the rule, so your patch makes it
perform nicely.

I hesitate with the nested syntax, ie.

table x {
       chain y {
                ... { ... }
                ...
                ... { ... }
       }
}

In this case, nft adds all the anonymous sets at the beginning of the
netlink message, then rules don't find it right at the end.

Probably it's better to convert this code to use a rhashtable for fast
lookups on the transaction so we don't mind about what userspace does
in the future.

Thanks.

> Signed-off-by: Jan-Philipp Litza <jpl@plutex.de>
> ---
>  net/netfilter/nf_tables_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 8d5aa0ac4..c488b6b95 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -3639,7 +3639,7 @@ static struct nft_set *nft_set_lookup_byid(const struct net *net,
>  	struct nft_trans *trans;
>  	u32 id = ntohl(nla_get_be32(nla));
>  
> -	list_for_each_entry(trans, &net->nft.commit_list, list) {
> +	list_for_each_entry_reverse(trans, &net->nft.commit_list, list) {
>  		if (trans->msg_type == NFT_MSG_NEWSET) {
>  			struct nft_set *set = nft_trans_set(trans);
>  
> --
> 2.27.0
> 
