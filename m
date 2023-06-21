Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8DDEB64D7
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Jun 2023 11:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjFULxJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Jun 2023 07:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjFULxI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2023 07:53:08 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D34D1703
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2023 04:53:07 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qBwOY-0007zY-0v; Wed, 21 Jun 2023 13:53:06 +0200
Date:   Wed, 21 Jun 2023 13:53:06 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jacek Tomasiak <jacek.tomasiak@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        Jacek Tomasiak <jtomasiak@arista.com>
Subject: Re: [iptables PATCH] iptables: Fix handling of non-existent chains
Message-ID: <ZJLkolFNPVChnQLF@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jacek Tomasiak <jacek.tomasiak@gmail.com>,
        netfilter-devel@vger.kernel.org,
        Jacek Tomasiak <jtomasiak@arista.com>
References: <20230619114636.7672-1-jacek.tomasiak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619114636.7672-1-jacek.tomasiak@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 19, 2023 at 01:46:36PM +0200, Jacek Tomasiak wrote:
> Since 694612adf87 the "compatibility" check considers non-existent
> chains as "incompatible". This broke some scripts which used calls
> like `iptables -L CHAIN404` to test for chain existence and expect
> "No chain/target/match by that name." in the output.
> 
> This patch changes the logic of `nft_is_table_compatible()` to
> report non-existent chains as "compatible" which restores the old
> behavior.
> 
> Fixes: 694612adf87 ("nft: Fix selective chain compatibility checks")
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1648
> Signed-off-by: Jacek Tomasiak <jtomasiak@arista.com>
> Signed-off-by: Jacek Tomasiak <jacek.tomasiak@gmail.com>

Also applied after adding testsuite coverage to it.

Thanks, Phil
