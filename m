From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables] xtables-translate: fix multiple spaces issue
Date: Sat,  9 Jul 2016 12:27:51 +0200
Message-ID: <20160709102751.3792-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35101 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbcGIK3N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Jul 2016 06:29:13 -0400
Received: by mail-wm0-f65.google.com with SMTP id k123so10863239wme.2
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Jul 2016 03:29:12 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes a multiple spaces issue. The problem arises when a rule
set loaded through iptables-compat-restore is listed in nft.

Before this commit, two spaces were printed after every match
translation:

$ cat iptables-save
*filter
:INPUT ACCEPT [0:0]
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m multiport --dports 80:85 -m ttl --ttl-gt 5 -j ACCEPT
COMMIT

$ sudo iptables-compat-restore iptables-save

$ sudo nft list ruleset
table ip filter {
    chain INPUT {
        type filter hook input priority 0; policy accept;
        ct state related,established  counter packets 0 bytes 0 accept
                                    ^^
        ip protocol tcp tcp dport 80-85  ip ttl gt 5  counter packets 0 bytes 0 accept
                                       ^^           ^^
    }
}

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 extensions/libip6t_ah.c      | 22 ++++++++------
 extensions/libip6t_frag.c    | 33 ++++++++++++---------
 extensions/libip6t_hbh.c     |  2 +-
 extensions/libip6t_hl.c      |  2 +-
 extensions/libip6t_mh.c      |  4 +--
 extensions/libip6t_rt.c      | 13 +++++----
 extensions/libipt_ah.c       |  4 +--
 extensions/libipt_icmp.c     |  2 --
 extensions/libipt_realm.c    |  6 ++--
 extensions/libipt_ttl.c      |  2 +-
 extensions/libxt_cgroup.c    |  4 +--
 extensions/libxt_connmark.c  |  4 +--
 extensions/libxt_conntrack.c | 68 +++++++++++++++++++++++++-------------------
 extensions/libxt_cpu.c       |  2 +-
 extensions/libxt_dccp.c      | 14 ++++-----
 extensions/libxt_devgroup.c  | 10 ++++---
 extensions/libxt_dscp.c      |  2 +-
 extensions/libxt_ecn.c       |  8 +++---
 extensions/libxt_esp.c       |  4 +--
 extensions/libxt_helper.c    |  2 +-
 extensions/libxt_ipcomp.c    |  2 +-
 extensions/libxt_iprange.c   | 38 ++++++++++++++++---------
 extensions/libxt_length.c    |  4 +--
 extensions/libxt_limit.c     |  6 ++--
 extensions/libxt_mac.c       |  1 -
 extensions/libxt_mark.c      |  4 +--
 extensions/libxt_multiport.c | 20 ++++++-------
 extensions/libxt_owner.c     |  8 +++---
 extensions/libxt_pkttype.c   |  2 +-
 extensions/libxt_sctp.c      | 10 ++++---
 extensions/libxt_tcp.c       | 14 +++++----
 extensions/libxt_udp.c       | 10 ++++---
 iptables/xtables-translate.c |  4 +++
 33 files changed, 185 insertions(+), 146 deletions(-)

diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 9c7bdd7..179390c 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -132,24 +132,28 @@ static int ah_xlate(const void *ip, const struct xt_entry_match *match,
 		    struct xt_xlate *xl, int numeric)
 {
 	const struct ip6t_ah *ahinfo = (struct ip6t_ah *)match->data;
+	char *space = "";
 
 	if (!(ahinfo->spis[0] == 0 && ahinfo->spis[1] == 0xFFFFFFFF)) {
 		xt_xlate_add(xl, "ah spi%s ",
-			   (ahinfo->invflags & IP6T_AH_INV_SPI) ? " !=" : "");
-	if (ahinfo->spis[0] != ahinfo->spis[1])
-		xt_xlate_add(xl, "%u-%u ", ahinfo->spis[0], ahinfo->spis[1]);
-	else
-		xt_xlate_add(xl, "%u ", ahinfo->spis[0]);
+			(ahinfo->invflags & IP6T_AH_INV_SPI) ? " !=" : "");
+		if (ahinfo->spis[0] != ahinfo->spis[1])
+			xt_xlate_add(xl, "%u-%u", ahinfo->spis[0], 
+				     ahinfo->spis[1]);
+		else
+			xt_xlate_add(xl, "%u", ahinfo->spis[0]);
+		space = " ";
 	}
 
 	if (ahinfo->hdrlen != 0 || (ahinfo->invflags & IP6T_AH_INV_LEN)) {
-		xt_xlate_add(xl, "ah hdrlength%s %u ",
-			   (ahinfo->invflags & IP6T_AH_INV_LEN) ? " !=" : "",
-			   ahinfo->hdrlen);
+		xt_xlate_add(xl, "%sah hdrlength%s %u", space,
+			     (ahinfo->invflags & IP6T_AH_INV_LEN) ? " !=" : "",
+			     ahinfo->hdrlen);
+		space = " ";
 	}
 
 	if (ahinfo->hdrres != 0)
-		xt_xlate_add(xl, "ah reserved %u ", ahinfo->hdrres);
+		xt_xlate_add(xl, "%sah reserved %u", space, ahinfo->hdrres);
 
 	return 1;
 }
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 57487c4..e7a51d3 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -177,29 +177,36 @@ static int frag_xlate(const void *ip, const struct xt_entry_match *match,
 		      struct xt_xlate *xl, int numeric)
 {
 	const struct ip6t_frag *fraginfo = (struct ip6t_frag *)match->data;
+	char *space= "";
 
 	if (!(fraginfo->ids[0] == 0 && fraginfo->ids[1] == 0xFFFFFFFF)) {
 		xt_xlate_add(xl, "frag id %s",
 			     (fraginfo->invflags & IP6T_FRAG_INV_IDS) ?
 			     "!= " : "");
 		if (fraginfo->ids[0] != fraginfo->ids[1])
-			xt_xlate_add(xl, "%u-%u ", fraginfo->ids[0],
+			xt_xlate_add(xl, "%u-%u", fraginfo->ids[0],
 				     fraginfo->ids[1]);
 		else
-			xt_xlate_add(xl, "%u ", fraginfo->ids[0]);
-	}
-
-	if (fraginfo->flags & IP6T_FRAG_RES)
-		xt_xlate_add(xl, "frag reserved 1 ");
+			xt_xlate_add(xl, "%u", fraginfo->ids[0]);
 
-	if (fraginfo->flags & IP6T_FRAG_FST)
-		xt_xlate_add(xl, "frag frag-off 0 ");
-
-	if (fraginfo->flags & IP6T_FRAG_MF)
-		xt_xlate_add(xl, "frag more-fragments 1 ");
+		space = " ";
+	}
 
-	if (fraginfo->flags & IP6T_FRAG_NMF)
-		xt_xlate_add(xl, "frag more-fragments 0 ");
+	if (fraginfo->flags & IP6T_FRAG_RES) {
+		xt_xlate_add(xl, "%sfrag reserved 1", space);
+		space = " ";
+	}
+	if (fraginfo->flags & IP6T_FRAG_FST) {
+		xt_xlate_add(xl, "%sfrag frag-off 0", space);
+		space = " ";
+	}
+	if (fraginfo->flags & IP6T_FRAG_MF) {
+		xt_xlate_add(xl, "%sfrag more-fragments 1", space);
+		space = " ";
+	}
+	if (fraginfo->flags & IP6T_FRAG_NMF) {
+		xt_xlate_add(xl, "%sfrag more-fragments 0", space);
+	}
 
 	return 1;
 }
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 416681d..cb7e4e8 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -173,7 +173,7 @@ static int hbh_xlate(const void *ip, const struct xt_entry_match *match,
 	    (optinfo->flags & IP6T_OPTS_OPTS))
 		return 0;
 
-	xt_xlate_add(xl, "hbh hdrlength %s%u ",
+	xt_xlate_add(xl, "hbh hdrlength %s%u",
 		     (optinfo->invflags & IP6T_OPTS_INV_LEN) ? "!= " : "",
 		     optinfo->hdrlen);
 
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index ee9c36b..50b47f4 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -95,7 +95,7 @@ static int hl_xlate(const void *ip, const struct xt_entry_match *match,
 	const struct ip6t_hl_info *info =
 		(struct ip6t_hl_info *) match->data;
 
-	xt_xlate_add(xl, "ip6 hoplimit %s%u ", op[info->mode], info->hop_limit);
+	xt_xlate_add(xl, "ip6 hoplimit %s%u", op[info->mode], info->hop_limit);
 
 	return 1;
 }
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index f4672da..4cf20c2 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -211,11 +211,11 @@ static int mh_xlate(const void *ip, const struct xt_entry_match *match,
 		return 1;
 
 	if (mhinfo->types[0] != mhinfo->types[1])
-		xt_xlate_add(xl, "mh type %s%u-%u ",
+		xt_xlate_add(xl, "mh type %s%u-%u",
 			     mhinfo->invflags & IP6T_MH_INV_TYPE ? "!= " : "",
 			     mhinfo->types[0], mhinfo->types[1]);
 	else
-		xt_xlate_add(xl, "mh type %s%u ",
+		xt_xlate_add(xl, "mh type %s%u",
 			     mhinfo->invflags & IP6T_MH_INV_TYPE ? "!= " : "",
 			     mhinfo->types[0]);
 
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 14a7f7e..81e222e 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -249,26 +249,29 @@ static int rt_xlate(const void *ip, const struct xt_entry_match *match,
 		    struct xt_xlate *xl, int numeric)
 {
 	const struct ip6t_rt *rtinfo = (struct ip6t_rt *)match->data;
+	char *space = "";
 
 	if (rtinfo->flags & IP6T_RT_TYP) {
-		xt_xlate_add(xl, "rt type%s %u ",
+		xt_xlate_add(xl, "rt type%s %u",
 			     (rtinfo->invflags & IP6T_RT_INV_TYP) ? " !=" : "",
 			      rtinfo->rt_type);
+		space = " ";
 	}
 
 	if (!(rtinfo->segsleft[0] == 0 && rtinfo->segsleft[1] == 0xFFFFFFFF)) {
-		xt_xlate_add(xl, "rt seg-left%s ",
+		xt_xlate_add(xl, "%srt seg-left%s ", space,
 			     (rtinfo->invflags & IP6T_RT_INV_SGS) ? " !=" : "");
 
 		if (rtinfo->segsleft[0] != rtinfo->segsleft[1])
-			xt_xlate_add(xl, "%u-%u ", rtinfo->segsleft[0],
+			xt_xlate_add(xl, "%u-%u", rtinfo->segsleft[0],
 					rtinfo->segsleft[1]);
 		else
-			xt_xlate_add(xl, "%u ", rtinfo->segsleft[0]);
+			xt_xlate_add(xl, "%u", rtinfo->segsleft[0]);
+		space = " ";
 	}
 
 	if (rtinfo->flags & IP6T_RT_LEN) {
-		xt_xlate_add(xl, "rt hdrlength%s %u ",
+		xt_xlate_add(xl, "%srt hdrlength%s %u", space,
 			     (rtinfo->invflags & IP6T_RT_INV_LEN) ? " !=" : "",
 			      rtinfo->hdrlen);
 	}
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index b8953d7..7dff93d 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -101,10 +101,10 @@ static int ah_xlate(const void *ip, const struct xt_entry_match *match,
 		xt_xlate_add(xl, "ah spi%s ",
 			   (ahinfo->invflags & IPT_AH_INV_SPI) ? " !=" : "");
 		if (ahinfo->spis[0] != ahinfo->spis[1])
-			xt_xlate_add(xl, "%u-%u ", ahinfo->spis[0],
+			xt_xlate_add(xl, "%u-%u", ahinfo->spis[0],
 				   ahinfo->spis[1]);
 		else
-			xt_xlate_add(xl, "%u ", ahinfo->spis[0]);
+			xt_xlate_add(xl, "%u", ahinfo->spis[0]);
 	}
 
 	return 1;
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index fb6050a..342659e 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -280,8 +280,6 @@ static int icmp_xlate(const void *ip, const struct xt_entry_match *match,
 		if (!type_xlate_print(xl, info->type, info->code[0],
 				      info->code[1]))
 			return 0;
-
-		xt_xlate_add(xl, " ");
 	}
 	return 1;
 }
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 0a4bc3b..b5c9032 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -115,16 +115,16 @@ print_realm_xlate(unsigned long id, unsigned long mask,
 	const char *name = NULL;
 
 	if (mask != 0xffffffff)
-		xt_xlate_add(xl, " and 0x%lx %s 0x%lx ", mask,
+		xt_xlate_add(xl, " and 0x%lx %s 0x%lx", mask,
 			   op == XT_OP_EQ ? "==" : "!=", id);
 	else {
 		if (numeric == 0)
 			name = xtables_lmap_id2name(realms, id);
 		if (name)
-			xt_xlate_add(xl, "%s%s ",
+			xt_xlate_add(xl, "%s%s",
 				   op == XT_OP_EQ ? "" : "!= ", name);
 		else
-			xt_xlate_add(xl, " %s0x%lx ",
+			xt_xlate_add(xl, " %s0x%lx",
 				   op == XT_OP_EQ ? "" : "!= ", id);
 	}
 }
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 01e085d..e1db0df 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -124,7 +124,7 @@ static int ttl_xlate(const void *ip, const struct xt_entry_match *match,
 			break;
 	}
 
-	xt_xlate_add(xl, " %u ", info->ttl);
+	xt_xlate_add(xl, " %u", info->ttl);
 
 	return 1;
 }
diff --git a/extensions/libxt_cgroup.c b/extensions/libxt_cgroup.c
index 1191815..fcd77c3 100644
--- a/extensions/libxt_cgroup.c
+++ b/extensions/libxt_cgroup.c
@@ -126,7 +126,7 @@ static int cgroup_xlate_v0(const void *ip, const struct xt_entry_match *match,
 {
 	const struct xt_cgroup_info_v0 *info = (void *)match->data;
 
-	xt_xlate_add(xl, "meta cgroup %s%u ", info->invert ? "!= " : "",
+	xt_xlate_add(xl, "meta cgroup %s%u", info->invert ? "!= " : "",
 		     info->id);
 	return 1;
 }
@@ -140,7 +140,7 @@ static int cgroup_xlate_v1(const void *ip, const struct xt_entry_match *match,
 		return 0;
 
 	if (info->has_classid)
-		xt_xlate_add(xl, "meta cgroup %s%u ",
+		xt_xlate_add(xl, "meta cgroup %s%u",
 			     info->invert_classid ? "!= " : "",
 			     info->classid);
 
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 958a50c..1630858 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -127,10 +127,10 @@ static void print_mark_xlate(unsigned int mark, unsigned int mask,
 			     struct xt_xlate *xl, uint32_t op)
 {
 	if (mask != 0xffffffffU)
-		xt_xlate_add(xl, " and 0x%x %s 0x%x ", mask,
+		xt_xlate_add(xl, " and 0x%x %s 0x%x", mask,
 			   op == XT_OP_EQ ? "==" : "!=", mark);
 	else
-		xt_xlate_add(xl, " %s0x%x ",
+		xt_xlate_add(xl, " %s0x%x",
 			   op == XT_OP_EQ ? "" : "!= ", mark);
 }
 
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 2242489..4f3853c 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1236,40 +1236,45 @@ static int _conntrack3_mt_xlate(const void *ip,
 				int family)
 {
 	const struct xt_conntrack_mtinfo3 *sinfo = (const void *)match->data;
+	char *space = "";
 
-	if (sinfo->match_flags & XT_CONNTRACK_DIRECTION)
-		xt_xlate_add(xl, "ct direction %s ",
+	if (sinfo->match_flags & XT_CONNTRACK_DIRECTION) {
+		xt_xlate_add(xl, "ct direction %s",
 			     sinfo->invert_flags & XT_CONNTRACK_DIRECTION ?
 			     "reply" : "original");
+		space = " ";
+	}
 
-	if (sinfo->match_flags & XT_CONNTRACK_PROTO)
-		xt_xlate_add(xl, "ct %s protocol %s%u ",
+	if (sinfo->match_flags & XT_CONNTRACK_PROTO) {
+		xt_xlate_add(xl, "%sct %s protocol %s%u", space,
 			     sinfo->invert_flags & XT_CONNTRACK_DIRECTION ?
 			     "reply" : "original",
 			     sinfo->invert_flags & XT_CONNTRACK_PROTO ?
 			     "!= " : "",
 			     sinfo->l4proto);
+		space = " ";
+	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_STATE) {
-		xt_xlate_add(xl, "ct state %s",
+		xt_xlate_add(xl, "%sct state %s", space,
 			     sinfo->invert_flags & XT_CONNTRACK_STATE ?
 			     "!= " : "");
 		state_xlate_print(xl, sinfo->state_mask);
-		xt_xlate_add(xl, " ");
+		space = " ";
 	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_STATUS) {
 		if (sinfo->status_mask == 1)
 			return 0;
-		xt_xlate_add(xl, "ct status %s",
+		xt_xlate_add(xl, "%sct status %s", space,
 			     sinfo->invert_flags & XT_CONNTRACK_STATUS ?
 			     "!= " : "");
 		status_xlate_print(xl, sinfo->status_mask);
-		xt_xlate_add(xl, " ");
+		space = " ";
 	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_EXPIRES) {
-		xt_xlate_add(xl, "ct expiration %s",
+		xt_xlate_add(xl, "%sct expiration %s", space,
 			     sinfo->invert_flags & XT_CONNTRACK_EXPIRES ?
 			     "!= " : "");
 		if (sinfo->expires_max == sinfo->expires_min)
@@ -1277,98 +1282,101 @@ static int _conntrack3_mt_xlate(const void *ip,
 		else
 			xt_xlate_add(xl, "%lu-%lu", sinfo->expires_min,
 				     sinfo->expires_max);
-		xt_xlate_add(xl, " ");
+		space = " ";
 	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_ORIGSRC) {
 		if (&sinfo->origsrc_addr == 0L)
 			return 0;
 
-		xt_xlate_add(xl, "ct original saddr %s",
+		xt_xlate_add(xl, "%sct original saddr %s", space,
 			     sinfo->invert_flags & XT_CONNTRACK_ORIGSRC ?
 			     "!= " : "");
 		addr_xlate_print(xl, &sinfo->origsrc_addr,
 				 &sinfo->origsrc_mask, family);
-		xt_xlate_add(xl, " ");
+		space = " ";
 	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_ORIGDST) {
 		if (&sinfo->origdst_addr == 0L)
 			return 0;
 
-		xt_xlate_add(xl, "ct original daddr %s",
+		xt_xlate_add(xl, "%sct original daddr %s", space,
 			     sinfo->invert_flags & XT_CONNTRACK_ORIGDST ?
 			     "!= " : "");
 		addr_xlate_print(xl, &sinfo->origdst_addr,
 				 &sinfo->origdst_mask, family);
-		xt_xlate_add(xl, " ");
+		space = " ";
 	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_REPLSRC) {
 		if (&sinfo->replsrc_addr == 0L)
 			return 0;
 
-		xt_xlate_add(xl, "ct reply saddr %s",
+		xt_xlate_add(xl, "%sct reply saddr %s", space,
 			     sinfo->invert_flags & XT_CONNTRACK_REPLSRC ?
 			     "!= " : "");
 		addr_xlate_print(xl, &sinfo->replsrc_addr,
 				 &sinfo->replsrc_mask, family);
-		xt_xlate_add(xl, " ");
+		space = " ";
 	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_REPLDST) {
 		if (&sinfo->repldst_addr == 0L)
 			return 0;
 
-		xt_xlate_add(xl, "ct reply daddr %s",
+		xt_xlate_add(xl, "%sct reply daddr %s", space,
 			     sinfo->invert_flags & XT_CONNTRACK_REPLDST ?
 			     "!= " : "");
 		addr_xlate_print(xl, &sinfo->repldst_addr,
 				 &sinfo->repldst_mask, family);
-		xt_xlate_add(xl, " ");
+		space = " ";
 	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_ORIGSRC_PORT) {
-		xt_xlate_add(xl, "ct original proto-src %s",
+		xt_xlate_add(xl, "%sct original proto-src %s", space,
 			     sinfo->invert_flags & XT_CONNTRACK_ORIGSRC_PORT ?
 			     "!= " : "");
 		if (sinfo->origsrc_port == sinfo->origsrc_port_high)
-			xt_xlate_add(xl, "%u ", sinfo->origsrc_port);
+			xt_xlate_add(xl, "%u", sinfo->origsrc_port);
 		else
-			xt_xlate_add(xl, "%u-%u ", sinfo->origsrc_port,
+			xt_xlate_add(xl, "%u-%u", sinfo->origsrc_port,
 				     sinfo->origsrc_port_high);
+		space = " ";
 	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_ORIGDST_PORT) {
-		xt_xlate_add(xl, "ct original proto-dst %s",
+		xt_xlate_add(xl, "%sct original proto-dst %s", space,
 			     sinfo->invert_flags & XT_CONNTRACK_ORIGDST_PORT ?
 			     "!= " : "");
 		if (sinfo->origdst_port == sinfo->origdst_port_high)
-			xt_xlate_add(xl, "%u ", sinfo->origdst_port);
+			xt_xlate_add(xl, "%u", sinfo->origdst_port);
 		else
-			xt_xlate_add(xl, "%u-%u ", sinfo->origdst_port,
+			xt_xlate_add(xl, "%u-%u", sinfo->origdst_port,
 				     sinfo->origdst_port_high);
+		space = " ";
 	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_REPLSRC_PORT) {
-		xt_xlate_add(xl, "ct reply proto-src %s",
+		xt_xlate_add(xl, "%sct reply proto-src %s", space,
 			     sinfo->invert_flags & XT_CONNTRACK_REPLSRC_PORT ?
 			     "!= " : "");
 		if (sinfo->replsrc_port == sinfo->replsrc_port_high)
-			xt_xlate_add(xl, "%u ", sinfo->replsrc_port);
+			xt_xlate_add(xl, "%u", sinfo->replsrc_port);
 		else
-			xt_xlate_add(xl, "%u-%u ", sinfo->replsrc_port,
+			xt_xlate_add(xl, "%u-%u", sinfo->replsrc_port,
 				     sinfo->replsrc_port_high);
+		space = " ";
 	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_REPLDST_PORT) {
-		xt_xlate_add(xl, "ct reply proto-dst %s",
+		xt_xlate_add(xl, "%sct reply proto-dst %s", space,
 			     sinfo->invert_flags & XT_CONNTRACK_REPLDST_PORT ?
 			     "!= " : "", sinfo->repldst_port);
 		if (sinfo->repldst_port == sinfo->repldst_port_high)
-			xt_xlate_add(xl, "%u ", sinfo->repldst_port);
+			xt_xlate_add(xl, "%u", sinfo->repldst_port);
 		else
-			xt_xlate_add(xl, "%u-%u ", sinfo->repldst_port,
+			xt_xlate_add(xl, "%u-%u", sinfo->repldst_port,
 				     sinfo->repldst_port_high);
 	}
 
diff --git a/extensions/libxt_cpu.c b/extensions/libxt_cpu.c
index d453fad..97927fa 100644
--- a/extensions/libxt_cpu.c
+++ b/extensions/libxt_cpu.c
@@ -49,7 +49,7 @@ static int cpu_xlate(const void *ip, const struct xt_entry_match *match,
 {
 	const struct xt_cpu_info *info = (void *)match->data;
 
-	xt_xlate_add(xl, "cpu%s %u ", info->invert ? " !=" : "", info->cpu);
+	xt_xlate_add(xl, "cpu%s %u", info->invert ? " !=" : "", info->cpu);
 
 	return 1;
 }
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index d442e37..179261f 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -299,7 +299,7 @@ static int dccp_type_xlate(const struct xt_dccp_info *einfo,
 	if (types & (1 << DCCP_PKT_INVALID))
 		return 0;
 
-	xt_xlate_add(xl, "dccp type%s ", einfo->invflags ? " !=" : "");
+	xt_xlate_add(xl, " dccp type%s ", einfo->invflags ? " !=" : "");
 
 	if ((types != 0) && !(types == (types & -types))) {
 		xt_xlate_add(xl, "{");
@@ -324,8 +324,6 @@ static int dccp_type_xlate(const struct xt_dccp_info *einfo,
 	if (set_need)
 		xt_xlate_add(xl, "}");
 
-	xt_xlate_add(xl, " ");
-
 	return 1;
 }
 
@@ -335,27 +333,29 @@ static int dccp_xlate(const void *ip, const struct xt_entry_match *match,
 	const struct xt_dccp_info *einfo =
 			(const struct xt_dccp_info *)match->data;
 	int ret = 1;
+	char *space = "";
 
 	xt_xlate_add(xl, "dccp ");
 
 	if (einfo->flags & XT_DCCP_SRC_PORTS) {
 		if (einfo->spts[0] != einfo->spts[1])
-			xt_xlate_add(xl, "sport%s %u-%u ",
+			xt_xlate_add(xl, "sport%s %u-%u",
 				     einfo->invflags & XT_DCCP_SRC_PORTS ? " !=" : "",
 				     einfo->spts[0], einfo->spts[1]);
 		else
-			xt_xlate_add(xl, "sport%s %u ",
+			xt_xlate_add(xl, "sport%s %u",
 				     einfo->invflags & XT_DCCP_SRC_PORTS ? " !=" : "",
 				     einfo->spts[0]);
+		space = " ";
 	}
 
 	if (einfo->flags & XT_DCCP_DEST_PORTS) {
 		if (einfo->dpts[0] != einfo->dpts[1])
-			xt_xlate_add(xl, "dport%s %u-%u ",
+			xt_xlate_add(xl, "%sdport%s %u-%u", space,
 				     einfo->invflags & XT_DCCP_DEST_PORTS ? " !=" : "",
 				     einfo->dpts[0], einfo->dpts[1]);
 		else
-			xt_xlate_add(xl, "dport%s %u ",
+			xt_xlate_add(xl, "%sdport%s %u", space,
 				     einfo->invflags & XT_DCCP_DEST_PORTS ? " !=" : "",
 				     einfo->dpts[0]);
 	}
diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index f110ea7..41dae2f 100644
--- a/extensions/libxt_devgroup.c
+++ b/extensions/libxt_devgroup.c
@@ -158,15 +158,15 @@ print_devgroup_xlate(unsigned int id, uint32_t op,  unsigned int mask,
 	const char *name = NULL;
 
 	if (mask != 0xffffffff)
-		xt_xlate_add(xl, "and 0x%x %s 0x%x ", mask,
+		xt_xlate_add(xl, "and 0x%x %s 0x%x", mask,
 			   op == XT_OP_EQ ? "==" : "!=", id);
 	else {
 		if (numeric == 0)
 			name = xtables_lmap_id2name(devgroups, id);
 		if (name)
-			xt_xlate_add(xl, "%s ", name);
+			xt_xlate_add(xl, "%s", name);
 		else
-			xt_xlate_add(xl, "%s0x%x ",
+			xt_xlate_add(xl, "%s0x%x",
 				   op == XT_OP_EQ ? "" : "!= ", id);
 	}
 }
@@ -175,6 +175,7 @@ static void devgroup_show_xlate(const struct xt_devgroup_info *info,
 				struct xt_xlate *xl, int numeric)
 {
 	enum xt_op op = XT_OP_EQ;
+	char *space = "";
 
 	if (info->flags & XT_DEVGROUP_MATCH_SRC) {
 		if (info->flags & XT_DEVGROUP_INVERT_SRC)
@@ -182,12 +183,13 @@ static void devgroup_show_xlate(const struct xt_devgroup_info *info,
 		xt_xlate_add(xl, "iifgroup ");
 		print_devgroup_xlate(info->src_group, op,
 				     info->src_mask, xl, numeric);
+		space = " ";
 	}
 
 	if (info->flags & XT_DEVGROUP_MATCH_DST) {
 		if (info->flags & XT_DEVGROUP_INVERT_DST)
 			op = XT_OP_NEQ;
-		xt_xlate_add(xl, "oifgroup ");
+		xt_xlate_add(xl, "%soifgroup ", space);
 		print_devgroup_xlate(info->dst_group, op,
 				     info->dst_mask, xl, numeric);
 	}
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index adc7827..17433ef 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -97,7 +97,7 @@ static int __dscp_xlate(const void *ip, const struct xt_entry_match *match,
 	const struct xt_dscp_info *dinfo =
 		(const struct xt_dscp_info *)match->data;
 
-	xt_xlate_add(xl, "dscp %s0x%02x ", dinfo->invert ? "!= " : "",
+	xt_xlate_add(xl, "dscp %s0x%02x", dinfo->invert ? "!= " : "",
 		     dinfo->dscp);
 
 	return 1;
diff --git a/extensions/libxt_ecn.c b/extensions/libxt_ecn.c
index 2856a31..969920d 100644
--- a/extensions/libxt_ecn.c
+++ b/extensions/libxt_ecn.c
@@ -133,16 +133,16 @@ static int ecn_xlate(const void *ip, const struct xt_entry_match *match,
 
 	switch (einfo->ip_ect) {
 	case 0:
-		xt_xlate_add(xl, "not-ect ");
+		xt_xlate_add(xl, "not-ect");
 		break;
 	case 1:
-		xt_xlate_add(xl, "ect1 ");
+		xt_xlate_add(xl, "ect1");
 		break;
 	case 2:
-		xt_xlate_add(xl, "ect0 ");
+		xt_xlate_add(xl, "ect0");
 		break;
 	case 3:
-		xt_xlate_add(xl, "ce ");
+		xt_xlate_add(xl, "ce");
 		break;
 	}
 	return 1;
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index bd7b643..5e8c58d 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -95,10 +95,10 @@ static int esp_xlate(const void *ip, const struct xt_entry_match *match,
 		xt_xlate_add(xl, "esp spi%s",
 			   (espinfo->invflags & XT_ESP_INV_SPI) ? " !=" : "");
 		if (espinfo->spis[0] != espinfo->spis[1])
-			xt_xlate_add(xl, " %u-%u ", espinfo->spis[0],
+			xt_xlate_add(xl, " %u-%u", espinfo->spis[0],
 				   espinfo->spis[1]);
 		else
-			xt_xlate_add(xl, " %u ", espinfo->spis[0]);
+			xt_xlate_add(xl, " %u", espinfo->spis[0]);
 	}
 
 	return 1;
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index a8b7c68..26e9569 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -50,7 +50,7 @@ static int helper_xlate(const void *ip, const struct xt_entry_match *match,
 {
 	const struct xt_helper_info *info = (const void *)match->data;
 
-	xt_xlate_add(xl, "ct helper%s \\\"%s\\\" ",
+	xt_xlate_add(xl, "ct helper%s \\\"%s\\\"",
 		   info->invert ? " !=" : "", info->name);
 
 	return 1;
diff --git a/extensions/libxt_ipcomp.c b/extensions/libxt_ipcomp.c
index 19b251a..5e72154 100644
--- a/extensions/libxt_ipcomp.c
+++ b/extensions/libxt_ipcomp.c
@@ -100,7 +100,7 @@ static int comp_xlate(const void *ip, const struct xt_entry_match *match,
 {
 	const struct xt_ipcomp *compinfo = (struct xt_ipcomp *)match->data;
 
-	xt_xlate_add(xl, "comp cpi %s%u ",
+	xt_xlate_add(xl, "comp cpi %s%u",
 		     (compinfo->invflags & XT_IPCOMP_INV_SPI) ? "!= " : "",
 		     compinfo->spis[0]);
 
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 8da7de1..d68df48 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -319,17 +319,21 @@ static int iprange_xlate(const void *ip, const struct xt_entry_match *match,
 			 struct xt_xlate *xl, int numeric)
 {
 	const struct ipt_iprange_info *info = (const void *)match->data;
+	char *space = "";
 
 	if (info->flags & IPRANGE_SRC) {
 		if (info->flags & IPRANGE_SRC_INV)
 			xt_xlate_add(xl, "!= ");
 		xt_xlate_add(xl, "ip saddr");
 		print_iprange_xlate(&info->src, xl);
+		space = " ";
 	}
 	if (info->flags & IPRANGE_DST) {
-		if (info->flags & IPRANGE_DST_INV)
-			xt_xlate_add(xl, "!= ");
-		xt_xlate_add(xl, "ip daddr");
+		if (info->flags & IPRANGE_DST_INV) {
+			xt_xlate_add(xl, "%s!= ", space);
+			space = "";
+		}
+		xt_xlate_add(xl, "%sip daddr", space);
 		print_iprange_xlate(&info->dst, xl);
 	}
 
@@ -340,21 +344,25 @@ static int iprange_mt4_xlate(const void *ip, const struct xt_entry_match *match,
 			     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_iprange_mtinfo *info = (const void *)match->data;
+	char *space = "";
 
 	if (info->flags & IPRANGE_SRC) {
 		if (info->flags & IPRANGE_SRC_INV)
 			xt_xlate_add(xl, "!= ");
 		xt_xlate_add(xl, "ip saddr %s",
 			   xtables_ipaddr_to_numeric(&info->src_min.in));
-		xt_xlate_add(xl, "-%s ",
+		xt_xlate_add(xl, "-%s",
 			   xtables_ipaddr_to_numeric(&info->src_max.in));
+		space = " ";
 	}
 	if (info->flags & IPRANGE_DST) {
-		if (info->flags & IPRANGE_DST_INV)
-			xt_xlate_add(xl, "!= ");
-		xt_xlate_add(xl, "ip daddr %s",
+		if (info->flags & IPRANGE_DST_INV) {
+			xt_xlate_add(xl, "%s!= ", space);
+			space = "";
+		}
+		xt_xlate_add(xl, "%sip daddr %s", space,
 			   xtables_ipaddr_to_numeric(&info->dst_min.in));
-		xt_xlate_add(xl, "-%s ",
+		xt_xlate_add(xl, "-%s",
 			   xtables_ipaddr_to_numeric(&info->dst_max.in));
 	}
 
@@ -365,21 +373,25 @@ static int iprange_mt6_xlate(const void *ip, const struct xt_entry_match *match,
 			     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_iprange_mtinfo *info = (const void *)match->data;
+	char *space = "";
 
 	if (info->flags & IPRANGE_SRC) {
 		if (info->flags & IPRANGE_SRC_INV)
 			xt_xlate_add(xl, "!= ");
 		xt_xlate_add(xl, "ip saddr %s",
 			   xtables_ip6addr_to_numeric(&info->src_min.in6));
-		xt_xlate_add(xl, "-%s ",
+		xt_xlate_add(xl, "-%s",
 			   xtables_ip6addr_to_numeric(&info->src_max.in6));
+		space = " ";
 	}
 	if (info->flags & IPRANGE_DST) {
-		if (info->flags & IPRANGE_DST_INV)
-			xt_xlate_add(xl, "!= ");
-		xt_xlate_add(xl, "ip daddr %s",
+		if (info->flags & IPRANGE_DST_INV) {
+			xt_xlate_add(xl, "%s!= ", space);
+			space = "";
+		}
+		xt_xlate_add(xl, "%sip daddr %s", space,
 			   xtables_ip6addr_to_numeric(&info->dst_min.in6));
-		xt_xlate_add(xl, "-%s ",
+		xt_xlate_add(xl, "-%s",
 			   xtables_ip6addr_to_numeric(&info->dst_max.in6));
 	}
 
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 1335b4e..feb1d2b 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -63,9 +63,9 @@ static int length_xlate(const void *ip, const struct xt_entry_match *match,
 
 	xt_xlate_add(xl, "meta length %s", info->invert ? "!= " : "");
 	if (info->min == info->max)
-		xt_xlate_add(xl, "%u ", info->min);
+		xt_xlate_add(xl, "%u", info->min);
 	else
-		xt_xlate_add(xl, "%u-%u ", info->min, info->max);
+		xt_xlate_add(xl, "%u-%u", info->min, info->max);
 
 	return 1;
 }
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 6652849..c82d4df 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -164,7 +164,7 @@ static void print_rate_xlate(uint32_t period, struct xt_xlate *xl)
 	unsigned int i;
 
 	if (period == 0) {
-		xt_xlate_add(xl, " %f ", INFINITY);
+		xt_xlate_add(xl, " %f", INFINITY);
 		return;
 	}
 
@@ -173,7 +173,7 @@ static void print_rate_xlate(uint32_t period, struct xt_xlate *xl)
 		    rates_xlate[i].mult / period < rates_xlate[i].mult % period)
 			break;
 
-	xt_xlate_add(xl, " %u/%s ", rates_xlate[i - 1].mult / period,
+	xt_xlate_add(xl, " %u/%s", rates_xlate[i - 1].mult / period,
 		   rates_xlate[i - 1].name);
 }
 
@@ -185,7 +185,7 @@ static int limit_xlate(const void *ip, const struct xt_entry_match *match,
 	xt_xlate_add(xl, "limit rate");
 	print_rate_xlate(r->avg, xl);
 	if (r->burst != 0)
-		xt_xlate_add(xl, "burst %u packets ", r->burst);
+		xt_xlate_add(xl, " burst %u packets", r->burst);
 
 	return 1;
 }
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index b416487..251134a 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -78,7 +78,6 @@ static void print_mac_xlate(const unsigned char *macaddress,
 	xt_xlate_add(xl, "%02x", macaddress[0]);
 	for (i = 1; i < ETH_ALEN; ++i)
 		xt_xlate_add(xl, ":%02x", macaddress[i]);
-	xt_xlate_add(xl, " ");
 }
 
 static int mac_xlate(const void *ip, const struct xt_entry_match *match,
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 6eccd5b..3711ec3 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -107,10 +107,10 @@ print_mark_xlate(struct xt_xlate *xl, unsigned int mark,
 		 unsigned int mask, uint32_t op)
 {
 	if (mask != 0xffffffffU)
-		xt_xlate_add(xl, " and 0x%x %s 0x%x ", mask,
+		xt_xlate_add(xl, " and 0x%x %s 0x%x", mask,
 			   op == XT_OP_EQ ? "==" : "!=", mark);
 	else
-		xt_xlate_add(xl, " %s0x%x ",
+		xt_xlate_add(xl, " %s0x%x",
 			   op == XT_OP_EQ ? "" : "!= ", mark);
 }
 
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index e420a0f..94b3f54 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -477,10 +477,10 @@ static int __multiport_xlate(const void *ip, const struct xt_entry_match *match,
 
 	switch (multiinfo->flags) {
 	case XT_MULTIPORT_SOURCE:
-		xt_xlate_add(xl, "sport ");
+		xt_xlate_add(xl, " sport ");
 		break;
 	case XT_MULTIPORT_DESTINATION:
-		xt_xlate_add(xl, "dport ");
+		xt_xlate_add(xl, " dport ");
 		break;
 	case XT_MULTIPORT_EITHER:
 		return 0;
@@ -495,8 +495,6 @@ static int __multiport_xlate(const void *ip, const struct xt_entry_match *match,
 	if (multiinfo->count > 1)
 		xt_xlate_add(xl, "}");
 
-	xt_xlate_add(xl, " ");
-
 	return 1;
 }
 
@@ -505,7 +503,7 @@ static int multiport_xlate(const void *ip, const struct xt_entry_match *match,
 {
 	uint8_t proto = ((const struct ipt_ip *)ip)->proto;
 
-	xt_xlate_add(xl, "%s ", proto_to_name(proto));
+	xt_xlate_add(xl, "%s", proto_to_name(proto));
 	return __multiport_xlate(ip, match, xl, numeric);
 }
 
@@ -514,7 +512,7 @@ static int multiport_xlate6(const void *ip, const struct xt_entry_match *match,
 {
 	uint8_t proto = ((const struct ip6t_ip6 *)ip)->proto;
 
-	xt_xlate_add(xl, "%s ", proto_to_name(proto));
+	xt_xlate_add(xl, "%s", proto_to_name(proto));
 	return __multiport_xlate(ip, match, xl, numeric);
 }
 
@@ -528,10 +526,10 @@ static int __multiport_xlate_v1(const void *ip,
 
 	switch (multiinfo->flags) {
 	case XT_MULTIPORT_SOURCE:
-		xt_xlate_add(xl, "sport ");
+		xt_xlate_add(xl, " sport ");
 		break;
 	case XT_MULTIPORT_DESTINATION:
-		xt_xlate_add(xl, "dport ");
+		xt_xlate_add(xl, " dport ");
 		break;
 	case XT_MULTIPORT_EITHER:
 		return 0;
@@ -554,8 +552,6 @@ static int __multiport_xlate_v1(const void *ip,
 	    (multiinfo->count > 1 && !multiinfo->pflags[0]))
 		xt_xlate_add(xl, "}");
 
-	xt_xlate_add(xl, " ");
-
 	return 1;
 }
 
@@ -565,7 +561,7 @@ static int multiport_xlate_v1(const void *ip,
 {
 	uint8_t proto = ((const struct ipt_ip *)ip)->proto;
 
-	xt_xlate_add(xl, "%s ", proto_to_name(proto));
+	xt_xlate_add(xl, "%s", proto_to_name(proto));
 	return __multiport_xlate_v1(ip, match, xl, numeric);
 }
 
@@ -575,7 +571,7 @@ static int multiport_xlate6_v1(const void *ip,
 {
 	uint8_t proto = ((const struct ip6t_ip6 *)ip)->proto;
 
-	xt_xlate_add(xl, "%s ", proto_to_name(proto));
+	xt_xlate_add(xl, "%s", proto_to_name(proto));
 	return __multiport_xlate_v1(ip, match, xl, numeric);
 }
 
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 1ee58ff..249ba5a 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -499,10 +499,10 @@ owner_mt_print_uid_xlate(const struct xt_owner_match_info *info,
 	xt_xlate_add(xl, "skuid%s ", info->invert ? " !=" : "");
 
 	if (info->uid_min != info->uid_max)
-		xt_xlate_add(xl, "%u-%u ", (unsigned int)info->uid_min,
+		xt_xlate_add(xl, "%u-%u", (unsigned int)info->uid_min,
 			     (unsigned int)info->uid_max);
 	else
-		xt_xlate_add(xl, "%u ", (unsigned int)info->uid_min);
+		xt_xlate_add(xl, "%u", (unsigned int)info->uid_min);
 
 	return 1;
 }
@@ -514,10 +514,10 @@ owner_mt_print_gid_xlate(const struct xt_owner_match_info *info,
 	xt_xlate_add(xl, "skgid%s ", info->invert ? " !=" : "");
 
 	if (info->gid_min != info->gid_max)
-		xt_xlate_add(xl, "%u-%u ", (unsigned int)info->gid_min,
+		xt_xlate_add(xl, "%u-%u", (unsigned int)info->gid_min,
 			     (unsigned int)info->gid_max);
 	else
-		xt_xlate_add(xl, "%u ", (unsigned int)info->gid_min);
+		xt_xlate_add(xl, "%u", (unsigned int)info->gid_min);
 
 	return 1;
 }
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index c8123a2..a14409d 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -133,7 +133,7 @@ static void print_pkttype_xlate(const struct xt_pkttype_info *info,
 
 	for (i = 0; i < ARRAY_SIZE(supported_types_xlate); ++i) {
 		if (supported_types_xlate[i].pkttype == info->pkttype) {
-			xt_xlate_add(xl, "%s ", supported_types_xlate[i].name);
+			xt_xlate_add(xl, "%s", supported_types_xlate[i].name);
 			return;
 		}
 	}
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index ae1969a..a04b4fc 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -490,6 +490,7 @@ static int sctp_xlate(const void *ip, const struct xt_entry_match *match,
 {
 	const struct xt_sctp_info *einfo =
 		(const struct xt_sctp_info *)match->data;
+	char *space = "";
 
 	if (!einfo->flags)
 		return 0;
@@ -498,22 +499,23 @@ static int sctp_xlate(const void *ip, const struct xt_entry_match *match,
 
 	if (einfo->flags & XT_SCTP_SRC_PORTS) {
 		if (einfo->spts[0] != einfo->spts[1])
-			xt_xlate_add(xl, "sport%s %u-%u ",
+			xt_xlate_add(xl, "sport%s %u-%u",
 				     einfo->invflags & XT_SCTP_SRC_PORTS ? " !=" : "",
 				     einfo->spts[0], einfo->spts[1]);
 		else
-			xt_xlate_add(xl, "sport%s %u ",
+			xt_xlate_add(xl, "sport%s %u",
 				     einfo->invflags & XT_SCTP_SRC_PORTS ? " !=" : "",
 				     einfo->spts[0]);
+		space = " ";
 	}
 
 	if (einfo->flags & XT_SCTP_DEST_PORTS) {
 		if (einfo->dpts[0] != einfo->dpts[1])
-			xt_xlate_add(xl, "dport%s %u-%u ",
+			xt_xlate_add(xl, "%sdport%s %u-%u", space,
 				     einfo->invflags & XT_SCTP_DEST_PORTS ? " !=" : "",
 				     einfo->dpts[0], einfo->dpts[1]);
 		else
-			xt_xlate_add(xl, "dport%s %u ",
+			xt_xlate_add(xl, "%sdport%s %u", space,
 				     einfo->invflags & XT_SCTP_DEST_PORTS ? " !=" : "",
 				     einfo->dpts[0]);
 	}
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 2a14035..bc1d0af 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -397,33 +397,36 @@ static int tcp_xlate(const void *ip, const struct xt_entry_match *match,
 		     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_tcp *tcpinfo = (const struct xt_tcp *)match->data;
+	char *space= "";
 
 	if (tcpinfo->spts[0] != 0 || tcpinfo->spts[1] != 0xffff) {
 		if (tcpinfo->spts[0] != tcpinfo->spts[1]) {
-			xt_xlate_add(xl, "tcp sport %s%u-%u ",
+			xt_xlate_add(xl, "tcp sport %s%u-%u",
 				   tcpinfo->invflags & XT_TCP_INV_SRCPT ?
 					"!= " : "",
 				   tcpinfo->spts[0], tcpinfo->spts[1]);
 		} else {
-			xt_xlate_add(xl, "tcp sport %s%u ",
+			xt_xlate_add(xl, "tcp sport %s%u",
 				   tcpinfo->invflags & XT_TCP_INV_SRCPT ?
 					"!= " : "",
 				   tcpinfo->spts[0]);
 		}
+		space = " ";
 	}
 
 	if (tcpinfo->dpts[0] != 0 || tcpinfo->dpts[1] != 0xffff) {
 		if (tcpinfo->dpts[0] != tcpinfo->dpts[1]) {
-			xt_xlate_add(xl, "tcp dport %s%u-%u ",
+			xt_xlate_add(xl, "%stcp dport %s%u-%u", space,
 				   tcpinfo->invflags & XT_TCP_INV_DSTPT ?
 					"!= " : "",
 				   tcpinfo->dpts[0], tcpinfo->dpts[1]);
 		} else {
-			xt_xlate_add(xl, "tcp dport %s%u ",
+			xt_xlate_add(xl, "%stcp dport %s%u", space,
 				   tcpinfo->invflags & XT_TCP_INV_DSTPT ?
 					"!= " : "",
 				   tcpinfo->dpts[0]);
 		}
+		space = " ";
 	}
 
 	/* XXX not yet implemented */
@@ -431,12 +434,11 @@ static int tcp_xlate(const void *ip, const struct xt_entry_match *match,
 		return 0;
 
 	if (tcpinfo->flg_mask || (tcpinfo->invflags & XT_TCP_INV_FLAGS)) {
-		xt_xlate_add(xl, "tcp flags & ");
+		xt_xlate_add(xl, "%stcp flags & ", space);
 		print_tcp_xlate(xl, tcpinfo->flg_mask);
 		xt_xlate_add(xl, " %s ",
 			   tcpinfo->invflags & XT_TCP_INV_FLAGS ? "!=": "==");
 		print_tcp_xlate(xl, tcpinfo->flg_cmp);
-		xt_xlate_add(xl, " ");
 	}
 
 	return 1;
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 9af782e..d8e286a 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -156,29 +156,31 @@ static int udp_xlate(const void *ip, const struct xt_entry_match *match,
 		     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_udp *udpinfo = (struct xt_udp *)match->data;
+	char *space= "";
 
 	if (udpinfo->spts[0] != 0 || udpinfo->spts[1] != 0xFFFF) {
 		if (udpinfo->spts[0] != udpinfo->spts[1]) {
-			xt_xlate_add(xl,"udp sport %s%u-%u ",
+			xt_xlate_add(xl,"udp sport %s%u-%u",
 				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
 					 "!= ": "",
 				   udpinfo->spts[0], udpinfo->spts[1]);
 		} else {
-			xt_xlate_add(xl, "udp sport %s%u ",
+			xt_xlate_add(xl, "udp sport %s%u",
 				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
 					 "!= ": "",
 				   udpinfo->spts[0]);
 		}
+		space = " ";
 	}
 
 	if (udpinfo->dpts[0] != 0 || udpinfo->dpts[1] != 0xFFFF) {
 		if (udpinfo->dpts[0]  != udpinfo->dpts[1]) {
-			xt_xlate_add(xl,"udp dport %s%u-%u ",
+			xt_xlate_add(xl,"%sudp dport %s%u-%u", space,
 				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
 					 "!= ": "",
 				   udpinfo->dpts[0], udpinfo->dpts[1]);
 		} else {
-			xt_xlate_add(xl,"udp dport %s%u ",
+			xt_xlate_add(xl,"%sudp dport %s%u", space,
 				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
 					 "!= ": "",
 				   udpinfo->dpts[0]);
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 3f3a3c7..71f1356 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -75,6 +75,10 @@ int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl)
 
 		ret = matchp->match->xlate((const void *)&cs->fw,
 					   matchp->match->m, xl, numeric);
+
+		if (strcmp(matchp->match->name, "comment") != 0)
+			xt_xlate_add(xl, " ");
+
 		if (!ret)
 			break;
 	}
-- 
2.9.0

