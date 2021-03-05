Return-Path: <SRS0=VHt6=ID=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AA1C4332D
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Mar 2021 16:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74E0965094
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Mar 2021 16:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhCEQUv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 11:20:51 -0500
Received: from rs2.larkmoor.net ([162.211.66.16]:45378 "EHLO rs2.larkmoor.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230023AbhCEQU2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 11:20:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=larkmoor.net; s=larkmoor20140928;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject; bh=7qD2MEr3r8Ogs1AmU9192ZI3KSDAiTn/AGq9GdBj2do=;
        b=SGzq2bFAolQMA+yGbnUziq5dsMMAF8cWArZXFR6CCHmw/Tlh+z23yU1jMQwKThSNQnpTD1yecZjuwAh2yECDUP15YU43p27XFgsVFnj4CKGfjjUDGEVFdV0WP7mvM9zZiHi3o02/AbGTMkMn0MZSVZRi1s9+eUBTL753nAufAjs=;
Received: from [10.0.0.31]
        by gw.larkmoor.net with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <fmyhr@fhmtech.com>)
        id 1lIDBh-0007qK-Gk; Fri, 05 Mar 2021 11:20:25 -0500
Subject: Re: Kernel Error FLOW OFFLOAD on nftables
To:     =?UTF-8?B?0JzQsNC60YHQuNC8?= <maxbur89@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <CA+GUAtOnjr-bG41Ryf6YJsH66oBRBeBnTp9+8_1Zn--0OOiQ9g@mail.gmail.com>
From:   Frank Myhr <fmyhr@fhmtech.com>
Message-ID: <2f251cf4-e69e-f202-a061-6fd5b8b9df38@fhmtech.com>
Date:   Fri, 5 Mar 2021 11:20:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+GUAtOnjr-bG41Ryf6YJsH66oBRBeBnTp9+8_1Zn--0OOiQ9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I can't help with your kernel error, but have a couple of comments about 
your ruleset:

> Configuration nftables (nft list ruleset):
> table ip nat {
> chain postrouting {
> type nat hook postrouting priority 100; policy accept;
> counter packets 0 bytes 0
> oif "ens1f1" ip saddr 10.0.0.0/8 snat to 31.43.223.160-31.43.223.176 persistent
> oif "ens1f1" ip saddr 192.168.0.0/16 snat to
> 31.43.223.160-31.43.223.176 persistent
> oif "ens1f1" ip saddr 172.16.0.0/12 snat to
> 31.43.223.160-31.43.223.176 persistent
> counter packets 0 bytes 0
> }
> }
> table inet filter {
> flowtable fastnat {
> hook ingress priority 0
> devices = { ens1f0, ens1f1 }
> }
> 
> chain forward {
> type filter hook forward priority 0; policy accept;
> ip protocol { tcp, udp } flow offload @fastnat counter packets 3 bytes 323
> counter packets 3 bytes 323
> }
> }
> table ip raw {
> ct helper pptp-gre {
> type "pptp" protocol tcp
> l3proto ip
> }
> 
> chain prerouting {
> type filter hook prerouting priority -300; policy accept;
> tcp dport 1723 ct helper set "pptp-gre"
> counter packets 84 bytes 5147
> }

from nft man page:
"Unlike iptables, helper assignment needs to be performed after the 
conntrack lookup has completed, for example with the default 0 hook 
priority."

So I think you want priority > -200 for your prerouting chain.

https://wiki.nftables.org/wiki-nftables/index.php/Configuring_chains#Base_chain_priority

> }


I also wonder if using a single inet table rather than your 3 separate 
tables above would make any difference...?

Best Wishes,
Frank
