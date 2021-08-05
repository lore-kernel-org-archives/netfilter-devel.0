Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A516EC4338F
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Aug 2021 11:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83B8F61156
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Aug 2021 11:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240738AbhHELD4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Aug 2021 07:03:56 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58638 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240727AbhHELDz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 07:03:55 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id E166960043;
        Thu,  5 Aug 2021 13:03:02 +0200 (CEST)
Date:   Thu, 5 Aug 2021 13:03:34 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH nf] netfilter: conntrack: collect all entries in one cycle
Message-ID: <20210805110334.GA3995@salvia>
References: <20210726222919.5659-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210726222919.5659-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 27, 2021 at 12:29:19AM +0200, Florian Westphal wrote:
> Michal Kubecek reports that conntrack gc is responsible for frequent
> wakeups (every 125ms) on idle systems.
> 
> On busy systems, timed out entries are evicted during lookup.
> The gc worker is only needed to remove entries after system becomes idle
> after a busy period.
> 
> To resolve this, always scan the entire table.
> If the scan is taking too long, reschedule so other work_structs can run
> and resume from next bucket.
> 
> After a completed scan, wait for 2 minutes before the next cycle.
> Heuristics for faster re-schedule are removed.
> 
> GC_SCAN_INTERVAL could be exposed as a sysctl in the future to allow
> tuning this as-needed or even turn the gc worker off.

Applied, thanks.
