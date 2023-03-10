Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB78C64EC4
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Mar 2023 11:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjCJL4n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 06:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjCJL4S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 06:56:18 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7B50E4C64
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2023 03:56:05 -0800 (PST)
Date:   Fri, 10 Mar 2023 12:56:03 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [ipset PATCH 0/4] Some testsuite improvements
Message-ID: <ZAsa01H5FGddHC/a@salvia>
References: <20230307135812.25993-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230307135812.25993-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 07, 2023 at 02:58:08PM +0100, Phil Sutter wrote:
> Patch 1 fixes the reason why xlate testuite failed for me - it was
> simply not testing the right binary. Make it adhere to what the regular
> testsuite does by calling the built ipset tool instead of the installed
> one.
> 
> Patch 2 is just bonus, the idea for it came from a "does this even work"
> sanity check while debugging the above.
> 
> Patch 3 fixes for missing 'netmask' tool on my system. Not entirely
> satisfying though, there's no 'sendip', either (but the testsuite may
> run without).
> 
> Patch 4 avoids a spurious testsuite failure for me. Not sure if it's a
> good solution or will just move the spurious failure to others' systems.

LGTM
