Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8ECC4332F
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Nov 2023 22:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjKGWYz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Nov 2023 17:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjKGWYz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2023 17:24:55 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90A3EA
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2023 14:24:52 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1r0UV8-0007yl-Sz; Tue, 07 Nov 2023 23:24:50 +0100
Date:   Tue, 7 Nov 2023 23:24:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Eric Garver <eric@garver.life>
Subject: Re: [iptables PATCH] ebtables: Fix corner-case noflush restore bug
Message-ID: <ZUq5MsMzysrHrha/@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org, Eric Garver <eric@garver.life>
References: <20231107182500.29432-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231107182500.29432-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 07, 2023 at 07:25:00PM +0100, Phil Sutter wrote:
> Report came from firwalld, but this is actually rather hard to trigger.
> Since a regular chain line prevents it, typical dump/restore use-cases
> are unaffected.
> 
> Fixes: 73611d5582e72 ("ebtables-nft: add broute table emulation")
> Cc: Eric Garver <eric@garver.life>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
