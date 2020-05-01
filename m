Return-Path: <SRS0=Z556=6P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D71AFC47253
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 15:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C202320857
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 15:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgEAPrt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 May 2020 11:47:49 -0400
Received: from mail.thelounge.net ([91.118.73.15]:59957 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728495AbgEAPrt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 May 2020 11:47:49 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 49DGq71MrGzXQ5;
        Fri,  1 May 2020 17:47:47 +0200 (CEST)
Subject: Re: strage iptables counts of wireguard traffic
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
References: <1aa3eccc-032c-118e-1a4f-c129508696c5@thelounge.net>
 <nycvar.YFH.7.76.2005011738430.19024@n3.vanv.qr>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <e1f6d0b4-4aa1-7fad-b487-c4a1fe84f74b@thelounge.net>
Date:   Fri, 1 May 2020 17:47:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <nycvar.YFH.7.76.2005011738430.19024@n3.vanv.qr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 01.05.20 um 17:39 schrieb Jan Engelhardt:
> On Friday 2020-05-01 17:09, Reindl Harald wrote:
> 
>> how can it be that a single peer has 2.8 GB traffic and in the raw table
>> the whole udp traffic is only 417M?
> 
>> iptables --verbose --list --table raw
>> Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
> 
> Uh that's the policy counter, not the entire-table counter.

and why do do you strip the other lines when nobody cares about the
policy line at all?

how did the 2.8 GB wireguard udp traffic magically pass the stateless
raw table with only 417M bytes in the udp rule?

iptables --verbose --list --table raw
Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source
destination
  17M 4378M INBOUND    all  --  wan    any     anywhere             anywhere
  22M   20G ACCEPT     tcp  --  any    any     anywhere             anywhere
2802K  417M ACCEPT     udp  --  any    any     anywhere             anywhere
3678K  299M ACCEPT     icmp --  any    any     anywhere             anywhere
  256  131K DROP       all  --  any    any     anywhere             anywhere
