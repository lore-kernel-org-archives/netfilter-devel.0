Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FB6C4361B
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 20:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1FD0222F9
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 20:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgLHUpR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbgLHUpR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 15:45:17 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4081C0613CF
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 12:44:36 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id b4so97371lfo.6
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Dec 2020 12:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q97sGxDWGWagjRwlnMafgtG3WrJP/eyCvdTB5WtcyiI=;
        b=H5FZe85zE8SnrVK3IqxAT0GIxApOxnfeXQUMGkjSYw/WWEgS508cUSvOL1oXMPCHwZ
         Mrbi0Q5wsEGf/yejvuyaeroh1b8S9tqmzOtptfb5DClULqqmhdRG/UFQUCFcORbuknyO
         R4xxMkjfrziqKGMzIbEIMit/ShEM6bv/WauTJ0kZw0vweA0VOXBHBsyvV7S7JPblZFey
         tdUwENdQ7sOgawO49QvtAf3o8JEGD6m/mxf4LBbSnB0Vh4iUeIBOeMOjXiYwcvTCjzyd
         04Y0omgSM9f+DlO5werimGUUgTWBBWEgIt+sf72YeI1qmzjhHS/nwr3/XfpCPudUcSjg
         Ggtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q97sGxDWGWagjRwlnMafgtG3WrJP/eyCvdTB5WtcyiI=;
        b=fb6oaRAtLm2xsNBB9z5LhhMMrFN9l+OrxmwXW81oEM4JUEkIUumyffWnY78sKQXMQU
         dWe3DRjP8Nu7Xi9rREgSI8pnwDbhzqIDxCdNIHc5J/PT6SF+f3CxVERUf49GeMqfmzmQ
         nGdVrZSoHD2RROCXQY3sM2Er4hiQfTX1lNskRHnTyAEnGpqaYyunM5wsUqTa1ZuSuqfe
         /Puxqz2pnWlo0LAt1J42r7Ud7269AKF76W2x6qdHIj+zMHHHYPKztbHFBBPUknc5dY31
         qIlVWjDvZKZn/d76Ee/vEixiJly8BdglIs/DCyi+TxMiSFXH/o4oW4ot4koNQl90OK7u
         TqhQ==
X-Gm-Message-State: AOAM5312V0BQQ0rf2g1bLLuceR4vB4KE5qdGUjf+plWv8r1wib9XZFiC
        aojXG3ZqraFSU7HDGb4rfLRad/zskzs=
X-Google-Smtp-Source: ABdhPJwPmT1btU36gCoiAynFfxPphQ9FebWk4QmnQJCzGClUY8bDxQk289lZYRokBuJQnr17m5tNKw==
X-Received: by 2002:a17:906:cec3:: with SMTP id si3mr24313450ejb.277.1607455756982;
        Tue, 08 Dec 2020 11:29:16 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id bo20sm13717968edb.1.2020.12.08.11.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 11:29:16 -0800 (PST)
Date:   Tue, 8 Dec 2020 21:29:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nftables: comment indirect serialization
 of commit_mutex with rtnl_mutex
Message-ID: <20201208192915.rvtbfgkw7u6a2qu6@skbuf>
References: <20201208180101.14705-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208180101.14705-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Dec 08, 2020 at 07:01:01PM +0100, Pablo Neira Ayuso wrote:
> Add an explicit comment in the code to describe the indirect
> serialization of the holders of the commit_mutex with the rtnl_mutex.
> Commit 90d2723c6d4c ("netfilter: nf_tables: do not hold reference on
> netdevice from preparation phase") already describes this, but a comment
> in this case if better for reference.
> 
> Reported-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index c2f59879a48d..9a080767667b 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1723,6 +1723,10 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
>  	}
>  
>  	nla_strlcpy(ifname, attr, IFNAMSIZ);
> +	/* nf_tables_netdev_event() is called under rtnl_mutex, this is
> +	 * indirectly serializing all the other holders of the commit_mutex with
> +	 * the rtnl_mutex.
> +	 */
>  	dev = __dev_get_by_name(net, ifname);
>  	if (!dev) {
>  		err = -ENOENT;
> -- 
> 2.20.1
> 

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Thanks!
