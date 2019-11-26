Return-Path: <SRS0=M/8g=ZS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF09BC432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 19:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB0FF207DD
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 19:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfKZT15 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Nov 2019 14:27:57 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:36902 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbfKZT15 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Nov 2019 14:27:57 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iZgV6-0005lZ-Hz; Tue, 26 Nov 2019 20:27:52 +0100
Date:   Tue, 26 Nov 2019 20:27:52 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Operation not supported when adding jump command
Message-ID: <20191126192752.GE8016@orbyte.nwl.cc>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0A92D5EA-B158-4C7A-B85C-1692AE7C828B@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Nov 26, 2019 at 06:47:09PM +0000, Serguei Bezverkhi (sbezverk) wrote:
> Ok, I guess I will work around by using input and output chain types, even though it will raise some brows in k8s networking community.
> 
> I have a second issue I am struggling to solve with nftables. Here is a service exposed for tcp port 80 which has 2 corresponding backends listening on a container port 8080.
> 
> !
> ! Backend 1
> !
> -A KUBE-SEP-FS3FUULGZPVD4VYB -s 57.112.0.247/32 -j KUBE-MARK-MASQ
> -A KUBE-SEP-FS3FUULGZPVD4VYB -p tcp -m tcp -j DNAT --to-destination 57.112.0.247:8080
> !
> ! Backend 2
> !
> -A KUBE-SEP-MMFZROQSLQ3DKOQA -s 57.112.0.248/32 -j KUBE-MARK-MASQ
> -A KUBE-SEP-MMFZROQSLQ3DKOQA -p tcp -m tcp -j DNAT --to-destination 57.112.0.248:8080
> !
> ! Service
> !
> -A KUBE-SERVICES -d 57.142.221.21/32 -p tcp -m comment --comment "default/app:http-web cluster IP" -m tcp --dport 80 -j KUBE-SVC-57XVOCFNTLTR3Q27
> !
> ! Load balancing between 2 backends
> !
> -A KUBE-SVC-57XVOCFNTLTR3Q27 -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-FS3FUULGZPVD4VYB
> -A KUBE-SVC-57XVOCFNTLTR3Q27 -j KUBE-SEP-MMFZROQSLQ3DKOQA
> 
> I am looking for nftables equivalent for the load balancing part and also in this case there are double dnat translation,  destination port from 80 to 8080 and destination IP:  57.112.0.247 or 57.112.0.248.
> Can it be expressed in a single nft dnat statement with vmaps or sets?

Regarding xt_statistic replacement, I once identified the equivalent of
'-m statistic --mode random --probability 0.5' would be 'numgen random
mod 0x2 < 0x1'.

Keeping both target address and port in a single map for *NAT statements
is not possible AFAIK.

If I'm not mistaken, you might be able to hook up a vmap together with
the numgen expression above like so:

| numgen random mod 0x2 vmap { \
|	0x0: jump KUBE-SEP-FS3FUULGZPVD4VYB, \
|	0x1: jump KUBE-SEP-MMFZROQSLQ3DKOQA }

Pure speculation, though. :)

Cheers, Phil
