Return-Path: <SRS0=edwS=ZZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D79FC432C3
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 23:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7517620656
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 23:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfLCXu1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 18:50:27 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47165 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725845AbfLCXu1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 18:50:27 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 4A2CE3A199D
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Dec 2019 10:50:10 +1100 (AEDT)
Received: (qmail 17698 invoked by uid 501); 3 Dec 2019 23:50:10 -0000
Date:   Wed, 4 Dec 2019 10:50:10 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     "Serguei Bezverkhi \(sbezverk\)" <sbezverk@cisco.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Operation not supported when adding jump command
Message-ID: <20191203235010.GA11671@dimstar.local.net>
Mail-Followup-To: "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <5248B312-60A9-48A7-B4CF-E00D1BDF1CD2@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5248B312-60A9-48A7-B4CF-E00D1BDF1CD2@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=RSmzAf-M6YYA:10 a=VYzkZdTHSGtxVSRd18UA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 25, 2019 at 06:55:41PM +0000, Serguei Bezverkhi (sbezverk) wrote:
> Hello Pablo,
>
> Please see below  table/chain/rules/sets I program,  when I try to add jump from input-net, input-local to services  it fails with " Operation not supported" , I would appreciate if somebody could help to understand why:
>
> sudo nft add rule ipv4table input-net jump services
> Error: Could not process rule: Operation not supported
> add rule ipv4table input-net jump services
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
>
> table ip ipv4table {
> 	set no-endpoint-svc-ports {
> 		type inet_service
> 		elements = { 8080, 8989 }
> 	}
>
> 	set no-endpoint-svc-addrs {
> 		type ipv4_addr
> 		flags interval
> 		elements = { 10.1.1.1, 10.1.1.2 }
> 	}
>
> 	chain input-net {
> 		type nat hook prerouting priority filter; policy accept;
> 	}
>
> 	chain input-local {
> 		type nat hook output priority filter; policy accept;
> 	}
>
> 	chain services {
> 		ip daddr @no-endpoint-svc-addrs tcp dport @no-endpoint-svc-ports reject with tcp reset
> 		ip daddr @no-endpoint-svc-addrs udp dport @no-endpoint-svc-ports reject with icmp type net-unreachable
> 	}
> }
>
> Thank you
> Serguei
>
Hi Serguei,

The reason it files is, from *man nft*:

> This statement [reject] is only valid in the input, forward and output chains,
> and user-defined chains which are only called from those chains.

(I inserted the bit in square brackets).

The wording could perhaps be clarified: what it really means to say is

Reject is only only valid in base chains using the input, forward or output
hooks, and user-defined chains which are only called from those chains.

Put that way, you can see why your command is rejected.

Cheers ... Duncan.
