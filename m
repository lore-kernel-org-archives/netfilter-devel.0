From: Peter Surda <shurdeek@routehat.org>
Subject: Re: netfilter efficiency
Date: Fri, 21 Jan 2005 14:30:14 +0100
Message-ID: <20050121133013.GF31012@soldats.localdomain>
References: <005c01c4ff19$508ade80$c0de623e@MAURO>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <005c01c4ff19$508ade80$c0de623e@MAURO>
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

On Thu, Jan 20, 2005 at 06:56:04PM +0100, MauroTablo' wrote:
> Hi all.
hi

> The question is: iptables confronts the TCP packet with all my 90 rules, or
> it confronts the packet ONLY WITH rules for tcp packets (-p tcp)?  In other
> words, is there a function in netfilter that looks up to the protocol type
> of a transit packet and decides which rules to confront the packet with?
You can optimise this like this:
iptables -N tcp
iptables -N udp
iptables -N icmp
iptables -A FORWARD -p tcp -j tcp
iptables -A FORWARD -p udp -j udp
iptables -A FORWARD -p icmp -j icmp
iptables -A tcp my tcp rules
iptables -A udp my udp rules
iptables -A icmp my icmp rules

> Thank you.
> Mauro.
Bye,

Peter Surda (Shurdeek) <shurdeek@routehat.org>, ICQ 10236103, +436505122023

-- 
  Hello, this is Bill Gates and I pronounce Monopoly, er, Windows as Windows.
