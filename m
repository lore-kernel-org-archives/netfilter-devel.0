From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables denial of services
Date: Fri, 16 Apr 2004 12:03:19 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404161149300.1981-100000@filer.marasystems.com>
References: <20040415183141.40EC43D96DC@smtp.latinmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jorge Garcia <anarkophobia@latinmail.com>
In-Reply-To: <20040415183141.40EC43D96DC@smtp.latinmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 15 Apr 2004, Jorge Garcia wrote:

> I saw in the net that for examples servers like apache or smtp stop his services after a determinated numbers of connections at the same time.

This is called connection flooding. Related to SYN flooding but harder to 
protect from.

You can use the connlimit match from iptables patch-o-matic-ng to help 
reducing this problem but it is not a universal fix to the problem.

> Is this a problem in iptables firewall??i mean does iptables stop filtering after handling a lot of traffic?

No, but it may start dropping packets if overloaded.

If you are doing connection tracking then there is also an analogy to the
connection flooding, where conntrack will not accept new sessions when a
huge number of connetions is already established and this will most likely
result in those new sessions to dropped by your firewall. But it is not a
risk that filtering stops, only that new connections may not be accepted 
for a while. The number of sessions involved is considerably higher than 
on a server so your servers will most likely be dead long before the limit 
in conntrack can be reached.

> The other thing i saw in the net is that it is possible to send a lot of
> traffic to full the log messabges of iptables and the firewall will stpo
> filtering so a hacker could acces to different services on the net, i
> didnt find any code or proof of concept of this but i want to know if
> this is possible.

If the kernel log buffer gets full then the older not yet written to disk
log messages is lost. The filtering is completely unaffected, but some of 
the audit trails of who did what may have been lost..

> Another thing is that vulnerabilities in the netfilter webpages are very
> intresting but they are all old, and it seems to not work in actual
> kernels, i wanna know if there are new vulnerabilities and were to find
> it.

As soon as a vulnerability is made known to the netfilter developers a 
solution is developed, usually within a day from the problem becomes 
known. This solution is then pushed for inclusion in the next kernel 
release.

There has not been any vulnerabilities in quite some time, and is why all 
the vulnerabilities on the netfilter.org homepage is old and not relevant 
to the current kernels.

> Any security information about linux firewall will be accept and will help me a lot.

As with all firewalls the key is making a correct ruleset.

Regards
Henrik
