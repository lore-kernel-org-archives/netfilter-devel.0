Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012B4C282DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 18:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C821520663
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 18:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732524AbfDQSB5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 14:01:57 -0400
Received: from a3.inai.de ([88.198.85.195]:41038 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729939AbfDQSB5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 14:01:57 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id 9DFBA29E4D52; Wed, 17 Apr 2019 20:01:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 96B662A7EB2B;
        Wed, 17 Apr 2019 20:01:55 +0200 (CEST)
Date:   Wed, 17 Apr 2019 20:01:55 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Xiaozhou Liu <liuxiaozhou@bytedance.com>
cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        zhangyongsu@bytedance.com, wenxudong@bytedance.com
Subject: Re: [External Email] Re: RFC: NAT's default behavior of forwarding
 un-NATed packets
In-Reply-To: <20190417115457.l6fblixeihez7blc@bytedancedeMacBook-Air.local>
Message-ID: <nycvar.YFH.7.76.1904171958490.16281@n3.vanv.qr>
References: <20190417080242.jas4vongrv5fivzx@bytedancedeMacBook-Air.local> <nycvar.YFH.7.76.1904171048490.11120@n3.vanv.qr> <20190417115457.l6fblixeihez7blc@bytedancedeMacBook-Air.local>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wednesday 2019-04-17 13:54, Xiaozhou Liu wrote:
>On Wed, Apr 17, 2019 at 10:58:37AM +0200, Jan Engelhardt wrote:
>
>> I disagree. The ct state may be absent because the firewall has an empty state
>> (e.g. reboot / `conntrack -F`) — that alone does not make the TCP connection
>> invalid. Blocking ct-less packets breaks the user expectation to get a timely
>> response (the more so on connection shutdown).
>
>Allowing ct-less packets out does not help in this situation either. If for
>some reason the NAT's ct gets emptied, and some abnormal packets (orphaned
>SYN-ACK/FIN) pass through SNAT without NATed, they'd still carry their inner
>source IP (e.g. 192.168.X.X) in the header

Well argued. I also failed to notice that the return NF_ACCEPT; statement was
in nf_nat_core.c (as opposed to somewhere in general connection tracking).

>, which will not be respected outside
>of our private network. Hence, although the bad packets are not dropped by NAT,
>they can go to the internet but eventually gets dropped somewhere else.

Only if SNAT, but SNAT is not the only type of NAT that is possible.
Though I cannot think of a sensible use case involving DNAT where forwarding
to the original destination is meaningful either.

>On the other hand, we see that normal established-state packets can setup ct
>info on-the-fly even if NAT's ct gets emptied,

This mechanism is part of CT (not NAT), and I am not sure that will work
if the packet goes from public to private network (as there is no NAT entry,
there is no knowing where it could possibly go).
