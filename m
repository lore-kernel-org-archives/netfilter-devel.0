From: Sven-Haegar Koch <haegar@sdinet.de>
Subject: Re: netfilter efficiency
Date: Fri, 21 Jan 2005 14:42:30 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0501211440290.17007@mercury.sdinet.de>
References: <005c01c4ff19$508ade80$c0de623e@MAURO>
	<7958.142.169.215.10.1106314775.squirrel@142.169.215.10>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: MauroTablo' <m.tablo@libero.it>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samuel Jean <sj-netfilter@cookinglinux.org>
In-Reply-To: <7958.142.169.215.10.1106314775.squirrel@142.169.215.10>
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

On Fri, 21 Jan 2005, Samuel Jean wrote:

> On Thu, January 20, 2005 12:56 pm, MauroTablo' said:

>> [...]
>> The question is: iptables confronts the TCP packet with all my 90 rules,
>> or it confronts the packet ONLY WITH rules for tcp packets (-p tcp)?
[...]
> By now, your packets just hit every rules and test against your -p proto.

To speed up you can use subchains.

iptables -N mytcpchain
iptables -A mytcpchain ....
iptables -A FORWARD -p tcp -j mytcpchain
iptables -A FORWARD -p udp -j myudpchain  etc etc

That way iptables needs to check only a subset of your rules.

c'ya
sven

-- 

The Internet treats censorship as a routing problem, and routes around it.
(John Gilmore on http://www.cygnus.com/~gnu/)
