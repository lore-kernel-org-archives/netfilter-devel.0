Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16064C10F12
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 05:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C472073F
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 05:13:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VlFUsJQ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbfDQFNm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 01:13:42 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:39790 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfDQFNm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 01:13:42 -0400
Received: by mail-yb1-f196.google.com with SMTP id x71so8120599ybe.6
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Apr 2019 22:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PLMCy9CikZL7NnW3ipucpx/S3Pxg9I1DTltXkGPuT+A=;
        b=VlFUsJQ6Ahz+oAe3Ps0AYTCr6FOv6sheZ87EUDFOrOTgef7NesjAkkpotSDjaTh5J4
         9V3sB5CLo8L1ntnaXkzlhjE9DXNyP/wy8fpeOGIPsd14ZcZmKh1ggdG44HpMdxCm//KJ
         rFQjuSm60WEVobg1+G9nh2umSe9zQ1Ok1lWxR65vjooDUBN2zKNUMNqBOARwdzw3vAN0
         RfF26/kzk33r4U441c70d57t8N5Bp7nAHBaAeprMh6k3QWgKi9eCgeCfo3QoAzIr9xgW
         KPo6Q6Vl0g9xcqQnoFKoXGGNujfwtKZZApIylhgDWGnKZ4YbMChdT7qV2hNh3VAZ/zVd
         LDow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PLMCy9CikZL7NnW3ipucpx/S3Pxg9I1DTltXkGPuT+A=;
        b=NE9G6wgXdNucgVueOEv8asUNlXrs+K2zkl5D4Z/R9wHmLIfV722/aOAXsGFq0QUzbL
         yjpRYn34Tz6emSkINMoyUZM/T5372AgHDFM8RXAEGUFLaFFn/OW/iE+Yaa7ZK49CQ/Qx
         dRHU/DHShpNG/fR+/ydMWJzJArUKbiUW1WReL1YFdj50m2SadfDY0c7ICc9KWlJnCR3K
         lHqXkLP4SdkMEJbW3pCvjX5EhystAnjy2FTPwQWfPwMwnzaXDFp0DnvN8pq04XX8OWmy
         LEx9bPRlPC22qLELxLvTE+kylUuStQbCnzJ0MvjwoQGQkOuuETvfs9VwnouQ++IDhpWX
         e1+A==
X-Gm-Message-State: APjAAAU04zZj6IenK1jQmY1n0rmST23jQpczUU3eXpMqbR7Ib2/CVCcO
        gJdHD/JRHtuYiKOsMx8VdP83JcqdDFpfXII4T3I13Q==
X-Google-Smtp-Source: APXvYqxZsywjOMEbzSBOqMXC2d3DRGeI1eN284LocSPPADq49P2ZrTAbF68F2WCgoVNgDvZxmZQ9+Q+k73ld3Cf+bM4=
X-Received: by 2002:a25:2fd4:: with SMTP id v203mr68302159ybv.353.1555478020736;
 Tue, 16 Apr 2019 22:13:40 -0700 (PDT)
MIME-Version: 1.0
References: <9cf8e521-8aa6-c022-e491-d3e6cfe0aca6@ziu.info> <20190417001723.17912-1-fw@strlen.de>
In-Reply-To: <20190417001723.17912-1-fw@strlen.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 16 Apr 2019 22:13:29 -0700
Message-ID: <CANn89i+uDBK=72sFTR3sqoBPAV0HKJYgoUJSZpuKk9pxqNof5w@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: never get/set skb->tstamp
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Michal Soltys <soltys@ziu.info>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 16, 2019 at 5:16 PM Florian Westphal <fw@strlen.de> wrote:
>
> setting net.netfilter.nf_conntrack_timestamp=1 breaks xmit with fq
> scheduler.  skb->tstamp might be "refreshed" using ktime_get_real(),
> but fq expects CLOCK_MONOTONIC.
>
> This patch removes all places in netfilter that check/set skb->tstamp:
>
> 1. To fix the bogus "start" time seen with conntrack timestamping for
>    outgoing packets, never use skb->tstamp and always use current time.
> 2. In nfqueue and nflog, only use skb->tstamp for incoming packets,
>    as determined by current hook (prerouting, input, forward).
> 3. xt_time has to use system clock as well rather than skb->tstamp.
>    We could still use skb->tstamp for prerouting/input/foward, but
>    I see no advantage to make this conditional.
>
> Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
> Cc: Eric Dumazet <edumazet@google.com>
> Reported-by: Michal Soltys <soltys@ziu.info>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---

SGTM, thanks for taking care of this Florian

Acked-by: Eric Dumazet <edumazet@google.com>
