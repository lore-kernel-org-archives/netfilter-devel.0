Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30C1C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 16:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9C1A2073E
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 16:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgFVQiP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 12:38:15 -0400
Received: from mail.thelounge.net ([91.118.73.15]:23489 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729260AbgFVQiP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 12:38:15 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 49rFTK1qQHzXNv;
        Mon, 22 Jun 2020 18:38:13 +0200 (CEST)
Subject: Re: iptables user space performance benchmarks published
To:     Stefano Brivio <sbrivio@redhat.com>, Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>
References: <20200619141157.GU23632@orbyte.nwl.cc>
 <20200622124207.GA25671@salvia>
 <faf06553-c894-e34c-264e-c0265e3ee071@thelounge.net>
 <20200622182314.6267f247@redhat.com>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <231b771c-6544-9f2e-e8b1-16955c41d77a@thelounge.net>
Date:   Mon, 22 Jun 2020 18:38:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622182314.6267f247@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 22.06.20 um 18:23 schrieb Stefano Brivio:
> By the way, now nftables should natively support all the features from
> ipset.
> 
> My plan (for which I haven't found the time in months) would be to
> write some kind of "reference" wrapper to create nftables sets from
> ipset commands, and to render them back as ipset-style output.
> 
> I wonder if this should become the job of iptables-nft, eventually

no, thanks

way too much work behind to get a admin-backend calling nano and friends
to maintain that stuff and support a wild mix of ipv4 and ipv6 which is
assigend to the correct ipset

that's a whole and very fancy toolkit and when ruled out the issues of
my last mail probably everything works transparnet with iptables-legacy
and iptables-nft while keep ipset as it is a seperate layer

it's not only about assign, load and save but also about find, list and
count things - if someone wants it native when staring from scratch i
understand why but i don't want to in this lifetime :-)
