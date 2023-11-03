Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F3E7C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 15:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbjKCP4k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 11:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjKCP4j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 11:56:39 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4FAD42
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 08:56:33 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qywXA-00063n-3X; Fri, 03 Nov 2023 16:56:32 +0100
Date:   Fri, 3 Nov 2023 16:56:32 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables 1/4] arptables-nft: use ARPT_INV flags
 consistently
Message-ID: <ZUUYMEGTRN2OFBwn@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20231103102330.27578-1-fw@strlen.de>
 <20231103102330.27578-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103102330.27578-2-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 03, 2023 at 11:23:23AM +0100, Florian Westphal wrote:
> These values are not always interchangeable, e.g.:
> 
> define IPT_INV_SRCDEVADDR	0x0080
> but:
> define ARPT_INV_SRCDEVADDR	0x0010
> 
> as these flags can be tested by libarp_foo.so such
> checks can yield incorrect results.

Hmm. This is a partial revert of 44457c0805905 ("xtables-arp: Don't use
ARPT_INV_*") and therefore very likely incomplete - e.g. it does not
reinstate ipt_to_arpt_flags() which was used in nft_arp_parse_meta().

Above commit introduced IPT_INV_SRCDEVADDR in the first place, iptables
does not make use of it.

A revert of that commit requires a thorough review of later changes in
arptables code as it may have allowed for some code-sharing which is no
longer possible then. So please hold back with this a bit, I'll check if
any follow-ups are required.

Thanks, Phil
