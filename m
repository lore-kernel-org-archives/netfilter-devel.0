From: bdschuym@pandora.be
Subject: Re: [Bridge] Re:  Any way of knowing a packet's been defragmented
Date: Thu, 05 Aug 2004 15:02:14 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <W1746121773184611091718134@asteria.telenet-ops.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel" <netfilter-devel@lists.netfilter.org>,
	"bridge" <bridge@osdl.org>, shemminger@osdl.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Henrik Nordstrom" <hno@marasystems.com>,
	"Bart De Schuymer" <bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>----- Oorspronkelijk bericht -----
>Van
: Henrik Nordstrom [mailto:hno@marasystems.com]
>Verzonden
: donderdag
, augustus
 5, 2004 01:10 PM
>Eh.. I do not claim to be a bridge guru, but won't such bridge cause 
>serious havoc on the network much like PMTU blackholes does?

Someone who sets up such a bridge should obviously know what she is doing. That's not our problem.

>You should either reject creating such bridge, or make sure to fragment 
>packets including ICMP MUST FRAGMENT generation when not allowed (which 
>requires an IP).

It's connection tracking that is responsible for the defragmentation and connection tracking WILL refragment the packets, BUT only if the bridge code doesn't drop the packet first.
The bridge code should obviously not send any ICMP message.
