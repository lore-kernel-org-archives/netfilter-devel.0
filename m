From: Larry Stephan <jlarry@delanet.com>
Subject: Static NAT Ranges?
Date: Fri, 24 Jan 2003 23:39:58 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301250439.XAA31445@delanet.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi All-

I have worked both with netfilter (from ipfwadm through iptables) and with
some commercial firewall packages.  I must say that netfilter is a remarkably
capable system.  However, one feature which appears to be lacking is a
convenient way to NAT address ranges statically: that is, for a given range
of addresses, the NATted address would always differ from the original
address by the same fixed amount. This is handy for fixing certain routing
problems, as well as for changing ranges of address that may cause a
conflict to more acceptable ranges, a not infrequent problem when different
organizations establish dedicated network links.  I have attempted to find
something like this on the netfilter web site, but (perhaps I missed
something) I found nothing.

I was thinking that a --static option to SNAT and DNAT might do the trick.
For example, (line broken because it doesn't fit well):

iptables -s 5.6.7.0/25 -t nat -A POSTROUTING 
-o eth0 -j SNAT --static --to 1.2.3.64

would map 5.6.7.1 to 1.2.3.65, 5.6.7.2 to 1.2.3.66,...,5.6.7.126 to 1.2.3.190

Of course this can be done with individual entries, but the above could save
several hundred entries in the tables.  Does an equivalent capability exist?
Is is easy enough that you might wish to add it?  I am afraid I haven't the
time to get up to speed and contribute - at least not for a few years.
However, your efforts are greatly appreciated.


Another, but I suppose much harder, enhancement would be support of address
ranges in the matching code. This is also a useful feature I have seen on
some commercial packages.  (It is quite amazing what strange manipulations
become necessary when one is not free to re-assign addresses in a reasonable
manner.)  Maybe I can contribute this one sometime down the road.

Thank you for your software, your time, and your consideration,

Larry

Larry Stephan          "Sometimes I think the surest sign there's intelligent
jlarry@delanet.com        life in space is that they haven't contacted us."
                            Bill Watterson - "Calvin and Hobbes"
