From: Henrik Nordstrom <hno@marasystems.com>
Subject: CONNMARK patch
Date: Wed, 10 Sep 2003 03:54:48 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309100327010.31337-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

For those who have forgot the purposes of the CONNMARK patch in extra, 
here is a short reminder.

The basic desing idea behind CONNMARK is the ability to provide
per-session routing & classification information. Such per-session routing
information can be used in a variety of different applications:

* transparent proxying where the router must route a complete TCP session
(including ICMP and RELATED sessions if any) to the proxy without using
NAT. Using NAT hides important information from the proxy and is not 
possible with all protocols (think FTP).

* routing of multiple links without a global routing table. Allows for
example a standard three-legged firewall (internal/external/dmz) with a
very complex and dynamic (as in frequent changes of what networks are part
of the internal network) to run without any routingtable except for
internal & external default gateways simply by remembering from which
interface the session was initiated.

* Simplified setup of multihomed firewall using NAT to DMZ servers. By 
remembering which interface the traffic was originanly seen from return 
traffic from the DMZ can easily be routed back the same way.

Most routing problems except for the first can in theory be solved by
other means. i.e. the second can be solved by having full routing
information and the third by conntrack based policy routing using the
conntrack match nullifying the hiding of relevant information done by NAT,
but the CONNMARK makes these things a lot easier to manage and saves the
need of walking the whole classification ruleset on each packet (initial
packet classified with mark, all future packets in the session inherits
this information by a single rule)

The first (routing redirection of a whole session) can not be done easily
without CONNMARK or a equivalent function.


The CONNMARK can also be used as a generic per-connection memory to allow 
for some interesting rule constructs in combination with limit/string or 
other "advanced" iptables matches, especially when using nfmark for 
traffic shaping or similar purposes but also for log/auditing of 
suspicious sessions, but this is just a bonus of having additional 
per-session state in conntrack allowing for a long-term memory of events 
(long-term = longer than a single packet)

Regards
Henrik
