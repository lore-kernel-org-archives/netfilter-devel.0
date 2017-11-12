From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: conntrack: timeouts can be const
Date: Sun, 12 Nov 2017 20:42:01 +0100
Message-ID: <20171112194201.3403-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44192 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750910AbdKLTyZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2017 14:54:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nowadays this is just the default template that is used when setting up
the net namespace, so nothing writes to these locations.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   | 2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c | 2 +-
 net/netfilter/nf_conntrack_proto_generic.c     | 2 +-
 net/netfilter/nf_conntrack_proto_gre.c         | 2 +-
 net/netfilter/nf_conntrack_proto_sctp.c        | 2 +-
 net/netfilter/nf_conntrack_proto_tcp.c         | 2 +-
 net/netfilter/nf_conntrack_proto_udp.c         | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 1849fedd9b81..cc27c9af9629 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -22,7 +22,7 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_log.h>
 
-static unsigned int nf_ct_icmp_timeout __read_mostly = 30*HZ;
+static const unsigned int nf_ct_icmp_timeout = 30*HZ;
 
 static inline struct nf_icmp_net *icmp_pernet(struct net *net)
 {
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 3ac0d826afc4..ab9e83c64a96 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -27,7 +27,7 @@
 #include <net/netfilter/ipv6/nf_conntrack_icmpv6.h>
 #include <net/netfilter/nf_log.h>
 
-static unsigned int nf_ct_icmpv6_timeout __read_mostly = 30*HZ;
+static const unsigned int nf_ct_icmpv6_timeout = 30*HZ;
 
 static inline struct nf_icmp_net *icmpv6_pernet(struct net *net)
 {
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 1f86ddf6649a..c44f9c362551 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -12,7 +12,7 @@
 #include <linux/netfilter.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 
-static unsigned int nf_ct_generic_timeout __read_mostly = 600*HZ;
+static const unsigned int nf_ct_generic_timeout = 600*HZ;
 
 static bool nf_generic_should_process(u8 proto)
 {
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index a2503005d80b..d2de1d6bc15d 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -48,7 +48,7 @@ enum grep_conntrack {
 	GRE_CT_MAX
 };
 
-static unsigned int gre_timeouts[GRE_CT_MAX] = {
+static const unsigned int gre_timeouts[GRE_CT_MAX] = {
 	[GRE_CT_UNREPLIED]	= 30*HZ,
 	[GRE_CT_REPLIED]	= 180*HZ,
 };
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 80faf04ddf15..6eec712538f3 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -52,7 +52,7 @@ static const char *const sctp_conntrack_names[] = {
 #define HOURS * 60 MINS
 #define DAYS  * 24 HOURS
 
-static unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] __read_mostly = {
+static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
 	[SCTP_CONNTRACK_CLOSED]			= 10 SECS,
 	[SCTP_CONNTRACK_COOKIE_WAIT]		= 3 SECS,
 	[SCTP_CONNTRACK_COOKIE_ECHOED]		= 3 SECS,
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b12fc07111d0..0cf7ffde6da2 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -68,7 +68,7 @@ static const char *const tcp_conntrack_names[] = {
 #define HOURS * 60 MINS
 #define DAYS * 24 HOURS
 
-static unsigned int tcp_timeouts[TCP_CONNTRACK_TIMEOUT_MAX] __read_mostly = {
+static const unsigned int tcp_timeouts[TCP_CONNTRACK_TIMEOUT_MAX] = {
 	[TCP_CONNTRACK_SYN_SENT]	= 2 MINS,
 	[TCP_CONNTRACK_SYN_RECV]	= 60 SECS,
 	[TCP_CONNTRACK_ESTABLISHED]	= 5 DAYS,
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 3a5f727103af..c8d36feb9271 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -26,7 +26,7 @@
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 
-static unsigned int udp_timeouts[UDP_CT_MAX] = {
+static const unsigned int udp_timeouts[UDP_CT_MAX] = {
 	[UDP_CT_UNREPLIED]	= 30*HZ,
 	[UDP_CT_REPLIED]	= 180*HZ,
 };
-- 
2.13.6

