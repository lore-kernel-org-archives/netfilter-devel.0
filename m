Return-Path: <SRS0=WNzP=VO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8653BC7618F
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 18:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5090F217F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 18:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388725AbfGQSfV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 14:35:21 -0400
Received: from mail.us.es ([193.147.175.20]:44728 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727377AbfGQSfU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 14:35:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 98A0EDA722
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jul 2019 20:35:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89C3F6DA95
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jul 2019 20:35:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7F3D1D190F; Wed, 17 Jul 2019 20:35:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 459604FA31;
        Wed, 17 Jul 2019 20:35:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 17 Jul 2019 20:35:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2222D4265A31;
        Wed, 17 Jul 2019 20:35:16 +0200 (CEST)
Date:   Wed, 17 Jul 2019 20:35:15 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH RFC] net: nf_tables: Support auto-loading inet family
 nat chain
Message-ID: <20190717183515.yym6aageq3d3imlu@salvia>
References: <20190717171743.14754-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717171743.14754-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 17, 2019 at 07:17:43PM +0200, Phil Sutter wrote:
> Trying to create an inet family nat chain would not cause
> nft_chain_nat.ko module auto-load due to missing module alias.
> 
> The family is actually NFPROTO_INET which happens to be the same
> numerical value as AF_UNIX.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> This is obviously a hack to illustrate the problem and show a working
> solution. I'm not sure what a real fix would look like - maybe nf_tables
> should internally use NFPROTO_* defines instead of AF_* ones? Maybe it
> should translate NFPROTO_INET into AF_UNSPEC?
> ---
>  net/netfilter/nft_chain_nat.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nft_chain_nat.c b/net/netfilter/nft_chain_nat.c
> index 2f89bde3c61cb..d3bf4a297c655 100644
> --- a/net/netfilter/nft_chain_nat.c
> +++ b/net/netfilter/nft_chain_nat.c
> @@ -142,3 +142,6 @@ MODULE_ALIAS_NFT_CHAIN(AF_INET, "nat");
>  #ifdef CONFIG_NF_TABLES_IPV6
>  MODULE_ALIAS_NFT_CHAIN(AF_INET6, "nat");
>  #endif
> +#ifdef CONFIG_NF_TABLES_INET
> +MODULE_ALIAS_NFT_CHAIN(AF_UNIX, "nat");

Please, use (2, "nat") instead like in other extensions.

        MODULE_ALIAS_NFT_CHAIN(2, "nat");        /* NFPROTO_INET */

Yes, it's not nice, but this is so far what we have.

I agree we should fix this, problem is that NFPROTO_* are enum, and
IIRC this doesn't mix well with the existing macros.

If you want to have a look, that would be great.

Thanks.
