Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C24C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Apr 2022 16:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345588AbiD1QQF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Apr 2022 12:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiD1QQE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Apr 2022 12:16:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EE113D3E
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2022 09:12:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nk6l4-0002Q4-PL; Thu, 28 Apr 2022 18:12:46 +0200
Date:   Thu, 28 Apr 2022 18:12:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Steve Brecher <steve@sbrecher.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Minor issue in iptables(8) man page
Message-ID: <20220428161246.GG9849@breakpoint.cc>
References: <f7f0656d-4634-caad-c562-3121756f5afb@sbrecher.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7f0656d-4634-caad-c562-3121756f5afb@sbrecher.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Steve Brecher <steve@sbrecher.com> wrote:
> Hi,
> 
> The 4th section of the page, Tables, begins, "There are currently three
> independent tables ..." but lists four tables (filter, nat, mangle, and
> raw).

Update :-)  This was fixed in 2013.
