Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9678BC00144
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jul 2022 09:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiG2Jy6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jul 2022 05:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiG2Jy6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jul 2022 05:54:58 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87589785A9
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jul 2022 02:54:56 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1oHMhq-0005Vg-CC; Fri, 29 Jul 2022 11:54:54 +0200
Date:   Fri, 29 Jul 2022 11:54:54 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Erik Skultety <eskultet@redhat.com>
Subject: Re: [iptables PATCH 1/3] tests: shell: Fix testcases for changed
 ip6tables opts output
Message-ID: <YuOubmfEJ3wZ750N@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Erik Skultety <eskultet@redhat.com>
References: <20220728113136.24376-1-phil@nwl.cc>
 <20220728132634.GC4816@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728132634.GC4816@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 28, 2022 at 03:26:34PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Adjust captured output, ip6tables prints '--' instead of spaces since
> > the commit in Fixes: tag.
> 
> Thanks, all 3 patches look good to me.

Series applied, thanks for your review.

Cheers, Phil
