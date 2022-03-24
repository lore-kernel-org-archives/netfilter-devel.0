Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B55C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Mar 2022 12:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350054AbiCXMWD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Mar 2022 08:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350115AbiCXMWA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Mar 2022 08:22:00 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B7AF62A0C;
        Thu, 24 Mar 2022 05:20:26 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 137E963040;
        Thu, 24 Mar 2022 13:17:32 +0100 (CET)
Date:   Thu, 24 Mar 2022 13:20:23 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: bug report and future request
Message-ID: <YjxiB6Jk4plpx48G@salvia>
References: <AE6DAC96-EC3E-43C9-A95A-B230842DD7B1@gmail.com>
 <20220321212750.GB24574@breakpoint.cc>
 <4B0C8933-C7D8-49BA-B7F2-29625B0865C1@gmail.com>
 <20220322103203.GD24574@breakpoint.cc>
 <04C4931B-553E-4FEA-85D4-B3E186520EE5@gmail.com>
 <FE0EEED5-48C9-412F-81BA-0028818C2EE8@gmail.com>
 <DB57EE0F-F4CE-4198-89E0-F25ED3C321A5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DB57EE0F-F4CE-4198-89E0-F25ED3C321A5@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 24, 2022 at 02:09:25PM +0200, Martin Zaharinov wrote:
> One more update 
> 
> I try to make rule for limiter in offload mode :
> 
> table inet nft-qos-static {
>         set limit_ul {
>                 typeof ip saddr
>                 flags dynamic
>         }
>         set limit_dl {
>                 typeof ip daddr
>                 flags dynamic
>         }
> 
>         chain upload {
>                 type filter hook prerouting priority filter ; policy accept;
>                 ip saddr @limit_ul drop;
>         }
> 
>         chain download {
>                 type filter hook postrouting priority filter; policy accept;
>                 ip daddr @limit_dl drop;
> 
>         }
>         flowtable fastnat {
>                 hook ingress priority filter; devices = { eth0, eth1 };
>         }
>         chain forward {
>                 type filter hook forward priority filter; policy accept;
>                 ip protocol { tcp , udp } flow offload @fastnat;
>         }
> }
> 
> its not work perfect only upload limit work , download get full channel 
> 
> in test i set 100mbit up/down  upload is stay on ~100mbit , but download up to 250-300mbit (i have this limit be my isp).
> 
> the problem is limiter work only for Upload , is it posible to make work on download rule ?

If you want to combine ratelimit/policing with flowtable, then you
have to use the ingress and egress hooks, not prerouting and
postrouting.

Make sure you place the flowtable in a priority that comes after the
priority of your ingress hook.
