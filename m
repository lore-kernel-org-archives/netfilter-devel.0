From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/4] netfilter: xtables: remove xt_multiport revision 0
Date: Wed, 31 Mar 2010 10:03:46 +0200
Message-ID: <1270022629-2494-3-git-send-email-jengelh@medozas.de>
References: <1270022629-2494-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40387 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757013Ab0CaIDx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:03:53 -0400
In-Reply-To: <1270022629-2494-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Superseded by xt_multiport revision 1 (introduction already predates
linux.git).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_multiport.c |   77 ------------------------------------------
 1 files changed, 0 insertions(+), 77 deletions(-)

diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index b446738..83b77ce 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -28,23 +28,6 @@ MODULE_ALIAS("ip6t_multiport");
 
 /* Returns 1 if the port is matched by the test, 0 otherwise. */
 static inline bool
-ports_match_v0(const u_int16_t *portlist, enum xt_multiport_flags flags,
-	       u_int8_t count, u_int16_t src, u_int16_t dst)
-{
-	unsigned int i;
-	for (i = 0; i < count; i++) {
-		if (flags != XT_MULTIPORT_DESTINATION && portlist[i] == src)
-			return true;
-
-		if (flags != XT_MULTIPORT_SOURCE && portlist[i] == dst)
-			return true;
-	}
-
-	return false;
-}
-
-/* Returns 1 if the port is matched by the test, 0 otherwise. */
-static inline bool
 ports_match_v1(const struct xt_multiport_v1 *minfo,
 	       u_int16_t src, u_int16_t dst)
 {
@@ -89,30 +72,6 @@ ports_match_v1(const struct xt_multiport_v1 *minfo,
 }
 
 static bool
-multiport_mt_v0(const struct sk_buff *skb, const struct xt_match_param *par)
-{
-	const __be16 *pptr;
-	__be16 _ports[2];
-	const struct xt_multiport *multiinfo = par->matchinfo;
-
-	if (par->fragoff != 0)
-		return false;
-
-	pptr = skb_header_pointer(skb, par->thoff, sizeof(_ports), _ports);
-	if (pptr == NULL) {
-		/* We've been asked to examine this packet, and we
-		 * can't.  Hence, no choice but to drop.
-		 */
-		pr_debug("Dropping evil offset=0 tinygram.\n");
-		*par->hotdrop = true;
-		return false;
-	}
-
-	return ports_match_v0(multiinfo->ports, multiinfo->flags,
-	       multiinfo->count, ntohs(pptr[0]), ntohs(pptr[1]));
-}
-
-static bool
 multiport_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	const __be16 *pptr;
@@ -152,15 +111,6 @@ check(u_int16_t proto,
 		&& count <= XT_MULTI_PORTS;
 }
 
-static int multiport_mt_check_v0(const struct xt_mtchk_param *par)
-{
-	const struct ipt_ip *ip = par->entryinfo;
-	const struct xt_multiport *multiinfo = par->matchinfo;
-
-	return check(ip->proto, ip->invflags, multiinfo->flags,
-		     multiinfo->count);
-}
-
 static int multiport_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ipt_ip *ip = par->entryinfo;
@@ -170,15 +120,6 @@ static int multiport_mt_check(const struct xt_mtchk_param *par)
 		     multiinfo->count);
 }
 
-static int multiport_mt6_check_v0(const struct xt_mtchk_param *par)
-{
-	const struct ip6t_ip6 *ip = par->entryinfo;
-	const struct xt_multiport *multiinfo = par->matchinfo;
-
-	return check(ip->proto, ip->invflags, multiinfo->flags,
-		     multiinfo->count);
-}
-
 static int multiport_mt6_check(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_ip6 *ip = par->entryinfo;
@@ -192,15 +133,6 @@ static struct xt_match multiport_mt_reg[] __read_mostly = {
 	{
 		.name		= "multiport",
 		.family		= NFPROTO_IPV4,
-		.revision	= 0,
-		.checkentry	= multiport_mt_check_v0,
-		.match		= multiport_mt_v0,
-		.matchsize	= sizeof(struct xt_multiport),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "multiport",
-		.family		= NFPROTO_IPV4,
 		.revision	= 1,
 		.checkentry	= multiport_mt_check,
 		.match		= multiport_mt,
@@ -210,15 +142,6 @@ static struct xt_match multiport_mt_reg[] __read_mostly = {
 	{
 		.name		= "multiport",
 		.family		= NFPROTO_IPV6,
-		.revision	= 0,
-		.checkentry	= multiport_mt6_check_v0,
-		.match		= multiport_mt_v0,
-		.matchsize	= sizeof(struct xt_multiport),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "multiport",
-		.family		= NFPROTO_IPV6,
 		.revision	= 1,
 		.checkentry	= multiport_mt6_check,
 		.match		= multiport_mt,
-- 
1.7.0.2

