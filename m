Return-Path: <SRS0=4QBM=ZU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA565C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 13:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C72B021741
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 13:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfK1NIU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 08:08:20 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:41148 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbfK1NIU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 08:08:20 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iaJWo-0007kt-Qg; Thu, 28 Nov 2019 14:08:14 +0100
Date:   Thu, 28 Nov 2019 14:08:14 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Laura Garcia <nevola@gmail.com>
Subject: Re: Operation not supported when adding jump command
Message-ID: <20191128130814.GQ8016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Laura Garcia <nevola@gmail.com>
References: <20191126192752.GE8016@orbyte.nwl.cc>
 <AC4B6BFD-30FA-4A62-AD3C-3EB37029EC1B@cisco.com>
 <3a457e5b-be8f-e99d-fb0d-4826a15a4a55@netfilter.org>
 <89C24159-37F8-4D2F-B391-8A1D6AE403E7@cisco.com>
 <20191127150836.GJ8016@orbyte.nwl.cc>
 <3AE9B74A-37FB-4CDA-86FB-143F506D6C77@cisco.com>
 <20191127160646.GK8016@orbyte.nwl.cc>
 <7C2EF59A-57A3-4E55-92EB-7D64BC0A8417@cisco.com>
 <20191127172210.GM8016@orbyte.nwl.cc>
 <739A821F-2645-41B2-AADA-AA6C34A17335@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <739A821F-2645-41B2-AADA-AA6C34A17335@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Serguei,

On Thu, Nov 28, 2019 at 01:22:17AM +0000, Serguei Bezverkhi (sbezverk) wrote:
> Please see below the list of nftables rules the code generate to mimic only filter chain portion of kube proxy.
> 
> Here is the location of code programming these rules. 
> https://github.com/sbezverk/nftableslib-samples/blob/master/proxy/mimic-filter/mimic-filter.go
> 
> Most of rules are static, will be programed  just once when proxy comes up, with the exception is 2 rules in k8s-filter-services chain. The reference to the list of ports can change. Ideally it would be great to express these two rules with a single rule and a vmap, where the key must be service's ip AND service port, as it is possible to have a single service IP that can be associated with several ports and some of these ports might have an endpoint and some do not. So far I could not figure it out. Appreciate your thought/suggestions/critics. If you could file an issue for anything you feel needs to be discussed, that would be great.

What about something like this:

| table ip t {
| 	map m {
| 		type ipv4_addr . inet_service : verdict
| 		elements = { 192.168.80.104 . 8989 : goto do_reject }
| 	}
| 
| 	chain c {
| 		ip daddr . tcp dport vmap @m
| 	}
| 
| 	chain do_reject {
| 		reject with icmp type host-unreachable
| 	}
| }

For unknown reasons reject statement can't be used directly in a verdict
map, but the do_reject chain hack works.

> sudo nft list table ipv4table
> table ip ipv4table {
> 	set svc1-no-endpoints {
> 		type inet_service
> 		elements = { 8989 }
> 	}
> 
> 	chain filter-input {
> 		type filter hook input priority filter; policy accept;
> 		ct state new jump k8s-filter-services
> 		jump k8s-filter-firewall
> 	}
> 
> 	chain filter-output {
> 		type filter hook output priority filter; policy accept;
> 		ct state new jump k8s-filter-services
> 		jump k8s-filter-firewall
> 	}

Same ruleset for input and output? Seems weird given the daddr-based
filtering in k8s-filter-services.

Cheers, Phil
