Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD4CFC6FD1C
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Mar 2023 22:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjCXWgz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Mar 2023 18:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbjCXWgy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2023 18:36:54 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF7F3A8F
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2023 15:36:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pfq1e-0004YN-BR; Fri, 24 Mar 2023 23:36:46 +0100
Date:   Fri, 24 Mar 2023 23:36:46 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v3 0/4] Support for shifted port-ranges in NAT
Message-ID: <20230324223646.GA17250@breakpoint.cc>
References: <20230324190419.543888-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324190419.543888-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> Commit 2eb0f624b709 ("netfilter: add NAT support for shifted portmap
> ranges") introduced support for shifting port-ranges in DNAT.  This
> allows one to redirect packets intended for one port to another in a
> range in such a way that the new port chosen has the same offset in the
> range as the original port had from a specified base value.
> 
> For example, by using the base value 2000, one could redirect packets
> intended for 10.0.0.1:2000-3000 to 10.10.0.1:12000-13000 so that the old
> and new ports were at the same offset in their respective ranges, i.e.:
> 
>   10.0.0.1:2345 -> 10.10.0.1:12345
> 
> However, while support for this was added to the common DNAT infra-
> structure, only the xt_nat module was updated to make use of it.  This
> patch-set extends the core support and updates all the nft NAT modules
> to support it too.
> 
> Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=970672
> Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1501

I have no objections to the kernel side.

Pablo, unless you disagree I'm inclined to merge this.
