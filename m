Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2241C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Jan 2022 12:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241363AbiA2Mop (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Jan 2022 07:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239539AbiA2Mop (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Jan 2022 07:44:45 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EC8C061714
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jan 2022 04:44:45 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nDn5v-0002nw-G9; Sat, 29 Jan 2022 13:44:43 +0100
Date:   Sat, 29 Jan 2022 13:44:43 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables-nft 0/7] iptables: prefer native expressions for
 udp and tcp matches
Message-ID: <20220129124443.GK25922@breakpoint.cc>
References: <20220125165301.5960-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125165301.5960-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> This series switches iptables-nft to use native nft expressions
> (payload, cmp, range, bitwise) to match on ports and tcp flags.
> 
> Patches are split up to first add delinearization support and
> then switch the add/insert side over to generating those expressions.

I pushed this series out, with "_complete_" replaced with "_parse_"
in function names to make it more aligned with the other function
names.
