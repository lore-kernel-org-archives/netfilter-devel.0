Return-Path: <SRS0=pcvh=2J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA52EC43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 15:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACDA4206EC
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 15:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfLSPpe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 10:45:34 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:37526 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbfLSPpe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 10:45:34 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ihxzW-0002Nk-7N; Thu, 19 Dec 2019 16:45:30 +0100
Date:   Thu, 19 Dec 2019 16:45:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Laura Garcia <nevola@gmail.com>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Message-ID: <20191219154530.GB30413@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        Laura Garcia <nevola@gmail.com>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <98A8233C-1A83-44A1-A122-6F80212D618F@cisco.com>
 <20191217122925.GD8553@orbyte.nwl.cc>
 <C5103001-881F-46A8-8738-EC8F8117FAE6@cisco.com>
 <20191217164140.GE8553@orbyte.nwl.cc>
 <6F72FC38-4238-4CCC-BAEB-A7F4B07817D7@cisco.com>
 <20191218172436.GA24932@orbyte.nwl.cc>
 <36EA0652-C146-4ED4-A004-2D729AB69BA7@cisco.com>
 <CAF90-Whnsiw=kEGyYroERYwo+_E2vWEv_3RtT89oSbp-9xoc1A@mail.gmail.com>
 <20191219104834.GD24932@orbyte.nwl.cc>
 <F1A3EFFB-7C17-4AC1-B543-C4789F2418A9@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F1A3EFFB-7C17-4AC1-B543-C4789F2418A9@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Dec 19, 2019 at 02:59:01PM +0000, Serguei Bezverkhi (sbezverk) wrote:
> Not sure why, but even with 0.9.2 "th" expression is not recognized.
> 
> error: syntax error, unexpected th
> add rule ipv4table k8s-filter-services ip protocol . ip daddr . th dport vmap @no-endpoints-services
>                                                                                                           ^^
> sbezverk@dev-ubuntu-1:mimic-filter$ sudo nft -version
> nftables v0.9.2 (Scram)
> sbezverk@dev-ubuntu-1:mimic-filter$
> 
> It seems 0.9.3 is out but still no Debian package. Is it possible it did not make it into 0.9.2?

Not sure what's missing on your end. I checked 0.9.2 tarball, at least
parser should understand the syntax.

Cheers, Phil
