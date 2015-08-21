From: Andreas Herz <andi@geekosphere.org>
Subject: [PATCH iptables] add missing icmpv6 codes (rfc4443) in REJECT
Date: Fri, 21 Aug 2015 10:55:03 +0200
Message-ID: <1440147303-27198-1-git-send-email-andi@geekosphere.org>
Cc: Andreas Herz <andi@geekosphere.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:57788 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbbHUIzR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Aug 2015 04:55:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

RFC 4443 added two new codes values for ICMPv6 type 1:

 5 - Source address failed ingress/egress policy
 6 - Reject route to destination

And RFC 7084 states in L-14 that IPv6 Router MUST send ICMPv6 Destination
Unreachable with code 5 for packets forwarded to it that use an address 
from a prefix that has been invalidated.

Signed-off-by: Andreas Herz <andi@geekosphere.org>
---
 extensions/libip6t_REJECT.c                | 4 ++++
 extensions/libip6t_REJECT.t                | 2 ++
 include/linux/netfilter_ipv6/ip6t_REJECT.h | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 8085321..033f65c 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -34,6 +34,10 @@ static const struct reject_names reject_table[] = {
 		IP6T_ICMP6_ADDR_UNREACH, "ICMPv6 address unreachable"},
 	{"icmp6-port-unreachable", "port-unreach",
 		IP6T_ICMP6_PORT_UNREACH, "ICMPv6 port unreachable"},
+	{"icmp6-policy-fail", "policy-fail",
+		IP6T_ICMP6_POLICY_FAIL, "ICMPv6 policy fail"},
+	{"icmp6-reject-route", "reject-route",
+		IP6T_ICMP6_REJECT_ROUTE, "ICMPv6 reject route"},
 	{"tcp-reset", "tcp-reset",
 		IP6T_TCP_RESET, "TCP RST packet"}
 };
diff --git a/extensions/libip6t_REJECT.t b/extensions/libip6t_REJECT.t
index 5a38942..d2b337d 100644
--- a/extensions/libip6t_REJECT.t
+++ b/extensions/libip6t_REJECT.t
@@ -5,5 +5,7 @@
 -j REJECT --reject-with icmp6-adm-prohibited;=;OK
 -j REJECT --reject-with icmp6-addr-unreachable;=;OK
 -j REJECT --reject-with icmp6-port-unreachable;=;OK
+-j REJECT --reject-with icmp6-policy-fail;=;OK
+-j REJECT --reject-with icmp6-reject-route;=;OK
 -p tcp -j REJECT --reject-with tcp-reset;=;OK
 -j REJECT --reject-with tcp-reset;;FAIL
diff --git a/include/linux/netfilter_ipv6/ip6t_REJECT.h b/include/linux/netfilter_ipv6/ip6t_REJECT.h
index 205ed62..8bd5f4b 100644
--- a/include/linux/netfilter_ipv6/ip6t_REJECT.h
+++ b/include/linux/netfilter_ipv6/ip6t_REJECT.h
@@ -9,6 +9,8 @@ enum ip6t_reject_with {
 	IP6T_ICMP6_NOT_NEIGHBOUR,
 	IP6T_ICMP6_ADDR_UNREACH,
 	IP6T_ICMP6_PORT_UNREACH,
+	IP6T_ICMP6_POLICY_FAIL,
+	IP6T_ICMP6_REJECT_ROUTE,
 	IP6T_ICMP6_ECHOREPLY,
 	IP6T_TCP_RESET
 };
-- 
2.4.6

