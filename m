Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEBBC04AA5
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Aug 2022 10:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240820AbiHYKcs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Aug 2022 06:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237172AbiHYKcr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2022 06:32:47 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8931D9C1EB;
        Thu, 25 Aug 2022 03:32:44 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 31B1529C3F;
        Thu, 25 Aug 2022 13:32:42 +0300 (EEST)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id E5E5329D09;
        Thu, 25 Aug 2022 13:32:40 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 69AA33C0325;
        Thu, 25 Aug 2022 13:32:38 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 27PAWZLJ047634;
        Thu, 25 Aug 2022 13:32:37 +0300
Date:   Thu, 25 Aug 2022 13:32:35 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Jiri Wiesner <jwiesner@suse.de>
cc:     netfilter-devel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        lvs-devel@vger.kernel.org
Subject: Re: [RFC PATCH nf-next] netfilter: ipvs: Divide estimators into
 groups
In-Reply-To: <20220816162257.GA18621@incl>
Message-ID: <5af573f-b773-d43-4b11-dea3c2797d7e@ssi.bg>
References: <20220812103459.GA7521@incl> <f1657ace-59fb-7265-faf8-8a1a26aaf560@ssi.bg> <20220816162257.GA18621@incl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Tue, 16 Aug 2022, Jiri Wiesner wrote:

> On Sat, Aug 13, 2022 at 03:11:48PM +0300, Julian Anastasov wrote:
> > > The intention is to develop this RFC patch into a short series addressing
> > > the design changes proposed in [1]. Also, after moving the rate estimation
> > > out of softirq context, the whole estimator list could be processed
> > > concurrently - more than one work item would be used.
> > 
> > 	Other developers tried solutions with workqueues
> > but so far we don't see any results. Give me some days, may be
> > I can come up with solution that uses kthread(s) to allow later
> > nice/cpumask cfg tuning and to avoid overload of the system
> > workqueues.
> 
> The RFC patch already resolves the issue despite having the code still run in softirq context. Even if estimators were processed in groups, moving the rate estimation out of softirq context is a good idea. I am interested in implementing this. An alternative approach would be moving the rate estimation out of softirq context and reworking locking so that cond_resched() could be used to let other processes run as the scheduler sees fit. I would be willing to try to implement this alternative approach as well.

	I started reworking the estimation code. I think,
I'll have results in few days. I'm using kthreads, the
locking is ready, just finishing the cpumask/nice
configuration and will do simple tests. When a RFC patch
is ready we can comment what should be the final version.

Regards

--
Julian Anastasov <ja@ssi.bg>

