From: Aleksandar Milivojevic <alex@milivojevic.org>
Subject: Netfilter connection tracking and GRE/IPSec
Date: Fri, 02 Dec 2005 10:40:46 -0600
Message-ID: <20051202104046.v6z10kbwn40k4440@www.milivojevic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter@lists.netfilter.org
Content-disposition: inline
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

I've just submitted bug report on Red Hat's bugzilla, and felt like discussing
on Netfilter list too.

What happens is, for connections that go through GRE tunnel (wich is in turn
encapsulated into IPSec tunnel), ip_conntrack is loosing connection tracking
information.  The connection is sucessfully established, works for some period
of time (random, I observed anywhere from several minutes to up to one hour). 
I can see entry for it in /proc/net/ip_conntrack.  Then all the sudden
Netfilter starts dropping packets belonging to this TCP connection.  When I
check /proc/net/ip_conntrack on remote side (always happens on remote side of
the tunnel, although both sides are the same), the entry for this TCP
connection is no longer there.

The packets are being dropped because my rules look something like this (very
simplified, just to show where the problem is):

iptables -A -m state --state ESTABLISHED -j ACCEPT
iptables -A -p icmp -m state --state RELATED -j ACCEPT
iptables -A -p tcp --syn -s xxx -d yyy --dport 22 -m state --state NEW -j ACCEPT

Once the connection is removed from ip_conntrack table, it can't get back into
it because of the "--syn" flag on the third line.  Possible workaround might be
removing the "--syn" flag (security vs. usability).  However, the connection
entry should have not been removed from the ip_conntrack in the first place. 
Looks like it may be bug somewhere in Netfilter code.

Red Hat packaged/patched 2.6.9-22.EL kernel.

There's a bit more details on:
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=174827


----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.
