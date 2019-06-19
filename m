Return-Path: <SRS0=ZPov=US=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50495C31E49
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 08:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E61B20823
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 08:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731266AbfFSIqN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 04:46:13 -0400
Received: from mail.us.es ([193.147.175.20]:34234 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731136AbfFSIqM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 04:46:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 67764BEBA4
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2019 10:46:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52A9FDA71F
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2019 10:46:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 74F98DA78D; Wed, 19 Jun 2019 10:45:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CBF92DA713;
        Wed, 19 Jun 2019 10:45:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Jun 2019 10:45:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A75574265A2F;
        Wed, 19 Jun 2019 10:45:42 +0200 (CEST)
Date:   Wed, 19 Jun 2019 10:45:42 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Simon Kirby <sim@hostway.ca>, netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nft ct original oddity
Message-ID: <20190619084542.p6myk7tpm7fozxoi@salvia>
References: <20190618220508.twxiuzaxvtc7ya6u@hostway.ca>
 <20190619051010.aae7tvgptmgldawp@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619051010.aae7tvgptmgldawp@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 19, 2019 at 07:10:10AM +0200, Florian Westphal wrote:
> Simon Kirby <sim@hostway.ca> wrote:
> 
> [ moving to nf-devel ]
> 
> > I accidentally wrote "ct original" instead of "ct direction original",
> > and this broke "nft list ruleset":
> > 
> > # nft add set filter myset '{ type ipv4_addr; }'
> > # nft insert rule filter input ct original ip daddr @myset
> > # nft list ruleset
> > nft: netlink_delinearize.c:124: netlink_parse_concat_expr: Assertion `consumed > 0' failed.
> > Abort
> 
> Indeed.
> 
> This will fix the immediate problem:
> 
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -329,7 +329,7 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
>                 return netlink_error(ctx, loc,
>                                      "Lookup expression has no left hand side");
>  
> -       if (left->len < set->key->len) {
> +       if (left->len && left->len < set->key->len) {
>                 expr_free(left);
>                 left = netlink_parse_concat_expr(ctx, loc, sreg, set->key->len);
>                 if (left == NULL)
> 
> Pablo, the problem is that ct->key is NFT_CT_SRC, so expr->len is 0, so
> we try to parse a concat expression.  Its not until the evaluation step
> before we will figure out from context that SRC is asking for an ipv4
> address and update the type and expression length.
> 
> AFAICS the plan was to stop using NFT_CT_SRC and use NFT_CT_SRC_IP(6)
> instead so we have type and length info available directly.
> 
> Was there a problem with it (inet family)?

Right. In general, we need keys with fixed lengths, the NFT_CT_SRC
approach where key is variable length is a problem for the set
infrastructure, as you're describing.

There's a fix for this here:

https://patchwork.ozlabs.org/patch/883575/

It requires kernel >= 4.17.

I wanted to have netlink descriptions to deal with this case, but so
far only probing is possible, and I would like not to open up for that
path.

I can just rebase, resubmit and merge it if you are fine with it.

Thanks.
