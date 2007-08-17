From: Peter Riley <Peter.Riley@hotpop.com>
Subject: Old ip6t_REJECT.h header file in iptables include dir
Date: Fri, 17 Aug 2007 01:55:17 -0700
Message-ID: <46C56275.5080803@hotpop.com>
Reply-To: Peter.Riley@hotpop.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080400090703000902030607"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------080400090703000902030607
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


Hello!

Apologies if this is a bad place to report bugs/fixes, but bugzilla.netfilter.org
appears to be down for some time now...

I noticed some incongruities between the ip6tables firewall rules configured
via the "--reject-with" option of the libip6t_REJECT.so module and the actual
packet types that are sent out upon matching this target.

Here is one example (there are others) run on CentOS 5.0, which has a patched
up iptables-1.3.5:


# ip6tables -I INPUT 1 -i lo -p tcp --dport 22 -j REJECT --reject-with tcp-reset
# ip6tables -nxvL INPUT | head -3
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
  pkts    bytes target   prot opt in   out  source   destination
     0        0 REJECT   tcp      lo   *    ::/0     ::/0    tcp dpt:22 reject-with tcp-reset

# ssh -6 ::1
ssh: connect to host ::1 port 22: Connection refused

# tcpdump -i lo -t -nn -s0 ip6  ### on separate xterm
listening on lo, link-type EN10MB (Ethernet), capture size 65535 bytes IP6 ::1.56371 > ::1.22: S 25897503:25897503(0) win 32752 <mss
16376,sackOK,timestamp 3441643437 0,nop,wscale 7>
IP6 ::1 > ::1: ICMP6, destination unreachable, unreachable port, ::1 tcp port 22, length 88


So the ip6tables firewall is configured to respond with tcp-reset,
but the actual packet sent is as if it were icmp6-port-unreachable.

I traced this misbehavior to conflicting enumerations of constants in different
header files from iptables vs netfilter:


iptables-1.3.5/include/linux/netfilter_ipv6/ip6t_REJECT.h
---------------------------------------------------------
  1:#ifndef _IP6T_REJECT_H
  2:	#define _IP6T_REJECT_H
  3:	
  4:	enum ip6t_reject_with {
  5:		IP6T_ICMP6_NO_ROUTE,
  6:		IP6T_ICMP6_ADM_PROHIBITED,
  7:		IP6T_ICMP6_ADDR_UNREACH,
  8:		IP6T_ICMP6_PORT_UNREACH,
  9:		IP6T_TCP_RESET
 10:	};
 11:	
 12:	struct ip6t_reject_info {
 13:		enum ip6t_reject_with with;      /* reject type */
 14:	};
 15:	
 16:	#endif /*_IP6T_REJECT_H*/



linux-2.6.18/include/linux/netfilter_ipv6/ip6t_REJECT.h
-------------------------------------------------------
  1:	#ifndef _IP6T_REJECT_H
  2:	#define _IP6T_REJECT_H
  3:	
  4:	enum ip6t_reject_with {
  5:		IP6T_ICMP6_NO_ROUTE,
  6:		IP6T_ICMP6_ADM_PROHIBITED,
  7:		IP6T_ICMP6_NOT_NEIGHBOUR,
  8:		IP6T_ICMP6_ADDR_UNREACH,
  9:		IP6T_ICMP6_PORT_UNREACH,
 10:		IP6T_ICMP6_ECHOREPLY,
 11:		IP6T_TCP_RESET
 12:	};
 13:	
 14:	struct ip6t_reject_info {
 15:		u_int32_t	with;	/* reject type */
 16:	};
 17:	
 18:	#endif /*_IP6T_REJECT_H*/


The old header file is still in the iptables include dir as of v1.3.8.

I looked into why this problem affects RHEL5/CentOS but does not appear
when building from the tarball. It turns out to be because Red Hat doesn't
build the iptables package against the kernel sources, but instead their
spec file has KERNEL_DIR=/usr so that the gcc option -I/usr/include is
ignored and header files in the iptables own include directory always
take precedence over the kernel headers.

Anyway, the attached patch merely updates the old ip6t_REJECT.h header file
in the iptables package to the newer one from the kernel-headers package. I
tested that it does indeed fix this bug for me when building iptables under
rpmbuild with the spec file that Red Hat uses.

I filed this here with more details:
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=253014

Best Regards!




--------------080400090703000902030607
Content-Type: text/plain;
 name="iptables-1.3.5-REJECT6_header.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-1.3.5-REJECT6_header.patch"

--- iptables-1.3.5/include/linux/netfilter_ipv6/ip6t_REJECT.h.REJECT6_header	2004-10-10 02:56:23.000000000 -0700
+++ iptables-1.3.5/include/linux/netfilter_ipv6/ip6t_REJECT.h	2006-09-19 20:42:06.000000000 -0700
@@ -4,13 +4,15 @@
 enum ip6t_reject_with {
 	IP6T_ICMP6_NO_ROUTE,
 	IP6T_ICMP6_ADM_PROHIBITED,
+	IP6T_ICMP6_NOT_NEIGHBOUR,
 	IP6T_ICMP6_ADDR_UNREACH,
 	IP6T_ICMP6_PORT_UNREACH,
+	IP6T_ICMP6_ECHOREPLY,
 	IP6T_TCP_RESET
 };
 
 struct ip6t_reject_info {
-	enum ip6t_reject_with with;      /* reject type */
+	u_int32_t	with;	/* reject type */
 };
 
 #endif /*_IP6T_REJECT_H*/







--------------080400090703000902030607--
