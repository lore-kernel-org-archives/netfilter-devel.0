From: Patrick McHardy <kaber@trash.net>
Subject: Re: [LARTC] How to balance OUTBOUND traffic by packet if..
Date: Fri, 14 Jan 2005 03:08:02 +0100
Message-ID: <41E72982.5000205@trash.net>
References: <1483.192.168.1.2.1105403313@maild.mine.nu>	<41E5E91C.6050606@dsl.pipex.com>
	<41E6694A.2020203@dsl.pipex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: LARTC@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	junk@maild.mine.nu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andy Furniss <andy.furniss@dsl.pipex.com>
In-Reply-To: <41E6694A.2020203@dsl.pipex.com>
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

Andy Furniss wrote:

> Seems still broken.
>
> I built vanilla(apart from nth) 2.6.10, new iptables 1.2.11 + 
> pom-200400621 with runme extra only said y to nth.
>
> I see -
>
> Chain OUTPUT (policy ACCEPT 817 packets, 103K bytes)
>  pkts bytes target     prot opt in     out     source destination
>    15  1260 MARK       all  --  *      eth0    0.0.0.0/0 
> 0.0.0.0/0           every 2th packet #0 MARK set 0x1
>    15  1260 MARK       all  --  *      eth0    0.0.0.0/0 
> 0.0.0.0/0           every 2th packet #1 MARK set 0x2
>
> Chain POSTROUTING (policy ACCEPT 817 packets, 103K bytes)
>  pkts bytes target     prot opt in     out     source destination
>     0     0            all  --  *      eth0    0.0.0.0/0 
> 0.0.0.0/0           MARK match 0x1
>    15  1260            all  --  *      eth0    0.0.0.0/0 
> 0.0.0.0/0           MARK match 0x2
> [root@amd /home/andy]# cat ./nth-test
> iptables -t mangle -A OUTPUT -o eth0 -m nth --counter 1 --every 2 
> --packet 0 -j MARK --set-mark 1
> iptables -t mangle -A OUTPUT -o eth0 -m nth --counter 1 --every 2 
> --packet 1 -j MARK --set-mark 2
> iptables -t mangle -A POSTROUTING -o eth0 -m mark --mark 1
> iptables -t mangle -A POSTROUTING -o eth0 -m mark --mark 2
>
> Any Ideas anyone?


Try adding "-m mark --mark X -j RETURN" rules after the MARK rules. The MARK
target is non-terminal, so you are overwriting the mark in the second rule.
Alternatively you can use "--start 1" in the one of the nth matches.

Regards
Patrick
