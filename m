From: Roberto Nibali <ratz@tac.ch>
Subject: Re: to solve the performance problem of netfilter
Date: Wed, 17 Dec 2003 16:27:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FE075CC.2060707@tac.ch>
References: <32301.1071658647@www15.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: tady@gmx.net
In-Reply-To: <32301.1071658647@www15.gmx.net>
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

>>I tested the throughput of our linux firewall. the result is as follows,
>>	linux(no netfilter)					580kpps
>>	with netfilter(no ip_conntrack)	    450kpps
>>	with ip_conntrack					295kpps
>>So the throughput dropped about 40% when with ip_conntrack.
>  
> I can _not_ approve your results. I'm currently running a firewall
> using conntrack with much more throughput than you mentioned above. I
> did an (udp only for the moment) investigation on the latency
> introduced by a netfilter firewall but could not find any significant
> throughput decrease.  If someone is interessted have a look at
> 
> http://rnvs.informatik.uni-leipzig.de/ipp2p/

I fail to see how you had more throughput than he had. Unless I'm completely 
mistaken, he's referring to kilo packets per second (kpps) which if you would 
translate it to your measurements means that your UDP sender maxed out at 65kpps 
with 64Bytes UDP packets. This is not comparable.

So assuming my understanding is correct I'd say he's done tests on GBit Ethernet 
  _and_ I think he's using TCP too as I have myself seen those numbers (at least 
the relative performance drop with conntrack and TCP running switched GBit 
networks).

We (I) need more information from his part as there are solutions to solve his 
problems. At least I would need the average packet size, the NIC and driver 
used, the exact kernel (as there are for example TSO issues with regard to 
netfilter).

Best regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
