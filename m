From: Andreas Herz <andi@geekosphere.org>
Subject: [PATCH v2 iptables] added missing icmpv6 codes in REJECT
Date: Fri, 21 Aug 2015 11:33:05 +0200
Message-ID: <1440149585-27908-1-git-send-email-andi@geekosphere.org>
Cc: Andreas Herz <andi@geekosphere.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:59350 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbbHUJdQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Aug 2015 05:33:16 -0400
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
 extensions/libip6t_REJECT.c                | 6 +++++-
 extensions/libip6t_REJECT.t                | 2 ++
 include/linux/netfilter_ipv6/ip6t_REJECT.h | 4 +++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 8085321..d62f431 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -35,7 +35,11 @@ static const struct reject_names reject_table[] = {
 	{"icmp6-port-unreachable", "port-unreach",
 		IP6T_ICMP6_PORT_UNREACH, "ICMPv6 port unreachable"},
 	{"tcp-reset", "tcp-reset",
-		IP6T_TCP_RESET, "TCP RST packet"}
+		IP6T_TCP_RESET, "TCP RST packet"},
+	{"icmp6-policy-fail", "policy-fail",
+		IP6T_ICMP6_POLICY_FAIL, "ICMPv6 policy fail"},
+	{"icmp6-reject-route", "reject-route",
+		IP6T_ICMP6_REJECT_ROUTE, "ICMPv6 reject route"}
 };
 
 static void
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
index 205ed62..cd2e940 100644
--- a/include/linux/netfilter_ipv6/ip6t_REJECT.h
+++ b/include/linux/netfilter_ipv6/ip6t_REJECT.h
@@ -10,7 +10,9 @@ enum ip6t_reject_with {
 	IP6T_ICMP6_ADDR_UNREACH,
 	IP6T_ICMP6_PORT_UNREACH,
 	IP6T_ICMP6_ECHOREPLY,
-	IP6T_TCP_RESET
+	IP6T_TCP_RESET,
+	IP6T_ICMP6_POLICY_FAIL,
+	IP6T_ICMP6_REJECT_ROUTE
 };
 
 struct ip6t_reject_info {
-- 
2.4.6

