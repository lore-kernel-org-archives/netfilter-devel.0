Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EF2C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 13:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ACFF206D7
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 13:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgFVNed (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 09:34:33 -0400
Received: from mail.thelounge.net ([91.118.73.15]:37445 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbgFVNed (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 09:34:33 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 49r9PL0lSTzXST;
        Mon, 22 Jun 2020 15:34:25 +0200 (CEST)
Subject: Re: iptables user space performance benchmarks published
To:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20200619141157.GU23632@orbyte.nwl.cc>
 <20200622124207.GA25671@salvia>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <faf06553-c894-e34c-264e-c0265e3ee071@thelounge.net>
Date:   Mon, 22 Jun 2020 15:34:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622124207.GA25671@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 22.06.20 um 14:42 schrieb Pablo Neira Ayuso:
> Hi Phil,
> 
> On Fri, Jun 19, 2020 at 04:11:57PM +0200, Phil Sutter wrote:
>> Hi Pablo,
>>
>> I remember you once asked for the benchmark scripts I used to compare
>> performance of iptables-nft with -legacy in terms of command overhead
>> and caching, as detailed in a blog[1] I wrote about it. I meanwhile
>> managed to polish the scripts a bit and push them into a public repo,
>> accessible here[2]. I'm not sure whether they are useful for regular
>> runs (or even CI) as a single run takes a few hours and parallel use
>> likely kills result precision.
> 
> So what is the _technical_ incentive for using the iptables blob
> interface (a.k.a. legacy) these days then?
> 
> The iptables-nft frontend is transparent and it outperforms the legacy
> code for dynamic rulesets.

it is not transparent enough because it don't understand classical ipset

my shell scripts creating the ruleset, cahins and ipsets can be switched
from iptables-legacy to iptables-nft and before the reboot despite the
warning that both are loaded it *looked* more or less fine comparing the
rulset from both backends

i gave it one try and used "iptables-nft-restore" and "ip6tables-nft",
after reboot nothing worked at all

via console i called "firewall.sh" again wich would delete all rules and
chains followed by re-create them, no success and errors that things
already exist

please don't consider to drop iptables-legacy, it just works and im miss
a compelling argument to rework thousands of hours
