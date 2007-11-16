From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Sat, 17 Nov 2007 12:29:45 +1300
Message-ID: <473E27E9.4080306@treenet.co.nz>
References: <473D6C99.1010306@trash.net> <20071116.021254.114985389.davem@davemloft.net> <Pine.LNX.4.64.0711161316060.3340@fbirervta.pbzchgretzou.qr> <20071116.044413.227110480.davem@davemloft.net> <473D91E9.4010809@trash.net> <20071116153541.GA25986@linuxace.com> <473DBB8C.9020709@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Phil Oester <kernel@linuxace.com>,
	David Miller <davem@davemloft.net>, jengelh@computergmbh.de,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 60-234-233-111.bitstream.orcon.net.nz ([60.234.233.111]:45997
	"EHLO mail.treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369AbXKPXka (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:40:30 -0500
In-Reply-To: <473DBB8C.9020709@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Phil Oester wrote:
>> On Fri, Nov 16, 2007 at 01:49:45PM +0100, Patrick McHardy wrote:
>>> What I have in mind is roughly:
>>>
>>> IPv4/IPv6 conntrack
>>> NAT
>>> ip_tables/ip6_tables
>>> tables: filter, nat
>>> matches: tcpudp, state, limit, hashlimit, policy
>>> targets: LOG, NFLOG, TCPMSS, REJECT, MASQUERADE
>>>
>>> That should be enough for a simple firewall script. I'm not sure
>>> whether we should also select helpers though. Maybe the common
>>> ones, like ftp, irc and sip?
>>
>> I'd vote for at least FTP here...most users will use it at
>> some point (or if they don't, wonder why FTP is broken).
> 
> 
> I agree. It would be useful if some users of a distribution that
> includes a firewall script could check which modules it requires.
> 

All right.
Here is the fairly common shorewall 3.4's default dependencies as taken 
from /usr/share/shorewall/modules .
These are not likely to change per-system without a clueful administrator.

#
# Essential Modules
#
loadmodule nfnetlink
loadmodule x_tables
loadmodule ip_tables
loadmodule iptable_filter
loadmodule iptable_mangle
loadmodule ip_conntrack
loadmodule nf_conntrack
loadmodule nf_conntrack_ipv4
loadmodule iptable_nat
loadmodule xt_state
loadmodule xt_tcpudp
#
# Other xtables modules
#
loadmodule xt_CLASSIFY
loadmodule xt_connmark
loadmodule xt_CONNMARK
loadmodule xt_conntrack
loadmodule xt_dccp
loadmodule xt_hashlimit
loadmodule xt_helper
loadmodule xt_length
loadmodule xt_limit
loadmodule xt_mac
loadmodule xt_mark
loadmodule xt_MARK
loadmodule xt_NFLOG
loadmodule xt_NFQUEUE
loadmodule xt_physdev
loadmodule xt_pkttype
loadmodule xt_tcpmss
#
# Helpers
#
loadmodule ip_conntrack_amanda
loadmodule ip_conntrack_ftp
loadmodule ip_conntrack_h323
loadmodule ip_conntrack_irc
loadmodule ip_conntrack_netbios_ns
loadmodule ip_conntrack_pptp
# loadmodule ip_conntrack_sip
loadmodule ip_conntrack_tftp
loadmodule ip_nat_amanda
loadmodule ip_nat_ftp
loadmodule ip_nat_h323
loadmodule ip_nat_irc
loadmodule ip_nat_pptp
# loadmodule ip_nat_sip
loadmodule ip_nat_snmp_basic
loadmodule ip_nat_tftp
loadmodule ip_set
loadmodule ip_set_iphash
loadmodule ip_set_ipmap
loadmodule ip_set_macipmap
loadmodule ip_set_portmap
#
# 2.6.20+ helpers
#
loadmodule nf_conntrack_ftp
loadmodule nf_conntrack_h323
loadmodule nf_conntrack_irc
loadmodule nf_conntrack_netbios_ns
loadmodule nf_conntrack_netlink
loadmodule nf_conntrack_pptp
loadmodule nf_conntrack_proto_gre
loadmodule nf_conntrack_proto_sctp
loadmodule nf_conntrack_sip
loadmodule nf_conntrack_tftp
loadmodule nf_nat_amanda
loadmodule nf_nat_ftp
loadmodule nf_nat_h323
loadmodule nf_nat_irc
loadmodule nf_nat
loadmodule nf_nat_pptp
loadmodule nf_nat_proto_gre
loadmodule nf_nat_sip
loadmodule nf_nat_snmp_basic
loadmodule nf_nat_tftp
#
# Traffic Shaping
#
loadmodule sch_sfq
loadmodule sch_ingress
loadmodule sch_htb
loadmodule cls_u32
#
# Extensions
#
loadmodule ipt_addrtype
loadmodule ipt_ah
loadmodule ipt_CLASSIFY
loadmodule ipt_CLUSTERIP
loadmodule ipt_comment
loadmodule ipt_connmark
loadmodule ipt_CONNMARK
loadmodule ipt_conntrack
loadmodule ipt_dscp
loadmodule ipt_DSCP
loadmodule ipt_ecn
loadmodule ipt_ECN
loadmodule ipt_esp
loadmodule ipt_hashlimit
loadmodule ipt_helper
loadmodule ipt_ipp2p
loadmodule ipt_iprange
loadmodule ipt_length
loadmodule ipt_limit
loadmodule ipt_LOG
loadmodule ipt_mac
loadmodule ipt_mark
loadmodule ipt_MARK
loadmodule ipt_MASQUERADE
loadmodule ipt_multiport
loadmodule ipt_NETMAP
loadmodule ipt_NOTRACK
loadmodule ipt_owner
loadmodule ipt_physdev
loadmodule ipt_pkttype
loadmodule ipt_policy
loadmodule ipt_realm
loadmodule ipt_recent
loadmodule ipt_REDIRECT
loadmodule ipt_REJECT
loadmodule ipt_SAME
loadmodule ipt_sctp
loadmodule ipt_set
loadmodule ipt_state
loadmodule ipt_tcpmss
loadmodule ipt_TCPMSS
loadmodule ipt_tos
loadmodule ipt_TOS
loadmodule ipt_ttl
loadmodule ipt_TTL
loadmodule ipt_ULOG



AYJ
