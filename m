From: Nguyen Dinh Nam <64vn@cardvn.net>
Subject: Re: is this make sense: iptables -A PREROUTING -t nat -j SNAT --to
 0.0.0.0
Date: Sat, 26 Mar 2005 22:02:50 +0700
Message-ID: <4245799A.6010206@cardvn.net>
References: <42403008.9070006@cardvn.net> <42444A4A.5090308@cardvn.net>
	<42454F80.4090603@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <42454F80.4090603@outerspace.dyndns.org>
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

No, AFAIK, SAME is for internet connections which supply a whole subnet 
of public IP addresses instead of just 1 IP address. But it's not what I 
want. I want to make routing in a multihomed host easier, let me write 
an example:
There is a host with 2 PPPOE connections: ppp1 (IP: 11.1.1.1) and ppp2 
(IP: 22.2.2.2), so connection teaming is done like this:
ip rule add prio 1 from 11.1.1.1 lookup 101
ip route add table 101 to default dev ppp1
ip rule add prio 2 from 22.2.2.2 lookup 102
ip route add table 102 to default dev ppp2
ip route add default nexthop dev ppp0 nexthop dev ppp1

the problem is that the routing system can depend on the source IP 
address (11.1.1.1 or 22.2.2.2) to route the packet to the correct 
interface, but packets from the LAN will have LAN ip address when 
reaching routing system, thus those packet won't match neither "prio 1" 
nor "prio 2" rules.

My idea to solve it is to do something to make netfilter to masquerade 
the source of packets (from LAN IP address to 11.1.1.1 or 22.2.2.2) 
*before* reaching routing system, so those packets can match "prio 1" or 
"prio 2" routing rules. If I know that it's possible, I'll start the new 
career of hacking networking code so may be you will have one more 
contributor.

Sincerely,
Nam

Jonas Berlin wrote:

> I'm no senior, but could the SAME target in patch-o-matic-ng maybe 
> help you out?
