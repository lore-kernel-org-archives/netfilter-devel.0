Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E08FC61DA4
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Feb 2023 20:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjBIURV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Feb 2023 15:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjBIURU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Feb 2023 15:17:20 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97025ACD7;
        Thu,  9 Feb 2023 12:17:18 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pQDM0-0008Dn-Fu; Thu, 09 Feb 2023 21:17:12 +0100
Date:   Thu, 9 Feb 2023 21:17:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Florian Westphal <fw@strlen.de>,
        Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [lvc-project] [PATCH] netfilter: xt_recent: Fix attempt to
 update removed entry
Message-ID: <20230209201712.GB17303@breakpoint.cc>
References: <20230209125831.2674811-1-Igor.A.Artemiev@mcst.ru>
 <20230209150733.GA17303@breakpoint.cc>
 <6152n4q7-1ssr-521p-786s-71q4q9731370@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6152n4q7-1ssr-521p-786s-71q4q9731370@vanv.qr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jan Engelhardt <jengelh@inai.de> wrote:
> On Thursday 2023-02-09 16:07, Florian Westphal wrote:
> 
> >Igor Artemiev <Igor.A.Artemiev@mcst.ru> wrote:
> >> When both --remove and --update flag are specified, there's a code
> >> path at which the entry to be updated is removed beforehand,
> >> that leads to kernel crash. Update entry, if --remove flag
> >> don't specified.
> >> 
> >> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> >
> >How did you manage to do this?  --update and --remove are supposed
> >to be mutually exclusive.
> 
> I suppose the exclusivity is only checked at the iptables command-line
> and neverwhere else.

Removing the userspace check gives me an -EINVAL from checkentry.
