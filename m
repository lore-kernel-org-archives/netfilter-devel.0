From: Jeff Hall <hall@vdata.com>
Subject: PPTP Conntrack and NAT
Date: Sun, 2 Mar 2003 19:45:57 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.03.10303020448140.6286-100000@shemp.vdata.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

I am trying to use the PPTP Conntrack and NAT modules with so little
success that I think I must be doing something very basically wrong
and I'm hoping that someone who subscribes to this list will very quickly
spot my error.

I started with a base RH 7.2, downloaded 2.4-20 from kernel.org, downloaded
patch-o-matic-20030107, applied the V1.12 extra/pptp-contrack-nat.patch to
patch-o-matic, then installed the extra/pptp-conntrack-nat.patch and all
the pending patches. Then I copied over the v1.7 ip_conntrack_pptp.c and
v1.3 ip_nat_pptp.c.

For testing purposes I am using a WinNT4 box on interface eth1 (see
below) and connecting to PPTP servers through the PtP link and to
Poptop running on the firewall server. There is a SNAT firewall rule
rewriting packets to a "masquerade address" as they leave wp1_ppp (not
the PtP address of the Sangoma card).

With this setup I am having the following problems:
	I consistently received kernel panics until I inserted a "return 0"
	just before the code in function pptp_expectfn in ip_conntrack_pptp.c
	with the comment: /* delete other expectation */. The panic sited an
	attempt to free a NULL pointer.

	With the above patch pass through connections initiated from VPN clients
	(PNS) behind the fireware worked well - although the second expectation
	was left hanging.  However, I could not break the TCP control connec-
	tion by disconnecting (or even closing Dial-Up networking). Both the
	TCP and the GRE connection remained visible in /proc/net/ip_conntrack
	with status ASSURED.

	If I try to connect to the Poptop server on the firewall machine the
	first GRE write by the Poptop server to the internal trusted inter-
	face fails with the error "Operation Not Permitted" even though I 
	have no firewall rules blocking packets.

Any thoughts will be greatly appreciated.

Jeff Hall


	
Hardware:
eth0: Internal DMZ network
eth1: Internal trusted network (while testing)
wp1_ppp: Sangoma S514 PtP link over a T1


Here are the Netfilter related variables I set during kernel compilation:
#   IP: Netfilter Configuration
#
CONFIG_IP_NF_CONNTRACK=y
CONFIG_IP_NF_FTP=y
CONFIG_IP_NF_IRC=y
CONFIG_IP_NF_CT_PROTO_GRE=y
CONFIG_IP_NF_PPTP=y
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_LIMIT is not set
# CONFIG_IP_NF_MATCH_MAC is not set
# CONFIG_IP_NF_MATCH_PKTTYPE is not set
CONFIG_IP_NF_MATCH_MARK=y
# CONFIG_IP_NF_MATCH_MULTIPORT is not set
# CONFIG_IP_NF_MATCH_TOS is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_DSCP is not set
# CONFIG_IP_NF_MATCH_AH_ESP is not set
# CONFIG_IP_NF_MATCH_LENGTH is not set
# CONFIG_IP_NF_MATCH_TTL is not set
# CONFIG_IP_NF_MATCH_TCPMSS is not set
# CONFIG_IP_NF_MATCH_HELPER is not set
CONFIG_IP_NF_MATCH_STATE=y
# CONFIG_IP_NF_MATCH_CONNTRACK is not set
# CONFIG_IP_NF_MATCH_UNCLEAN is not set
# CONFIG_IP_NF_MATCH_OWNER is not set
CONFIG_IP_NF_FILTER=y
# CONFIG_IP_NF_TARGET_REJECT is not set
# CONFIG_IP_NF_TARGET_MIRROR is not set
CONFIG_IP_NF_NAT=y
CONFIG_IP_NF_NAT_NEEDED=y
# CONFIG_IP_NF_TARGET_MASQUERADE is not set
CONFIG_IP_NF_TARGET_REDIRECT=y
CONFIG_IP_NF_NAT_LOCAL=y
# CONFIG_IP_NF_NAT_SNMP_BASIC is not set
CONFIG_IP_NF_NAT_IRC=y
CONFIG_IP_NF_NAT_FTP=y
CONFIG_IP_NF_NAT_PPTP=y
CONFIG_IP_NF_NAT_PROTO_GRE=y
CONFIG_IP_NF_MANGLE=y
# CONFIG_IP_NF_TARGET_TOS is not set
# CONFIG_IP_NF_TARGET_ECN is not set
# CONFIG_IP_NF_TARGET_DSCP is not set
CONFIG_IP_NF_TARGET_MARK=y
CONFIG_IP_NF_TARGET_LOG=y
# CONFIG_IP_NF_TARGET_ULOG is not set
# CONFIG_IP_NF_TARGET_TCPMSS is not set
# CONFIG_IP_NF_ARPTABLES is not set
# CONFIG_IPV6 is not set
# CONFIG_KHTTPD is not set
