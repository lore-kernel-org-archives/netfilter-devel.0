From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: to solve the performance problem of netfilter
Date: Wed, 17 Dec 2003 16:55:54 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1071676553.1058.48.camel@nienna.balabit>
References: <32301.1071658647@www15.gmx.net>  <3FE075CC.2060707@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: tady@gmx.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <3FE075CC.2060707@tac.ch>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2003-12-17, sze keltezéssel 16:27-kor Roberto Nibali ezt írta:
> >>I tested the throughput of our linux firewall. the result is as follows,
> >>	linux(no netfilter)					580kpps
> >>	with netfilter(no ip_conntrack)	    450kpps
> >>	with ip_conntrack					295kpps
> >>So the throughput dropped about 40% when with ip_conntrack.
> >  
> > I can _not_ approve your results. I'm currently running a firewall
> > using conntrack with much more throughput than you mentioned above. I
> > did an (udp only for the moment) investigation on the latency
> > introduced by a netfilter firewall but could not find any significant
> > throughput decrease.  If someone is interessted have a look at
> > 
> > http://rnvs.informatik.uni-leipzig.de/ipp2p/
> 
> I fail to see how you had more throughput than he had. Unless I'm completely 
> mistaken, he's referring to kilo packets per second (kpps) which if you would 
> translate it to your measurements means that your UDP sender maxed out at 65kpps 
> with 64Bytes UDP packets. This is not comparable.

  Jozsef Kadlecsik has also done some benchmarking of ip_conntrack in a
Gigabit environment. The slides of his presentation prepared for the
Netfilter Workshop held in Budapest can be found at 

http://www.netfilter.org/~kadlec/workshop-2003-budapest/benchmark.sxi

  It contains tuning tips also, and is very interesting indeed. However,
I'd like to see NAT benchmarks as well. Jozsef mentioned that NAT
performance is horrible compared to conntrack, and it would be really
useful if bottlenecks could be identified. Would an OProfile benchmark
be useful?

-- 
 Regards,
   Krisztian KOVACS
