Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B22EC77B7F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 18:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjECSro (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 14:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjECSr1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 14:47:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41843C16
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2023 11:46:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1puHUk-0000Z4-GG; Wed, 03 May 2023 20:46:30 +0200
Date:   Wed, 3 May 2023 20:46:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netfilter-devel@vger.kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH nf-next 00/19] netfilter: nftables: dscp modification
 offload
Message-ID: <20230503184630.GB28036@breakpoint.cc>
References: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> Consider ruleset such as:
> 
> table inet filter {
>         chain forward {
>                 type filter hook forward priority filter; policy accept;
>                 ip dscp set cs3
>                 ct state established,related accept
>         }
> }
> 
> As expected, all of the packets from 10.0.2.99 to 10.0.1.99 have IPv4 tos field
> changed to 0x60:
> 
> ...
> 13:36:42.474591 fe:dc:b3:e2:dc:3b > 5a:45:4d:2a:25:65, ethertype IPv4 (0x0800), length 1090: (tos 0x60, ttl 62, id 39855, offset 0, flags [none], proto TCP (6), length 1076)
>     10.0.2.99.12345 > 10.0.1.99.44084: Flags [P.], cksum 0x1bec (incorrect -> 0x44c3), seq 1:1025, ack 1025, win 1987, options [nop,nop,TS val 2854899766 ecr 3249774499], length 1024
> ...
> 
> Now lets try to add flow offload:
> 
> table inet filter {
>         flowtable f1 {
>                 hook ingress priority filter
>                 devices = { veth0, veth1 }
>         }
> 
>         chain forward {
>                 type filter hook forward priority filter; policy accept;
>                 ip dscp set cs3
>                 ip protocol { tcp, udp, gre } flow add 
>                 ct state established,related accept
>         }
> }
> 
> Although some of the packets still have their TOS being correct, some are not:
> 
> ...
> 13:41:17.138782 5e:d5:1f:a3:ba:d1 > d2:d2:73:e6:5b:92, ethertype IPv4 (0x0800), length 1090: (tos 0x0, ttl 62, id 20142, offset 0, flags [none], proto TCP (6), length 1076)
>     10.0.2.99.12345 > 10.0.1.99.34230: Flags [P.], cksum 0x1bec (incorrect -> 0xc090), seq 1:1025, ack 1, win 2009, options [nop,nop,TS val 2855174430 ecr 3250049157], length 1024
> ...
> 
> The root cause for the bug seems to be that nft_payload_set_eval (which sets the
> dscp tos field) isn't being called on the offload fast path in
> nf_flow_offload_ip_hook.

I wish you would have reported this before you started to work on
this, because this is not a bug, this is expected behaviour.

Once you offload, the ruleset is bypassed, this is by design.
Lets not make the software offload more complex as it already is.

If you want to apply dscp payload modification, do not use flowtable
offload or hook those parts at netdev:ingress, it will be called before the
software offload pipeline.

I will reply to some of the changes to the shell tests because this
general reply above doesn't apply to those patches.
