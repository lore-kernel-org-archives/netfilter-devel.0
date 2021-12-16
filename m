Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F97FC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 15:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238185AbhLPPa1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 10:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbhLPPa0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 10:30:26 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94408C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 07:30:26 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mxsi8-0005PD-UT; Thu, 16 Dec 2021 16:30:24 +0100
Date:   Thu, 16 Dec 2021 16:30:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <eric@garver.life>
Subject: Re: [PATCH nf v3] netfilter: nat: force port remap to prevent
 shadowing well-known ports
Message-ID: <YbtbkP/F77ej9KkC@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Eric Garver <eric@garver.life>
References: <20211216152816.1481-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216152816.1481-1-fw@strlen.de>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 16, 2021 at 04:28:16PM +0100, Florian Westphal wrote:
> If destination port is above 32k and source port below 16k
> assume this might cause 'port shadowing' where a 'new' inbound
> connection matches an existing one, e.g.
> 
> inbound X:41234 -> Y:53 matches existing conntrack entry
>         Z:53 -> X:4123, where Z got natted to X.
> 
> In this case, new packet is natted to Z:53 which is likely
> unwanted.
> 
> We avoid the rewrite for connections that originate from local host:
> port-shadowing is only possible with forwarded connections.
> 
> Also adjust test case.
> 
> v3: no need to call tuple_force_port_remap if already in random mode
> 
> Cc: Eric Garver <eric@garver.life>
> Cc: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks for the quick follow-up!
