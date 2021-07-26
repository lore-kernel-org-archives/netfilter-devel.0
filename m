Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5D0C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 21:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F29C160F91
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 21:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhGZUsm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 16:48:42 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33672 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhGZUsl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 16:48:41 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 715076429D;
        Mon, 26 Jul 2021 23:28:39 +0200 (CEST)
Date:   Mon, 26 Jul 2021 23:29:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ryoga Saito <proelbtn@gmail.com>
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netfilter-devel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Subject: Re: [PATCH] net: Add netfilter hooks to track SRv6-encapsulated flows
Message-ID: <20210726212903.GA11555@salvia>
References: <20210708033138.ef3af5a724d7b569c379c35e@uniroma2.it>
 <20210708133859.GA6745@salvia>
 <20210708183239.824f8e1ed569b0240c38c7a8@uniroma2.it>
 <CALPAGbJt_rb_r3M2AEJ_6VRsG+zXrEOza0U-6SxFGsERGipT4w@mail.gmail.com>
 <8EFE7482-6E0E-4589-A9BE-F7BC96C7876E@gmail.com>
 <20210709204851.90b847c71760aa40668a0971@uniroma2.it>
 <FEF1CBA8-62EC-483A-B7CA-50973020F27B@gmail.com>
 <20210713013116.441cc6015af001c4df4f16b0@uniroma2.it>
 <20210715221342.GA19921@salvia>
 <0B18A029-E4B5-4D74-AE9E-C617E5325190@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0B18A029-E4B5-4D74-AE9E-C617E5325190@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Ryoga,

On Mon, Jul 19, 2021 at 07:12:46PM +0900, Ryoga Saito wrote:
> Hi Pablo
> 
> I would like your comments for it.
> 
> I have 2 implementation ideas about fixing this patch:
> 
> 1.) fix only coding style pointed out in previous mail
> 2.) add sysctl parameter and change NF_HOOK to NF_HOOK_COND for user to
>     select behavior of hook call
> 
> I believed SRv6 encaps/decaps operations should be tracked with conntrack
> like any other virtual net-device based tunneling protocols (e.g. VXLAN,
> IPIP)

Agreed, users will be expecting consistent behaviour with the existing
net-device based tunneling infrastructure. The hook order you are
proposing look correct to me.

> even if the forwarding performance slows down because occurred by
> lack of considerations. and any other tunnels also have this overhead.

If you go for option 2, you can add a new specific static_key for
the lightweight tunnel netfilter hooks, this static key could be
turned on via sysctl. But I think this sysctl toggle should be
one-time (once enabled, you cannot disable it).

I'll help you with the benchmarking.

> Therefore, I support 1st idea. However, 2nd idea is ok if the overhead
> caused by adding new hook isn't acceptable.

I'd prefer option 1 too, I tend to dislike new sysctl toggles, the
specific static_key should remove the concern on the performance
impact for people that do not want to use this new infrastructure.

Thanks.
