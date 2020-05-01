Return-Path: <SRS0=Z556=6P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C30FCC4724C
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 17:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A14CA20857
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 17:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbgEARJC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 May 2020 13:09:02 -0400
Received: from hydra.sdinet.de ([136.243.3.21]:46804 "EHLO mail.sdinet.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbgEARJC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 May 2020 13:09:02 -0400
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 May 2020 13:09:01 EDT
Received: from aurora.sdinet.de (aurora.sdinet.de [193.103.159.39])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: haegar)
        by mail.sdinet.de (bofa-smtpd) with ESMTPSA id 0358234063C;
        Fri,  1 May 2020 19:01:13 +0200 (CEST)
Date:   Fri, 1 May 2020 19:01:12 +0200 (CEST)
From:   Sven-Haegar Koch <haegar@sdinet.de>
To:     Reindl Harald <h.reindl@thelounge.net>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: strage iptables counts of wireguard traffic
In-Reply-To: <1aa3eccc-032c-118e-1a4f-c129508696c5@thelounge.net>
Message-ID: <alpine.DEB.2.22.394.2005011859150.1855929@aurora.sdinet.de>
References: <1aa3eccc-032c-118e-1a4f-c129508696c5@thelounge.net>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 1 May 2020, Reindl Harald wrote:

> how can it be that a single peer has 2.8 GB traffic and in the raw table
> the whole udp traffic is only 417M?
> 
> iptables --verbose --list --table raw
> Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
>  pkts bytes target     prot opt in     out     source
> destination
>   17M 4378M INBOUND    all  --  wan    any     anywhere             anywhere
>   22M   20G ACCEPT     tcp  --  any    any     anywhere             anywhere
> 2802K  417M ACCEPT     udp  --  any    any     anywhere             anywhere
> 3678K  299M ACCEPT     icmp --  any    any     anywhere             anywhere
>   256  131K DROP       all  --  any    any     anywhere             anywhere
> 
> peer: cA4YZkh8GfPIrMtMwMPzutcfW5U0Ht5Gq2XHs5I9dlo=
>   preshared key: (hidden)
>   endpoint: *******
>   allowed ips: *********
>   latest handshake: 59 seconds ago
>   transfer: 148.09 MiB received, 2.67 GiB sent

Locally generated traffic does not pass through the raw PREROUTING 
table, it only passes through raw OUTPUT.

If wireguard is running on the same machine and the 2.67 GiB is sent by 
the wireguard daemon to the pear, it would only be in OUTPUT when not 
received from a third station first.

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
