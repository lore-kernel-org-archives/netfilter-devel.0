Return-Path: <SRS0=Xgm7=SK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDCAC10F13
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 23:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B9562148E
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 23:15:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SZnTIx/v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfDHXPk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 19:15:40 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46759 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfDHXPk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 19:15:40 -0400
Received: by mail-oi1-f195.google.com with SMTP id x188so11915813oia.13
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Apr 2019 16:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TMt00Z8OZAB1gNheJyr1t+GYXCJPWDgp5TAUdeJVSvo=;
        b=SZnTIx/vSwYYQz58SAnd7l7rlUocMFFNsvrKzzuDfzqihiV8yVYwIEOEPE1z1BjiwU
         IW0CW5yYe1FbIbE0QrJDlf0qfUzL8+mR3QmQKNMxiH46+rDD0SDVzF3Bhk4ALqoZVBWy
         WyU0X4cGgl3DbrzOgrI/Fn3yRaZUZlNYcR69fCD9ApNYTfVLsdtaWTD3iRHZt/cJiohn
         4eVqH/2NLuPyXtqOuTCxnpShCBb4kPWD7XnnnDYa9EHJGBz4GC2hQsjQyBG5w+hN9pOY
         Dwn9s87e9c4fTuJtyFp3HrEBYVJdZUx8q0pEhPQev5OznzdofwwfSRztk0xILW4JPh+Q
         CHIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TMt00Z8OZAB1gNheJyr1t+GYXCJPWDgp5TAUdeJVSvo=;
        b=fKp4S+hHzfO0JkzgsG6GeNITnIv3OLdQhi5f9CNs1HY731pLuoOKBv9t76vXoKK/FP
         nCvRbF4UC4Tk3V/wFnlR7UIPRPcit20D1M7WClTUOhoYkbzSttaScxBe5Ck2INmkxyCL
         iKNeIenHYTE+NVUT+Ddoo/0waaXQ/mxeDZeXfb3XtqQZkzI7VbvdISIEB0YPhv6cXXUj
         elsU7iIYLCaDLISt79P0BQOuM+p0UG/6nIO/Xm/Ub9Lj/6hpUXGRzFziQ4qJBow2FgLH
         CXZje/TqH3FNhFDr62jCRhYy+E/UTLBNsrnf00qDxm5iH5R7xfb6wilD8vhDeL0IAU6y
         dzsQ==
X-Gm-Message-State: APjAAAXgOdGqbHofc6ZSov0J8iIhj9PqkwWqG71Mu1V/Lqk8izp7DhTc
        Fq2+TjBNDtLyAI16FJ5P+/Hu4T8d5H4N9ZPIqmQ=
X-Google-Smtp-Source: APXvYqwoHjjhwf65oeWDX5DUx5833Lhkn40IO2qYaZ/4+bBZXR7q6AHZ1wilAzfxtHpPM6VK5QdIZ26a6DHTL4SVxmE=
X-Received: by 2002:aca:c647:: with SMTP id w68mr18776410oif.173.1554765339595;
 Mon, 08 Apr 2019 16:15:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190408104220.3816-1-ap420073@gmail.com> <20190408211112.gdbsl7cizymcx6fp@breakpoint.cc>
In-Reply-To: <20190408211112.gdbsl7cizymcx6fp@breakpoint.cc>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 9 Apr 2019 08:15:28 +0900
Message-ID: <CAMArcTW1-2BpquD_hxkbryApTFGYsBLHB2XT72jBsC9p8Lzk0g@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nf_conntrack: restrict
 conntrack_buckets value
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 9 Apr 2019 at 06:11, Florian Westphal <fw@strlen.de> wrote:
>

Hi Florian,

> Taehee Yoo <ap420073@gmail.com> wrote:
> > In order to avoid wastefull memory allocation, conntrack bucket size
> > should be lower than conntrack_max size.
> > When a conntrack_max is changed, a conntrack_buckets will be changed to be
> > under a conntrack_max value.
> > But, a conntrack_buckets can be over than a conntrack_max only when
> > a conntrack_max is lower than minimum of a conntrack_buckets.
> >
> > TEST
> >    sysctl net.netfilter.nf_conntrack_max=100000 -w
> >    sysctl net.netfilter.nf_conntrack_buckets=200000 -w
> > second command will be failed because of this patch.
>
> Are you sure this is correct?
>
> IIRC nf_conntrack_buckets is a global value, whereas nf_conntrack_max
> is per netns.
>
> So, with 100 netns nf_conntrack_buckets should be set to a much larger
> value.
>
> Also, we hash and insert each conntrack entry twice, once for original
> and once for the reverse direction.
>
> So, setting buckets to twice the max count is fine even for the 'init
> netns only' case.
>

Thank you for review!
I checked about conntrack_max and conntrack_buckets.
Your review is right.
conntrack_max is global variable but session count is pernet.
So, in netns condition, large bucket would be needed.

So, this patch is not correct.

Thank you!
