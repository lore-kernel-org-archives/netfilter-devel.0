Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D3EC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 23:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA3BE64F20
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 23:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhCQXgw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 19:36:52 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49572 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhCQXgd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 19:36:33 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 91A0B62BA4;
        Thu, 18 Mar 2021 00:36:29 +0100 (CET)
Date:   Thu, 18 Mar 2021 00:36:30 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH nf-next] netfilter: flowtable: separate replace, destroy
 and stats to different workqueues
Message-ID: <20210317233630.GA2480@salvia>
References: <20210303125953.11911-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210303125953.11911-1-ozsh@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 03, 2021 at 02:59:53PM +0200, Oz Shlomo wrote:
> Currently the flow table offload replace, destroy and stats work items are
> executed on a single workqueue. As such, DESTROY and STATS commands may
> be backloged after a burst of REPLACE work items. This scenario can bloat
> up memory and may cause active connections to age.
> 
> Instatiate add, del and stats workqueues to avoid backlogs of non-dependent
> actions. Provide sysfs control over the workqueue attributes, allowing
> userspace applications to control the workqueue cpumask.

I'm going to apply this to nf-next, it should be possible to revisit
this problem incrementally.

Applied, thanks for your patience.
