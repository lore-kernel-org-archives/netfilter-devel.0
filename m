From: Mike Andersen <mike@src.no>
Subject: Using netfilter to filter sessions to a packet sniffer ("TopLayer Light")
Date: Wed, 5 May 2004 15:13:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <092D610A-9E96-11D8-85B6-000A957FD99E@src.no>
Mime-Version: 1.0 (Apple Message framework v613)
Content-Type: multipart/alternative; boundary=Apple-Mail-3-228925665
Cc: Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Apple-Mail-3-228925665
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed

I've spent some time investigating a problem I described in an earlier
mail to this list.  First, a recap of the scenario:

     External net
     ---+--------
        |
     +--+--+    +----------+    +----------------+
     | HUB +----+ Firewall +----+ Packet sniffer |
     +--+--+    +----------+    +----------------+
        |
     ---+--------
     Internal net

The firewall is configured with a patched version of the bridge code
that allows it to mirror all traffic from the hub to the packet sniffer
(the patch makes the bridge work like a hub instead of a switch).

The idea is to only send selected sessions to the packet sniffer, and
that makes me very depended on the state table in netfilter.  After some
help from Henrik Nordstrom, I am now trying to route unwanted traffic to
a "blackhole", instead of using DROP statements (which probably ruins
the state of the session).  Here is the current rules I'm testing:

int=10.10.10.199/32
iptables -t mangle -A PREROUTING -m conntrack --ctorigsrc $int -j ACCEPT
iptables -t mangle -A PREROUTING -j ROUTE --oif dummy0

When testing this by setting up netcat (nc) on 10.10.10.199 to listen to
port 1111, I discovered that only the first SYN packet was sent to the
dummy0 interface.  The rest of that session was caught by the ACCEPT
rule.

Using tcpreplay I managed to send one packet at a time, and then looked
at how the state table was built up.  Here is data from a tcpdump on the
external interface, with the corresponding entry in the state table
(which I got by cat /proc/net/ip_conntrack):

The first SYN packed:

13:45:26.961881 10.10.10.196.32776 > 10.10.10.199.1111: S 
3584179430:3584179430(0) win 5840 <mss 1460,sackOK,timestamp 8133815 
0,nop,wscale 0> (DF)

After this packet was sent, I did not see any entries in the state
table.  Then I sent the SYN/ACK package:

13:45:45.695980 10.10.10.199.1111 > 10.10.10.196.32776: S 
17191942:17191942(0) ack 3584179431 win 65535 <mss 1460,nop,wscale 
0,nop,nop,timestamp 3448506332 8133815> (DF)

And the state table showed:

tcp      6 117 SYN_SENT src=10.10.10.199 dst=10.10.10.196 sport=1111 
dport=32776 [UNREPLIED] src=10.10.10.196 dst=10.10.10.199 sport=32776 
dport=1111 use=1

Then the third package (ACK):

13:45:55.872610 10.10.10.196.32776 > 10.10.10.199.1111: . ack 1 win 
5840 <nop,nop,timestamp 8133815 3448506332> (DF)

And the corresponding entry in the state table:

tcp      6 117 SYN_SENT src=10.10.10.199 dst=10.10.10.196 sport=1111 
dport=32776 src=10.10.10.196 dst=10.10.10.199 sport=32776 dport=1111 
use=1

So.  Again I'm stuck, and don't really know where to go from here.  I
would appreciate some help and hints on what to investigate further.

mike
-- 
"It is a lesson which all history teaches wise men, to put trust in
  ideas, and not in circumstances."            --Ralph Waldo Emerson
--Apple-Mail-3-228925665
Content-Transfer-Encoding: 7bit
Content-Type: text/enriched;
	charset=US-ASCII

<fontfamily><param>Courier</param><bigger>I've spent some time
investigating a problem I described in an earlier

mail to this list.  First, a recap of the scenario:


    External net

    ---+--------

       |

    +--+--+    +----------+    +----------------+

    | HUB +----+ Firewall +----+ Packet sniffer |

    +--+--+    +----------+    +----------------+

       |

    ---+--------

    Internal net


The firewall is configured with a patched version of the bridge code

that allows it to mirror all traffic from the hub to the packet sniffer

(the patch makes the bridge work like a hub instead of a switch).


The idea is to only send selected sessions to the packet sniffer, and

that makes me very depended on the state table in netfilter.  After
some

help from Henrik Nordstrom, I am now trying to route unwanted traffic
to

a "blackhole", instead of using DROP statements (which probably ruins

the state of the session).  Here is the current rules I'm testing:


int=10.10.10.199/32

iptables -t mangle -A PREROUTING -m conntrack --ctorigsrc $int -j
ACCEPT

iptables -t mangle -A PREROUTING -j ROUTE --oif dummy0


When testing this by setting up netcat (nc) on 10.10.10.199 to listen
to

port 1111, I discovered that only the first SYN packet was sent to the

dummy0 interface.  The rest of that session was caught by the ACCEPT

rule.


Using tcpreplay I managed to send one packet at a time, and then looked

at how the state table was built up.  Here is data from a tcpdump on
the

external interface, with the corresponding entry in the state table

(which I got by cat /proc/net/ip_conntrack):


The first SYN packed:


13:45:26.961881 10.10.10.196.32776 > 10.10.10.199.1111: S
3584179430:3584179430(0) win 5840 <<mss 1460,sackOK,timestamp 8133815
0,nop,wscale 0> (DF)


After this packet was sent, I did not see any entries in the state

table.  Then I sent the SYN/ACK package:


13:45:45.695980 10.10.10.199.1111 > 10.10.10.196.32776: S
17191942:17191942(0) ack 3584179431 win 65535 <<mss 1460,nop,wscale
0,nop,nop,timestamp 3448506332 8133815> (DF)


And the state table showed:


tcp      6 117 SYN_SENT src=10.10.10.199 dst=10.10.10.196 sport=1111
dport=32776 [UNREPLIED] src=10.10.10.196 dst=10.10.10.199 sport=32776
dport=1111 use=1


Then the third package (ACK):


13:45:55.872610 10.10.10.196.32776 > 10.10.10.199.1111: . ack 1 win
5840 <<nop,nop,timestamp 8133815 3448506332> (DF)


And the corresponding entry in the state table:


tcp      6 117 SYN_SENT src=10.10.10.199 dst=10.10.10.196 sport=1111
dport=32776 src=10.10.10.196 dst=10.10.10.199 sport=32776 dport=1111
use=1


So.  Again I'm stuck, and don't really know where to go from here.  I

would appreciate some help and hints on what to investigate further.

</bigger></fontfamily>

<fontfamily><param>Courier</param><bigger>mike

-- 

"It is a lesson which all history teaches wise men, to put trust in

 ideas, and not in circumstances."            --Ralph Waldo Emerson</bigger></fontfamily>
--Apple-Mail-3-228925665--
