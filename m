From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] update raw patch in POM
Date: Mon, 27 Jun 2005 14:07:44 +0200
Message-ID: <42BFEC10.20102@tac.ch>
References: <42A6AB19.2040106@tac.ch>	<42A6E685.3060408@eurodev.net>	<42AEF774.8060300@tac.ch>	<42B67BEC.1090105@tac.ch>	<20050621003441.GI8335@postel.suug.ch>	<42B76474.8080209@eurodev.net>	<20050621111328.GK8335@postel.suug.ch>	<42B81D75.8090205@trash.net>	<20050621215027.GP8335@postel.suug.ch>	<42B8B181.4020607@trash.net>	<20050622005243.GQ8335@postel.suug.ch>	<42B8DA09.9080406@eurodev.net>	<42B8E141.1080902@trash.net>	<42B94DFE.2070205@tac.ch>
	<42B9B00F.90601@trash.net>	<42BF9E5D.4000705@tac.ch>
	<42BFDBA1.7060002@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42BFDBA1.7060002@trash.net>
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

>>What neighbour needs to be resolved? The neighbour cache is full, only 4
>>addresses are involved, gc threshold is high, so no trashing. Or are we talking
>>different issues?
>  
> It was just a guess, I can't think of anywhere else where packets
> might have been queued for 30s, given that you have no packet
> sockets and probably don't have a long enough device queue that
> it would take 30s.

sem-arbeit:~# ip -s -s neigh show
172.23.2.30 dev eth0 lladdr 00:01:02:6c:23:f8 ref 3 used 0/0/69 nud reachable
172.23.2.31 dev eth0 lladdr 00:30:05:50:50:2b ref 1 used 3/0/224 nud reachable

That's all I have in the cache ;). The routing cache is more populated though:

sem-arbeit:~# ip -s -s route show cache
broadcast 255.255.255.255 from 172.23.10.16 dev lo  src 172.23.120.120
    cache <local,brd,src-direct>  users 1 age 136sec iif eth0
unreachable 172.27.1.10 from 172.27.232.50 dev lo  src 172.23.120.120
    cache  error 101 users 1 used 6 age 34sec iif eth0
local 172.23.120.120 from 172.23.2.31 dev lo  src 172.23.120.120
    cache <local,src-direct>  users 1 age 271sec iif eth0
broadcast 172.23.255.255 from 172.23.1.14 dev lo  src 172.23.120.120
    cache <local,brd,src-direct>  users 1 used 3 age 149sec iif eth0
unreachable 172.30.12.254 from 172.30.12.203 dev lo  src 172.23.120.120
    cache  error 101 users 1 used 29 age 11sec iif eth0
172.23.2.30 from 172.23.120.120 dev eth0
    cache  users 1 used 3 age 97sec mtu 1500 advmss 1460
local 172.23.120.120 from 172.23.134.111 dev lo  src 172.23.120.120
    cache <local,src-direct>  users 1 used 36 age 6sec iif eth0
172.23.2.30 from 172.23.120.120 tos lowdelay dev eth0
    cache  users 5 used 2 age 93sec mtu 1500 advmss 1460
unreachable 172.30.12.154 from 172.30.12.203 dev lo  src 172.23.120.120
    cache  error 101 users 1 used 5 age 182sec iif eth0
local 172.23.120.120 from 172.23.2.31 tos lowdelay dev lo  src 172.23.120.120
    cache <local,src-direct>  users 1 used 47504 age 0sec iif eth0
local 172.23.120.120 from 172.23.2.30 dev lo  src 172.23.120.120
    cache <local,src-direct>  users 1 used 37 age 93sec iif eth0
local 172.23.120.120 from 172.23.2.30 tos lowdelay dev lo  src 172.23.120.120
    cache <local,src-direct>  users 1 used 150 iif eth0
172.23.2.31 from 172.23.120.120 tos lowdelay dev eth0
    cache  users 5 used 3 age 225sec mtu 1500 advmss 1460
broadcast 255.255.255.255 from 172.23.10.19 dev lo  src 172.23.120.120
    cache <local,brd,src-direct>  users 1 used 1 age 100sec iif eth0
broadcast 172.23.255.255 from 172.23.232.138 dev lo  src 172.23.120.120
    cache <local,brd,src-direct>  users 1 used 1 age 32sec iif eth0
sem-arbeit:~#

>>>To confirm that
>>>theory you could play with the values in
>>>/proc/sys/net/ipv4/neigh/default and see if it changes anything.
>>
>>
>>I'll do that. How do you think I should instrument these values? And what does
>>the neighbour stuff have to do with conntrack timeouts?
> 
> 
> Try halving all values and see if it has any effects on the time
> it takes to unload the module.

Nope, I'll upload the new results shortly but the time is unchanged.

> I'm pretty sure the nf_reset + the wait-for-untracked-refs patches
> should take care of the problem, but to be sure it would be good
> to know where the delay came from.

Currently I do not run it with nf_reset patched kernels which is another really
strange thing. Some other timeout which is 30s? But I only see
udp_timeout_stream and icmp_timeout ...

Do you plan to submit the nf_reset and wait-for-untracked-refs patches for
mainline inclusion?

Best regards,
Robert Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
