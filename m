Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D19DC43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 12:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F44320716
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 12:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfLQM33 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 07:29:29 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:60748 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727427AbfLQM32 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 07:29:28 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ihByf-0001mE-QF; Tue, 17 Dec 2019 13:29:25 +0100
Date:   Tue, 17 Dec 2019 13:29:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Message-ID: <20191217122925.GD8553@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <EC8889A1-27E2-4DC9-B752-514689982085@cisco.com>
 <20191204101819.GN8016@orbyte.nwl.cc>
 <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
 <20191204151738.GR14469@orbyte.nwl.cc>
 <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
 <20191204155619.GU14469@orbyte.nwl.cc>
 <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
 <20191204223215.GX14469@orbyte.nwl.cc>
 <98A8233C-1A83-44A1-A122-6F80212D618F@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98A8233C-1A83-44A1-A122-6F80212D618F@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Serguei,

On Tue, Dec 17, 2019 at 12:51:07AM +0000, Serguei Bezverkhi (sbezverk) wrote:
> In this google doc, see link: https://docs.google.com/document/d/128gllbr_o-40pD2i0D14zMNdtCwRYR7YM49T4L2Eyac/edit?usp=sharing

I avoid Google-Doc as far as possible. ;)

> There is a question about possible optimizations. I was wondering if you could comment/reply. Also I got one more question about updates of a set. Let's say there is a set with 10k entries, how costly would be the update of such set.

Regarding Rob's question: With iptables, for N balanced servers there
are N rules. With equal probabilities a package traverses N/2 rules on
average (unless I'm mistaken). With nftables, there's a single rule
which triggers the map lookup. In kernel, that's a lookup in rhashtable
and therefore performs quite well.

Another aspect to Rob's question is jitter: With iptables solution, a
packet may traverse all N rules before it is dispatched. The nftables
map lookup will happen in almost constant time.

I can't give you performance numbers, but it should be easy to measure.
Given that you won't need set content for insert or delete operations
while iptables fetches the whole table for each rule insert or delete
command, I guess you can imagine how the numbers will look like. But
feel free to verify, it's fun! :)

Cheers, Phil
