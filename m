Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A24C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 17:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiLHREC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 12:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiLHREB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 12:04:01 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 427DE450A2;
        Thu,  8 Dec 2022 09:04:00 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 4FC2D372B6;
        Thu,  8 Dec 2022 19:03:58 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 024F837343;
        Thu,  8 Dec 2022 19:03:54 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 707053C07E2;
        Thu,  8 Dec 2022 19:03:50 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 2B8H3iO7059867;
        Thu, 8 Dec 2022 19:03:45 +0200
Date:   Thu, 8 Dec 2022 19:03:44 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Jiri Wiesner <jwiesner@suse.de>,
        yunhong-cgl jiang <xintian1976@gmail.com>,
        dust.li@linux.alibaba.com
Subject: Re: [PATCHv7 0/6] ipvs: Use kthreads for stats
In-Reply-To: <Y5HV0EpOrQtdU11y@salvia>
Message-ID: <1866fdd6-dff-67b5-cd66-41bc8962957d@ssi.bg>
References: <20221122164604.66621-1-ja@ssi.bg> <Y5HTM6jY/ZRw+ar0@salvia> <Y5HV0EpOrQtdU11y@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Thu, 8 Dec 2022, Pablo Neira Ayuso wrote:

> On Thu, Dec 08, 2022 at 01:06:14PM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Nov 22, 2022 at 06:45:58PM +0200, Julian Anastasov wrote:
> > > 	Hello,
> > > 
> > > 	This patchset implements stats estimation in kthread context.
> > > It replaces the code that runs on single CPU in timer context every
> > > 2 seconds and causing latency splats as shown in reports [1], [2], [3].
> > > The solution targets setups with thousands of IPVS services, destinations
> > > and multi-CPU boxes.
> > 
> > Series applied to nf-next, thanks.
> 
> Oh wait. I have to hold this back, I have a fundamental question:
> 
> [PATCHv7 4/6] ipvs: use kthreads for stats estimation
> 
> uses kthreads, these days the preferred interface for this is the
> generic workqueue infrastructure.
> 
> Then, I can see patch:
> 
>  [PATCHv7 5/6] ipvs: add est_cpulist and est_nice sysctl vars
> 
> allows for CPU pinning which is also possible via sysfs.
> 
> Is there any particular reason for not using the generic workqueue
> infrastructure? I could not find a reason in the commit logs.

	The estimation can take long time when using
multiple IPVS rules (eg. millions estimator structures) and
especially when box has multiple CPUs due to the for_each_possible_cpu
usage that expects packets from any CPU. With est_nice sysctl
we have more control how to prioritize the estimation
kthreads compared to other processes/kthreads that
have latency requirements (such as servers). As a benefit,
we can see these kthreads in top and decide if we will
need some further control to limit their CPU usage (max
number of structure to estimate per kthread).

Regards

--
Julian Anastasov <ja@ssi.bg>

