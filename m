Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 506F6C31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 17:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21A20208C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 17:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfFQReq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 13:34:46 -0400
Received: from mail.us.es ([193.147.175.20]:33822 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726238AbfFQReq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 13:34:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CD44DC4146
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 19:34:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDDE4DA705
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 19:34:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B38EBDA709; Mon, 17 Jun 2019 19:34:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9F47DA702;
        Mon, 17 Jun 2019 19:34:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Jun 2019 19:34:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 99C074265A2F;
        Mon, 17 Jun 2019 19:34:42 +0200 (CEST)
Date:   Mon, 17 Jun 2019 19:34:42 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        fw@strlen.de
Subject: Re: [PATCH nft,v2 2/5] tests: shell: cannot use handle for
 non-existing rule in kernel
Message-ID: <20190617173442.m6wwae3pdhda5hue@salvia>
References: <20190617171842.1227-1-pablo@netfilter.org>
 <20190617171842.1227-2-pablo@netfilter.org>
 <20190617172653.GW31548@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617172653.GW31548@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 17, 2019 at 07:26:53PM +0200, Phil Sutter wrote:
> Hey Pablo!
> 
> On Mon, Jun 17, 2019 at 07:18:39PM +0200, Pablo Neira Ayuso wrote:
> > This test invokes the 'replace rule ... handle 2' command. However,
> > there are no rules in the kernel, therefore it always fails.
> 
> I found the cause for why this stopped working: You forgot to adjust
> rule_evaluate(), what you need is something like this:
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index ff0888d0c7842..f17bebe4a5f22 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -3295,7 +3295,7 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule,
>         }
>  
>         /* add rules to cache only if it is complete enough to contain them */
> -       if (!cache_is_complete(&ctx->nft->cache, CMD_LIST))
> +       if (!(ctx->nft->cache.flags & NFT_CACHE_RULE))
>                 return 0;

Thanks! I'll fix this an send a new version.
