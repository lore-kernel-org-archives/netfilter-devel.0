Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6138C33C9E
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 06:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6E1020721
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 06:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgBCG5E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 01:57:04 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:40792 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgBCG5E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 01:57:04 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iyVfG-0001e8-PX; Mon, 03 Feb 2020 07:56:58 +0100
Date:   Mon, 3 Feb 2020 07:56:58 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Proxy load balancer rules
Message-ID: <20200203065658.GT19873@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <DEB99F9B-0D1A-40DD-97C8-3FB0C4E24CD6@cisco.com>
 <20200131140909.GR28318@orbyte.nwl.cc>
 <20200131220558.GI795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131220558.GI795@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Fri, Jan 31, 2020 at 11:05:58PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Hi Serguei,
> > 
> > On Thu, Jan 30, 2020 at 05:12:07PM +0000, Serguei Bezverkhi (sbezverk) wrote:
> > [...]
> > > 
> > > !
> > > !   -m recent --rcheck --seconds 10800 --reap  --rsource - keywords I am looking for equivalent in  nftables  
> > > !
> > > 
> > > -A KUBE-XLB-BAJ42O6WMSSB7YGA -m comment --comment "services-9837/affinity-lb-esipp-transition:" -m recent --rcheck --seconds 10800 --reap --name KUBE-SEP-JAOQ4ZBNFGZ34AZ4 --mask 255.255.255.255 --rsource -j KUBE-SEP-JAOQ4ZBNFGZ34AZ4
> > > -A KUBE-XLB-BAJ42O6WMSSB7YGA -m comment --comment "services-9837/affinity-lb-esipp-transition:" -m recent --rcheck --seconds 10800 --reap --name KUBE-SEP-WLHDVQTL57VBPURE --mask 255.255.255.255 --rsource -j KUBE-SEP-WLHDVQTL57VBPURE
> > > -A KUBE-XLB-BAJ42O6WMSSB7YGA -m comment --comment "services-9837/affinity-lb-esipp-transition:" -m recent --rcheck --seconds 10800 --reap --name KUBE-SEP-5XWCIKNI3M4MWAMU --mask 255.255.255.255 --rsource -j KUBE-SEP-5XWCIKNI3M4MWAMU
> > 
> > There is no direct equivalent for recent extension in nftables (yet).
> 
> Do we need one? All use cases I've seen can be handled via set infra.

Me neither, but in theory there are hard to achieve (--hitcount) or even missing
(--rttl) features. Support in iptables-translate would be interesting,
too, but that's a different kettle of fish. :)

Cheers, Phil
