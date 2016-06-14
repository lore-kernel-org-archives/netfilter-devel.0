From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] extensions: libxt_conntrack: Add translation to nft
Date: Tue, 14 Jun 2016 20:02:45 +0200
Message-ID: <20160614180242.GA26384@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33476 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbcFNSCu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 14:02:50 -0400
Received: by mail-wm0-f66.google.com with SMTP id r5so373618wmr.0
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 11:02:49 -0700 (PDT)
Received: from sonyv ([195.235.183.163])
        by smtp.gmail.com with ESMTPSA id ue1sm13290622wjc.44.2016.06.14.11.02.47
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 14 Jun 2016 11:02:48 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation of conntrack to nftables.

Examples:

$ sudo iptables-translate -t filter -A INPUT -m conntrack --ctstate NEW,RELATED -j ACCEPT
nft add rule ip filter INPUT ct state { new,related } counter accept

$ sudo ip6tables-translate -t filter -A INPUT -m conntrack ! --ctstate NEW,RELATED -j ACCEPT
nft add rule ip6 filter INPUT ct state != { new,related } counter accept

$ sudo iptables-translate -t filter -A INPUT -m conntrack --ctproto UDP -j ACCEPT
nft add rule ip filter INPUT ct proto 17 counter accept

$ sudo iptables-translate -t filter -A INPUT -m conntrack ! --ctproto UDP -j ACCEPT
nft add rule ip filter INPUT ct proto != 17 counter accept

$ sudo iptables-translate -t filter -A INPUT -m conntrack --ctorigsrc 10.100.2.131 -j ACCEPT
nft add rule ip filter INPUT ct original saddr 10.100.2.131 counter accept

$ sudo iptables-translate -t filter -A INPUT -m conntrack --ctorigsrc 10.100.0.0/255.255.0.0 -j ACCEPT
nft add rule ip filter INPUT ct original saddr 10.100.0.0/16 counter accept

$ sudo iptables-translate -t filter -A INPUT -m conntrack --ctorigdst 10.100.2.131 -j ACCEPT
nft add rule ip filter INPUT ct original daddr 10.100.2.131 counter accept

$ sudo iptables-translate -t filter -A INPUT -m conntrack --ctreplsrc 10.100.2.131 -j ACCEPT
nft add rule ip filter INPUT ct reply saddr 10.100.2.131 counter accept

$ sudo iptables-translate -t filter -A INPUT -m conntrack --ctrepldst 10.100.2.131 -j ACCEPT
nft add rule ip filter INPUT ct reply daddr 10.100.2.131 counter accept

$ sudo iptables-translate -t filter -A INPUT -m conntrack --ctproto tcp --ctorigsrcport 443:444 -j ACCEPT
nft add rule ip filter INPUT ct original protocol 6 ct original proto-src 443-444 counter accept

$ sudo iptables-translate -t filter -A INPUT -m conntrack ! --ctstatus CONFIRMED -j ACCEPT
nft add rule ip filter INPUT ct status != confirmed counter accept

$ sudo iptables-translate -t filter -A INPUT -m conntrack --ctexpire 3 -j ACCEPT
nft add rule ip filter INPUT ct expiration 3 counter accept

$ sudo iptables-translate -t filter -A INPUT -m conntrack --ctdir ORIGINAL -j ACCEPT
nft add rule ip filter INPUT ct direction original counter accept

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 extensions/libxt_conntrack.c | 247 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 247 insertions(+)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 310a468..cf6c03d 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1182,6 +1182,28 @@ static void state_xlate_print(struct xt_xlate *xl, unsigned int statemask)
 	}
 }
 
+static int state_xlate_counter(unsigned int statemask)
+{
+	int bcounter = 0;
+
+	if (statemask & XT_CONNTRACK_STATE_INVALID)
+		bcounter++;
+
+	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_NEW))
+		bcounter++;
+
+	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_RELATED))
+		bcounter++;
+
+	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_ESTABLISHED))
+		bcounter++;
+
+	if (statemask & XT_CONNTRACK_STATE_UNTRACKED)
+		bcounter++;
+
+	return bcounter;
+}
+
 static int state_xlate(const void *ip, const struct xt_entry_match *match,
 		       struct xt_xlate *xl, int numeric)
 {
@@ -1194,6 +1216,229 @@ static int state_xlate(const void *ip, const struct xt_entry_match *match,
 	return 1;
 }
 
+static void status_xlate_print(struct xt_xlate *xl, unsigned int statusmask)
+{
+	const char *sep = "";
+
+	if (statusmask & IPS_EXPECTED) {
+		xt_xlate_add(xl, "%s%s", sep, "expected");
+		sep = ",";
+	}
+	if (statusmask & IPS_SEEN_REPLY) {
+		xt_xlate_add(xl, "%s%s", sep, "seen-reply");
+		sep = ",";
+	}
+	if (statusmask & IPS_ASSURED) {
+		xt_xlate_add(xl, "%s%s", sep, "assured");
+		sep = ",";
+	}
+	if (statusmask & IPS_CONFIRMED) {
+		xt_xlate_add(xl, "%s%s", sep, "confirmed");
+		sep = ",";
+	}
+}
+
+static int status_xlate_counter(unsigned int statusmask)
+{
+	int bcounter = 0;
+
+	if (statusmask & IPS_EXPECTED)
+		bcounter++;
+
+	if (statusmask & IPS_SEEN_REPLY)
+		bcounter++;
+
+	if (statusmask & IPS_ASSURED)
+		bcounter++;
+
+	if (statusmask & IPS_CONFIRMED)
+		bcounter++;
+
+	return bcounter;
+}
+
+static void addr_xlate_print(struct xt_xlate *xl,
+			     const union nf_inet_addr *addr,
+			     const union nf_inet_addr *mask,
+			     unsigned int family)
+{
+	if (family == NFPROTO_IPV4) {
+		xt_xlate_add(xl, "%s%s", xtables_ipaddr_to_numeric(&addr->in),
+		     xtables_ipmask_to_numeric(&mask->in));
+	} else if (family == NFPROTO_IPV6) {
+		xt_xlate_add(xl, "%s%s", xtables_ip6addr_to_numeric(&addr->in6),
+		     xtables_ip6mask_to_numeric(&mask->in6));
+	}
+}
+
+static int _conntrack3_mt_xlate(const void *ip,
+				const struct xt_entry_match *match,
+				struct xt_xlate *xl, int numeric,
+				int family)
+{
+	const struct xt_conntrack_mtinfo3 *sinfo = (const void *)match->data;
+	int counter;
+
+	if (sinfo->match_flags & XT_CONNTRACK_DIRECTION)
+		xt_xlate_add(xl, "ct direction %s ",
+			     sinfo->invert_flags & XT_CONNTRACK_DIRECTION ?
+			     "reply" : "original");
+
+	if (sinfo->match_flags & XT_CONNTRACK_PROTO)
+		xt_xlate_add(xl, "ct %s protocol %s%u ",
+			     sinfo->invert_flags & XT_CONNTRACK_DIRECTION ?
+			     "reply" : "original",
+			     sinfo->invert_flags & XT_CONNTRACK_PROTO ?
+			     "!= " : "",
+			     sinfo->l4proto);
+
+	if (sinfo->match_flags & XT_CONNTRACK_STATE) {
+		counter = state_xlate_counter(sinfo->state_mask);
+		xt_xlate_add(xl, "ct state %s%s",
+			     sinfo->invert_flags & XT_CONNTRACK_STATE ?
+			     "!= " : "",
+			     counter > 1 ? "{ " : "");
+		state_xlate_print(xl, sinfo->state_mask);
+		if (counter > 1)
+			xt_xlate_add(xl, " }");
+		xt_xlate_add(xl, " ");
+	}
+
+	if (sinfo->match_flags & XT_CONNTRACK_STATUS) {
+		if (sinfo->status_mask == 1)
+			return 0;
+		counter = status_xlate_counter(sinfo->status_mask);
+		xt_xlate_add(xl, "ct status %s%s",
+			     sinfo->invert_flags & XT_CONNTRACK_STATUS ?
+			     "!= " : "",
+			     counter > 1 ? "{ " : "");
+		status_xlate_print(xl, sinfo->status_mask);
+		if (counter > 1)
+			xt_xlate_add(xl, " }");
+		xt_xlate_add(xl, " ");
+	}
+
+	if (sinfo->match_flags & XT_CONNTRACK_EXPIRES) {
+		xt_xlate_add(xl, "ct expiration %s",
+			     sinfo->invert_flags & XT_CONNTRACK_EXPIRES ?
+			     "!= " : "");
+		if (sinfo->expires_max == sinfo->expires_min)
+			xt_xlate_add(xl, "%lu", sinfo->expires_min);
+		else
+			xt_xlate_add(xl, "%lu-%lu", sinfo->expires_min,
+				     sinfo->expires_max);
+		xt_xlate_add(xl, " ");
+	}
+
+	if (sinfo->match_flags & XT_CONNTRACK_ORIGSRC) {
+		if (&sinfo->origsrc_addr == 0L)
+			return 0;
+
+		xt_xlate_add(xl, "ct original saddr %s",
+			     sinfo->invert_flags & XT_CONNTRACK_ORIGSRC ?
+			     "!= " : "");
+		addr_xlate_print(xl, &sinfo->origsrc_addr,
+				 &sinfo->origsrc_mask, family);
+		xt_xlate_add(xl, " ");
+	}
+
+	if (sinfo->match_flags & XT_CONNTRACK_ORIGDST) {
+		if (&sinfo->origdst_addr == 0L)
+			return 0;
+
+		xt_xlate_add(xl, "ct original daddr %s",
+			     sinfo->invert_flags & XT_CONNTRACK_ORIGDST ?
+			     "!= " : "");
+		addr_xlate_print(xl, &sinfo->origdst_addr,
+				 &sinfo->origdst_mask, family);
+		xt_xlate_add(xl, " ");
+	}
+
+	if (sinfo->match_flags & XT_CONNTRACK_REPLSRC) {
+		if (&sinfo->replsrc_addr == 0L)
+			return 0;
+
+		xt_xlate_add(xl, "ct reply saddr %s",
+			     sinfo->invert_flags & XT_CONNTRACK_REPLSRC ?
+			     "!= " : "");
+		addr_xlate_print(xl, &sinfo->replsrc_addr,
+				 &sinfo->replsrc_mask, family);
+		xt_xlate_add(xl, " ");
+	}
+
+	if (sinfo->match_flags & XT_CONNTRACK_REPLDST) {
+		if (&sinfo->repldst_addr == 0L)
+			return 0;
+
+		xt_xlate_add(xl, "ct reply daddr %s",
+			     sinfo->invert_flags & XT_CONNTRACK_REPLDST ?
+			     "!= " : "");
+		addr_xlate_print(xl, &sinfo->repldst_addr,
+				 &sinfo->repldst_mask, family);
+		xt_xlate_add(xl, " ");
+	}
+
+	if (sinfo->match_flags & XT_CONNTRACK_ORIGSRC_PORT) {
+		xt_xlate_add(xl, "ct original proto-src %s",
+			     sinfo->invert_flags & XT_CONNTRACK_ORIGSRC_PORT ?
+			     "!= " : "");
+		if (sinfo->origsrc_port == sinfo->origsrc_port_high)
+			xt_xlate_add(xl, "%u ", sinfo->origsrc_port);
+		else
+			xt_xlate_add(xl, "%u-%u ", sinfo->origsrc_port,
+				     sinfo->origsrc_port_high);
+	}
+
+	if (sinfo->match_flags & XT_CONNTRACK_ORIGDST_PORT) {
+		xt_xlate_add(xl, "ct original proto-dst %s",
+			     sinfo->invert_flags & XT_CONNTRACK_ORIGDST_PORT ?
+			     "!= " : "");
+		if (sinfo->origdst_port == sinfo->origdst_port_high)
+			xt_xlate_add(xl, "%u ", sinfo->origdst_port);
+		else
+			xt_xlate_add(xl, "%u-%u ", sinfo->origdst_port,
+				     sinfo->origdst_port_high);
+	}
+
+	if (sinfo->match_flags & XT_CONNTRACK_REPLSRC_PORT) {
+		xt_xlate_add(xl, "ct reply proto-src %s",
+			     sinfo->invert_flags & XT_CONNTRACK_REPLSRC_PORT ?
+			     "!= " : "");
+		if (sinfo->replsrc_port == sinfo->replsrc_port_high)
+			xt_xlate_add(xl, "%u ", sinfo->replsrc_port);
+		else
+			xt_xlate_add(xl, "%u-%u ", sinfo->replsrc_port,
+				     sinfo->replsrc_port_high);
+	}
+
+	if (sinfo->match_flags & XT_CONNTRACK_REPLDST_PORT) {
+		xt_xlate_add(xl, "ct reply proto-dst %s",
+			     sinfo->invert_flags & XT_CONNTRACK_REPLDST_PORT ?
+			     "!= " : "", sinfo->repldst_port);
+		if (sinfo->repldst_port == sinfo->repldst_port_high)
+			xt_xlate_add(xl, "%u ", sinfo->repldst_port);
+		else
+			xt_xlate_add(xl, "%u-%u ", sinfo->repldst_port,
+				     sinfo->repldst_port_high);
+	}
+
+	return 1;
+}
+
+static int conntrack3_mt4_xlate(const void *ip,
+				const struct xt_entry_match *match,
+				struct xt_xlate *xl, int numeric)
+{
+	return _conntrack3_mt_xlate(ip, match, xl, numeric, NFPROTO_IPV4);
+}
+
+static int conntrack3_mt6_xlate(const void *ip,
+				const struct xt_entry_match *match,
+				struct xt_xlate *xl, int numeric)
+{
+	return _conntrack3_mt_xlate(ip, match, xl, numeric, NFPROTO_IPV6);
+}
+
 static struct xtables_match conntrack_mt_reg[] = {
 	{
 		.version       = XTABLES_VERSION,
@@ -1284,6 +1529,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.save          = conntrack3_mt_save,
 		.alias	       = conntrack_print_name_alias,
 		.x6_options    = conntrack3_mt_opts,
+		.xlate	       = conntrack3_mt4_xlate,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -1299,6 +1545,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.save          = conntrack3_mt6_save,
 		.alias	       = conntrack_print_name_alias,
 		.x6_options    = conntrack3_mt_opts,
+		.xlate	       = conntrack3_mt6_xlate,
 	},
 	{
 		.family        = NFPROTO_UNSPEC,
-- 
2.7.0

