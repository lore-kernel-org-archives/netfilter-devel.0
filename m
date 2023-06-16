Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F130EB64D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Jun 2023 14:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345545AbjFPOfL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Jun 2023 10:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245256AbjFPOfK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Jun 2023 10:35:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF43E30C5
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jun 2023 07:35:04 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qAAXW-0003N9-A0; Fri, 16 Jun 2023 16:35:02 +0200
Date:   Fri, 16 Jun 2023 16:35:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] nft: use payload matching for layer 4 protocol
Message-ID: <ZIxzFjSg1PIxA5oU@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230609103030.108396-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609103030.108396-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 09, 2023 at 12:30:30PM +0200, Pablo Neira Ayuso wrote:
> This is an IPv4 header, which does not require the special handling
> as in IPv6, use the payload matching instead of meta l4proto which
> is slightly faster in this case.

Interestingly, xlate code did this distinction between IPv4 and IPv6
already. So using a payload match here is actually more consistent.

Patch applied, thanks!
