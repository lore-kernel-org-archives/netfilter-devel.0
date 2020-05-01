Return-Path: <SRS0=Z556=6P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B368CC47253
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 17:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 993C220857
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 17:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgEARHJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 May 2020 13:07:09 -0400
Received: from mail.thelounge.net ([91.118.73.15]:19901 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728972AbgEARHJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 May 2020 13:07:09 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 49DJZf6xnHzXQ5;
        Fri,  1 May 2020 19:07:06 +0200 (CEST)
Subject: Re: strage iptables counts of wireguard traffic
To:     Sven-Haegar Koch <haegar@sdinet.de>
Cc:     netfilter-devel@vger.kernel.org
References: <1aa3eccc-032c-118e-1a4f-c129508696c5@thelounge.net>
 <alpine.DEB.2.22.394.2005011859150.1855929@aurora.sdinet.de>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <1c3e6483-f307-a565-030d-d729cc7c4246@thelounge.net>
Date:   Fri, 1 May 2020 19:07:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.22.394.2005011859150.1855929@aurora.sdinet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 01.05.20 um 19:01 schrieb Sven-Haegar Koch:
> On Fri, 1 May 2020, Reindl Harald wrote:
> 
>> how can it be that a single peer has 2.8 GB traffic and in the raw table
>> the whole udp traffic is only 417M?
>>
>> iptables --verbose --list --table raw
>> Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
>>  pkts bytes target     prot opt in     out     source
>> destination
>>   17M 4378M INBOUND    all  --  wan    any     anywhere             anywhere
>>   22M   20G ACCEPT     tcp  --  any    any     anywhere             anywhere
>> 2802K  417M ACCEPT     udp  --  any    any     anywhere             anywhere
>> 3678K  299M ACCEPT     icmp --  any    any     anywhere             anywhere
>>   256  131K DROP       all  --  any    any     anywhere             anywhere
>>
>> peer: cA4YZkh8GfPIrMtMwMPzutcfW5U0Ht5Gq2XHs5I9dlo=
>>   preshared key: (hidden)
>>   endpoint: *******
>>   allowed ips: *********
>>   latest handshake: 59 seconds ago
>>   transfer: 148.09 MiB received, 2.67 GiB sent
> 
> Locally generated traffic does not pass through the raw PREROUTING 
> table, it only passes through raw OUTPUT.
> 
> If wireguard is running on the same machine and the 2.67 GiB is sent by 
> the wireguard daemon to the pear, it would only be in OUTPUT when not 
> received from a third station first.

thank you

ok, that's a valid argument - i thought raw PREROUTING is facing *every*
package

makes my stats missing some stuff but OK

---------------------------------------------------------------
1D/0H/9M - TRAFFIC - IPV4: 100%, IPV6: 0%, TCP: 96.1%, UDP: 2%, ICMP:
1.4%, DROP: 0.7%
---------------------------------------------------------------
ALL  4    6  TCP  UDP   ICMP  TCP4  TCP6  UDP4  UDP6  ICMP4  ICMP6  DROP
21G  21G  0  20G  416M  304M  20G   0     416M  0     304M   0      147M
