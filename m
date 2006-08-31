From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: statistic match support in iptables snapshots
Date: Thu, 31 Aug 2006 17:08:38 +0200
Message-ID: <BAY103-F24A7DE4B639CB7E3909BCB23F0@phx.gbl>
References: <44F6F2D5.3030301@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <44F6F2D5.3030301@trash.net>
To: kaber@trash.net
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

Patrick McHardy wrote:

>Marco Berizzi wrote:
> > Sorry for breaking you again: is not possible
> > having multiple counters with 'nth mode'?
>
>No, why is that useful? You can just use multiple matches.

ok, it's clear.

Just the last question. I have tried to insert a couple of
rules with an out of range packet number and the kernel has
eaten them:

iptables -A FORWARD -m statistic --mode nth --every 2 --packet 0 -j ACCEPT
iptables -A FORWARD -m statistic --mode nth --every 2 --packet 1 -j ACCEPT
iptables -A FORWARD -m statistic --mode nth --every 2 --packet 2 -j ACCEPT
iptables -A FORWARD -m statistic --mode nth --every 2 --packet 20 -j ACCEPT

iptables -nvxL
Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               
destination
       0        0 ACCEPT     0    --  *      *       0.0.0.0/0            
0.0.0.0/0           statistic mode nth every 2
       0        0 ACCEPT     0    --  *      *       0.0.0.0/0            
0.0.0.0/0           statistic mode nth every 2 packet 1
       0        0 ACCEPT     0    --  *      *       0.0.0.0/0            
0.0.0.0/0           statistic mode nth every 2 packet 2
       0        0 ACCEPT     0    --  *      *       0.0.0.0/0            
0.0.0.0/0           statistic mode nth every 2 packet 20

uname -a
Linux Calimero 2.6.18-rc5 #1 PREEMPT Mon Aug 28 10:25:52 CEST 2006 i686 
unknown unknown GNU/Linux
