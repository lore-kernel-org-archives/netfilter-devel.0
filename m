Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CB1C10F12
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 08:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0CCC204FD
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 08:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfDQI6j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 04:58:39 -0400
Received: from a3.inai.de ([88.198.85.195]:50166 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726237AbfDQI6j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 04:58:39 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id 557D129E4D52; Wed, 17 Apr 2019 10:58:37 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 4AA6E29E4D4C;
        Wed, 17 Apr 2019 10:58:37 +0200 (CEST)
Date:   Wed, 17 Apr 2019 10:58:37 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Xiaozhou Liu <liuxiaozhou@bytedance.com>
cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        zhangyongsu@bytedance.com, wenxudong@bytedance.com
Subject: Re: RFC: NAT's default behavior of forwarding un-NATed packets
In-Reply-To: <20190417080242.jas4vongrv5fivzx@bytedancedeMacBook-Air.local>
Message-ID: <nycvar.YFH.7.76.1904171048490.11120@n3.vanv.qr>
References: <20190417080242.jas4vongrv5fivzx@bytedancedeMacBook-Air.local>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wednesday 2019-04-17 10:02, Xiaozhou Liu wrote:
>
>       ct = nf_ct_get(skb, &ctinfo);
>       /* Can't track?  It's not due to stress, or conntrack would
>        * have dropped it.  Hence it's the user's responsibilty to
>        * packet filter it out, or implement conntrack/NAT for that
>        * protocol. 8) --RR
>        */
>       if (!ct)
>              return NF_ACCEPT;
>
>But as normal users, we really want a NAT server which can work out of box as
>expected from users' point of view.

That depends on the user. NAT already breaks with expectations by messing with
the end-to-end principle for instance.

>That said, if any packet that is bad (in our case, orphaned SYN-ACK and FIN
>packets going out without getting a chance to setup conntrack), it's better to
>drop them in kernel by default.

I disagree. The ct state may be absent because the firewall has an empty state
(e.g. reboot / `conntrack -F`) — that alone does not make the TCP connection
invalid. Blocking ct-less packets breaks the user expectation to get a timely
response (the more so on connection shutdown).

NF_ACCEPT is the proper action, because it mirrors the default policy when the
firewall is unconfigured. Pretty much all common acts of dropping, directly or
indirectly, are opt-in.

>Is there any possibility to change this default behavior?

iptables -I FORWARD -m conntrack --ctstate UNTRACKED -j DROP

Or better yet, model your ruleset such that
 --ctstate NEW/ESTABLISHED/$OtherwiseGood -j ACCEPT
 -P DROP
