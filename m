From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: Question, my modifed -j LOG
Date: Sun, 21 Aug 2005 21:12:23 +0200
Message-ID: <20050821191223.GJ5638@aaricia.csbnet.se>
References: <20050820172824.GE5638@aaricia.csbnet.se>
	<Pine.LNX.4.61.0508202154050.18226@yvahk01.tjqt.qr>
	<20050820202552.GF5638@aaricia.csbnet.se>
	<Pine.LNX.4.61.0508210021050.22186@yvahk01.tjqt.qr>
	<20050821043728.GH5638@aaricia.csbnet.se>
	<4308C842.3040209@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Content-Disposition: inline
In-Reply-To: <4308C842.3040209@gmx.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

2005-08-21 20:30:26+0200, Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net> ->
> Joakim Axelsson schrieb:
> > The router has never ever crashed in some 18 months now. Im not about to
> > trade that for a possible unstable kernel. Its not needed. Well, it is not
> > as the traffic amount pushes the CPU to 100%.
> 
> Since the student network I'm managing is comparable in size to yours
> and we're going to get 1000 MBit upstream soon, I'd be interested in
> your experiences regarding netfilter scalability. Did you profile that
> machine to see where it spends most of its time? How big is the latency
> introduced by the ruleset? And do you have data about CPU utilization
> vs. network load?

I have _alot_ of data as i have alot of measuring points in my netfilter
setup. However, i can't profile it. Its running sharp and i can go around
and play with it. I have to make educated guesses on where to but in some
effort in trying to save some CPU. In general however (atleast with 2.4.23)
uses the netfilter very much cpu of the totalt routing. Something like 70-80%
of the load is just netfilter. Specially is it easy to DoS the machine by
bringing alot of --state NEW packets. Thats why i try to enforce alot of
"smart" limiters in -t raw before those packets hit the conntrack code.

> Could submit your local patches to pom-ng or at least mail them to me?
> I'd like to have a look and find out what can help in my situation.
> 

I can submit my -m lim, -j ACCOUNT and -j SPEED. Upcoming is also a -m
norm(alizer) and as i have been speaking of a -m log. Also a -m srcdst which
matches either the src IP or the dst IP to some specified data (I have alot
of rules regarding some IP that doesn't matter in which direction the
packets is taking.). I also have plans for splitting up -m unclean in
different workareas, making it more suitable and not just a "dangerous
module to use, unless you know what your doing". I don't like getting its
reason printk()-logged beside the packets -j LOG.

However, in general i have to speak with my boss first before handing out
the entire or parts of the routers config and netfilter scripts i have. I
have done them during work hours and thus they belong the my employe. The
code in netfilter however, have i choosed to do in my own time, just so i
can submit them.

I have been waiting because i want to try them in 2.6 first before submit.
I'll se if i find time to finally wrap them up for pom-ng this coming week.

> Regards,
> Carl-Daniel
> -- 
> http://www.hailfinger.org/

-- 
/Joakim Axelsson A.K.A Gozem@EFnet
