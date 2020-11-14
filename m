Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99ED1C55ABD
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Nov 2020 01:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C16E22256
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Nov 2020 01:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="HAefGWjQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgKNBz6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:55:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgKNBz6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 20:55:58 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C15A2225D;
        Sat, 14 Nov 2020 01:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605318957;
        bh=bvBQa1aHrc5u2eym5ixpn8V2pbjAJS/vj6NoLTlrsCE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HAefGWjQLDzjnTdTzsNFt9rK3ieKvKo7YcTWiMG5gH/mR+zmu26Ke0GM3nAI+eKFW
         5YS/3KbJfomHKdyoHSq4gWXhQ4/b1EFIaCvMZHTauhnDpu9wLME72wCvwUwyBm8hWb
         Ju8aJuIHo002q8oq572XdvCuTGUlkwgvT+H3nQwQ=
Date:   Fri, 13 Nov 2020 17:55:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201113175556.25e57856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111193737.1793-1-pablo@netfilter.org>
References: <20201111193737.1793-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 11 Nov 2020 20:37:28 +0100 Pablo Neira Ayuso wrote:
> The following patchset augments the Netfilter flowtable fastpath [1] to
> support for network topologies that combine IP forwarding, bridge and
> VLAN devices.
> 
> A typical scenario that can benefit from this infrastructure is composed
> of several VMs connected to bridge ports where the bridge master device
> 'br0' has an IP address. A DHCP server is also assumed to be running to
> provide connectivity to the VMs. The VMs reach the Internet through
> 'br0' as default gateway, which makes the packet enter the IP forwarding
> path. Then, netfilter is used to NAT the packets before they leave
> through the wan device.
> 
> Something like this:
> 
>                        fast path
>                 .------------------------.
>                /                          \
>                |           IP forwarding   |
>                |          /             \  .
>                |       br0               eth0
>                .       / \
>                -- veth1  veth2
>                    .
>                    .
>                    .
>                  eth0
>            ab:cd:ef:ab:cd:ef
>                   VM
> 
> The idea is to accelerate forwarding by building a fast path that takes
> packets from the ingress path of the bridge port and place them in the
> egress path of the wan device (and vice versa). Hence, skipping the
> classic bridge and IP stack paths.

The problem that immediately comes to mind is that if there is any
dynamic forwarding state the cache you're creating would need to be
flushed when FDB changes. Are you expecting users would plug into the
flowtable devices where they know things are fairly static?
