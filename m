Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC047C63697
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Nov 2020 13:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C1E4206B2
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Nov 2020 13:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389788AbgKZNMD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389604AbgKZNMD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Nov 2020 08:12:03 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E979AC0613D4;
        Thu, 26 Nov 2020 05:12:02 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kiH44-0006pB-KQ; Thu, 26 Nov 2020 14:12:00 +0100
Date:   Thu, 26 Nov 2020 14:12:00 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: XFRM interface and NF_INET_LOCAL_OUT hook
Message-ID: <20201126131200.GH4647@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org
References: <20201125112342.GA11766@orbyte.nwl.cc>
 <20201126094021.GK8805@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126094021.GK8805@gauss3.secunet.de>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Steffen,

On Thu, Nov 26, 2020 at 10:40:21AM +0100, Steffen Klassert wrote:
> On Wed, Nov 25, 2020 at 12:23:42PM +0100, Phil Sutter wrote:
> > I am working on a ticket complaining about netfilter policy match
> > missing packets in OUTPUT chain if XFRM interface is being used.
> > 
> > I don't fully overlook the relevant code path, but it seems like
> > skb_dest(skb)->xfrm is not yet assigned when the skb is routed towards
> > XFRM interface and already cleared again (by xfrm_output_one?) before it
> > makes its way towards the real output interface. NF_INET_POST_ROUTING
> > hook works though.
> > 
> > Is this a bug or an expected quirk when using XFRM interface?
> 
> This is expected behaviour. The xfrm interfaces are plaintext devices,
> the plaintext packets are routed to the xfrm interface which guarantees
> transformation. So the lookup that assigns skb_dst(skb)->xfrm
> happens 'behind' the interface. After transformation,
> skb_dst(skb)->xfrm will be cleared. So this assignment exists just
> inside xfrm in that case.

OK, thanks for the clarification.

> Does netfilter match against skb_dst(skb)->xfrm? What is the exact case
> that does not work?

The reported use-case is a match against tunnel data in output hook:

| table t {
|     chain c {
|         type filter hook output priority filter
|         oifname eth0 ipsec out ip daddr 192.168.1.2
|     }
| }

The ipsec expression tries to extract that data from skb_dst(skb)->xfrm
if present. In xt_policy (for iptables), code is equivalent. The above
works when not using xfrm_interface. Initially I assumed one just needs
to adjust the oifname match, but even dropping it doesn't help.

Cheers, Phil
