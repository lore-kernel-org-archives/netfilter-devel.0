From: marian stagarescu <marian@ti.com>
Subject: conntrack and application-triggered port forwarding
Date: 08 Apr 2003 20:02:59 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049846579.16856.157.camel@gt4rvnd11.telogy.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain
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

i may be missing something elementary about conntrack & nat & firewall
so please let me know if the following feature is supported in linux
because i don't quite see it:

outside the scope of specialized ALGs (e.g. ftp, h323,...) i want 
to be able to specify that an outbound tcp/udp connection to dstport x
will require that related traffic be allowed inbound on port y.

that is to say, for a gateway:

NET---| NAT/Conntrack/Firewall |---(private LAN)

_IF_AND_ONLY_IF_ traffic goes from LAN on tcp/dstport X open
forward chain to allow related udp/dstport Y to go back on LAN.
(i have a drop policy on forward chain for traffic with input interface
facing NET).

in this example the tcp traffic will be playing the role of the control
channel and the udp the data channel but since I know that it operates
on predefined ports (or port ranges) i don't have to snoop into the
control channel and get the data channel port.

this will be some "generic" ALG mechanism so that for applications that
are operating on known ports (or port ranges) i can use it without an
ALG implementation proper.

I can use static rules that will open udp/dstport Y but forward path
will be open on this rule (proto/port) regardless of the presence of
outbound tcp/dstport x traffic. so opening the firewall is not triggered
by an application.


Not being too familiar with the internals and api  of conntrack i
wonder: is such a task easy (example pointers ?)? 

the conntrack api is exposing methods for deleting/adding conntracks
entries. so theoretically speaking if i have a userland daemon that
talks via a netlink socket with conntrack (i played a bit with
ctnetlink) i can get notification on outgoing traffic, match it against
such "rule" and inject into conntrack "related" tuples that will match
the incoming response. is there a (better) way to do this in kernel
space alone via iptables interface, e.g, here are 2 related rules, when
one matches traffic install the other one too, when it expires, remove
the related rule ? 

your input is appreciated.

thanks,
marian
