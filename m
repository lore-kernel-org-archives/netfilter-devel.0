Return-Path: <SRS0=U5wk=2I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A52DC2D0D1
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 17:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F25F72146E
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 17:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfLRRYk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 12:24:40 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:35340 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbfLRRYj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 12:24:39 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ihd3s-0006a8-Uh; Wed, 18 Dec 2019 18:24:36 +0100
Date:   Wed, 18 Dec 2019 18:24:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Message-ID: <20191218172436.GA24932@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <20191204151738.GR14469@orbyte.nwl.cc>
 <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
 <20191204155619.GU14469@orbyte.nwl.cc>
 <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
 <20191204223215.GX14469@orbyte.nwl.cc>
 <98A8233C-1A83-44A1-A122-6F80212D618F@cisco.com>
 <20191217122925.GD8553@orbyte.nwl.cc>
 <C5103001-881F-46A8-8738-EC8F8117FAE6@cisco.com>
 <20191217164140.GE8553@orbyte.nwl.cc>
 <6F72FC38-4238-4CCC-BAEB-A7F4B07817D7@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6F72FC38-4238-4CCC-BAEB-A7F4B07817D7@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Serguei,

On Wed, Dec 18, 2019 at 05:01:33PM +0000, Serguei Bezverkhi (sbezverk) wrote:
> I came across a situation when I need to match against L4 proto (tcp/udp), L3 daddr and L4 port(port value) with vmap.
> 
> Vmap looks like this:
> 
> 	map no-endpoints-services {
> 		type inet_proto . ipv4_addr . inet_service : verdict
> 	}
> 
> I was wondering if somebody could come up with a single line rule with reference to that vmap.

Should work using th header expression:

| ip protocol . ip daddr . th dport vmap @no-endpoints-services

Cheers, Phil
