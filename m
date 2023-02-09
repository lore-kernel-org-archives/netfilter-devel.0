Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3A9C636D6
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Feb 2023 15:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjBIPHm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Feb 2023 10:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjBIPHl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Feb 2023 10:07:41 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0087235A7;
        Thu,  9 Feb 2023 07:07:37 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pQ8WL-0006NP-O0; Thu, 09 Feb 2023 16:07:33 +0100
Date:   Thu, 9 Feb 2023 16:07:33 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Igor Artemiev <Igor.A.Artemiev@mcst.ru>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [lvc-project] [PATCH] netfilter: xt_recent: Fix attempt to
 update removed entry
Message-ID: <20230209150733.GA17303@breakpoint.cc>
References: <20230209125831.2674811-1-Igor.A.Artemiev@mcst.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209125831.2674811-1-Igor.A.Artemiev@mcst.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Igor Artemiev <Igor.A.Artemiev@mcst.ru> wrote:
> When both --remove and --update flag are specified, there's a code
> path at which the entry to be updated is removed beforehand,
> that leads to kernel crash. Update entry, if --remove flag
> don't specified.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.

How did you manage to do this?  --update and --remove are supposed
to be mutually exclusive.
