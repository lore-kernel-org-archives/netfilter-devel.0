From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Sat, 8 Jun 2002 14:02:17 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206081402.17562@henrik.marasystems.com>
References: <3D007D73.9030609@cs.auc.dk> <3D016699.9010301@cs.auc.dk> <20020608102140.C23410@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>
In-Reply-To: <20020608102140.C23410@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Saturday 08 June 2002 10:21, Patrick Schaaf wrote:

> Mostly in ip_conntrack_core.c. The early_drop() and unreplied()
> functions implement the checking, based on the IPS_ASSURED bit in
> conntrack->status. Use "grep" to see where that bit is set.

ip_conntrack_core is also where the NEW/ESTABLISHED/RELATED states is 
defined. As said numerous times on this thread the conntrack states 
NEW/ESTABLISHED/RELATED has nothing to do with TCP as such.

The states you have been looking into in ip_conntrack_proto_tcp.c is 
the TCP tracking state, which is almost fully independent of the 
conntrack state.

The conntrack packet state is based on how THIS packet relates to the 
connection. The same set of rules applies to all protocols.. First 
packet (and initial retransmissions) is NEW, reply packet to a 
previously seen packet is ESTABLISHED, initiations of related 
connections identified as belonging to an existing connection is 
RELATED to differentiate these from NEW.

The conntrack packet state is what is being matched by -m state.

The TCP tracking state is based on what kind of TCP packets have been 
seen on the connection. The TCP state is what is being printed in 
/proc/net/ip_conntrack but is not really used in any iptables 
rulesets. Mainly determines the current timeout of the conntrack 
entry.

The conntrack packet states are:

INVALID
This packet cannot be tracked for some reason

NEW/ESTABLISHED/RELATED
How this packet relates to the connection. These are not really states 
but derived from the current state and the packet being processed. 
See below.

ORIGINAL/REPLY:  (flag, in addition to NEW/ESTABLISHED/RELATED)
Direction of this packet in relation to the packet that caused this 
conntrack to be created (NEW).

The above states are "ctinfo" and is derived from the conntrack state 
flags and the packet currently being processed. The actual conntrack 
state flags are:

ASSURED
The protocol (TCP/UDP/IMCP...) has seen the initiation and 
establishment of this connection. For TCP this requires seeing the 
whole SYN -> SYN+ACK -> ACK transition, for UDP and ICMP it simply is 
seeing traffic in both directions..

SEEN_REPLY
There has been traffic seen in both directions on this connection. 
This is what makes conntrack packet state ESTABLISHED.

EXPECTED
This connection is identified as belonging to another connection. This 
is what makes conntrack packet state RELATED.

If netiher of SEEN_REPLY or EXPECTED is true for the connection then 
the packet state is NEW.

Of these, only ASSURED is directly dependent on the TCP connection 
tracking state, the others are only dependent on the ability of 
identifying which connection the packet may belong to.

Regards
Henrik
