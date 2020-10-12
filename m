Return-Path: <SRS0=LXG+=DT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5EFCC433E7
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 11:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B62BD2074A
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 11:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388340AbgJLLya (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 07:54:30 -0400
Received: from correo.us.es ([193.147.175.20]:35760 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388209AbgJLLya (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 07:54:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 35CBB5E476C
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 13:54:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25D33DA78A
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 13:54:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1B54EDA789; Mon, 12 Oct 2020 13:54:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0AA00DA730;
        Mon, 12 Oct 2020 13:54:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 12 Oct 2020 13:54:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DF9BE42EE38E;
        Mon, 12 Oct 2020 13:54:24 +0200 (CEST)
Date:   Mon, 12 Oct 2020 13:54:24 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 01/10] nft: Fix selective chain compatibility
 checks
Message-ID: <20201012115424.GA26845@salvia>
References: <20200923174849.5773-1-phil@nwl.cc>
 <20200923174849.5773-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200923174849.5773-2-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 23, 2020 at 07:48:40PM +0200, Phil Sutter wrote:
> Since commit 80251bc2a56ed ("nft: remove cache build calls"), 'chain'
> parameter passed to nft_chain_list_get() is no longer effective. To
> still support running nft_is_chain_compatible() on specific chains only,
> add a short path to nft_is_table_compatible().
> 
> Follow-up patches will kill nft_chain_list_get(), so don't bother
> dropping the unused parameter from its signature.

This has a Fixes: tag.

What is precisely the problem? How does show from the iptables and
iptables-restore interface?

Not sure I understand the problem.

> Fixes: 80251bc2a56ed ("nft: remove cache build calls")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  iptables/nft.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 27bb98d184c7c..669e29d4cf88f 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -3453,6 +3453,12 @@ bool nft_is_table_compatible(struct nft_handle *h,
>  {
>  	struct nftnl_chain_list *clist;
>  
> +	if (chain) {
> +		struct nftnl_chain *c = nft_chain_find(h, table, chain);
> +
> +		return c && !nft_is_chain_compatible(c, h);
> +	}
> +
>  	clist = nft_chain_list_get(h, table, chain);
>  	if (clist == NULL)
>  		return false;
> -- 
> 2.28.0
> 
