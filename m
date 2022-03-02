Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1EDC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Mar 2022 11:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbiCBLdP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 06:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236912AbiCBLdO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 06:33:14 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 96398205E2
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2022 03:32:29 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0B657625DD;
        Wed,  2 Mar 2022 12:30:57 +0100 (CET)
Date:   Wed, 2 Mar 2022 12:32:24 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>,
        kadlec@netfilter.org, hmmsjan@kpnplanet.nl
Subject: Re: TCP connection fails in a asymmetric routing situation
Message-ID: <Yh9VyPluvrmNQWUz@salvia>
References: <20220225123030.GK28705@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220225123030.GK28705@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Fri, Feb 25, 2022 at 01:30:30PM +0100, Florian Westphal wrote:
> https://bugzilla.redhat.com/show_bug.cgi?id=2051413
> 
> Gist is:
> as of 878aed8db324bec64f3c3f956e64d5ae7375a5de
> (" netfilter: nat: force port remap to prevent shadowing well-known
>  port"), tcp connections won't get established with asymmetric routing
> setups.
> 
> Workaround: Block conntrack for  LAN-LAN2 traffic by
> iptables  -t raw -A PREROUTING -j CT --notrack
> Or: echo 0 > /proc/sys/net/netfilter/nf_conntrack_tcp_loose
> 
> I'd guess that is because conntrack picks up the flow on syn-ack rather
> than syn, snat check then thinks that source port is < 16384 and dest
> port is large, so we do port rewrite but we do it on syn-ack and
> connection cannot complete because client and server have different
> views of the source ports involved.
> 
> Question is on how this can be prevented. I see a few solutions:
> 
> 1. Change ct->local_origin to "ct->no_srcremap" (or a new status bit)
> that indicates that this should not have src remap done, just like we
> do for locally generated connections.
> 
> 2. Add a new "mid-stream" status bit, then bypass the entire -t nat
> logic if its set. nf_nat_core would create a null binding for the
> flow, this also bypasses the "src remap" code.
> 
> 3. Simpler version: from tcp conntrack, set the nat-done status bits
> if its a mid-stream pickup.
> 
> Downside: nat engine (as-is) won't create a null binding, so connection
> will not be known to nat engine for masquerade source port clash
> detection.
> 
> I would go for 2) unless you have a better suggestion/idea.

Conntrack needs to see traffic in both directions, otherwise it is
pickup the state from the middle from time to time (part of the
history is lost for us).

What am I missing here?
