From: Amin Azez <azez@ufomechanic.net>
Subject: Re: iptables STILL incorrectly using TCP packet contents without
 checking header!
Date: Tue, 05 Apr 2005 15:24:08 +0100
Message-ID: <d2u6ul$g29$1@sea.gmane.org>
References: <20050331185732.GA20249@netnation.com>	<424C57EB.7020308@outerspace.dyndns.org>
	<20050401000340.GA2275@netnation.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050401000340.GA2275@netnation.com>
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

Simon Kirby wrote:
> If checksumming were implemented in this case and the rule no longer
> matched a corrupted packet, the packet would still be forwarded. 
> However, the end point should just discard it.  I don't think this
> will introduce any new problems except possibly for the ability to
> fling loads of corrupted packets (DoS) past firewalls if TCP is
> blocked with something like:
> 
> 	iptables -A FORWARD -p tcp --dport 0:65535 -j REJECT
> 
> This is probably a rare case, but probably worth noting.
> 
> Is there anything else?

Possibly this discussion is about to get philosophical:

One mans corrupt packet is another mans disguise.

Off the top of my head, propogating corrupt packets could perhaps be 
used to subvert the firewall with the help of a co-operating box on the 
inside that will accept and perhaps fixup the corrupt packets, or at 
least do something with it.

We know that if an internal box has been "taken over" that all bets are 
off anyway, but that is no excuse for the firewall to fail in its duty. 
Various means including TCP/IP encapsulated in DNS requests can be used 
to subvert firewalls but at least they show up and can be handled be 
iptables or various other mechanisms.

Is this a "new problem"? I don't know, but it could be a problem.

Perhaps there is no practical difference between "corrupted packet" and 
"unknown protocol" ?

IMHO corrupt packets should be dropped and not forwarded, and possibly 
people want a similar rule for unknown protocols?

I much perfer your previous suggestion:
	iptables -A FORWARD -m checksum ! --checksum ip -J DROP
	iptables -A FORWARD -p tcp -m checksum ! --checksum tcp -J DROP

and I really think they ought to be the first rules in the FORWARD chain 
by default.

Amin
