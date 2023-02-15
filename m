Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2190EC6379F
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Feb 2023 10:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbjBOKDf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Feb 2023 05:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbjBOKD0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Feb 2023 05:03:26 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3ED38675
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2023 02:02:41 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pSEcW-00036h-Hu; Wed, 15 Feb 2023 11:02:36 +0100
Date:   Wed, 15 Feb 2023 11:02:36 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Bryce Kahle <bryce.kahle@datadoghq.com>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: PROBLEM: nf_conntrack_events autodetect mode invalidates
 NETLINK_LISTEN_ALL_NSID netlink socket option
Message-ID: <20230215100236.GC9908@breakpoint.cc>
References: <CALvGib_xHOVD2+6tKm2Sf0wVkQwut2_z2gksZPcGw30tOvOAAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvGib_xHOVD2+6tKm2Sf0wVkQwut2_z2gksZPcGw30tOvOAAA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bryce Kahle <bryce.kahle@datadoghq.com> wrote:
> This affects kernels 5.19+. I have git bisected the kernel with a
> reproducer to identify the commit above. I can publish the reproducer
> on request.

Reproducer would help, thanks.
