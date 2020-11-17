Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124C9C2D0E4
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Nov 2020 11:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAC8824630
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Nov 2020 11:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgKQL4I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 06:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgKQL4I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 06:56:08 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A786AC0613CF
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2020 03:56:07 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kezae-0005Vp-B1; Tue, 17 Nov 2020 12:56:04 +0100
Date:   Tue, 17 Nov 2020 12:56:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] ebtables: Fix for broken chain renaming
Message-ID: <20201117115604.GW11766@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117110804.GA12096@salvia>
 <20201117110725.GH22792@breakpoint.cc>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Nov 17, 2020 at 12:07:25PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Loading extensions pollutes 'errno' value, hence before using it to
> > indicate failure it should be sanitized. This was done by the called
> > function before the parsing/netlink split and not migrated by accident.
> > Move it into calling code to clarify the connection.
> > 
> > Fixes: a7f1e208cdf9c ("nft: split parsing from netlink commands")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Heh.  Thanks for adding a test -- LGTM, feel free to push this.

DONE. Thanks for the quick review, I'll go fix Fedora now. :/

On Tue, Nov 17, 2020 at 12:08:04PM +0100, Pablo Neira Ayuso wrote:
> LGTM, this is fixing one recent netfilter's bugzilla ticket, right?

Oh, right! I noticed it because of a ticket for Fedora[1]. Will close
nfbz#1481 as well. Thanks for the heads-up!

Cheers, Phil

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1898130
