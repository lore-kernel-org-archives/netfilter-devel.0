From: Roberto Nibali <ratz@tac.ch>
Subject: Re: to solve the performance problem of netfilter
Date: Wed, 17 Dec 2003 18:01:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FE08BF9.8060404@tac.ch>
References: <32301.1071658647@www15.gmx.net>  <3FE075CC.2060707@tac.ch> <1071676553.1058.48.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tady@gmx.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1071676553.1058.48.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

>   Jozsef Kadlecsik has also done some benchmarking of ip_conntrack in a
> Gigabit environment. The slides of his presentation prepared for the
> Netfilter Workshop held in Budapest can be found at 
> 
> http://www.netfilter.org/~kadlec/workshop-2003-budapest/benchmark.sxi

Thank you very much for the pointer. Highly interesting, indeed. I was going to 
check out what happened during that workshop one of these days ;).

>   It contains tuning tips also, and is very interesting indeed.

 From a quick skimming over the slides I get the impression that due to 
excessive tweaking of certain variables in the proc-fs a possible discussion of 
his results is highly difficult. Some of the graphs looked extremely suspicious 
due to their sharp and steep curves. I'll have to invest some time into his 
findings. But his tests are indeed extremely interesting.

> However,
> I'd like to see NAT benchmarks as well. Jozsef mentioned that NAT
> performance is horrible compared to conntrack, 

Aehhm, cough, NAT compared to conntrack??

> and it would be really
> useful if bottlenecks could be identified. Would an OProfile benchmark
> be useful? 

When I did my high speed packet filtering tests with huge numbers of rules I 
used OProfile to measure L1 -> L2 transitions and TLB miss rates dependent on 
the amount of rules netfilter has to match against.

I am not sure OProfile helps in identifying the issues which are at work when 
using conntrack, NAT and Gbit networks. I suspect certain performance penalties 
due to the size of the conntrack (-slabs), the bucket size, the functions which 
parse the table and bad hardware ;).

My first try would be to readprofile the packet filter kernel and get some 
information from therein and then continue to isolate the culprit(s).

BTW, if you need fast NAT, use iproute2: ip rule add nat ...

Best regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
