Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B23F7C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Nov 2022 15:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242334AbiKRPOJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Nov 2022 10:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242166AbiKRPN7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Nov 2022 10:13:59 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E4562FC11
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Nov 2022 07:13:57 -0800 (PST)
Date:   Fri, 18 Nov 2022 16:13:53 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tula Kraiser <tkraiser@arista.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Avoid race between tcp_packet packet processing and timeout set
 by a netfilter CTA_TIMEOUT message
Message-ID: <Y3ehMVHetV5Vx7R3@salvia>
References: <CAKh0D7xP9rmwes4zjwDAYvrB706Au3aLvfA25NV0+sYR17+-NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKh0D7xP9rmwes4zjwDAYvrB706Au3aLvfA25NV0+sYR17+-NQ@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Nov 10, 2022 at 10:03:43AM -0800, Tula Kraiser wrote:
> Hello,
> 
> We have been using the nat netfilter module to create NAT translations
> and then we offload the translations to our hardware. Once the
> translation is offloaded to hardware we expect only FIN and RST to be
> received by the linux stack. Once we finish programming the hardware
> we send a NETLINK message to the kernel setting the entry timeout to a
> larger value (we use the CTA_TIMEOUT for that). That's because we rely
> on hardware hitbit to indicate when the entry should be removed due to
> inactivity.

This sounds very much like the flowtable infrastructure [1], the TCP
FIN and RST handling is done in a similar way.

> Unfortunately there is a delay between receiving the notification of
> the translation (we subscribe to netfilter conntrack events for that)
> and the time we program the hardware where packets still make it into
> the kernel input queue. There is a race between the CTA_TIMEOUT
> message and the queue packets where the kernel can replace the timeout
> with its default values leading to the entry being removed
> prematurely.
> 
> 
> To avoid that we are proposing introducing a new attribute to the
> CTA_PROTOINFO for TCP where we set the IPS_FIXED_TIMEOUT_FLAG on the
> conntrack entry if the conntrack TCP state is less or equal to
> TCP_ESTABLISHED.  That takes care of the race.  We are modifying the
> tcp_packet routine to reset the IPS_FIXED_TIMEOUT_FLAG when the tcp
> state moves the established state so FINs can be processed correctly.
> 
> 
> Does this sound like a reasonable solution to the problem or are there
> better suggestions? Does this sound like an interesting patch to push
> upstream?

There are already several drivers that support hardware offload
through this infrastructure.

Someone contributed more detailed documentation about the flowtable [2].

Code can be found under net/netfilter/nf_flow_table*.c files.

[1] https://docs.kernel.org/networking/nf_flowtable.html
[2] https://thermalcircle.de/doku.php?id=blog:linux:flowtables_1_a_netfilter_nftables_fastpath
