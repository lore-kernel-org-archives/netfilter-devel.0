Return-Path: <SRS0=pcvh=2J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD25DC43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 10:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6D76222C2
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 10:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfLSKsi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 05:48:38 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:37038 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbfLSKsi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 05:48:38 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ihtMA-0006vn-DE; Thu, 19 Dec 2019 11:48:34 +0100
Date:   Thu, 19 Dec 2019 11:48:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Laura Garcia <nevola@gmail.com>
Cc:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Message-ID: <20191219104834.GD24932@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Laura Garcia <nevola@gmail.com>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
 <20191204223215.GX14469@orbyte.nwl.cc>
 <98A8233C-1A83-44A1-A122-6F80212D618F@cisco.com>
 <20191217122925.GD8553@orbyte.nwl.cc>
 <C5103001-881F-46A8-8738-EC8F8117FAE6@cisco.com>
 <20191217164140.GE8553@orbyte.nwl.cc>
 <6F72FC38-4238-4CCC-BAEB-A7F4B07817D7@cisco.com>
 <20191218172436.GA24932@orbyte.nwl.cc>
 <36EA0652-C146-4ED4-A004-2D729AB69BA7@cisco.com>
 <CAF90-Whnsiw=kEGyYroERYwo+_E2vWEv_3RtT89oSbp-9xoc1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF90-Whnsiw=kEGyYroERYwo+_E2vWEv_3RtT89oSbp-9xoc1A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Dec 18, 2019 at 08:58:12PM +0100, Laura Garcia wrote:
> On Wed, Dec 18, 2019 at 8:44 PM Serguei Bezverkhi (sbezverk)
> <sbezverk@cisco.com> wrote:
> >
> > Error: syntax error, unexpected th
> >
> > add rule ipv4table k8s-filter-services ip protocol . ip daddr . th dport vmap @no-endpoints-services
> >                                                                                                           ^^
> 

The th header expression is available since v0.9.2, you'll have to
update nftables to use it.

> Try this:
> 
> ... @th dport vmap ...

Wrong syntax.

> or
> 
> ... @th,16,16 vmap ...

This not working in concatenations was one of Florian's motivations to
implement th expression, see a43a696443a15 ("proto: add pseudo th
protocol to match d/sport in generic way") for details. :)

Cheers, Phil
