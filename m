From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] netfilter: remove unused comefrom hookmask argument
Date: Sun, 24 May 2015 01:00:41 +0200
Message-ID: <1432422041-13960-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39998 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215AbbEWXAy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 May 2015 19:00:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/ip_tables.c  | 4 +---
 net/ipv6/netfilter/ip6_tables.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index c69db7f..583779f 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1441,7 +1441,6 @@ static int
 compat_find_calc_match(struct xt_entry_match *m,
 		       const char *name,
 		       const struct ipt_ip *ip,
-		       unsigned int hookmask,
 		       int *size)
 {
 	struct xt_match *match;
@@ -1510,8 +1509,7 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 	entry_offset = (void *)e - (void *)base;
 	j = 0;
 	xt_ematch_foreach(ematch, e) {
-		ret = compat_find_calc_match(ematch, name,
-					     &e->ip, e->comefrom, &off);
+		ret = compat_find_calc_match(ematch, name, &e->ip, &off);
 		if (ret != 0)
 			goto release_matches;
 		++j;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 1a732a1..d54f049 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1456,7 +1456,6 @@ static int
 compat_find_calc_match(struct xt_entry_match *m,
 		       const char *name,
 		       const struct ip6t_ip6 *ipv6,
-		       unsigned int hookmask,
 		       int *size)
 {
 	struct xt_match *match;
@@ -1525,8 +1524,7 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 	entry_offset = (void *)e - (void *)base;
 	j = 0;
 	xt_ematch_foreach(ematch, e) {
-		ret = compat_find_calc_match(ematch, name,
-					     &e->ipv6, e->comefrom, &off);
+		ret = compat_find_calc_match(ematch, name, &e->ipv6, &off);
 		if (ret != 0)
 			goto release_matches;
 		++j;
-- 
2.0.5

