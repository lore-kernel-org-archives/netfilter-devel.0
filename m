From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 19/24] libxtables: have xtopt_parse_mint interpret partially-spec'd ranges
Date: Wed, 25 May 2011 01:08:20 +0200
Message-ID: <1306278506-11463-20-git-send-email-jengelh@medozas.de>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40988 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab1EXXIt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:49 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When ":n" or "n:" is specified, it will now be interpreted as "0:n"
and "n:<max>", respecitvely. nvals will always reflect the number of
(expanded) components. This restores the functionality of options that
take such partially-unspecified ranges.

This makes it possible to nuke the per-matchdata init functions of
some extensions and simply the extensions postparsing to the point
where it only needs to check for nvals==1 or ==2.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_ah.c      |   10 +----
 extensions/libip6t_frag.c    |   12 ++----
 extensions/libip6t_rt.c      |   10 +----
 extensions/libipt_ah.c       |   10 +----
 extensions/libxt_conntrack.c |   73 ++++-------------------------------------
 extensions/libxt_esp.c       |   10 +----
 extensions/libxt_length.c    |    4 ++-
 xtoptions.c                  |   32 +++++++++++-------
 8 files changed, 42 insertions(+), 119 deletions(-)

diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index d30ddfa..26f8140 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -28,13 +28,6 @@ static const struct xt_option_entry ah_opts[] = {
 };
 #undef s
 
-static void ah_init(struct xt_entry_match *m)
-{
-	struct ip6t_ah *ahinfo = (struct ip6t_ah *)m->data;
-
-	ahinfo->spis[1] = 0xFFFFFFFF;
-}
-
 static void ah_parse(struct xt_option_call *cb)
 {
 	struct ip6t_ah *ahinfo = cb->data;
@@ -42,6 +35,8 @@ static void ah_parse(struct xt_option_call *cb)
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_AHSPI:
+		if (cb->nvals == 1)
+			ahinfo->spis[1] = ahinfo->spis[0];
 		if (cb->invert)
 			ahinfo->invflags |= IP6T_AH_INV_SPI;
 		break;
@@ -132,7 +127,6 @@ static struct xtables_match ah_mt6_reg = {
 	.size          = XT_ALIGN(sizeof(struct ip6t_ah)),
 	.userspacesize = XT_ALIGN(sizeof(struct ip6t_ah)),
 	.help          = ah_help,
-	.init          = ah_init,
 	.print         = ah_print,
 	.save          = ah_save,
 	.x6_parse      = ah_parse,
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 12794e4..4779386 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -41,19 +41,16 @@ static const struct xt_option_entry frag_opts[] = {
 };
 #undef s
 
-static void frag_init(struct xt_entry_match *m)
-{
-	struct ip6t_frag *fraginfo = (struct ip6t_frag *)m->data;
-
-	fraginfo->ids[1] = 0xFFFFFFFF;
-}
-
 static void frag_parse(struct xt_option_call *cb)
 {
 	struct ip6t_frag *fraginfo = cb->data;
 
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
+	case O_FRAGID:
+		if (cb->nvals == 1)
+			fraginfo->ids[1] = fraginfo->ids[0];
+		break;
 	case O_FRAGRES:
 		fraginfo->flags |= IP6T_FRAG_RES;
 		break;
@@ -160,7 +157,6 @@ static struct xtables_match frag_mt6_reg = {
 	.size          = XT_ALIGN(sizeof(struct ip6t_frag)),
 	.userspacesize = XT_ALIGN(sizeof(struct ip6t_frag)),
 	.help          = frag_help,
-	.init          = frag_init,
 	.print         = frag_print,
 	.save          = frag_save,
 	.x6_parse      = frag_parse,
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 9e6868d..d470488 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -99,13 +99,6 @@ parse_addresses(const char *addrstr, struct in6_addr *addrp)
 	return i;
 }
 
-static void rt_init(struct xt_entry_match *m)
-{
-	struct ip6t_rt *rtinfo = (struct ip6t_rt *)m->data;
-
-	rtinfo->segsleft[1] = 0xFFFFFFFF;
-}
-
 static void rt_parse(struct xt_option_call *cb)
 {
 	struct ip6t_rt *rtinfo = cb->data;
@@ -118,6 +111,8 @@ static void rt_parse(struct xt_option_call *cb)
 		rtinfo->flags |= IP6T_RT_TYP;
 		break;
 	case O_RT_SEGSLEFT:
+		if (cb->nvals == 1)
+			rtinfo->segsleft[1] = rtinfo->segsleft[0];
 		if (cb->invert)
 			rtinfo->invflags |= IP6T_RT_INV_SGS;
 		rtinfo->flags |= IP6T_RT_SGS;
@@ -250,7 +245,6 @@ static struct xtables_match rt_mt6_reg = {
 	.size		= XT_ALIGN(sizeof(struct ip6t_rt)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_rt)),
 	.help		= rt_help,
-	.init		= rt_init,
 	.x6_parse	= rt_parse,
 	.print		= rt_print,
 	.save		= rt_save,
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 53adfd8..8cf167c 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -21,18 +21,13 @@ static const struct xt_option_entry ah_opts[] = {
 	XTOPT_TABLEEND,
 };
 
-static void ah_init(struct xt_entry_match *m)
-{
-	struct ipt_ah *ahinfo = (struct ipt_ah *)m->data;
-
-	ahinfo->spis[1] = 0xFFFFFFFF;
-}
-
 static void ah_parse(struct xt_option_call *cb)
 {
 	struct ipt_ah *ahinfo = cb->data;
 
 	xtables_option_parse(cb);
+	if (cb->nvals == 1)
+		ahinfo->spis[1] = ahinfo->spis[0];
 	if (cb->invert)
 		ahinfo->invflags |= IPT_AH_INV_SPI;
 }
@@ -97,7 +92,6 @@ static struct xtables_match ah_mt_reg = {
 	.size		= XT_ALIGN(sizeof(struct ipt_ah)),
 	.userspacesize 	= XT_ALIGN(sizeof(struct ipt_ah)),
 	.help 		= ah_help,
-	.init 		= ah_init,
 	.print 		= ah_print,
 	.save 		= ah_save,
 	.x6_parse	= ah_parse,
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index ed0bd93..e1d8575 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -291,69 +291,6 @@ conntrack_ps_statuses(struct xt_conntrack_mtinfo3 *info, const char *arg)
 		xtables_error(PARAMETER_PROBLEM, "Bad ctstatus \"%s\"", arg);
 }
 
-static unsigned long
-parse_expire(const char *s)
-{
-	unsigned int len;
-
-	if (!xtables_strtoui(s, NULL, &len, 0, UINT32_MAX))
-		xtables_error(PARAMETER_PROBLEM, "expire value invalid: \"%s\"\n", s);
-	else
-		return len;
-}
-
-/* If a single value is provided, min and max are both set to the value */
-static void
-parse_expires(const char *s, struct xt_conntrack_info *sinfo)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(s);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		sinfo->expires_min = sinfo->expires_max =
-			parse_expire(buffer);
-	else {
-		*cp = '\0';
-		cp++;
-
-		sinfo->expires_min = buffer[0] ? parse_expire(buffer) : 0;
-		sinfo->expires_max = cp[0]
-			? parse_expire(cp)
-			: (unsigned long)-1;
-	}
-	free(buffer);
-
-	if (sinfo->expires_min > sinfo->expires_max)
-		xtables_error(PARAMETER_PROBLEM,
-		           "expire min. range value `%lu' greater than max. "
-		           "range value `%lu'", sinfo->expires_min, sinfo->expires_max);
-}
-
-static void
-conntrack_ps_expires(struct xt_conntrack_mtinfo3 *info, const char *s)
-{
-	unsigned int min, max;
-	char *end;
-
-	if (!xtables_strtoui(s, &end, &min, 0, UINT32_MAX))
-		xtables_param_act(XTF_BAD_VALUE, "conntrack", "--expires", s);
-	max = min;
-	if (*end == ':')
-		if (!xtables_strtoui(end + 1, &end, &max, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "conntrack", "--expires", s);
-	if (*end != '\0')
-		xtables_param_act(XTF_BAD_VALUE, "conntrack", "--expires", s);
-
-	if (min > max)
-		xtables_error(PARAMETER_PROBLEM,
-		           "expire min. range value \"%u\" greater than max. "
-		           "range value \"%u\"", min, max);
-
-	info->expires_min = min;
-	info->expires_max = max;
-}
-
 static void conntrack_parse(struct xt_option_call *cb)
 {
 	struct xt_conntrack_info *sinfo = cb->data;
@@ -408,7 +345,10 @@ static void conntrack_parse(struct xt_option_call *cb)
 		sinfo->flags |= XT_CONNTRACK_STATUS;
 		break;
 	case O_CTEXPIRE:
-		parse_expires(cb->arg, sinfo);
+		sinfo->expires_min = cb->val.u32_range[0];
+		sinfo->expires_max = cb->val.u32_range[0];
+		if (cb->nvals >= 2)
+			sinfo->expires_max = cb->val.u32_range[1];
 		if (cb->invert)
 			sinfo->invflags |= XT_CONNTRACK_EXPIRES;
 		sinfo->flags |= XT_CONNTRACK_EXPIRES;
@@ -473,7 +413,10 @@ static void conntrack_mt_parse(struct xt_option_call *cb, uint8_t rev)
 			info->invert_flags |= XT_CONNTRACK_STATUS;
 		break;
 	case O_CTEXPIRE:
-		conntrack_ps_expires(info, cb->arg);
+		info->expires_min = cb->val.u32_range[0];
+		info->expires_max = cb->val.u32_range[0];
+		if (cb->nvals >= 2)
+			info->expires_max = cb->val.u32_range[1];
 		info->match_flags |= XT_CONNTRACK_EXPIRES;
 		if (cb->invert)
 			info->invert_flags |= XT_CONNTRACK_EXPIRES;
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index e9d7990..294338b 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -21,18 +21,13 @@ static const struct xt_option_entry esp_opts[] = {
 	XTOPT_TABLEEND,
 };
 
-static void esp_init(struct xt_entry_match *m)
-{
-	struct xt_esp *espinfo = (struct xt_esp *)m->data;
-
-	espinfo->spis[1] = 0xFFFFFFFF;
-}
-
 static void esp_parse(struct xt_option_call *cb)
 {
 	struct xt_esp *espinfo = cb->data;
 
 	xtables_option_parse(cb);
+	if (cb->nvals == 1)
+		espinfo->spis[1] = espinfo->spis[0];
 	if (cb->invert)
 		espinfo->invflags |= XT_ESP_INV_SPI;
 }
@@ -91,7 +86,6 @@ static struct xtables_match esp_match = {
 	.size		= XT_ALIGN(sizeof(struct xt_esp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_esp)),
 	.help		= esp_help,
-	.init		= esp_init,
 	.print		= esp_print,
 	.save		= esp_save,
 	.x6_parse	= esp_parse,
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 4f3a331..6ea7646 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -26,7 +26,9 @@ static void length_parse(struct xt_option_call *cb)
 
 	xtables_option_parse(cb);
 	info->min = cb->val.u16_range[0];
-	info->max = (cb->nvals == 2) ? cb->val.u16_range[1] : UINT16_MAX;
+	info->max = cb->val.u16_range[0];
+	if (cb->nvals >= 2)
+		info->max = cb->val.u16_range[1];
 	if (cb->invert)
 		info->invert = 1;
 }
diff --git a/xtoptions.c b/xtoptions.c
index 30d70b0..ac0601f 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -284,7 +284,7 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 	const struct xt_option_entry *entry = cb->entry;
 	const char *arg = cb->arg;
 	size_t esize = xtopt_esize_by_type(entry->type);
-	uintmax_t lmax = xtopt_max_by_type(entry->type);
+	const uintmax_t lmax = xtopt_max_by_type(entry->type);
 	void *put = XTOPT_MKPTR(cb);
 	unsigned int maxiter;
 	uintmax_t value;
@@ -293,27 +293,33 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 
 	maxiter = entry->size / esize;
 	if (maxiter == 0)
-		maxiter = 2; /* ARRAY_SIZE(cb->val.uXX_range) */
+		maxiter = ARRAY_SIZE(cb->val.u32_range);
 	if (entry->size % esize != 0)
 		xt_params->exit_err(OTHER_PROBLEM, "%s: memory block does "
 			"not have proper size\n", __func__);
 
 	cb->nvals = 0;
-	for (arg = cb->arg; ; arg = end + 1) {
+	for (arg = cb->arg, end = (char *)arg; ; arg = end + 1) {
 		if (cb->nvals == maxiter)
 			xt_params->exit_err(PARAMETER_PROBLEM, "%s: Too many "
 				"components for option \"--%s\" (max: %u)\n",
 				cb->ext_name, entry->name, maxiter);
-		if (!xtables_strtoul(arg, &end, &value, 0, lmax))
-			xt_params->exit_err(PARAMETER_PROBLEM,
-				"%s: bad value for option \"--%s\" near "
-				"\"%s\", or out of range (0-%ju).\n",
-				cb->ext_name, entry->name, arg, lmax);
-		if (*end != '\0' && *end != sep)
-			xt_params->exit_err(PARAMETER_PROBLEM,
-				"%s: Argument to \"--%s\" has unexpected "
-				"characters near \"%s\".\n",
-				cb->ext_name, entry->name, end);
+		if (*arg == '\0' || *arg == sep) {
+			/* Default range components when field not spec'd. */
+			end = (char *)arg;
+			value = (cb->nvals == 1) ? lmax : 0;
+		} else {
+			if (!xtables_strtoul(arg, &end, &value, 0, lmax))
+				xt_params->exit_err(PARAMETER_PROBLEM,
+					"%s: bad value for option \"--%s\" near "
+					"\"%s\", or out of range (0-%ju).\n",
+					cb->ext_name, entry->name, arg, lmax);
+			if (*end != '\0' && *end != sep)
+				xt_params->exit_err(PARAMETER_PROBLEM,
+					"%s: Argument to \"--%s\" has "
+					"unexpected characters near \"%s\".\n",
+					cb->ext_name, entry->name, end);
+		}
 		xtopt_mint_value_to_cb(cb, value);
 		++cb->nvals;
 		xtopt_mint_value_to_ptr(cb, &put, value);
-- 
1.7.3.4

