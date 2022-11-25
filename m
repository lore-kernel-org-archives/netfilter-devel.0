Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EB4C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Nov 2022 16:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiKYQMy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Nov 2022 11:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiKYQMw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Nov 2022 11:12:52 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13F911C3C
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Nov 2022 08:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5b4XT65QpOUrOI5PgSgC3L49LtQS/mQU8Ns6KVzCdLM=; b=lKdlUeCLBwi8jmSm69Tof7tzcr
        U/hIgltBCy/tCIe+jG1a1DasNHDP0cxtAqDi1Hz6QmtXj4NuEUrHe8hcMVScFRoZUDpsfqyL96sBo
        +UK/leUUdnvthuviYymhPI7pJBrkpy1MWRnpFQ+O7Nwjr52mr0T9H0TviLp5DTJaRbmVA3vDY1vN2
        ElWk2MlIRRfjAV9XRwBAGfsf9+0YXGikZWiSfxC4wEvRBVaM2R8hL8XmtuTunJH6lMD78MIZdH6i/
        3XDgO/T7dWpBZa41bwendVGpghhvAdRwHywtEBbxOtsIDmrmXeBPDHvvt6S8TNh6pnb0xeGyc9bvT
        j+wMDyyg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oybJp-0006ZS-3J; Fri, 25 Nov 2022 17:12:49 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 2/4] extensions: Leverage xlate auto-spacing
Date:   Fri, 25 Nov 2022 17:12:27 +0100
Message-Id: <20221125161229.18406-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221125161229.18406-1-phil@nwl.cc>
References: <20221125161229.18406-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Drop code which is used explicitly to deal with spacing.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_frag.c    | 28 +++++++++++-----------------
 extensions/libip6t_rt.c      |  7 ++-----
 extensions/libxt_dccp.c      | 11 ++---------
 extensions/libxt_devgroup.c  |  4 +---
 extensions/libxt_iprange.c   | 12 +++---------
 extensions/libxt_sctp.c      | 32 +++++++++++++-------------------
 extensions/libxt_tcp.c       | 15 +++++----------
 extensions/libxt_time.txlate |  6 +++---
 extensions/libxt_udp.c       |  6 ++----
 iptables/nft-bridge.c        |  3 ---
 iptables/xtables-translate.c |  5 -----
 11 files changed, 42 insertions(+), 87 deletions(-)

diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 72a43153c53dc..49c787e709a9e 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -178,7 +178,6 @@ static int frag_xlate(struct xt_xlate *xl,
 {
 	const struct ip6t_frag *fraginfo =
 		(struct ip6t_frag *)params->match->data;
-	char *space= "";
 
 	if (!(fraginfo->ids[0] == 0 && fraginfo->ids[1] == 0xFFFFFFFF)) {
 		xt_xlate_add(xl, "frag id %s",
@@ -190,26 +189,21 @@ static int frag_xlate(struct xt_xlate *xl,
 		else
 			xt_xlate_add(xl, "%u", fraginfo->ids[0]);
 
-		space = " ";
 	}
 
 	/* ignore ineffective IP6T_FRAG_LEN bit */
 
-	if (fraginfo->flags & IP6T_FRAG_RES) {
-		xt_xlate_add(xl, "%sfrag reserved 1", space);
-		space = " ";
-	}
-	if (fraginfo->flags & IP6T_FRAG_FST) {
-		xt_xlate_add(xl, "%sfrag frag-off 0", space);
-		space = " ";
-	}
-	if (fraginfo->flags & IP6T_FRAG_MF) {
-		xt_xlate_add(xl, "%sfrag more-fragments 1", space);
-		space = " ";
-	}
-	if (fraginfo->flags & IP6T_FRAG_NMF) {
-		xt_xlate_add(xl, "%sfrag more-fragments 0", space);
-	}
+	if (fraginfo->flags & IP6T_FRAG_RES)
+		xt_xlate_add(xl, "frag reserved 1");
+
+	if (fraginfo->flags & IP6T_FRAG_FST)
+		xt_xlate_add(xl, "frag frag-off 0");
+
+	if (fraginfo->flags & IP6T_FRAG_MF)
+		xt_xlate_add(xl, "frag more-fragments 1");
+
+	if (fraginfo->flags & IP6T_FRAG_NMF)
+		xt_xlate_add(xl, "frag more-fragments 0");
 
 	return 1;
 }
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 9708b5a0c42f3..d5b0458bb397e 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -248,17 +248,15 @@ static int rt_xlate(struct xt_xlate *xl,
 		    const struct xt_xlate_mt_params *params)
 {
 	const struct ip6t_rt *rtinfo = (struct ip6t_rt *)params->match->data;
-	char *space = "";
 
 	if (rtinfo->flags & IP6T_RT_TYP) {
 		xt_xlate_add(xl, "rt type%s %u",
 			     (rtinfo->invflags & IP6T_RT_INV_TYP) ? " !=" : "",
 			      rtinfo->rt_type);
-		space = " ";
 	}
 
 	if (!(rtinfo->segsleft[0] == 0 && rtinfo->segsleft[1] == 0xFFFFFFFF)) {
-		xt_xlate_add(xl, "%srt seg-left%s ", space,
+		xt_xlate_add(xl, "rt seg-left%s ",
 			     (rtinfo->invflags & IP6T_RT_INV_SGS) ? " !=" : "");
 
 		if (rtinfo->segsleft[0] != rtinfo->segsleft[1])
@@ -266,11 +264,10 @@ static int rt_xlate(struct xt_xlate *xl,
 					rtinfo->segsleft[1]);
 		else
 			xt_xlate_add(xl, "%u", rtinfo->segsleft[0]);
-		space = " ";
 	}
 
 	if (rtinfo->flags & IP6T_RT_LEN) {
-		xt_xlate_add(xl, "%srt hdrlength%s %u", space,
+		xt_xlate_add(xl, "rt hdrlength%s %u",
 			     (rtinfo->invflags & IP6T_RT_INV_LEN) ? " !=" : "",
 			      rtinfo->hdrlen);
 	}
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index abd420fcc0032..bfceced3f79de 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -343,7 +343,6 @@ static int dccp_xlate(struct xt_xlate *xl,
 {
 	const struct xt_dccp_info *einfo =
 		(const struct xt_dccp_info *)params->match->data;
-	char *space = "";
 	int ret = 1;
 
 	if (einfo->flags & XT_DCCP_SRC_PORTS) {
@@ -353,27 +352,21 @@ static int dccp_xlate(struct xt_xlate *xl,
 
 		if (einfo->spts[0] != einfo->spts[1])
 			xt_xlate_add(xl, "-%u", einfo->spts[1]);
-
-		space = " ";
 	}
 
 	if (einfo->flags & XT_DCCP_DEST_PORTS) {
-		xt_xlate_add(xl, "%sdccp dport%s %u", space,
+		xt_xlate_add(xl, "dccp dport%s %u",
 			     einfo->invflags & XT_DCCP_DEST_PORTS ? " !=" : "",
 			     einfo->dpts[0]);
 
 		if (einfo->dpts[0] != einfo->dpts[1])
 			xt_xlate_add(xl, "-%u", einfo->dpts[1]);
-
-		space = " ";
 	}
 
 	if (einfo->flags & XT_DCCP_TYPE && einfo->typemask) {
-		xt_xlate_add(xl, "%sdccp type%s ", space,
+		xt_xlate_add(xl, "dccp type%s ",
 			     einfo->invflags & XT_DCCP_TYPE ? " !=" : "");
 		ret = dccp_type_xlate(einfo, xl);
-
-		space = " ";
 	}
 
 	/* FIXME: no dccp option support in nftables yet */
diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index a88211c5090d8..f60526ffded98 100644
--- a/extensions/libxt_devgroup.c
+++ b/extensions/libxt_devgroup.c
@@ -129,7 +129,6 @@ static void devgroup_show_xlate(const struct xt_devgroup_info *info,
 				struct xt_xlate *xl, int numeric)
 {
 	enum xt_op op = XT_OP_EQ;
-	char *space = "";
 
 	if (info->flags & XT_DEVGROUP_MATCH_SRC) {
 		if (info->flags & XT_DEVGROUP_INVERT_SRC)
@@ -137,13 +136,12 @@ static void devgroup_show_xlate(const struct xt_devgroup_info *info,
 		xt_xlate_add(xl, "iifgroup ");
 		print_devgroup_xlate(info->src_group, op,
 				     info->src_mask, xl, numeric);
-		space = " ";
 	}
 
 	if (info->flags & XT_DEVGROUP_MATCH_DST) {
 		if (info->flags & XT_DEVGROUP_INVERT_DST)
 			op = XT_OP_NEQ;
-		xt_xlate_add(xl, "%soifgroup ", space);
+		xt_xlate_add(xl, "oifgroup ");
 		print_devgroup_xlate(info->dst_group, op,
 				     info->dst_mask, xl, numeric);
 	}
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 04ce7b364f1c6..0df709d5462f1 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -317,16 +317,14 @@ static int iprange_xlate(struct xt_xlate *xl,
 			 const struct xt_xlate_mt_params *params)
 {
 	const struct ipt_iprange_info *info = (const void *)params->match->data;
-	char *space = "";
 
 	if (info->flags & IPRANGE_SRC) {
 		xt_xlate_add(xl, "ip saddr%s",
 			     info->flags & IPRANGE_SRC_INV ? " !=" : "");
 		print_iprange_xlate(&info->src, xl);
-		space = " ";
 	}
 	if (info->flags & IPRANGE_DST) {
-		xt_xlate_add(xl, "%sip daddr%s", space,
+		xt_xlate_add(xl, "ip daddr%s",
 			     info->flags & IPRANGE_DST_INV ? " !=" : "");
 		print_iprange_xlate(&info->dst, xl);
 	}
@@ -339,7 +337,6 @@ static int iprange_mt4_xlate(struct xt_xlate *xl,
 {
 	const struct xt_iprange_mtinfo *info =
 		(const void *)params->match->data;
-	char *space = "";
 
 	if (info->flags & IPRANGE_SRC) {
 		xt_xlate_add(xl, "ip saddr%s %s",
@@ -347,10 +344,9 @@ static int iprange_mt4_xlate(struct xt_xlate *xl,
 			     xtables_ipaddr_to_numeric(&info->src_min.in));
 		xt_xlate_add(xl, "-%s",
 			     xtables_ipaddr_to_numeric(&info->src_max.in));
-		space = " ";
 	}
 	if (info->flags & IPRANGE_DST) {
-		xt_xlate_add(xl, "%sip daddr%s %s", space,
+		xt_xlate_add(xl, "ip daddr%s %s",
 			     info->flags & IPRANGE_DST_INV ? " !=" : "",
 			     xtables_ipaddr_to_numeric(&info->dst_min.in));
 		xt_xlate_add(xl, "-%s",
@@ -365,7 +361,6 @@ static int iprange_mt6_xlate(struct xt_xlate *xl,
 {
 	const struct xt_iprange_mtinfo *info =
 		(const void *)params->match->data;
-	char *space = "";
 
 	if (info->flags & IPRANGE_SRC) {
 		xt_xlate_add(xl, "ip6 saddr%s %s",
@@ -373,10 +368,9 @@ static int iprange_mt6_xlate(struct xt_xlate *xl,
 			     xtables_ip6addr_to_numeric(&info->src_min.in6));
 		xt_xlate_add(xl, "-%s",
 			     xtables_ip6addr_to_numeric(&info->src_max.in6));
-		space = " ";
 	}
 	if (info->flags & IPRANGE_DST) {
-		xt_xlate_add(xl, "%sip6 daddr%s %s", space,
+		xt_xlate_add(xl, "ip6 daddr%s %s",
 			     info->flags & IPRANGE_DST_INV ? " !=" : "",
 			     xtables_ip6addr_to_numeric(&info->dst_min.in6));
 		xt_xlate_add(xl, "-%s",
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 8f069a43e7b71..fe5f5621a033d 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -489,24 +489,24 @@ static void sctp_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
-static const char *sctp_xlate_chunk(struct xt_xlate *xl, const char *space,
-				    const struct xt_sctp_info *einfo,
-				    const struct sctp_chunk_names *scn)
+static void sctp_xlate_chunk(struct xt_xlate *xl,
+			     const struct xt_sctp_info *einfo,
+			     const struct sctp_chunk_names *scn)
 {
 	bool inv = einfo->invflags & XT_SCTP_CHUNK_TYPES;
 	const struct xt_sctp_flag_info *flag_info = NULL;
 	int i;
 
 	if (!scn->nftname)
-		return space;
+		return;
 
 	if (!SCTP_CHUNKMAP_IS_SET(einfo->chunkmap, scn->chunk_type)) {
 		if (einfo->chunk_match_type != SCTP_CHUNK_MATCH_ONLY)
-			return space;
+			return;
 
-		xt_xlate_add(xl, "%ssctp chunk %s %s", space,
+		xt_xlate_add(xl, "sctp chunk %s %s",
 			     scn->nftname, inv ? "exists" : "missing");
-		return " ";
+		return;
 	}
 
 	for (i = 0; i < einfo->flag_count; i++) {
@@ -517,16 +517,14 @@ static const char *sctp_xlate_chunk(struct xt_xlate *xl, const char *space,
 	}
 
 	if (!flag_info) {
-		xt_xlate_add(xl, "%ssctp chunk %s %s", space,
+		xt_xlate_add(xl, "sctp chunk %s %s",
 			     scn->nftname, inv ? "missing" : "exists");
-		return " ";
+		return;
 	}
 
-	xt_xlate_add(xl, "%ssctp chunk %s flags & 0x%x %s 0x%x", space,
+	xt_xlate_add(xl, "sctp chunk %s flags & 0x%x %s 0x%x",
 		     scn->nftname, flag_info->flag_mask,
 		     inv ? "!=" : "==", flag_info->flag);
-
-	return " ";
 }
 
 static int sctp_xlate(struct xt_xlate *xl,
@@ -534,7 +532,6 @@ static int sctp_xlate(struct xt_xlate *xl,
 {
 	const struct xt_sctp_info *einfo =
 		(const struct xt_sctp_info *)params->match->data;
-	const char *space = "";
 
 	if (!einfo->flags)
 		return 0;
@@ -548,19 +545,17 @@ static int sctp_xlate(struct xt_xlate *xl,
 			xt_xlate_add(xl, "sctp sport%s %u",
 				     einfo->invflags & XT_SCTP_SRC_PORTS ? " !=" : "",
 				     einfo->spts[0]);
-		space = " ";
 	}
 
 	if (einfo->flags & XT_SCTP_DEST_PORTS) {
 		if (einfo->dpts[0] != einfo->dpts[1])
-			xt_xlate_add(xl, "%ssctp dport%s %u-%u", space,
+			xt_xlate_add(xl, "sctp dport%s %u-%u",
 				     einfo->invflags & XT_SCTP_DEST_PORTS ? " !=" : "",
 				     einfo->dpts[0], einfo->dpts[1]);
 		else
-			xt_xlate_add(xl, "%ssctp dport%s %u", space,
+			xt_xlate_add(xl, "sctp dport%s %u",
 				     einfo->invflags & XT_SCTP_DEST_PORTS ? " !=" : "",
 				     einfo->dpts[0]);
-		space = " ";
 	}
 
 	if (einfo->flags & XT_SCTP_CHUNK_TYPES) {
@@ -570,8 +565,7 @@ static int sctp_xlate(struct xt_xlate *xl,
 			return 0;
 
 		for (i = 0; i < ARRAY_SIZE(sctp_chunk_names); i++)
-			space = sctp_xlate_chunk(xl, space, einfo,
-						 &sctp_chunk_names[i]);
+			sctp_xlate_chunk(xl, einfo, &sctp_chunk_names[i]);
 	}
 
 	return 1;
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 2ef842990a4e8..f82572828649b 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -397,7 +397,6 @@ static int tcp_xlate(struct xt_xlate *xl,
 {
 	const struct xt_tcp *tcpinfo =
 		(const struct xt_tcp *)params->match->data;
-	char *space= "";
 
 	if (tcpinfo->spts[0] != 0 || tcpinfo->spts[1] != 0xffff) {
 		if (tcpinfo->spts[0] != tcpinfo->spts[1]) {
@@ -411,33 +410,29 @@ static int tcp_xlate(struct xt_xlate *xl,
 					"!= " : "",
 				   tcpinfo->spts[0]);
 		}
-		space = " ";
 	}
 
 	if (tcpinfo->dpts[0] != 0 || tcpinfo->dpts[1] != 0xffff) {
 		if (tcpinfo->dpts[0] != tcpinfo->dpts[1]) {
-			xt_xlate_add(xl, "%stcp dport %s%u-%u", space,
+			xt_xlate_add(xl, "tcp dport %s%u-%u",
 				   tcpinfo->invflags & XT_TCP_INV_DSTPT ?
 					"!= " : "",
 				   tcpinfo->dpts[0], tcpinfo->dpts[1]);
 		} else {
-			xt_xlate_add(xl, "%stcp dport %s%u", space,
+			xt_xlate_add(xl, "tcp dport %s%u",
 				   tcpinfo->invflags & XT_TCP_INV_DSTPT ?
 					"!= " : "",
 				   tcpinfo->dpts[0]);
 		}
-		space = " ";
 	}
 
-	if (tcpinfo->option) {
-		xt_xlate_add(xl, "%stcp option %u %s", space, tcpinfo->option,
+	if (tcpinfo->option)
+		xt_xlate_add(xl, "tcp option %u %s", tcpinfo->option,
 			     tcpinfo->invflags & XT_TCP_INV_OPTION ?
 			     "missing" : "exists");
-		space = " ";
-	}
 
 	if (tcpinfo->flg_mask || (tcpinfo->invflags & XT_TCP_INV_FLAGS)) {
-		xt_xlate_add(xl, "%stcp flags %s", space,
+		xt_xlate_add(xl, "tcp flags %s",
 			     tcpinfo->invflags & XT_TCP_INV_FLAGS ? "!= ": "");
 		print_tcp_xlate(xl, tcpinfo->flg_cmp);
 		xt_xlate_add(xl, " / ");
diff --git a/extensions/libxt_time.txlate b/extensions/libxt_time.txlate
index 2083ab94f4c24..6aea2aed5fa22 100644
--- a/extensions/libxt_time.txlate
+++ b/extensions/libxt_time.txlate
@@ -1,11 +1,11 @@
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --weekdays Sa,Su -j REJECT
-nft add rule ip filter INPUT icmp type echo-request  meta day { 6,0 } counter reject
+nft add rule ip filter INPUT icmp type echo-request meta day { 6,0 } counter reject
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --timestart 12:00 -j REJECT
-nft add rule ip filter INPUT icmp type echo-request  meta hour "12:00:00"-"23:59:59" counter reject
+nft add rule ip filter INPUT icmp type echo-request meta hour "12:00:00"-"23:59:59" counter reject
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --timestop 12:00 -j REJECT
-nft add rule ip filter INPUT icmp type echo-request  meta hour "00:00:00"-"12:00:00" counter reject
+nft add rule ip filter INPUT icmp type echo-request meta hour "00:00:00"-"12:00:00" counter reject
 
 iptables-translate -A INPUT -p icmp --icmp-type echo-request -m time --datestart 2021 -j REJECT
 nft add rule ip filter INPUT icmp type echo-request meta time "2021-01-01 00:00:00"-"2038-01-19 03:14:07" counter reject
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 0c7a4bc221993..ba1c3eb768592 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -156,7 +156,6 @@ static int udp_xlate(struct xt_xlate *xl,
 		     const struct xt_xlate_mt_params *params)
 {
 	const struct xt_udp *udpinfo = (struct xt_udp *)params->match->data;
-	char *space= "";
 
 	if (udpinfo->spts[0] != 0 || udpinfo->spts[1] != 0xFFFF) {
 		if (udpinfo->spts[0] != udpinfo->spts[1]) {
@@ -170,17 +169,16 @@ static int udp_xlate(struct xt_xlate *xl,
 					 "!= ": "",
 				   udpinfo->spts[0]);
 		}
-		space = " ";
 	}
 
 	if (udpinfo->dpts[0] != 0 || udpinfo->dpts[1] != 0xFFFF) {
 		if (udpinfo->dpts[0]  != udpinfo->dpts[1]) {
-			xt_xlate_add(xl,"%sudp dport %s%u-%u", space,
+			xt_xlate_add(xl,"udp dport %s%u-%u",
 				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
 					 "!= ": "",
 				   udpinfo->dpts[0], udpinfo->dpts[1]);
 		} else {
-			xt_xlate_add(xl,"%sudp dport %s%u", space,
+			xt_xlate_add(xl,"udp dport %s%u",
 				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
 					 "!= ": "",
 				   udpinfo->dpts[0]);
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 4367d072906df..3180091364fa2 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -830,7 +830,6 @@ static int xlate_ebaction(const struct iptables_command_state *cs, struct xt_xla
 		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
 			xt_xlate_add(xl, " return");
 		else if (cs->target->xlate) {
-			xt_xlate_add(xl, " ");
 			struct xt_xlate_tg_params params = {
 				.ip		= (const void *)&cs->eb,
 				.target		= cs->target->t,
@@ -876,8 +875,6 @@ static void nft_bridge_xlate_mac(struct xt_xlate *xl, const char *type, bool inv
 		for (i=1; i < ETH_ALEN; i++)
 			xt_xlate_add(xl, ":%02x", mac[i] & mask[i]);
 	}
-
-	xt_xlate_add(xl, " ");
 }
 
 static int nft_bridge_xlate(const struct iptables_command_state *cs,
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index d1e87f167df74..4e8db4bedff88 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -83,7 +83,6 @@ int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
 			xt_xlate_add(xl, " return");
 		else if (cs->target->xlate) {
-			xt_xlate_add(xl, " ");
 			struct xt_xlate_tg_params params = {
 				.ip		= (const void *)&cs->fw,
 				.target		= cs->target->t,
@@ -122,10 +121,6 @@ int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl)
 			return 0;
 
 		ret = matchp->match->xlate(xl, &params);
-
-		if (strcmp(matchp->match->name, "comment") != 0)
-			xt_xlate_add(xl, " ");
-
 		if (!ret)
 			break;
 	}
-- 
2.38.0

