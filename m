From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Help NAT - ISP: news
Date: Tue, 06 Sep 2005 16:31:58 +0100
Message-ID: <431DB66E.2000203@ufomechanic.net>
References: <001a01c5b16c$73fa8770$0300a8c0@giacomino>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <001a01c5b16c$73fa8770$0300a8c0@giacomino>
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

Have you tested the new ISP connection without your ip4 filter loaded?

I'm wondering if you need to update your /etc/resolv.conf file, default
route, or other such things that maybe associated with a change of ISP.

Any problem in the area you are looking at is likely to cause problems
for a lot of customers so it seems unlikely to be a problem of the ISP

Sam

Giacomo wrote:
> Good Morning, i'm Giacomo S. the one who
> posted some days ago a message titled:
> "help about NAT and ISP - developing a kernel module"
> 
> If anyone can help, in addition to the questions in original post, i
> discovered that
> 
> probably the problem is not related to fragmentation in network packets.
> 
> I setup the iptable rule
> 
> iptables -A FORWARD -f -j LOG --log-prefix="FWD_FRAGMENTED"
> 
> and no packet seems to arrive fragmented.
> 
> Don't know if this information is useful, but thank in advance anyone
> who could
> 
> point out a reason for what's happening to me.
> 
> Could it be related to packets arriving in disorder?
> 
> Should i mangle something else in gateway traversing packets in addition
> to ip, ports and checksum?
> 
> I underline that i do not change any other field, nor payload.
> 
> Thanks for help. I add below original message sent some days ago.
> 
> 
> 
> Giacomo.
> 
> 
> 
> -----
> ORIGINAL MESSAGE WITH PROBLEM EXPLAINED:
> 
> Good morning, I'm Giacomo Strangolino from Italy.
> 
> I finished developing an ipv4 packet filter with NAT/MASQUERADING and have
> been
> testing it
> for some time with success connecting from home to my ISP named "libero".
> 
> Then i changed ISP to another one, called "telecom" and with great surprise
> i discovered that
> images from sites and also sites failed to load.
> 
> So now, when i call an ISP all works fine, when i call the other, things go
> wrong.
> 
> I NAT machines behind my firewall changing only ips and ports, and
> recalculating checksum (ip and tcp/udp)
> to adjust such changes.
> I do not touch any other field as window size or seq number or ack, since
> the only things i manipulate are
> addresses and ports.
> 
> I was wondering what i could do to solve, since iptables and ipfw+natd on
> freeBSD or winXP sp2 work fine
> with this ISP...
> 
> Tweaking with ethereal i found that probably sometimes a tcp segment gets
> lost.
> 
> My firewall is a 2.6.12 kernel module which registers with netfilter hooks.
> A userspace program sends rules to
> kernel via netlink.
> 
> I thank you if you could help me find the way to fix the problem or
> understand what could be wrong with an
> ISP network and anyway work fine with the other.
> 
> Also any indication of where in iptables source is solved such problem
> would be appreciated.
> 
> I have been consulting news for many days and until now i tried to resolve
> the issue
> without success in the following ways:
> 
> - reducing MTU on both gateway and internal hosts.
> - trying with the option --clamp-tcpmss-to-pmtu.
> 
> Both failed and problem persisted.
> 
> 
> Thanks a lot in advance.
> 
> 
> 
> 
> 
