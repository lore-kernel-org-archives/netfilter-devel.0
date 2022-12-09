Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398FBC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Dec 2022 20:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiLIU6l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Dec 2022 15:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiLIU6k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Dec 2022 15:58:40 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EE05AC6DB;
        Fri,  9 Dec 2022 12:58:39 -0800 (PST)
Date:   Fri, 9 Dec 2022 21:58:36 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Jiri Wiesner <jwiesner@suse.de>,
        yunhong-cgl jiang <xintian1976@gmail.com>,
        dust.li@linux.alibaba.com
Subject: Re: [PATCHv7 0/6] ipvs: Use kthreads for stats
Message-ID: <Y5OhfLeQiOXhQ2/s@salvia>
References: <20221122164604.66621-1-ja@ssi.bg>
 <Y5HTM6jY/ZRw+ar0@salvia>
 <Y5HV0EpOrQtdU11y@salvia>
 <1866fdd6-dff-67b5-cd66-41bc8962957d@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1866fdd6-dff-67b5-cd66-41bc8962957d@ssi.bg>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 08, 2022 at 07:03:44PM +0200, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Thu, 8 Dec 2022, Pablo Neira Ayuso wrote:
> 
> > On Thu, Dec 08, 2022 at 01:06:14PM +0100, Pablo Neira Ayuso wrote:
> > > On Tue, Nov 22, 2022 at 06:45:58PM +0200, Julian Anastasov wrote:
> > > > 	Hello,
> > > > 
> > > > 	This patchset implements stats estimation in kthread context.
> > > > It replaces the code that runs on single CPU in timer context every
> > > > 2 seconds and causing latency splats as shown in reports [1], [2], [3].
> > > > The solution targets setups with thousands of IPVS services, destinations
> > > > and multi-CPU boxes.
> > > 
> > > Series applied to nf-next, thanks.
> > 
> > Oh wait. I have to hold this back, I have a fundamental question:
> > 
> > [PATCHv7 4/6] ipvs: use kthreads for stats estimation
> > 
> > uses kthreads, these days the preferred interface for this is the
> > generic workqueue infrastructure.
> > 
> > Then, I can see patch:
> > 
> >  [PATCHv7 5/6] ipvs: add est_cpulist and est_nice sysctl vars
> > 
> > allows for CPU pinning which is also possible via sysfs.
> > 
> > Is there any particular reason for not using the generic workqueue
> > infrastructure? I could not find a reason in the commit logs.
> 
> 	The estimation can take long time when using
> multiple IPVS rules (eg. millions estimator structures) and
> especially when box has multiple CPUs due to the for_each_possible_cpu
> usage that expects packets from any CPU. With est_nice sysctl
> we have more control how to prioritize the estimation
> kthreads compared to other processes/kthreads that
> have latency requirements (such as servers). As a benefit,
> we can see these kthreads in top and decide if we will
> need some further control to limit their CPU usage (max
> number of structure to estimate per kthread).

OK, then my understanding is that you have requirements to have more
control on the kthreads than what the workqueue interface provides.

I can see there is WQ_HIGHPRI and WQ_CPU_INTENSIVE flags to signal
latency sensitive and work taking long time to complete in the
workqueue respectively, but I have never used them though. sysfs also
exposes cpumask and nice, but you set the nice level while creating
kthreads on-demand from the kernel itself using the value provided by
new sysctl knob to set the nice value.

I'd like to include the text above you wrote in the pull request.
Please, let me know if you would like to expand it, I'll apply these
to nf-next and prepare the pull request by tomorrow.

Thanks.
