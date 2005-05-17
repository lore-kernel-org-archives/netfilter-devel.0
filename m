From: Patrick McHardy <kaber@trash.net>
Subject: Re: Problem with two addrtype matches in one iptables rule.
Date: Tue, 17 May 2005 03:35:23 +0200
Message-ID: <42894A5B.5050000@trash.net>
References: <42883902.7030909@riverviewtech.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: "Taylor, Grant" <gtaylor@riverviewtech.net>
In-Reply-To: <42883902.7030909@riverviewtech.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Taylor, Grant wrote:
> Hi, my name is Grant Taylor.  I'm playing with your addrtype match
> extension to iptables.  I must say that I like it very much.  However I
> have a slight problem with it.  Namely I am apparently only able to have
> one addrtype match in any given rule.  I would like to use two addrtype
> matches, one for the source address, and one for the destination address
> in my iptables rules.  Do you know of any limitations to the addrtype
> match extension that would be causing this?  Below is an example rule of
> what I am currently using as well as what I would like to be able to do:
> 
> # current rule:
> iptables -t filter -A INPUT -i eth1 -m pkttype --pkt-type broadcast -m
> addrtype --src-type broadcast -s 0.0.0.0 -d 255.255.255.255 -p udp
> --sport 68 --dport 67 -j ACCEPT
> 
> # desired rule:
> iptables -t filter -A INPUT -i eth1 -m pkttype --pkt-type broadcast -m
> addrtype --src-type broadcast -m addrtype --dst-type broadcast -s
> 0.0.0.0 -d 255.255.255.255 -p udp --sport 68 --dport 67 -j ACCEPT
> 
> Any comments or suggestions would be greatly appreciated.

This is a known limitation of iptables:

/* FIXME: This scheme doesn't allow two of the same
   matches --RR */

It looks like fixing it would break compatibility because currently
arguments to matches can occur at any position:

iptables -A OUTPUT -m addrtype -p tcp --dst-type BROADCAST

I suggest you add the second match to a new chain and jump to it
from the first match.

Regards
Patrick
