Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55B6C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 16:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344453AbjKCQSo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 12:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343808AbjKCQSo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 12:18:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F105111
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 09:18:41 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qywsZ-0006XA-9a; Fri, 03 Nov 2023 17:18:39 +0100
Date:   Fri, 3 Nov 2023 17:18:39 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables 1/4] arptables-nft: use ARPT_INV flags
 consistently
Message-ID: <ZUUdXyKzjKzIYae/@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20231103102330.27578-1-fw@strlen.de>
 <20231103102330.27578-2-fw@strlen.de>
 <ZUUYMEGTRN2OFBwn@orbyte.nwl.cc>
 <20231103160129.GD8035@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103160129.GD8035@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 03, 2023 at 05:01:29PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Hmm. This is a partial revert of 44457c0805905 ("xtables-arp: Don't use
> > ARPT_INV_*") and therefore very likely incomplete - e.g. it does not
> > reinstate ipt_to_arpt_flags() which was used in nft_arp_parse_meta().
> > 
> > Above commit introduced IPT_INV_SRCDEVADDR in the first place, iptables
> > does not make use of it.
> > 
> > A revert of that commit requires a thorough review of later changes in
> > arptables code as it may have allowed for some code-sharing which is no
> > longer possible then. So please hold back with this a bit, I'll check if
> > any follow-ups are required.
> 
> Well, in that case it might be better to convert libarpt_mangle.c
> AND remove all of the ARTP_INV?

Indeed, I broke the checks for ARPT_INV_ARPHLN in there. That needs a
fix either way.

The ARPT_INV_* defines are part of UAPI. They can't be removed without
breaking (or also converting?) legacy arptables. Either way, we're
breaking third-party arptables DSOs using them. Right now, they are only
broken with arptables-nft. No idea if such DSOs exist, but if
compatibility is to be taken seriously, there's no way around reverting
above commit (and reintroducing do_commandarp() or at least a wrapper
around the shared do_parse()).

Cheers, Phil
