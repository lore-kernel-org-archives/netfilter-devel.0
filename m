From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 045/103] netfilter: xtables: change hotdrop pointer to direct modification
Date: Tue,  4 Aug 2009 09:25:29 +0200
Message-ID: <1249370787-17583-46-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50630 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571AbZHDH1W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:22 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since xt_action_param is writable, let's use it. The pointer to
'bool hotdrop' always worried (8 bytes (64-bit) to write 1 byte!).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    5 ++++-
 net/bridge/netfilter/ebtables.c    |    5 ++---
 net/ipv4/netfilter/arp_tables.c    |    6 +++---
 net/ipv4/netfilter/ip_tables.c     |    9 ++++-----
 net/ipv4/netfilter/ipt_ah.c        |    2 +-
 net/ipv4/netfilter/ipt_ecn.c       |    2 +-
 net/ipv6/netfilter/ip6_tables.c    |   11 +++++------
 net/ipv6/netfilter/ip6t_ah.c       |    4 ++--
 net/ipv6/netfilter/ip6t_eui64.c    |    2 +-
 net/ipv6/netfilter/ip6t_frag.c     |    4 ++--
 net/ipv6/netfilter/ip6t_hbh.c      |    4 ++--
 net/ipv6/netfilter/ip6t_mh.c       |    4 ++--
 net/ipv6/netfilter/ip6t_rt.c       |    4 ++--
 net/netfilter/xt_connlimit.c       |    4 ++--
 net/netfilter/xt_dccp.c            |    4 ++--
 net/netfilter/xt_esp.c             |    2 +-
 net/netfilter/xt_hashlimit.c       |    4 ++--
 net/netfilter/xt_multiport.c       |    4 ++--
 net/netfilter/xt_recent.c          |    2 +-
 net/netfilter/xt_sctp.c            |    4 ++--
 net/netfilter/xt_tcpmss.c          |    2 +-
 net/netfilter/xt_tcpudp.c          |   10 +++++-----
 22 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index d8f8e2a..4b7927a 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -206,6 +206,9 @@ struct xt_counters_info
  * @hook:	hook number given packet came from
  * @family:	Actual NFPROTO_* through which the function is invoked
  * 		(helpful when match->family == NFPROTO_UNSPEC)
+ *
+ * Fields written to by extensions:
+ *
  * @hotdrop:	drop packet if we had inspection problems
  */
 struct xt_action_param {
@@ -221,7 +224,7 @@ struct xt_action_param {
 	unsigned int thoff;
 	unsigned int hooknum;
 	u_int8_t family;
-	bool *hotdrop;
+	bool hotdrop;
 };
 
 /**
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 290f7fa..df68825 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -164,13 +164,12 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 	struct ebt_entries *chaininfo;
 	const char *base;
 	const struct ebt_table_info *private;
-	bool hotdrop = false;
 	struct xt_action_param acpar;
 
 	acpar.family  = NFPROTO_BRIDGE;
 	acpar.in      = in;
 	acpar.out     = out;
-	acpar.hotdrop = &hotdrop;
+	acpar.hotdrop = false;
 	acpar.hooknum = hook;
 
 	read_lock_bh(&table->lock);
@@ -194,7 +193,7 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 
 		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb, &acpar) != 0)
 			goto letscontinue;
-		if (hotdrop) {
+		if (acpar.hotdrop) {
 			read_unlock_bh(&table->lock);
 			return NF_DROP;
 		}
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index db24dac..c5bba1f 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -253,7 +253,6 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	unsigned int verdict = NF_DROP;
 	const struct arphdr *arp;
-	bool hotdrop = false;
 	struct arpt_entry *e, *back;
 	const char *indev, *outdev;
 	void *table_base;
@@ -277,6 +276,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	acpar.out     = out;
 	acpar.hooknum = hook;
 	acpar.family  = NFPROTO_ARP;
+	acpar.hotdrop = false;
 
 	arp = arp_hdr(skb);
 	do {
@@ -338,10 +338,10 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 		else
 			/* Verdict */
 			break;
-	} while (!hotdrop);
+	} while (!acpar.hotdrop);
 	xt_info_rdunlock_bh();
 
-	if (hotdrop)
+	if (acpar.hotdrop)
 		return NF_DROP;
 	else
 		return verdict;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index a8398ae..8bc1b65 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -302,7 +302,6 @@ ipt_do_table(struct sk_buff *skb,
 {
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	const struct iphdr *ip;
-	bool hotdrop = false;
 	/* Initializing verdict to NF_DROP keeps gcc happy. */
 	unsigned int verdict = NF_DROP;
 	const char *indev, *outdev;
@@ -324,7 +323,7 @@ ipt_do_table(struct sk_buff *skb,
 	 * match it. */
 	acpar.fragoff = ntohs(ip->frag_off) & IP_OFFSET;
 	acpar.thoff   = ip_hdrlen(skb);
-	acpar.hotdrop = &hotdrop;
+	acpar.hotdrop = false;
 	acpar.in      = in;
 	acpar.out     = out;
 	acpar.family  = NFPROTO_IPV4;
@@ -428,7 +427,7 @@ ipt_do_table(struct sk_buff *skb,
 		else
 			/* Verdict */
 			break;
-	} while (!hotdrop);
+	} while (!acpar.hotdrop);
 	xt_info_rdunlock_bh();
 	pr_devel("Exiting %s; resetting sp from %u to %u\n",
 	         __func__, *stackptr, origptr);
@@ -436,7 +435,7 @@ ipt_do_table(struct sk_buff *skb,
 #ifdef DEBUG_ALLOW_ALL
 	return NF_ACCEPT;
 #else
-	if (hotdrop)
+	if (acpar.hotdrop)
 		return NF_DROP;
 	else return verdict;
 #endif
@@ -2140,7 +2139,7 @@ icmp_match(const struct sk_buff *skb, struct xt_action_param *par)
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("Dropping evil ICMP tinygram.\n");
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index 90bc2be..2a85d25 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -52,7 +52,7 @@ static bool ah_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("Dropping evil AH tinygram.\n");
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return 0;
 	}
 
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index 96056b0..5907351 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -78,7 +78,7 @@ static bool ecn_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	if (info->operation & (IPT_ECN_OP_MATCH_ECE|IPT_ECN_OP_MATCH_CWR)) {
 		if (ip_hdr(skb)->protocol != IPPROTO_TCP)
 			return false;
-		if (!match_tcp(skb, info, par->hotdrop))
+		if (!match_tcp(skb, info, &par->hotdrop))
 			return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 46c675d..1b9ba79 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -331,7 +331,6 @@ ip6t_do_table(struct sk_buff *skb,
 	      struct xt_table *table)
 {
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
-	bool hotdrop = false;
 	/* Initializing verdict to NF_DROP keeps gcc happy. */
 	unsigned int verdict = NF_DROP;
 	const char *indev, *outdev;
@@ -350,7 +349,7 @@ ip6t_do_table(struct sk_buff *skb,
 	 * things we don't know, ie. tcp syn flag or ports).  If the
 	 * rule is also a fragment-specific rule, non-fragments won't
 	 * match it. */
-	acpar.hotdrop = &hotdrop;
+	acpar.hotdrop = false;
 	acpar.in      = in;
 	acpar.out     = out;
 	acpar.family  = NFPROTO_IPV6;
@@ -374,7 +373,7 @@ ip6t_do_table(struct sk_buff *skb,
 
 		IP_NF_ASSERT(e);
 		if (!ip6_packet_match(skb, indev, outdev, &e->ipv6,
-		    &acpar.thoff, &acpar.fragoff, &hotdrop)) {
+		    &acpar.thoff, &acpar.fragoff, &acpar.hotdrop)) {
  no_match:
 			e = ip6t_next_entry(e);
 			continue;
@@ -443,7 +442,7 @@ ip6t_do_table(struct sk_buff *skb,
 		else
 			/* Verdict */
 			break;
-	} while (!hotdrop);
+	} while (!acpar.hotdrop);
 
 	xt_info_rdunlock_bh();
 	*stackptr = origptr;
@@ -451,7 +450,7 @@ ip6t_do_table(struct sk_buff *skb,
 #ifdef DEBUG_ALLOW_ALL
 	return NF_ACCEPT;
 #else
-	if (hotdrop)
+	if (acpar.hotdrop)
 		return NF_DROP;
 	else return verdict;
 #endif
@@ -2154,7 +2153,7 @@ icmp6_match(const struct sk_buff *skb, struct xt_action_param *par)
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("Dropping evil ICMP tinygram.\n");
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index c25af95..ae46feb 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -48,13 +48,13 @@ static bool ah_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_AUTH, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
-			*par->hotdrop = true;
+			par->hotdrop = true;
 		return false;
 	}
 
 	ah = skb_header_pointer(skb, ptr, sizeof(_ah), &_ah);
 	if (ah == NULL) {
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index 86eb6ae..d2bec74 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -28,7 +28,7 @@ eui64_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	if (!(skb_mac_header(skb) >= skb->head &&
 	      skb_mac_header(skb) + ETH_HLEN <= skb->data) &&
 	    par->fragoff != 0) {
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index 35b9553..a4b6bb0 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -46,13 +46,13 @@ frag_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_FRAGMENT, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
-			*par->hotdrop = true;
+			par->hotdrop = true;
 		return false;
 	}
 
 	fh = skb_header_pointer(skb, ptr, sizeof(_frag), &_frag);
 	if (fh == NULL) {
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index e8a845e..08645e7 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -61,13 +61,13 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	err = ipv6_find_hdr(skb, &ptr, par->match->data, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
-			*par->hotdrop = true;
+			par->hotdrop = true;
 		return false;
 	}
 
 	oh = skb_header_pointer(skb, ptr, sizeof(_optsh), &_optsh);
 	if (oh == NULL) {
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index c001965..6393bf5 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -52,14 +52,14 @@ static bool mh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil MH tinygram.\n");
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
 	if (mh->ip6mh_proto != IPPROTO_NONE) {
 		duprintf("Dropping invalid MH Payload Proto: %u\n",
 			 mh->ip6mh_proto);
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index cd060f4..3f7a176 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -52,13 +52,13 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_ROUTING, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
-			*par->hotdrop = true;
+			par->hotdrop = true;
 		return false;
 	}
 
 	rh = skb_header_pointer(skb, ptr, sizeof(_route), &_route);
 	if (rh == NULL) {
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 645a91c..ddf0a2f 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -212,14 +212,14 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 	if (connections < 0) {
 		/* kmalloc failed, drop it entirely */
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
 	return (connections > info->limit) ^ info->inverse;
 
  hotdrop:
-	*par->hotdrop = true;
+	par->hotdrop = true;
 	return false;
 }
 
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index d39a637..b217d93 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -106,7 +106,7 @@ dccp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 	dh = skb_header_pointer(skb, par->thoff, sizeof(_dh), &_dh);
 	if (dh == NULL) {
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
@@ -119,7 +119,7 @@ dccp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		&& DCCHECK(match_types(dh, info->typemask),
 			   XT_DCCP_TYPE, info->flags, info->invflags)
 		&& DCCHECK(match_option(info->option, skb, par->thoff, dh,
-					par->hotdrop),
+					&par->hotdrop),
 			   XT_DCCP_OPTION, info->flags, info->invflags);
 }
 
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 2ae4a59..fcd6940 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -58,7 +58,7 @@ static bool esp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("Dropping evil ESP tinygram.\n");
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 32fb029..1d8224c 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -609,7 +609,7 @@ hashlimit_mt_v0(const struct sk_buff *skb, struct xt_action_param *par)
 	return false;
 
 hotdrop:
-	*par->hotdrop = true;
+	par->hotdrop = true;
 	return false;
 }
 
@@ -659,7 +659,7 @@ hashlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return info->cfg.mode & XT_HASHLIMIT_INVERT;
 
  hotdrop:
-	*par->hotdrop = true;
+	par->hotdrop = true;
 	return false;
 }
 
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index ab967a5..ab29604 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -110,7 +110,7 @@ multiport_mt_v0(const struct sk_buff *skb, struct xt_action_param *par)
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("xt_multiport: Dropping evil offset=0 tinygram.\n");
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
@@ -134,7 +134,7 @@ multiport_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("xt_multiport: Dropping evil offset=0 tinygram.\n");
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 6929c0b..1431c0e 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -240,7 +240,7 @@ recent_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			goto out;
 		e = recent_entry_init(t, &addr, par->match->family, ttl);
 		if (e == NULL)
-			*par->hotdrop = true;
+			par->hotdrop = true;
 		ret = !ret;
 		goto out;
 	}
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index 182a272..7c9f650 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -131,7 +131,7 @@ sctp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	sh = skb_header_pointer(skb, par->thoff, sizeof(_sh), &_sh);
 	if (sh == NULL) {
 		duprintf("Dropping evil TCP offset=0 tinygram.\n");
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 	duprintf("spt: %d\tdpt: %d\n", ntohs(sh->source), ntohs(sh->dest));
@@ -143,7 +143,7 @@ sctp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			&& ntohs(sh->dest) <= info->dpts[1],
 			XT_SCTP_DEST_PORTS, info->flags, info->invflags)
 		&& SCCHECK(match_packet(skb, par->thoff + sizeof(sctp_sctphdr_t),
-					info, par->hotdrop),
+					info, &par->hotdrop),
 			   XT_SCTP_CHUNK_TYPES, info->flags, info->invflags);
 }
 
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index f90728f..c53d4d1 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -73,7 +73,7 @@ out:
 	return info->invert;
 
 dropit:
-	*par->hotdrop = true;
+	par->hotdrop = true;
 	return false;
 }
 
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index d04ef76..e903042 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -83,7 +83,7 @@ static bool tcp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		*/
 		if (par->fragoff == 1) {
 			duprintf("Dropping evil TCP offset=1 frag.\n");
-			*par->hotdrop = true;
+			par->hotdrop = true;
 		}
 		/* Must not be a fragment. */
 		return false;
@@ -96,7 +96,7 @@ static bool tcp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil TCP offset=0 tinygram.\n");
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
@@ -114,13 +114,13 @@ static bool tcp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		return false;
 	if (tcpinfo->option) {
 		if (th->doff * 4 < sizeof(_tcph)) {
-			*par->hotdrop = true;
+			par->hotdrop = true;
 			return false;
 		}
 		if (!tcp_find_option(tcpinfo->option, skb, par->thoff,
 				     th->doff*4 - sizeof(_tcph),
 				     tcpinfo->invflags & XT_TCP_INV_OPTION,
-				     par->hotdrop))
+				     &par->hotdrop))
 			return false;
 	}
 	return true;
@@ -149,7 +149,7 @@ static bool udp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil UDP tinygram.\n");
-		*par->hotdrop = true;
+		par->hotdrop = true;
 		return false;
 	}
 
-- 
1.6.3.3

