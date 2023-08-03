Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B42EEB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 14:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbjHCO0x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 10:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjHCO0x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 10:26:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5DCDA
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 07:26:50 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qRZHt-0005vi-67
        for netfilter-devel@vger.kernel.org; Thu, 03 Aug 2023 16:26:49 +0200
Date:   Thu, 3 Aug 2023 16:26:49 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] Makefile: Support 'make tags' and 'make cscope'
Message-ID: <ZMu5KZarZ4PQLgFq@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20230801165510.23976-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230801165510.23976-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 01, 2023 at 06:55:10PM +0200, Phil Sutter wrote:
> Copy necessary bits from generated Makefile.in into the static
> extensions/GNUmakefile.in so it plays nicely when called.
> 
> For some reason, using 'make ctags' creates a top-level tags file which
> does not include others, so not quite useful. Using 'make tags' instead
> works, but only after I created an etags-wrapper (calling ctags -e) in
> my ~/bin. Seems as per design, though.

This one sucks: 'make tags' won't cover headers in include/iptables and
include/linux because Makefile.am merely lists the directories in
EXTRA_DIST.

Since automake does not support anything involving wildcards, I see only
two options moving forward:

A) List the individual files in EXTRA_DIST instead of the directories
B) Replace Makefile.am by (yet another) GNUmakefile.in

While (A) means updating Makefile.am whenever a new linux header is
being cached, (B) is going into the false direction in my opinion.

Better ideas are appreciated, of course. :)

Cheers, Phil
