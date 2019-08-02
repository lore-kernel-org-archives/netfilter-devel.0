Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23781C32750
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 17:39:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFC79217F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 17:39:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="EIL5tYeU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405761AbfHBRjn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 13:39:43 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40116 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729364AbfHBRjl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 13:39:41 -0400
Received: by mail-qt1-f195.google.com with SMTP id a15so74691614qtn.7
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Aug 2019 10:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C223IRfi6QPDBoq/hAHA+3DQ52r2Z1VMP9djgUIRcvI=;
        b=EIL5tYeUWNt/YJ283Nqs3vJs4KaDYvFmdOlkW1lV9Qy13YsZKyKQoLyb+6Z1JyX97c
         AAadYFlmEXIfqVJbRl/N9BHkL5s8wmep5ht5ClvZFwcAoV6E5uyuZXS/BDi9z8HQAo6O
         F+qXZIBQb5zlFfd+RuhrEeOlhRc7U6rDp5+30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C223IRfi6QPDBoq/hAHA+3DQ52r2Z1VMP9djgUIRcvI=;
        b=pQZVvzi3cyxYZZ2JbIZsYQ36Ymzt0GpQbDKwdjJJVaCy4jNaB+pyTQxZDcpbXFSlzp
         9iLvsZ8I6C93b10OZ+nsU5YL8nEhI6VE4U9qbjE2BWdc4p5sfw+GWmINaoFglBoQYQxX
         SXn1+0AWSCTrjm/7YG4zKDqhoN8fSvVY/0srTgsof06rnygQVgim4jlCib/lGV5xYoED
         uuI6vrggOXqyd+HIcioFCs3CjdtiNLh9PCYpEa4BV9S2QcThtHXJSZAFGizjglOFIcYY
         lcUJ68lddwXvK4awZnmwqpT+PUdFkVlUD5npA0IV9TsFRlGC0bUanREH/0ra7GWd5E7z
         Q+uw==
X-Gm-Message-State: APjAAAXadfdHEn+3La5LzTVtYCwhaoyELHra8dIHsI2tAa62XOcvmRNt
        t1ly5eTWOP7GtYXvmxgYJfiYfaY8dxGHMWXFOiaA1md4ZTIIsg==
X-Google-Smtp-Source: APXvYqyz4Um42L2CdT4l8hdXrUWEFtw3a7P+FYIH4tdqWiwdZ4qdzmTIpp04BQGlXuP5jqpuh1HdsZj1YS90W2KQpQ4=
X-Received: by 2002:ac8:2b90:: with SMTP id m16mr94719526qtm.384.1564767580835;
 Fri, 02 Aug 2019 10:39:40 -0700 (PDT)
MIME-Version: 1.0
References: <CABWYdi0aifR5EDAMVJ2vh6nURXwc0ED75hOkkWvU6-8icmvM_A@mail.gmail.com>
 <20190802093535.ujni4pckhrihjtaj@breakpoint.cc>
In-Reply-To: <20190802093535.ujni4pckhrihjtaj@breakpoint.cc>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Fri, 2 Aug 2019 10:39:29 -0700
Message-ID: <CABWYdi2qH6L9o37yNZfNGTumM6h2h9KcNYCeHYWTzJ9KV0La6w@mail.gmail.com>
Subject: Re: [PATCH] expr: allow export of notrack expr
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

You're right, it does indeed work in master. I've seen the issue on
Debian with libnftnl-1.0.7 and assumed it carried over to the latest
version by glancing over the code without actually trying it.

Sorry about that.

On Fri, Aug 2, 2019 at 2:35 AM Florian Westphal <fw@strlen.de> wrote:
>
> Ivan Babrou <ivan@cloudflare.com> wrote:
> > Currently it's impossible to export notrack expr as json,
> > as it lacks snprintf member and triggers segmentation fault.
>
> Hmm, works for me:
>
> table ip raw {
>         chain prerouting {
>                 type filter hook prerouting priority -300; policy accept;
>                 udp dport 53 notrack
> }
>
> gets exported as:
>
> nft -j list ruleset
> {"nftables": [{"metainfo": {"version": "0.9.1", "release_name": "Headless=
 Horseman", "json_schema_version": 1}}, {"table": {"family": "ip", "name": =
"raw", "handle": 1}}, {"chain": {"family": "ip", "table": "raw", "name": "p=
rerouting", "handle": 1, "type": "filter", "hook": "prerouting", "prio": -3=
00, "policy": "accept"}}, {"rule": {"family": "ip", "table": "raw", "chain"=
: "prerouting", "handle": 3, "expr": [{"match": {"op": "=3D=3D", "left": {"=
payload": {"protocol": "udp", "field": "dport"}}, "right": 53}}, {"notrack"=
: null}]}}]}
