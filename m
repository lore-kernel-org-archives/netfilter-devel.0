From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: conntrack: use power efficient workqueue
Date: Tue, 7 Nov 2017 01:02:26 +0100
Message-ID: <20171107000226.GA1364@salvia>
References: <1509635767-12253-1-git-send-email-vincent.guittot@linaro.org>
 <20171106143155.GA8738@salvia>
 <20171106145632.GA20091@salvia>
 <CAKfTPtDXb5x23UzapinOo=Wg8fPf0G-sJoD1Dpw15e0sMteLEQ@mail.gmail.com>
 <20171106152533.GA27072@salvia>
 <CAKfTPtAXJsq4cYxyYbeBqYx8W9v8MBEdHqkxM4DfyrYMr+GPSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Vincent Guittot <vincent.guittot@linaro.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52156 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932831AbdKGACi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 19:02:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B6CF41F4B65
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2017 01:02:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4CF8DA7F1
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2017 01:02:36 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKfTPtAXJsq4cYxyYbeBqYx8W9v8MBEdHqkxM4DfyrYMr+GPSg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 06, 2017 at 05:33:43PM +0100, Vincent Guittot wrote:
> On 6 November 2017 at 16:25, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Nov 06, 2017 at 04:15:42PM +0100, Vincent Guittot wrote:
> >> Hi Pablo,
> >>
> >> On 6 November 2017 at 15:56, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> > On Mon, Nov 06, 2017 at 03:31:55PM +0100, Pablo Neira Ayuso wrote:
> >> >> On Thu, 2 Nov 2017 15:16:07 +0100 Vincent Guittot <vincent.guittot@linaro.org> wrote:
> >> >> > conntrack uses the bounded system_long_wq workqueue for its works that
> >> >> > don't have to run on the cpu they have been queued.  Using bounded
> >> >> > workqueue prevents the scheduler to make smart decision about the best
> >> >> > place to schedule the work.
> >> >> >
> >> >> > This patch replaces system_long_wq with system_power_efficient_wq.
> >> >> > the work stays bounded to a cpu by default unless the
> >> >> > CONFIG_WQ_POWER_EFFICIENT is enable. In the latter case, the work can
> >> >> > be scheduled on the best cpu from a power or a performance point of
> >> >> > view.
> >> >>
> >> >> Applied, thanks.
> >> >
> >> > I'm stepping back. According to what I'm reading
> >> > system_power_efficient_wq becomes system_wq when disabled, which is
> >> > not semantically the same as system_long_wq that we have now.
> >>
> >> When disabled, system_power_efficient_wq behaves like system_wq (and
> >> system_long_wq) as the worqueue are bounded to a cpu but It stays a
> >> different workqueue.
> >>
> >> > My concern is that the conntrack garbage collector may run for quite a
> >> > bit of time. Did you test this with a large conntrack table full of
> >>
> >> No, I haven't done specific tests with a large conntrack table full of entries.
> >>
> >> There is no system_power_efficient_long_wq. I was not convinced that
> >> we should create one that's why I have used system_power_efficient_wq
> >
> > My concern is that this garbage collector may run intensively on busy
> > conntrack tables to get rid of expired entries, so my question is if
> > switching from system_long_wq to system_wq is a real issue.
> 
> system_long_wq and system_wq have the same configuration. They are
> just named differently so people will use one or the other but they
> behave exactly the same.

I see, this confirms what I've been reading in the code, so it's just
another queue with a different name.

> Then system_power_efficient_wq is a 3rd workqueue that behaves like
> system_wq and system_long_wq when CONFIG_WQ_POWER_EFFICIENT is disable
> but uses ubounded workqueue when enabled
> 
> I don't think that switching from system_long_wq to
> system_power_efficient_wq is an issue.
> I haven't seen any problem so far but i'm haven't done specific tests
> that stress the system with a large conntrack table full of entries.
> Furthermore, these workqueue use default max active context (256)
> which means that other work should be able to run.

Thanks for explaining, I think then system_long_wq is missing a bit
its purpose, but this is out of my scope a bit, so I have pushed out
this to nf-next.git. Thanks!
