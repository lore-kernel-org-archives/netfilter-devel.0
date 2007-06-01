From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables gateway match
Date: Fri, 01 Jun 2007 18:52:00 +0200
Message-ID: <46604EB0.9080302@trash.net>
References: <46604D8B.7030507@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46604D8B.7030507@ufomechanic.net>
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

Amin Azez wrote:
> This adds a gateway match to iptables that lets you match against the
> routed ipv4 gateway, it's very useful for SNAT if you want to avoid
> replicating your routing in your SNAT table.
> 
> e.g.
> 
> iptables -t nat -A POSTROUTING -m gateway --nexthop 172.16.1.1 -j SNAT
> --to-address 172.16.1.5
> iptables -t nat -A POSTROUTING -m gateway --nexthop 192.168.1.1 -j SNAT
> --to-address 192.168.1.25


I'm wondering whether we really need a new match for this. It should
be possible to do the same using routing realms and the realm match.
