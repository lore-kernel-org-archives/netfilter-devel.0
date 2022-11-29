Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91028C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 18:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbiK2SZD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 13:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235644AbiK2SY7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 13:24:59 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A673F61518
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 10:24:57 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p05Hr-0000Oz-LY; Tue, 29 Nov 2022 19:24:55 +0100
Date:   Tue, 29 Nov 2022 19:24:55 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fwestpha@redhat.com>
Subject: Re: [iptables PATCH] tests: shell: Test selective ebtables flushing
Message-ID: <Y4ZOd0SuekFZlCBV@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org,
        Florian Westphal <fwestpha@redhat.com>
References: <20221129142338.2394-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129142338.2394-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 29, 2022 at 03:23:38PM +0100, Phil Sutter wrote:
> Found this on disk, maybe there was a problem with this and among match
> at some point? Anyway, it is relevant again since it fails recently.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
