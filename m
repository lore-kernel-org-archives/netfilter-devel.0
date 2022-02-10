Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F28C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Feb 2022 16:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244206AbiBJQ3j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 11:29:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiBJQ3h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 11:29:37 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA068BB4
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Feb 2022 08:29:35 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id y129so17031432ybe.7
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Feb 2022 08:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=icJaWELoFkK+x1iy67lv/nCb3yezWQKgn5KOEGJ+cIY=;
        b=SN2tNbcQchx4HXJyjvkghxpfPQ2bvwdEG3CbOAyk+0XyFNYjQkxITqTjVne6ncX93M
         Ft/L/YPHrYfefVdYvRiuB7L8xki1DMTFwDelpjUnawbEyMDT0o5dakr/W8+2VkvrLNZa
         5q5IMl6Op/EZeK1QHdMQnbJUXOuk06mg6VYmGWEYbMD1OAOJjg6mEt9Rdb7AI8N5RE3P
         pDA0PijIAVF9dWawbq0V5TFORF6k91Lg52OzlD6dCOlt06XvOdBgbsfuz6FjKzGf9znC
         Xwbmr06f7BVMlJfpekrsnSWf6dQFwfMtX1T+LhO2xdECrKk6hLVQauiRV1sljIAiQWh7
         X7kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=icJaWELoFkK+x1iy67lv/nCb3yezWQKgn5KOEGJ+cIY=;
        b=5k/LWtWBOadDB2wv/DHJV2KGCQ1Jdlu2cuQpXdTuerh8kipQ1aZ24xhVGzsLMiBPi+
         WZ1eX2nXjDyPdVbPk5kQwss4V6kwYVmIUNv0e6ZQWDT0Nr/S2PrLDiBawsS7pJRDedmI
         qCw6suj4usHbcHKRStQf+i18jiP9TQwcAyS9INF/HLqJwEj7GAr879yiydSUYf5Dcgtl
         agLXPSCPN7zSBRlXTf4vKLMyVYRNw8tuMui4FOz9/NUeJwya62t38kkop0gySH0ZW7Rn
         yZ8zdK3mqq2XKlKWFuOwOnXD0N6/FH2rDnnG2UW9tFeKi7CQlgBheqYe4xdB95cL2eOf
         guWg==
X-Gm-Message-State: AOAM532r5szS1X6BIl4CVrwVuXjqdHFS6W3n8SpVmZwQiM6zaC1Hsl++
        T+3pacsgbEO7lGkOz7e2CApAnxgQy1IqT9Q30ghFuw==
X-Google-Smtp-Source: ABdhPJzt9+1Rkf4flJfxjiFJAaQfZGZW9tw1ziM0rdiM1SVD5y2oz2Eso/1rLeRMF9U4H1OVH/407PmVpIn8yVGq8f8=
X-Received: by 2002:a25:4f0a:: with SMTP id d10mr7613486ybb.296.1644510574702;
 Thu, 10 Feb 2022 08:29:34 -0800 (PST)
MIME-Version: 1.0
References: <20220128073319.1017084-1-imagedong@tencent.com>
 <20220128073319.1017084-2-imagedong@tencent.com> <0029e650-3f38-989b-74a3-58c512d63f6b@gmail.com>
 <CADxym3akuxC_Cr07Vzvv+BD55XgMEx7nqU4qW8WHowGR0jeoOQ@mail.gmail.com>
 <20220209211202.7cddd337@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADxym3ZajjCV2EHF6+2xa5ewZuVqxwk6bSqF0KuA+J6sGnShbQ@mail.gmail.com> <20220210081322.566488f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220210081322.566488f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 10 Feb 2022 08:29:23 -0800
Message-ID: <CANn89iKhkQ_0TbSJnPtMJrC57nz=0iiRXR-XzeZj5q6OPYZnFA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 1/7] net: skb_drop_reason: add document for
 drop reasons
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Menglong Dong <menglong8.dong@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Alexander Lobakin <alobakin@pm.me>, paulb@nvidia.com,
        Kees Cook <keescook@chromium.org>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Feb 10, 2022 at 8:13 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 10 Feb 2022 21:42:14 +0800 Menglong Dong wrote:
> > How about introducing a field to 'struct sock' for drop reasons? As sk is
> > locked during the packet process in tcp_v4_do_rcv(), this seems to work.
>
> I find adding temporary storage to persistent data structures awkward.
> You can put a structure on the stack and pass it thru the call chain,
> that's just my subjective preference, tho, others may have better ideas.

I had a similar TODO item, because stuff like 'waking up task' or free
one skb (or list of skb) could be performed outside of socket lock.
