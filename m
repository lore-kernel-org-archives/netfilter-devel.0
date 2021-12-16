Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA2BC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 12:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbhLPMri (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 07:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbhLPMrh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 07:47:37 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DD3C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 04:47:37 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mxqAY-0003yk-G8; Thu, 16 Dec 2021 13:47:34 +0100
Date:   Thu, 16 Dec 2021 13:47:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 4/6] xtables_globals: Introduce
 program_variant
Message-ID: <Ybs1ZhgVwqavtzeF@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20211213180747.20707-1-phil@nwl.cc>
 <20211213180747.20707-5-phil@nwl.cc>
 <YbpvLPEatqIKqhym@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbpvLPEatqIKqhym@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 15, 2021 at 11:41:48PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Dec 13, 2021 at 07:07:45PM +0100, Phil Sutter wrote:
> > This is supposed to hold the variant name (either "legacy" or
> > "nf_tables") for use in shared help/error printing functions.
> 
> Only one more nitpick: Probably you can store this in program_version?
> It is also string then this skips the binary layout update of
> xtables_globals.
> 
> .program_version = PACKAGE_VERSION VARIANT,
> 
> where VARIANT is " legacy" or " nf_tables".

Works fine, thanks for the hint!

> Apart from this, this batch LGTM, thanks.

I'll incorporate the change, resubmit and push if nobody complains in a
few hours.

Thanks, Phil
