From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH]: Keep the "state" match as alias [Re: state match is obsolete
 1.4.17]
Date: Tue, 15 Jan 2013 18:28:11 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301151820230.12091@blackhole.kfki.hu>
References: <CAMD-=V+PhM3NLpWyxB0G4KUN6D+-XKL0PZCBAuyUXUw56gmuJw@mail.gmail.com> <alpine.LNX.2.01.1301150958390.16853@nerf07.vanv.qr> <50F5273F.5020205@inliniac.net> <alpine.DEB.2.00.1301151102490.11129@blackhole.kfki.hu> <alpine.LNX.2.01.1301151342440.19279@nerf07.vanv.qr>
 <alpine.DEB.2.00.1301151406540.11172@blackhole.kfki.hu> <alpine.LNX.2.01.1301151444250.20224@nerf07.vanv.qr> <alpine.DEB.2.00.1301151534360.11172@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Victor Julien <lists@inliniac.net>,
	Nick Edwards <nick.z.edwards@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1301151534360.11172@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 15 Jan 2013, Jozsef Kadlecsik wrote:

> With passing one more internal flag, indicating that the "state" alias is 
> used, the "conntrack" module can remain completely hidden and the user can 
> list/save exactly the same command as the issued one.

Here follows the patch which introduces match module aliases (the same can 
be done for targets as well). The alias is handled as it were a real 
extension while it's actually handled by another module. Listing/saving 
keeps the alias name and options.

The "state" extension is the first example of such an alias.

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index c37f14d..92a42dc 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -794,6 +794,15 @@ conntrack_dump_ports(const char *prefix, const char *opt,
 		printf(" %s%s %u:%u", prefix, opt, port_low, port_high);
 }
 
+static const char *
+print_name_alias(const struct xt_entry_match *match)
+{
+	struct xt_conntrack_mtinfo1 *info = (void *)match->data;
+	
+	return info->match_flags & XT_CONNTRACK_STATE_ALIAS
+		? "state" : "conntrack";	
+}
+
 static void
 conntrack_dump(const struct xt_conntrack_mtinfo3 *info, const char *prefix,
                unsigned int family, bool numeric, bool v3)
@@ -801,7 +810,9 @@ conntrack_dump(const struct xt_conntrack_mtinfo3 *info, const char *prefix,
 	if (info->match_flags & XT_CONNTRACK_STATE) {
 		if (info->invert_flags & XT_CONNTRACK_STATE)
 			printf(" !");
-		printf(" %sctstate", prefix);
+		printf(" %s%s", prefix,
+		       info->match_flags & XT_CONNTRACK_STATE_ALIAS
+		       ? "state" : "ctstate");
 		print_state(info->state_mask);
 	}
 
@@ -1083,7 +1094,7 @@ static void state_ct1_parse(struct xt_option_call *cb)
 	struct xt_conntrack_mtinfo1 *sinfo = cb->data;
 
 	xtables_option_parse(cb);
-	sinfo->match_flags = XT_CONNTRACK_STATE;
+	sinfo->match_flags = XT_CONNTRACK_STATE | XT_CONNTRACK_STATE_ALIAS;
 	sinfo->state_mask = state_parse_states(cb->arg);
 	if (cb->invert)
 		sinfo->invert_flags |= XT_CONNTRACK_STATE;
@@ -1094,7 +1105,7 @@ static void state_ct23_parse(struct xt_option_call *cb)
 	struct xt_conntrack_mtinfo3 *sinfo = cb->data;
 
 	xtables_option_parse(cb);
-	sinfo->match_flags = XT_CONNTRACK_STATE;
+	sinfo->match_flags = XT_CONNTRACK_STATE | XT_CONNTRACK_STATE_ALIAS;
 	sinfo->state_mask = state_parse_states(cb->arg);
 	if (cb->invert)
 		sinfo->invert_flags |= XT_CONNTRACK_STATE;
@@ -1172,6 +1183,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack1_mt4_print,
 		.save          = conntrack1_mt4_save,
+		.alias	       = print_name_alias,
 		.x6_options    = conntrack2_mt_opts,
 	},
 	{
@@ -1186,6 +1198,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack1_mt6_print,
 		.save          = conntrack1_mt6_save,
+		.alias	       = print_name_alias,
 		.x6_options    = conntrack2_mt_opts,
 	},
 	{
@@ -1200,6 +1213,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack2_mt_print,
 		.save          = conntrack2_mt_save,
+		.alias	       = print_name_alias,
 		.x6_options    = conntrack2_mt_opts,
 	},
 	{
@@ -1214,6 +1228,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack2_mt6_print,
 		.save          = conntrack2_mt6_save,
+		.alias	       = print_name_alias,
 		.x6_options    = conntrack2_mt_opts,
 	},
 	{
@@ -1228,6 +1243,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack3_mt_print,
 		.save          = conntrack3_mt_save,
+		.alias	       = print_name_alias,
 		.x6_options    = conntrack3_mt_opts,
 	},
 	{
@@ -1242,6 +1258,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack3_mt6_print,
 		.save          = conntrack3_mt6_save,
+		.alias	       = print_name_alias,
 		.x6_options    = conntrack3_mt_opts,
 	},
 	{
@@ -1249,6 +1266,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.name          = "state",
 		.real_name     = "conntrack",
 		.revision      = 1,
+		.ext_flags     = XTABLES_EXT_ALIAS,
 		.version       = XTABLES_VERSION,
 		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
@@ -1261,6 +1279,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.name          = "state",
 		.real_name     = "conntrack",
 		.revision      = 2,
+		.ext_flags     = XTABLES_EXT_ALIAS,
 		.version       = XTABLES_VERSION,
 		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
@@ -1273,6 +1292,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.name          = "state",
 		.real_name     = "conntrack",
 		.revision      = 3,
+		.ext_flags     = XTABLES_EXT_ALIAS,
 		.version       = XTABLES_VERSION,
 		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
diff --git a/extensions/libxt_state.man b/extensions/libxt_state.man
index bd60468..ec096ca 100644
--- a/extensions/libxt_state.man
+++ b/extensions/libxt_state.man
@@ -1,4 +1,4 @@
-The "state" module is an obsolete version of "conntrack".
+The "state" extension is a subset of the "conntrack" module.
 "state" allows access to the connection tracking state for this packet.
 .TP
 [\fB!\fP] \fB\-\-state\fP \fIstate\fP
diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
index 74b904d..e971501 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -30,6 +30,7 @@ enum {
 	XT_CONNTRACK_REPLSRC_PORT = 1 << 10,
 	XT_CONNTRACK_REPLDST_PORT = 1 << 11,
 	XT_CONNTRACK_DIRECTION    = 1 << 12,
+	XT_CONNTRACK_STATE_ALIAS  = 1 << 13,
 };
 
 struct xt_conntrack_mtinfo1 {
diff --git a/include/xtables.h b/include/xtables.h
index 75de958..892c0b9 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -201,6 +201,10 @@ struct xtables_lmap {
 	struct xtables_lmap *next;
 };
 
+enum xtables_ext_flags {
+	XTABLES_EXT_ALIAS = 1 << 0,
+};
+
 /* Include file for additions: new matches and targets. */
 struct xtables_match
 {
@@ -217,6 +221,9 @@ struct xtables_match
 
 	/* Revision of match (0 by default). */
 	u_int8_t revision;
+	
+	/* Extension flags */
+	u_int8_t ext_flags;
 
 	u_int16_t family;
 
@@ -251,6 +258,9 @@ struct xtables_match
 	/* ip is struct ipt_ip * for example */
 	void (*save)(const void *ip, const struct xt_entry_match *match);
 
+	/* Print match name or alias*/
+	const char *(*alias)(const struct xt_entry_match *match);
+
 	/* Pointer to list of extra command-line options */
 	const struct option *extra_opts;
 
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 556647f..a5bcca3 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1000,7 +1000,8 @@ static int print_match_save(const struct xt_entry_match *e,
 		xtables_find_match(e->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
-		printf(" -m %s", e->u.user.name);
+		printf(" -m %s",
+		       match->alias ? match->alias(e) : e->u.user.name);
 
 		/* some matches don't provide a save function */
 		if (match->save)
@@ -1265,8 +1266,9 @@ static void command_match(struct iptables_command_state *cs)
 		strcpy(m->m->u.user.name, m->name);
 	} else {
 		strcpy(m->m->u.user.name, m->real_name);
-		fprintf(stderr, "WARNING: The %s match is obsolete. "
-		        "Use %s instead.\n", m->name, m->real_name);
+		if (!(m->ext_flags & XTABLES_EXT_ALIAS))
+			fprintf(stderr, "WARNING: The %s match is obsolete. "
+			        "Use %s instead.\n", m->name, m->real_name);
 	}
 	m->m->u.user.revision = m->revision;
 
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 00e3f01..6c53c54 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -991,7 +991,8 @@ static int print_match_save(const struct xt_entry_match *e,
 		xtables_find_match(e->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
-		printf(" -m %s", e->u.user.name);
+		printf(" -m %s",
+		       match->alias ? match->alias(e) : e->u.user.name);
 
 		/* some matches don't provide a save function */
 		if (match->save)
@@ -1259,8 +1260,9 @@ static void command_match(struct iptables_command_state *cs)
 		strcpy(m->m->u.user.name, m->name);
 	} else {
 		strcpy(m->m->u.user.name, m->real_name);
-		fprintf(stderr, "WARNING: The %s match is obsolete. "
-		        "Use %s instead.\n", m->name, m->real_name);
+		if (!(m->ext_flags & XTABLES_EXT_ALIAS))
+			fprintf(stderr, "WARNING: The %s match is obsolete. "
+			        "Use %s instead.\n", m->name, m->real_name);
 	}
 	m->m->u.user.revision = m->revision;
 
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
