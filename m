Return-Path: <SRS0=M/8g=ZS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C95D1C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 22:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A25532064B
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 22:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfKZWPX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Nov 2019 17:15:23 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:37184 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbfKZWPX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Nov 2019 17:15:23 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iZj78-0007OH-FB; Tue, 26 Nov 2019 23:15:18 +0100
Date:   Tue, 26 Nov 2019 23:15:18 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Operation not supported when adding jump command
Message-ID: <20191126221518.GF8016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <5248B312-60A9-48A7-B4CF-E00D1BDF1CD2@cisco.com>
 <20191126122110.GD795@breakpoint.cc>
 <3DBD9E39-A0DF-4A69-93CC-4344617BDB2F@cisco.com>
 <20191126153850.pblaoj4xklfz5jgv@salvia>
 <427E92A6-2FFA-47CF-BF3B-C08961C978C9@cisco.com>
 <20191126155125.GD8016@orbyte.nwl.cc>
 <0A92D5EA-B158-4C7A-B85C-1692AE7C828B@cisco.com>
 <20191126192752.GE8016@orbyte.nwl.cc>
 <AC4B6BFD-30FA-4A62-AD3C-3EB37029EC1B@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AC4B6BFD-30FA-4A62-AD3C-3EB37029EC1B@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Nov 26, 2019 at 09:20:20PM +0000, Serguei Bezverkhi (sbezverk) wrote:
> It almost worked ( Check this out:
> sudo nft list table ipv4table
> table ip ipv4table {
> 	set no-endpoint-svc-ports {
> 		type inet_service
> 		elements = { 8080, 8989 }
> 	}
> 
> 	set no-endpoint-svc-addrs {
> 		type ipv4_addr
> 		flags interval
> 		elements = { 10.1.1.1, 10.1.1.2}
> 	}
> 
> 	chain input-net {
> 		type nat hook input priority filter; policy accept;
> 		jump services
> 	}
> 
> 	chain input-local {
> 		type nat hook output priority filter; policy accept;
> 		jump services
> 	}
> 
> 	chain services {
> 		ip daddr @no-endpoint-svc-addrs tcp dport @no-endpoint-svc-ports reject with tcp reset
> 		ip daddr @no-endpoint-svc-addrs udp dport @no-endpoint-svc-ports reject with icmp type net-unreachable
> 	}
> 
> 	chain svc1-endpoint-1 {
> 		ip protocol tcp dnat to 12.1.1.1:8080
> 	}
> 
> 	chain svc1-endpoint-2 {
> 		ip protocol tcp dnat to 12.1.1.2:8080
> 	}
> 
> 	chain svc2-endpoint-1 {
> 		ip protocol tcp dnat to 12.1.1.3:8090
> 	}
> 
> 	chain svc2-endpoint-2 {
> 		ip protocol tcp dnat to 12.1.1.4:8090
> 	}
> 
> 	chain svc1 {
> 	}
> 
> 	chain svc2 {
> 	}
> 
> 	chain prerouting {
> 		type nat hook prerouting priority filter; policy accept;
> 		ip daddr 1.1.1.1 tcp dport 88 numgen random mod 2 vmap { 0 : jump svc1-endpoint-1, 1 : jump svc1-endpoint-2 }
> 		ip daddr 2.2.2.2 tcp dport 99 numgen random mod 2 vmap { 0 : jump svc2-endpoint-1, 1 : jump svc2-endpoint-2 }
> 	}}
> 
> Ideally I need to apply  this rule " numgen random mod 2 vmap { 0 : jump svc1-endpoint-1, 1 : jump svc1-endpoint-2 }" to svc1 and svc2 chains to load balance between services' endpoints but when I do that it fails with Unsupported operation.
> In contrast it let me apply this rule to prerouting chain.

I don't see where you jump to svc1/svc2 so this is a bit of guesswork.
Anyway, please keep in mind that dnat is only supported from nat (and
prerouting or output).

> This split support of reject in input/forward/output and numgen only in prerouting is not ideal as a packet for a client  of a service without registered endpoint will need to go through all checks in prerouting chain before it reaches input chain and get its reject back.

As said, it is dnat which is limited to prerouting. Numgen itself works
everywhere. If there is a known criteria identifying a client without
registered endpoint, you could match on that and 'accept' early in
prerouting. This will make the packet go to input/forward directly
without traversing the remaining prerouting rules.

Cheers, Phil
