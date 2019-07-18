Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 047A6C76195
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 10:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDD8421841
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 10:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389961AbfGRKSH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 06:18:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:41322 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726482AbfGRKSH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 06:18:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 67F0DAF81;
        Thu, 18 Jul 2019 10:18:06 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 14A87E00A9; Thu, 18 Jul 2019 12:18:06 +0200 (CEST)
Date:   Thu, 18 Jul 2019 12:18:06 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: userspace conntrack helper and confirming the master conntrack
Message-ID: <20190718101806.GF24551@unicorn.suse.cz>
References: <20190718084943.GE24551@unicorn.suse.cz>
 <20190718092128.zbw4qappq6jsb4ja@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718092128.zbw4qappq6jsb4ja@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 18, 2019 at 11:21:28AM +0200, Florian Westphal wrote:
> > I added some more tracing and this is what seems to happen:
> > 
> >   - ipv4_confirm() is called for the conntrack from ip_output() via hook
> >   - nf_confirm() calls attached helper and calls its help() function
> >     which is nfnl_userspace_cthelper(), that returns 0x78003
> >   - nf_confirm() returns that without calling nf_confirm_conntrack()
> >   - verdict 0x78003 is returned to nf_hook_slow() which therefore calls
> >     nf_queue() to pass this to userspace helper on queue 7
> >   - nf_queue() returns 0 which is also returned by nf_hook_slow()
> >   - the packet reappears in nf_reinject() where it passes through
> >     nf_reroute() and nf_iterate() to the main switch statement
> >   - it takes NF_ACCEPT branch to call okfn which is ip_finish_output()
> >   - unless I missed something, there is nothing that could confirm the
> >     conntrack after that
> 
> I broke this with
> commit 827318feb69cb07ed58bb9b9dd6c2eaa81a116ad
> ("netfilter: conntrack: remove helper hook again").
> 
> Seems we have to revert, i see no other solution at this time.

Thanks for the quick reply. I can confirm that with commit 827318feb69c
reverted, the helper works as expected.

Michal 
