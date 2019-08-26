Return-Path: <SRS0=4EdP=WW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B132C3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 07:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E90C20874
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 07:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730190AbfHZH7f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 03:59:35 -0400
Received: from a3.inai.de ([88.198.85.195]:35432 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730136AbfHZH7f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 03:59:35 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id 80EC73BB696A; Mon, 26 Aug 2019 09:59:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 7FE983BB6EEC;
        Mon, 26 Aug 2019 09:59:33 +0200 (CEST)
Date:   Mon, 26 Aug 2019 09:59:33 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Florian Westphal <fw@strlen.de>
cc:     Rundong Ge <rdong.ge@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        roopa@cumulusnetworks.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        nikolay@cumulusnetworks.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bridge:fragmented packets dropped by bridge
In-Reply-To: <20190730123542.zrsrfvcy7t2n3d4g@breakpoint.cc>
Message-ID: <nycvar.YFH.7.76.1908260955400.22383@n3.vanv.qr>
References: <20190730122534.30687-1-rdong.ge@gmail.com> <20190730123542.zrsrfvcy7t2n3d4g@breakpoint.cc>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tuesday 2019-07-30 14:35, Florian Westphal wrote:
>Rundong Ge <rdong.ge@gmail.com> wrote:
>> Given following setup:
>> -modprobe br_netfilter
>> -echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
>> -brctl addbr br0
>> -brctl addif br0 enp2s0
>> -brctl addif br0 enp3s0
>> -brctl addif br0 enp6s0
>> -ifconfig enp2s0 mtu 1300
>> -ifconfig enp3s0 mtu 1500
>> -ifconfig enp6s0 mtu 1500
>> -ifconfig br0 up
>> 
>>                  multi-port
>> mtu1500 - mtu1500|bridge|1500 - mtu1500
>>   A                  |            B
>>                    mtu1300
>
>How can a bridge forward a frame from A/B to mtu1300?

There might be a misunderstanding here judging from the shortness of this
thread.

I understood it such that the bridge ports (eth0,eth1) have MTU 1500, yet br0
(in essence the third bridge port if you so wish) itself has MTU 1300.

Therefore, frame forwarding from eth0 to eth1 should succeed, since the
1300-byte MTU is only relevant if the bridge decides the packet needs to be
locally delivered.
