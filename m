Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78260C63798
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Nov 2020 14:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8B01206D8
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Nov 2020 14:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730717AbgK0OKz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Nov 2020 09:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730041AbgK0OKz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Nov 2020 09:10:55 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BFEC0613D1;
        Fri, 27 Nov 2020 06:10:54 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kieSW-0003ZF-6o; Fri, 27 Nov 2020 15:10:48 +0100
Date:   Fri, 27 Nov 2020 15:10:48 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: XFRM interface and NF_INET_LOCAL_OUT hook
Message-ID: <20201127141048.GL4647@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org
References: <20201125112342.GA11766@orbyte.nwl.cc>
 <20201126094021.GK8805@gauss3.secunet.de>
 <20201126131200.GH4647@orbyte.nwl.cc>
 <20201127095511.GD9390@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127095511.GD9390@gauss3.secunet.de>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 27, 2020 at 10:55:11AM +0100, Steffen Klassert wrote:
> On Thu, Nov 26, 2020 at 02:12:00PM +0100, Phil Sutter wrote:
> > > > 
> > > > Is this a bug or an expected quirk when using XFRM interface?
> > > 
> > > This is expected behaviour. The xfrm interfaces are plaintext devices,
> > > the plaintext packets are routed to the xfrm interface which guarantees
> > > transformation. So the lookup that assigns skb_dst(skb)->xfrm
> > > happens 'behind' the interface. After transformation,
> > > skb_dst(skb)->xfrm will be cleared. So this assignment exists just
> > > inside xfrm in that case.
> > 
> > OK, thanks for the clarification.
> > 
> > > Does netfilter match against skb_dst(skb)->xfrm? What is the exact case
> > > that does not work?
> > 
> > The reported use-case is a match against tunnel data in output hook:
> > 
> > | table t {
> > |     chain c {
> > |         type filter hook output priority filter
> > |         oifname eth0 ipsec out ip daddr 192.168.1.2
> > |     }
> > | }
> > 
> > The ipsec expression tries to extract that data from skb_dst(skb)->xfrm
> > if present. In xt_policy (for iptables), code is equivalent. The above
> > works when not using xfrm_interface. Initially I assumed one just needs
> > to adjust the oifname match, but even dropping it doesn't help.
> 
> Yes, this does not work with xfrm interfaces. As said, they are plaintext
> devices that guarantee transformation.
> 
> Maybe you can try to match after transformation by using the secpath,
> but not sure if that is what you need.

Secpath is used for input only, no?

I played a bit more with xfrm_interface and noticed that when used,
NF_INET_LOCAL_OUT hook sees the packet (an ICMP reply) only once instead
of twice as without xfrm_interface. I don't think using it should change
behaviour that much apart from packets without matching policy being
dropped. What do you think about the following fix? I checked forwarding
packets as well and it looks like behaviour is identical to plain
policy:

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index aa4cdcf69d471..24af61c95b4d4 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -317,7 +317,8 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
        skb_dst_set(skb, dst);
        skb->dev = tdev;
 
-       err = dst_output(xi->net, skb->sk, skb);
+       err = NF_HOOK(skb_dst(skb)->ops->family, NF_INET_LOCAL_OUT, xi->net,
+                     skb->sk, skb, NULL, skb_dst(skb)->dev, dst_output);
        if (net_xmit_eval(err) == 0) {
                struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
 
Thanks, Phil
