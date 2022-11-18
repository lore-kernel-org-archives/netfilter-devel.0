Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2271C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Nov 2022 09:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbiKRJsi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241357AbiKRJsR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Nov 2022 04:48:17 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C468FFB8
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Nov 2022 01:47:50 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ovxyO-0001uv-IE; Fri, 18 Nov 2022 10:47:48 +0100
Date:   Fri, 18 Nov 2022 10:47:48 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 0/4] xt: Implement dump and restore support
Message-ID: <Y3dUxJZ6J4mg/KNh@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20221117174546.21715-1-phil@nwl.cc>
 <20221117211347.GB15714@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117211347.GB15714@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 17, 2022 at 10:13:47PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > If nft can't translate a compat expression, dump it in a format that can
> > be restored later without losing data, thereby keeping the ruleset
> > intact.
> 
> Why? :-( This cements nft_compat.c forever.

To avoid silently breaking a ruleset. It is a last resort measure for
cases where nft can't translate the ruleset into something meaningful. I
already submitted a patch adding a warning when listing tables
containing compat expressions (status unclear), but a real alternative
to the above would be to abort the listing or to ignore the table.

Listing the ruleset in translated form when iptables-nft can't parse the
translation or without translation but still maintaining syntax to be
parsed without error during a later restore is almost luring users into
doing stupid things.

> If we're goping to do it lets at least dump it properly,
> i.e.  nft ... add rule compat "-m conntrack --ctstate NEW".

This will make things worse: People will understand the format and start
using it despite the warnings. This adds a new user base to compat
expressions. I don't dare claiming nobody would start crafting compat
expressions in my zip-dump format, but it's at least a larger obstacle.
:D

> At this time I'd rather like a time machine to prevent nft_compat.c from
> getting merged :-(

If you do, please convince Pablo to not push iptables commit 384958620a.
I think it opened the can of worms we're trying to confine here.

Cheers, Phil
