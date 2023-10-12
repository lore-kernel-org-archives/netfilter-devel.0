Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6093CDB47E
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Oct 2023 18:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347349AbjJLSRL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Oct 2023 14:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344076AbjJLSRK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Oct 2023 14:17:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75548BE
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Oct 2023 11:17:08 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qr0F8-0000LV-Kh
        for netfilter-devel@vger.kernel.org; Thu, 12 Oct 2023 20:17:06 +0200
Date:   Thu, 12 Oct 2023 20:17:06 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] libiptc: Fix for another segfault due to chain
 index NULL pointer
Message-ID: <ZSg4Ik3viRJZq5zT@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20231012160703.18198-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012160703.18198-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 12, 2023 at 06:07:03PM +0200, Phil Sutter wrote:
> Chain rename code missed to adjust the num_chains value which is used to
> calculate the number of chain index buckets to allocate during an index
> rebuild. So with the right number of chains present, the last chain in a
> middle bucket being renamed (and ending up in another bucket) triggers
> an index rebuild based on false data. The resulting NULL pointer index
> bucket then causes a segfault upon reinsertion.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1713
> Fixes: 64ff47cde38e4 ("libiptc: fix chain rename bug in libiptc")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
