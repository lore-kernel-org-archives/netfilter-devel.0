From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Subject: Re: Question, my modifed -j LOG
Date: Sun, 21 Aug 2005 20:30:26 +0200
Message-ID: <4308C842.3040209@gmx.net>
References: <20050820172824.GE5638@aaricia.csbnet.se>	<Pine.LNX.4.61.0508202154050.18226@yvahk01.tjqt.qr>	<20050820202552.GF5638@aaricia.csbnet.se>	<Pine.LNX.4.61.0508210021050.22186@yvahk01.tjqt.qr>
	<20050821043728.GH5638@aaricia.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20050821043728.GH5638@aaricia.csbnet.se>
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

Joakim Axelsson schrieb:
> The router has never ever crashed in some 18 months now. Im not about to
> trade that for a possible unstable kernel. Its not needed. Well, it is not
> as the traffic amount pushes the CPU to 100%.

Since the student network I'm managing is comparable in size to yours
and we're going to get 1000 MBit upstream soon, I'd be interested in
your experiences regarding netfilter scalability. Did you profile that
machine to see where it spends most of its time? How big is the latency
introduced by the ruleset? And do you have data about CPU utilization
vs. network load?
Could submit your local patches to pom-ng or at least mail them to me?
I'd like to have a look and find out what can help in my situation.

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
