Return-Path: <SRS0=mmGa=IG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A096C433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 10:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B41DC651C5
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 10:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhCHKer (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 05:34:47 -0500
Received: from correo.us.es ([193.147.175.20]:53234 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230488AbhCHKem (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 05:34:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 23F26B56F1
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 11:34:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14473DA55C
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 11:34:41 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 085F8DA844; Mon,  8 Mar 2021 11:34:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A620ADA78C;
        Mon,  8 Mar 2021 11:34:38 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Mar 2021 11:34:38 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 88BD442DF563;
        Mon,  8 Mar 2021 11:34:38 +0100 (CET)
Date:   Mon, 8 Mar 2021 11:34:38 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Marc =?utf-8?Q?Aur=C3=A8le?= La France <tsi@tuyoix.net>
Cc:     Laura Garcia Liebana <nevola@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: {PATCH nf] x_tables: Allow REJECT targets in PREROUTING chains
Message-ID: <20210308103438.GA23953@salvia>
References: <alpine.LNX.2.20.2103071733480.15162@fanir.tuyoix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.20.2103071733480.15162@fanir.tuyoix.net>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Mar 07, 2021 at 06:16:10PM -0700, Marc Aurèle La France wrote:
> Extend commit f53b9b0bdc59c0823679f2e3214e0d538f5951b9 "netfilter:
> introduce support for reject at prerouting stage", which appeared in
> 5.9, by making the corresponding changes to x_tables REJECT targets.
> 
> Please Reply-To-All.

This patch LGTM.

> Thanks.
> 
> Marc.
> 
> Signed-off-by: Marc Aurèle La France <tsi@tuyoix.net>
> Tested-by: Marc Aurèle La France <tsi@tuyoix.net>
> 
> --- a/net/ipv4/netfilter/ipt_REJECT.c
> +++ b/net/ipv4/netfilter/ipt_REJECT.c
> @@ -92,7 +92,7 @@ static struct xt_target reject_tg_reg __read_mostly = {
>  	.targetsize	= sizeof(struct ipt_reject_info),
>  	.table		= "filter",
>  	.hooks		= (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD) |
> -			  (1 << NF_INET_LOCAL_OUT),
> +			  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_PRE_ROUTING),
>  	.checkentry	= reject_tg_check,
>  	.me		= THIS_MODULE,
>  };
> --- a/net/ipv6/netfilter/ip6t_REJECT.c
> +++ b/net/ipv6/netfilter/ip6t_REJECT.c
> @@ -102,7 +102,7 @@ static struct xt_target reject_tg6_reg __read_mostly = {
>  	.targetsize	= sizeof(struct ip6t_reject_info),
>  	.table		= "filter",
>  	.hooks		= (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD) |
> -			  (1 << NF_INET_LOCAL_OUT),
> +			  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_PRE_ROUTING),
>  	.checkentry	= reject_tg6_check,
>  	.me		= THIS_MODULE
>  };

