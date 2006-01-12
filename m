From: Patrick McHardy <kaber@trash.net>
Subject: Re: new iptables policy match
Date: Thu, 12 Jan 2006 11:42:34 +0100
Message-ID: <43C6329A.8010101@trash.net>
References: <BAY103-F16E9571FF1B70C7DBB70A1B2270@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F16E9571FF1B70C7DBB70A1B2270@phx.gbl>
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

Marco Berizzi wrote:

> Ok, my fault sorry. Here is my corrected (I hope) iptables rules:
> 
> iptables -P FORWARD DROP
> iptables -F
> 
> iptables -A FORWARD -m policy --dir out --pol ipsec --mode tunnel 
> --tunnel-src 10.1.2.0/24 --tunnel-dst 10.1.1.0/24 -j DROP
> iptables -A FORWARD -m policy --dir in  --pol ipsec  --mode tunnel 
> --tunnel-dst 10.1.2.0/24 --tunnel-src 10.1.1.0/24 -j DROP
> 
> iptables -A FORWARD -m policy --dir in --pol ipsec --mode tunnel 
> --tunnel-src 10.1.2.0/24 --tunnel-dst 10.1.1.0/24 -j DROP
> iptables -A FORWARD -m policy --dir out  --pol ipsec  --mode tunnel 
> --tunnel-dst 10.1.2.0/24 --tunnel-src 10.1.1.0/24 -j DROP
> 
> 
> iptables -A FORWARD -s 10.1.2.0/24 -d 10.1.1.10/24 -j ACCEPT
> iptables -A FORWARD -d 10.1.2.0/24 -s 10.1.1.10/24 -j ACCEPT
> 
> iptables -L -v output:
> 
> root@Calimero:/tmp/RACOON# iptables -L -v
> Chain INPUT (policy ACCEPT 11574 packets, 2434K bytes)
> pkts bytes target     prot opt in     out     source               
> destination
> 
> Chain FORWARD (policy DROP 0 packets, 0 bytes)
> pkts bytes target     prot opt in     out     source               
> destination
>    0     0 DROP       all  --  any    any     anywhere             
> anywhere            policy match dir out pol ipsec mode tunnel 
> tunnel-dst 10.1.1.0/24 tunnel-src 10.1.2.0/24
>    0     0 DROP       all  --  any    any     anywhere             
> anywhere            policy match dir in pol ipsec mode tunnel tunnel-dst 
> 10.1.2.0/24 tunnel-src 10.1.1.0/24
>    0     0 DROP       all  --  any    any     anywhere             
> anywhere            policy match dir in pol ipsec mode tunnel tunnel-dst 
> 10.1.1.0/24 tunnel-src 10.1.2.0/24
>    0     0 DROP       all  --  any    any     anywhere             
> anywhere            policy match dir out pol ipsec mode tunnel 
> tunnel-dst 10.1.2.0/24 tunnel-src 10.1.1.0/24
> 1074 64440 ACCEPT     all  --  any    any     10.1.2.0/24          
> 10.1.1.0/24
> 1074 64440 ACCEPT     all  --  any    any     10.1.1.0/24          
> 10.1.2.0/24
> 
> Chain OUTPUT (policy ACCEPT 5983 packets, 933K bytes)
> pkts bytes target     prot opt in     out     source               
> destination
> 
> Ipsec policy match are never matched: I can ping-pong from-to both sites.
> I'm not understand what is wrong.

What does "ip xfrm policy" show?
