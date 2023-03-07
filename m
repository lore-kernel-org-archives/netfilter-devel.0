Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53438C678D5
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 12:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjCGMfG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 07:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjCGMfF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 07:35:05 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022DE497C4
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 04:35:03 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pZWWz-0000DE-KW; Tue, 07 Mar 2023 13:35:01 +0100
Date:   Tue, 7 Mar 2023 13:35:01 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 10/13] netfilter: nf_nat_redirect: use `struct
 nf_nat_range2` in ipv4 API
Message-ID: <20230307123501.GC13059@breakpoint.cc>
References: <20230305121817.2234734-1-jeremy@azazel.net>
 <20230305121817.2234734-11-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230305121817.2234734-11-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> `nf_nat_redirect_ipv4` takes a `struct nf_nat_ipv4_multi_range_compat`,
> but converts it internally to a `struct nf_nat_range2`.  Change the
> function to take the latter, factor out the code now shared with
> `nf_nat_redirect_ipv6`, move the conversion to the xt_REDIRECT module,
> and update the ipv4 range initialization in the nft_redir module.

Reviewed-by: Florian Westphal <fw@strlen.de>
