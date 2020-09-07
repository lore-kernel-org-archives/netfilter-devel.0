Return-Path: <SRS0=Y+c4=CQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E424AC433E2
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Sep 2020 10:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88E9C207C3
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Sep 2020 10:19:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="jly9ZVPy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgIGKTo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Sep 2020 06:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728618AbgIGKTk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Sep 2020 06:19:40 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5F1C061573
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2020 03:19:40 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id i22so17517714eja.5
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2020 03:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FKt9Ni9znuL/T5DiGGNRnDoYpXehn3oQFsifjWsLIGg=;
        b=jly9ZVPylGHnaA+MOBaKixpbQj5+JlStiySeH3qn/+1+oel+sLn8P3AxtDuy86A9E2
         aBA7e02V9MlJkZWCwqGAO7lNmM8GX+GrZrx1zk5w0+fCUh1EpztHwVAWcJDVm9Y7fEGg
         2m5QsBOnlUHDNyPcxyZe09vLh+RPWnGTVP9UWCWEu+ngMY1yHWJt5DpSUPcpYLU+gqN0
         mgNSUeC3kxF7QdjK6Hs+mWgqPWS6pIxQAHaCY7jL7bsnKzSuqLlvNb+pV/zovO7EzOVS
         asLiNuvQxlLLbdHrnWFFP0FrkPfHk5/5uyXqZJittIhL9QkDkhiE5Gv7JwRM8eVzgpfW
         GKNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FKt9Ni9znuL/T5DiGGNRnDoYpXehn3oQFsifjWsLIGg=;
        b=t8ltcGVofFyyhhtZF+RzvRpDeSz4s68Q0khYYzatUZ/8hKjMTJYifRXXwmD8RrPMSs
         NdxBa/rjFeHVU+cIbzHIP9xQkqc/Lsc/fQwdtifFdCmnUMnGIEQ3ksvQ1AoXPldhxGW1
         aqTaazzjpjbmHnMlDRHPHeenFNyxA045IT8rFBEjD0bjNoP+FM8MQwp1OrK3sa6vo87M
         NKAHCs+MHTDVh7Z6oabIYuDy/1aihRJca/RGTSfIw0o0RzY44/SDIvGREBHU2flYRdJs
         nt/YzJbs1fWtuqDqlkcH+obuThE0OYUQiJ1OEiE6korYlb7Zqn8xBqwCkdtKFKW6Qn3U
         tUMQ==
X-Gm-Message-State: AOAM5329b+FuDIWy4euaXWGyPVAktk93dTWlz1VxwRKggJf+wcbm8BEO
        /pq/vGXh9HiiJogue/HExqPxO9jIX2ZKxQ==
X-Google-Smtp-Source: ABdhPJzbbal6iYv3ya8B+7Go7waH2YQEAoZAbOw0/xIqd5/TAyHQHCWvPWecDtmFJ7wSJlJjsd9i7w==
X-Received: by 2002:a17:906:3e81:: with SMTP id a1mr19854774ejj.227.1599473979033;
        Mon, 07 Sep 2020 03:19:39 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id i15sm6834108edf.82.2020.09.07.03.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:19:38 -0700 (PDT)
Date:   Mon, 7 Sep 2020 12:19:36 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-net] netfilter: conntrack: nf_conncount_init is
 failing with IPv6 disabled
Message-ID: <20200907101934.GA3739@netronome.com>
References: <159897212470.60236.5737844268627410321.stgit@ebuild>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159897212470.60236.5737844268627410321.stgit@ebuild>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

+ Pablo, netfilter-devel@vger.kernel.org

On Tue, Sep 01, 2020 at 04:56:02PM +0200, Eelco Chaudron wrote:
> The openvswitch module fails initialization when used in a kernel
> without IPv6 enabled. nf_conncount_init() fails because the ct code
> unconditionally tries to initialize the netns IPv6 related bit,
> regardless of the build option. The change below ignores the IPv6
> part if not enabled.
> 
> Note that the corresponding _put() function already has this IPv6
> configuration check.
> 
> Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
>  net/netfilter/nf_conntrack_proto.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
> index 95f79980348c..47e9319d2cf3 100644
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c
> @@ -565,6 +565,7 @@ static int nf_ct_netns_inet_get(struct net *net)
>  	int err;
>  
>  	err = nf_ct_netns_do_get(net, NFPROTO_IPV4);
> +#if IS_ENABLED(CONFIG_IPV6)
>  	if (err < 0)
>  		goto err1;
>  	err = nf_ct_netns_do_get(net, NFPROTO_IPV6);
> @@ -575,6 +576,7 @@ static int nf_ct_netns_inet_get(struct net *net)
>  err2:
>  	nf_ct_netns_put(net, NFPROTO_IPV4);
>  err1:
> +#endif
>  	return err;
>  }
>  
> 
