From: Michal Soltys <soltys@ziu.info>
Subject: Re: Bug#631945: HFSC warning issue
Date: Wed, 13 Jul 2011 01:28:14 +0200
Message-ID: <4E1CD88E.4030107@ziu.info>
References: <1310376412.8036.134.camel@luna.madrid.commsmundi.com>	<4E1AE4F1.6030905@ziu.info>	<4E1AE88F.803@ziu.info> <CAAJ8s-RGocriAycZv4cjkKGd2mwGF1UH_-uyi+fbwdeUhvMk7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 631945@bugs.debian.org, fdelawarde@wirelessmundi.com,
	netfilter-devel@vger.kernel.org, kaber@trash.net
To: 00bormoj@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from drutsystem.com ([80.72.38.138]:3543 "EHLO drutsystem.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab1GMABE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jul 2011 20:01:04 -0400
In-Reply-To: <CAAJ8s-RGocriAycZv4cjkKGd2mwGF1UH_-uyi+fbwdeUhvMk7g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11-07-11 17:07, 00bormoj@gmail.com wrote:
> Oops - my logs are again filled with the WARN_ON from
> net/sched/sch_hfsc.c:1427. Sorry for the confusion, it looks like
> "initialize parent's cl_cfmin properly in init_vf()" is not to blame.
>

Ah, ok then. It would be really weird if that was the actual cause. I
have few patches stacked for later, so it made me feel a bit uneasy :)

> This is an amd64 system. Vanilla kernel.org kernel except with fglrx
> (the amd/ati radeon proprietary driver - yes it is a router and an
> HTPC...) loaded. I should probably start bisecting then, but it's a
> little tough when it can take more than two days to trigger :(
>

 From what I can see, and if I haven't missed or misread anything:

That warning that gets triggered when next_time == 0 in
hfsc_schedule_watchdog() implies, that hfsc_dequeue() tried to dequeue a
packet, but no leaf had anything eligible for scheduling (realtime
criterion) and linksharing was upperlimited.

Now if there IS something to dequeue, then I don't see how next_time
could possibly be zero - that would mean there's no packet to schedule
at all. But if that happened, then hfsc_dequeue() would simply exit at
the very beginning due to: if (sch->q.qlen == 0) .

So it does look weird (like if something external messed with hfsc's
qlen) ...

Also note - the changes to sch_hfsc.c were pretty minimal since the last
kernel that worked for you. You might be searching for something else ...


ps.

You don't have to upperlimit every single class (which will cripple
linksharing between siblings) - if your aim is to match some interface's
speed, just set it in the single top class of your class hierarchy.

