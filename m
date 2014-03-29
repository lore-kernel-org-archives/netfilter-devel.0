From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd RFC PATCH 2/2] ip2str: introduce changable address separator
Date: Sat, 29 Mar 2014 13:29:15 +0900
Message-ID: <20140329042915.GC22821@gmail.com>
References: <20140329042336.GA22821@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:65097 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaC2E3X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Mar 2014 00:29:23 -0400
Received: by mail-pd0-f172.google.com with SMTP id p10so5694226pdj.3
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2014 21:29:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140329042336.GA22821@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch make change address string separator by "v4sep" or "v6sep" in config
file, because graphite uses `.' as path separator and statsd uses `:' as path
and value separator. Now I am testing ulogd and statsd (actually statsite) using
ulogd config:

  stack=ct1:NFCT,ip2str1:IP2STR,sprint:SPRINT
  [ct1]
  # in event mode, NF_NETLINK_CONNTRACK_DESTROY only
  event_mask=4
  [ip2str1]
  v4sep="_"
  v6sep="_"
  [sprint]
  form="myrouter.<orig.ip.daddr.str>.<orig.ip.protocol>.(<icmp.type>|<orig.l4.dport>|unknown).<orig.ip.saddr.str>:<orig.raw.pktlen> + <reply.raw.pktlen>\|kv\n"
  proto="tcp"
  dest="8125@192.168.1.1"

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 filter/ulogd_filter_IP2STR.c | 74 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 2 deletions(-)

diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
index 732e1ef..774b9cf 100644
--- a/filter/ulogd_filter_IP2STR.c
+++ b/filter/ulogd_filter_IP2STR.c
@@ -137,10 +137,55 @@ static struct ulogd_key ip2str_keys[] = {
 	},
 };
 
+enum ip2str_conf {
+	IP2STR_CONF_V6SEP = 0,
+	IP2STR_CONF_V4SEP,
+	IP2STR_CONF_MAX
+};
+
+static struct config_keyset ip2str_config_kset = {
+	.num_ces = 2,
+	.ces = {
+		[IP2STR_CONF_V6SEP] = {
+			.key = "v6sep",
+			.type = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+			.u = {.string = ":"},
+		},
+		[IP2STR_CONF_V4SEP] = {
+			.key = "v4sep",
+			.type = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+			.u = {.string = "."},
+		},
+	},
+};
+
+#define v6sep_ce(x)	(x->ces[IP2STR_CONF_V6SEP])
+#define v4sep_ce(x)	(x->ces[IP2STR_CONF_V4SEP])
+
 static char ipstr_array[MAX_KEY-START_KEY][IPADDR_LENGTH];
 
-static int ip2str(struct ulogd_key *inp, int index, int oindex)
+void change_separator(char family, char *addr, char to)
 {
+	char from;
+	char *cur;
+
+	switch(family) {
+	case AF_INET6: from = ':'; break;
+	case AF_INET: from = '.'; break;
+	default:
+		ulogd_log(ULOGD_NOTICE, "Unknown protocol family\n");
+		return;
+	}
+
+	for (cur = strchr(addr, from); cur != NULL; cur = strchr(cur + 1, from))
+		*cur = to;
+}
+
+static int ip2str(struct ulogd_pluginstance *upi, int index, int oindex)
+{
+	struct ulogd_key *inp = upi->input.keys;
 	char family = ikey_get_u8(&inp[KEY_OOB_FAMILY]);
 	char convfamily = family;
 
@@ -173,11 +218,17 @@ static int ip2str(struct ulogd_key *inp, int index, int oindex)
 		inet_ntop(AF_INET6,
 			  ikey_get_u128(&inp[index]),
 			  ipstr_array[oindex], sizeof(ipstr_array[oindex]));
+		if (*v6sep_ce(upi->config_kset).u.string != ':')
+			change_separator(convfamily, ipstr_array[oindex],
+					 *v6sep_ce(upi->config_kset).u.string);
 		break;
 	case AF_INET:
 		ip = ikey_get_u32(&inp[index]);
 		inet_ntop(AF_INET, &ip,
 			  ipstr_array[oindex], sizeof(ipstr_array[oindex]));
+		if (*v4sep_ce(upi->config_kset).u.string != '.')
+			change_separator(convfamily, ipstr_array[oindex],
+					 *v4sep_ce(upi->config_kset).u.string);
 		break;
 	default:
 		/* TODO error handling */
@@ -197,7 +248,7 @@ static int interp_ip2str(struct ulogd_pluginstance *pi)
 	/* Iter on all addr fields */
 	for (i = START_KEY; i <= MAX_KEY; i++) {
 		if (pp_is_valid(inp, i)) {
-			fret = ip2str(inp, i, i-START_KEY);
+			fret = ip2str(pi, i, i-START_KEY);
 			if (fret != ULOGD_IRET_OK)
 				return fret;
 			okey_set_ptr(&ret[i-START_KEY],
@@ -208,6 +259,23 @@ static int interp_ip2str(struct ulogd_pluginstance *pi)
 	return ULOGD_IRET_OK;
 }
 
+static int configure_ip2str(struct ulogd_pluginstance *upi,
+			    struct ulogd_pluginstance_stack *stack)
+{
+	int ret = config_parse_file(upi->id, upi->config_kset);
+
+	if (ret < 0)
+		return ret;
+
+	if (strlen(v6sep_ce(upi->config_kset).u.string) > 1)
+		ulogd_log(ULOGD_NOTICE, "only one char v6 separator is allowed,"
+			  " using: %c\n", *v6sep_ce(upi->config_kset).u.string);
+	if (strlen(v4sep_ce(upi->config_kset).u.string) > 1)
+		ulogd_log(ULOGD_NOTICE, "only one char v4 separator is allowed,"
+			  " using: %c\n", *v4sep_ce(upi->config_kset).u.string);
+	return ret;
+}
+
 static struct ulogd_plugin ip2str_pluging = {
 	.name = "IP2STR",
 	.input = {
@@ -220,7 +288,9 @@ static struct ulogd_plugin ip2str_pluging = {
 		.num_keys = ARRAY_SIZE(ip2str_keys),
 		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
 		},
+	.config_kset = &ip2str_config_kset,
 	.interp = &interp_ip2str,
+	.configure = &configure_ip2str,
 	.version = VERSION,
 };
 
-- 
1.8.5.3

