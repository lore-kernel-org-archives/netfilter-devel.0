Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF67C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jan 2022 17:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbiA0RIf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 12:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbiA0RIe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 12:08:34 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C70C061714
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jan 2022 09:08:34 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nD8G7-0006qm-Tf; Thu, 27 Jan 2022 18:08:31 +0100
Date:   Thu, 27 Jan 2022 18:08:31 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xshared: Fix response to unprivileged users
Message-ID: <YfLRjynofXWBGFCo@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220120101653.28280-1-phil@nwl.cc>
 <YfLINxzIDlCwej1X@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfLINxzIDlCwej1X@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, Jan 27, 2022 at 05:28:39PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Jan 20, 2022 at 11:16:53AM +0100, Phil Sutter wrote:
> > Expected behaviour in both variants is:
> > 
> > * Print help without error, append extension help if -m and/or -j
> >   options are present
> > * Indicate lack of permissions in an error message for anything else
> > 
> > With iptables-nft, this was broken basically from day 1. Shared use of
> > do_parse() then somewhat broke legacy: it started complaining about
> > inability to create a lock file.
> > 
> > Fix this by making iptables-nft assume extension revision 0 is present
> > if permissions don't allow to verify. This is consistent with legacy.
> > 
> > Second part is to exit directly after printing help - this avoids having
> > to make the following code "nop-aware" to prevent privileged actions.
> 
> On top of this patch, it should be possible to allow for some
> nfnetlink command to be used from unpriviledged process.
> 
> I'm attaching a sketch patch, it skips module autoload which is should
> not be triggered by an unpriviledged process.
> 
> This should allow for better help with -m/-j if the module is present.

That's interesting. What's the use-case? With my patch, extension help
text printing works fine as unprivileged user. Does it allow to drop the
"revision == 0 && EPERM" hack?

Thanks, Phil
