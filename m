From: Patrick McHardy <kaber@trash.net>
Subject: Enabling CONFIG_IP_NAT_LOCAL unconditionally
Date: Sat, 27 Nov 2004 12:53:56 +0100
Message-ID: <41A86AD4.1060706@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: coreteam@netfilter.org
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

Hi,

I discovered more problems with locally generated ICMP errors while
testing NAT with IPsec. When an error is generated after POST_ROUTING,
the original packet has already be SNATed. icmp_reply_translation
expects all packets to go PRE_ROUTING -> ... -> POST_ROUTING, so both
SNAT and DNAT of the inner packet can be reversed and applied to the
outer packet in the opposite direction. Locally generated ICMP errors
only go through LOCAL_OUT -> POST_ROUTING. Since they never hit
PRE_ROUTING, the inner packet is not reverse-SNATed and the outer
packet is not DNATed properly.

Example with locally generated traffic. The error is visible best for
locally generated traffic with SNAT to non-local addresses, with local
addresses the error is reported properly anyway unless the port number
is also translated.

eth0 is 172.16.195.3/16, 172.16.195.100 is not existant:

# iptables -t nat -A POSTROUTING -o eth0 -d 172.16.195.100 -j SNAT 
--to-source 10.0.0.1
# telnet 172.16.195.100

on eth0:
IP (tos 0xd0, ttl  64, id 57576, offset 0, flags [none], length: 88) 
172.16.195.3 > 10.0.0.1: icmp 68: host 172.16.195.100 unreachable for IP 
(tos 0x10, ttl  64, id 48538, offset 0, flags [DF], length: 60) 
10.0.0.1.33912 > 172.16.195.100.23: [|tcp]

It seems the easiest fix for this is always enabling CONFIG_IP_NAT_LOCAL
and applying PRE_ROUTING manips in LOCAL_OUT in icmp_reply_translation.
Is everyone fine with this ?

Regards
Patrick
