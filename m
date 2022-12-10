Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56549C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Dec 2022 00:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiLJAsF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Dec 2022 19:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLJAsE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Dec 2022 19:48:04 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 795BB21270;
        Fri,  9 Dec 2022 16:48:02 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id EDF703C7AB;
        Sat, 10 Dec 2022 02:47:59 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 907993C811;
        Sat, 10 Dec 2022 02:47:55 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id BDF6F3C07EF;
        Sat, 10 Dec 2022 02:47:51 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 2BA0ljIP161290;
        Sat, 10 Dec 2022 02:47:46 +0200
Date:   Sat, 10 Dec 2022 02:47:45 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Jiri Wiesner <jwiesner@suse.de>,
        yunhong-cgl jiang <xintian1976@gmail.com>,
        dust.li@linux.alibaba.com
Subject: Re: [PATCHv7 0/6] ipvs: Use kthreads for stats
In-Reply-To: <Y5OhfLeQiOXhQ2/s@salvia>
Message-ID: <6d155743-5bd-ba4e-225d-ac2875c99c76@ssi.bg>
References: <20221122164604.66621-1-ja@ssi.bg> <Y5HTM6jY/ZRw+ar0@salvia> <Y5HV0EpOrQtdU11y@salvia> <1866fdd6-dff-67b5-cd66-41bc8962957d@ssi.bg> <Y5OhfLeQiOXhQ2/s@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Fri, 9 Dec 2022, Pablo Neira Ayuso wrote:

> On Thu, Dec 08, 2022 at 07:03:44PM +0200, Julian Anastasov wrote:
> > 
> > > Is there any particular reason for not using the generic workqueue
> > > infrastructure? I could not find a reason in the commit logs.
> > 
> > 	The estimation can take long time when using
> > multiple IPVS rules (eg. millions estimator structures) and
> > especially when box has multiple CPUs due to the for_each_possible_cpu
> > usage that expects packets from any CPU. With est_nice sysctl
> > we have more control how to prioritize the estimation
> > kthreads compared to other processes/kthreads that
> > have latency requirements (such as servers). As a benefit,
> > we can see these kthreads in top and decide if we will
> > need some further control to limit their CPU usage (max
> > number of structure to estimate per kthread).
> 
> OK, then my understanding is that you have requirements to have more
> control on the kthreads than what the workqueue interface provides.
> 
> I can see there is WQ_HIGHPRI and WQ_CPU_INTENSIVE flags to signal
> latency sensitive and work taking long time to complete in the
> workqueue respectively, but I have never used them though. sysfs also
> exposes cpumask and nice, but you set the nice level while creating
> kthreads on-demand from the kernel itself using the value provided by
> new sysctl knob to set the nice value.

	There are probably more reasons why kthreads look
better:

- with kthreads we run code that is read-mostly, no write/lock
operations to process the estimators in 2-second intervals

- work items are one-shot: as estimators are processed every
2 seconds, they need to be re-added every time. This again
loads the timers (add_timer) if we use delayed works, as there are
no kthreads to do the timings.

> I'd like to include the text above you wrote in the pull request.
> Please, let me know if you would like to expand it, I'll apply these
> to nf-next and prepare the pull request by tomorrow.

	There is such paragraph in 0/6:

===
	Spread the estimation on multiple (configured) CPUs and
multiple time slots (timer ticks) by using multiple chains
organized under RCU rules. When stats are not needed, it is recommended
to use run_estimation=0 as already implemented before this change.
===

	After it we can add something like that which
explains why we prefer kthreads over work queue from
performance point of view:

===
	Solution with kthreads was preferred over workqueues
because there is less overhead to process the entries in
specific time intervals:

- entries are not unlinked before processing, so no write/lock
operations to re-queue them
- not using kernel timers as it is done by the delayed works,
the entries do not change position in lists and processing
is read-only
===

Regards

--
Julian Anastasov <ja@ssi.bg>

