From: alex <alex@bennee.com>
Subject: More on ip_conntrack problems
Date: 10 Jul 2002 08:10:20 +0100
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1026285021.14566.80.camel@trent.nin>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Netfilter Development Mailing List <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I've seen numerous references to percieved problems with default
timeouts and potential DoS attacks on ip_conntrack but I'm starting to
think is possible to ip_conntrack just to miss connection closures.

I'm running on a memory constrained machine (28Mb Physical RAM) which
shouldn't prove too problamatic as I'm only on a DSL connection. I've
been running a Freenet node on my internal machine with the appropraite
port forwarding magic with iptables. The problem I'm seeing is a slow
climb in the number of connections until it reaches saturation and
connectivity becomes very dicey (so I now open a ssh shell to my gateway
box before I do anything, just to ensure I can still talk to it).

The one piece of evidence that makes me suspicious of ip_conntracks
ability to detect connection tear down is the disparity between the
numbers I get from the gateway box to what I get on my internal box

gateway:
cat /proc/net/ip_conntrack | wc -l

give 1688 connections

internal box:

netstat -t | wc -l

gives 41 connections

I eyeballed the ip_conntrack output and all the connections tracked are
Freenet connections so I'm discounting other server connections like web
etc as in the minority. Once I stop freenet the count stays quite
static, I hope it will of cleared down once I get back to my box this
afternoon but I assume this is due to the long timeouts on closing TCP
connections.

A few questions:

a) Am I measuring things correctly?
b) Should the number of connections on ip_conntrack be broadly the same
as the internal machines understanding of connections (netstat output)?
c) Has this come up before? 
d) Are there any patches I could try that alter ipconntracks end of
connection heuristics?

Cheers,

-- 
Alex@Bennee.com
http://www.bennee.com/~alex/
