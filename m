Return-Path: <SRS0=Z556=6P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195FEC47257
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 15:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 030FC216FD
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 15:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgEAPJO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 May 2020 11:09:14 -0400
Received: from mail.thelounge.net ([91.118.73.15]:58269 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728856AbgEAPJM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 May 2020 11:09:12 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 49DFyY5tRszXQ5
        for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2020 17:09:09 +0200 (CEST)
To:     netfilter-devel@vger.kernel.org
From:   Reindl Harald <h.reindl@thelounge.net>
Subject: strage iptables counts of wireguard traffic
Organization: the lounge interactive design
Message-ID: <1aa3eccc-032c-118e-1a4f-c129508696c5@thelounge.net>
Date:   Fri, 1 May 2020 17:09:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

how can it be that a single peer has 2.8 GB traffic and in the raw table
the whole udp traffic is only 417M?

iptables --verbose --list --table raw
Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source
destination
  17M 4378M INBOUND    all  --  wan    any     anywhere             anywhere
  22M   20G ACCEPT     tcp  --  any    any     anywhere             anywhere
2802K  417M ACCEPT     udp  --  any    any     anywhere             anywhere
3678K  299M ACCEPT     icmp --  any    any     anywhere             anywhere
  256  131K DROP       all  --  any    any     anywhere             anywhere

peer: cA4YZkh8GfPIrMtMwMPzutcfW5U0Ht5Gq2XHs5I9dlo=
  preshared key: (hidden)
  endpoint: *******
  allowed ips: *********
  latest handshake: 59 seconds ago
  transfer: 148.09 MiB received, 2.67 GiB sent
