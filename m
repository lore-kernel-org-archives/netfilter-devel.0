Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44B4C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3D58206E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbfG3MgJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:36:09 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42196 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726190AbfG3MgJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 08:36:09 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hsRLy-0003m8-Pk; Tue, 30 Jul 2019 14:35:42 +0200
Date:   Tue, 30 Jul 2019 14:35:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Rundong Ge <rdong.ge@gmail.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, roopa@cumulusnetworks.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, nikolay@cumulusnetworks.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bridge:fragmented packets dropped by bridge
Message-ID: <20190730123542.zrsrfvcy7t2n3d4g@breakpoint.cc>
References: <20190730122534.30687-1-rdong.ge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730122534.30687-1-rdong.ge@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rundong Ge <rdong.ge@gmail.com> wrote:
> Given following setup:
> -modprobe br_netfilter
> -echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
> -brctl addbr br0
> -brctl addif br0 enp2s0
> -brctl addif br0 enp3s0
> -brctl addif br0 enp6s0
> -ifconfig enp2s0 mtu 1300
> -ifconfig enp3s0 mtu 1500
> -ifconfig enp6s0 mtu 1500
> -ifconfig br0 up
> 
>                  multi-port
> mtu1500 - mtu1500|bridge|1500 - mtu1500
>   A                  |            B
>                    mtu1300

How can a bridge forward a frame from A/B to mtu1300?

> With netfilter defragmentation/conntrack enabled, fragmented
> packets from A will be defragmented in prerouting, and refragmented
> at postrouting.

Yes, but I don't see how that relates to the problem at hand.

> But in this scenario the bridge found the frag_max_size(1500) is
> larger than the dst mtu stored in the fake_rtable whitch is
> always equal to the bridge's mtu 1300, then packets will be dopped.

What happens without netfilter or non-fragmented packets?

> This modifies ip_skb_dst_mtu to use the out dev's mtu instead
> of bridge's mtu in bridge refragment.

It seems quite a hack?  The above setup should use a router, not a bridge.
