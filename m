From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] kill NFC_* stuff in iptables [was Re: iptables compile
 error: NFC_IP_TOS undeclared]
Date: Sat, 12 Feb 2005 23:25:29 +0100
Message-ID: <420E8259.60604@eurodev.net>
References: <Pine.GSO.4.33.0502101758010.19216-100000@indigo>	<420B8623.9050308@niksula.hut.fi>	<420B9ED0.1020303@trash.net>
	<420BEB36.7080209@eurodev.net> <420D0276.5080200@trash.net>
	<420D27DB.9000608@eurodev.net> <420D5CC8.1060600@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030503080105060003030600"
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <420D5CC8.1060600@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------030503080105060003030600
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:

>>> Why didn't you remove it entirely instead ?
>>
>>
>> true :), patch attached. I've gzip'ed it, it's too big for sending it 
>> in clear text.
>
>
> Thanks a lot. Hopeing I don't annoy you ..


No way, thanks Patrick.

> I haven't actually checked
> the API, but can't we remove all those now empty init functions ?
> If not I think it would be nicer to change the API to check for
> ->init == NULL instead of leaving all these empty funtion bodies around.


Yes, I agree and I did it, I must confess that it was kinda boring a 
bit. See the patch attached.

>> Next step, what do you think about removing nfcache passed as 
>> parameter from the iptables API?
>
>
> I don't think we can remove it from struct ipt_entry without
> breaking userspace compatibility. But we could stop using it.


Yes, I was aware of that :). I didn't talk about modifying ipt_entry 
which is not possible because of backward compatibility. I mean that, as 
next step, we could kill those nfcache arguments passed as parameter 
that aren't useful anymore.

--
Pablo

--------------030503080105060003030600
Content-Type: text/x-patch;
 name="die-die-NFC-die.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="die-die-NFC-die.patch"

Index: iptables.c
===================================================================
--- iptables.c	(revision 3656)
+++ iptables.c	(working copy)
@@ -1987,7 +1987,6 @@
 			    && (fw.ip.invflags & IPT_INV_PROTO))
 				exit_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
-			fw.nfcache |= NFC_IP_PROTO;
 			break;
 
 		case 's':
@@ -1995,7 +1994,6 @@
 			set_option(&options, OPT_SOURCE, &fw.ip.invflags,
 				   invert);
 			shostnetworkmask = argv[optind-1];
-			fw.nfcache |= NFC_IP_SRC;
 			break;
 
 		case 'd':
@@ -2003,7 +2001,6 @@
 			set_option(&options, OPT_DESTINATION, &fw.ip.invflags,
 				   invert);
 			dhostnetworkmask = argv[optind-1];
-			fw.nfcache |= NFC_IP_DST;
 			break;
 
 		case 'j':
@@ -2024,7 +2021,8 @@
 				strcpy(target->t->u.user.name, jumpto);
 				set_revision(target->t->u.user.name,
 					     target->revision);
-				target->init(target->t, &fw.nfcache);
+				if (target->init != NULL)
+					target->init(target->t, &fw.nfcache);
 				opts = merge_options(opts, target->extra_opts, &target->option_offset);
 			}
 			break;
@@ -2037,7 +2035,6 @@
 			parse_interface(argv[optind-1],
 					fw.ip.iniface,
 					fw.ip.iniface_mask);
-			fw.nfcache |= NFC_IP_IF_IN;
 			break;
 
 		case 'o':
@@ -2047,14 +2044,12 @@
 			parse_interface(argv[optind-1],
 					fw.ip.outiface,
 					fw.ip.outiface_mask);
-			fw.nfcache |= NFC_IP_IF_OUT;
 			break;
 
 		case 'f':
 			set_option(&options, OPT_FRAGMENT, &fw.ip.invflags,
 				   invert);
 			fw.ip.flags |= IPT_F_FRAG;
-			fw.nfcache |= NFC_IP_FRAG;
 			break;
 
 		case 'v':
@@ -2078,7 +2073,8 @@
 			m->m->u.match_size = size;
 			strcpy(m->m->u.user.name, m->name);
 			set_revision(m->m->u.user.name, m->revision);
-			m->init(m->m, &fw.nfcache);
+			if (m->init != NULL)
+				m->init(m->m, &fw.nfcache);
 			opts = merge_options(opts, m->extra_opts, &m->option_offset);
 		}
 		break;
@@ -2221,7 +2217,8 @@
 					strcpy(m->m->u.user.name, m->name);
 					set_revision(m->m->u.user.name,
 						     m->revision);
-					m->init(m->m, &fw.nfcache);
+					if (m->init != NULL)
+						m->init(m->m, &fw.nfcache);
 
 					opts = merge_options(opts,
 					    m->extra_opts, &m->option_offset);
@@ -2349,7 +2346,8 @@
 			target->t->u.target_size = size;
 			strcpy(target->t->u.user.name, jumpto);
 			set_revision(target->t->u.user.name, target->revision);
-			target->init(target->t, &fw.nfcache);
+			if (target->init != NULL)
+				target->init(target->t, &fw.nfcache);
 		}
 
 		if (!target) {
Index: libiptc/libip4tc.c
===================================================================
--- libiptc/libip4tc.c	(revision 3656)
+++ libiptc/libip4tc.c	(working copy)
@@ -149,17 +149,6 @@
 	printf("Cache: %08X ", e->nfcache);
 	if (e->nfcache & NFC_ALTERED) printf("ALTERED ");
 	if (e->nfcache & NFC_UNKNOWN) printf("UNKNOWN ");
-	if (e->nfcache & NFC_IP_SRC) printf("IP_SRC ");
-	if (e->nfcache & NFC_IP_DST) printf("IP_DST ");
-	if (e->nfcache & NFC_IP_IF_IN) printf("IP_IF_IN ");
-	if (e->nfcache & NFC_IP_IF_OUT) printf("IP_IF_OUT ");
-	if (e->nfcache & NFC_IP_TOS) printf("IP_TOS ");
-	if (e->nfcache & NFC_IP_PROTO) printf("IP_PROTO ");
-	if (e->nfcache & NFC_IP_OPTIONS) printf("IP_OPTIONS ");
-	if (e->nfcache & NFC_IP_TCPFLAGS) printf("IP_TCPFLAGS ");
-	if (e->nfcache & NFC_IP_SRC_PT) printf("IP_SRC_PT ");
-	if (e->nfcache & NFC_IP_DST_PT) printf("IP_DST_PT ");
-	if (e->nfcache & NFC_IP_PROTO_UNKNOWN) printf("IP_PROTO_UNKNOWN ");
 	printf("\n");
 
 	IPT_MATCH_ITERATE(e, print_match);
Index: libiptc/libip6tc.c
===================================================================
--- libiptc/libip6tc.c	(revision 3656)
+++ libiptc/libip6tc.c	(working copy)
@@ -180,17 +180,6 @@
 	printf("Cache: %08X ", e->nfcache);
 	if (e->nfcache & NFC_ALTERED) printf("ALTERED ");
 	if (e->nfcache & NFC_UNKNOWN) printf("UNKNOWN ");
-	if (e->nfcache & NFC_IP6_SRC) printf("IP6_SRC ");
-	if (e->nfcache & NFC_IP6_DST) printf("IP6_DST ");
-	if (e->nfcache & NFC_IP6_IF_IN) printf("IP6_IF_IN ");
-	if (e->nfcache & NFC_IP6_IF_OUT) printf("IP6_IF_OUT ");
-	if (e->nfcache & NFC_IP6_TOS) printf("IP6_TOS ");
-	if (e->nfcache & NFC_IP6_PROTO) printf("IP6_PROTO ");
-	if (e->nfcache & NFC_IP6_OPTIONS) printf("IP6_OPTIONS ");
-	if (e->nfcache & NFC_IP6_TCPFLAGS) printf("IP6_TCPFLAGS ");
-	if (e->nfcache & NFC_IP6_SRC_PT) printf("IP6_SRC_PT ");
-	if (e->nfcache & NFC_IP6_DST_PT) printf("IP6_DST_PT ");
-	if (e->nfcache & NFC_IP6_PROTO_UNKNOWN) printf("IP6_PROTO_UNKNOWN ");
 	printf("\n");
 	
 	IP6T_MATCH_ITERATE(e, print_match);
Index: extensions/libipt_connlimit.c
===================================================================
--- extensions/libipt_connlimit.c	(revision 3656)
+++ extensions/libipt_connlimit.c	(working copy)
@@ -26,14 +26,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -127,7 +119,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_connlimit_info)),
 	.userspacesize 	= offsetof(struct ipt_connlimit_info,data),
 	.help		= help,
-	.init		= init,
 	.parse 		= parse,
 	.final_check	= final_check,
 	.print		= print,
Index: extensions/libipt_account.c
===================================================================
--- extensions/libipt_account.c	(revision 3656)
+++ extensions/libipt_account.c	(working copy)
@@ -168,7 +168,6 @@
 	
 	struct t_ipt_account_info *info = (struct t_ipt_account_info *)(match)->data;
 
-	*nfcache |= NFC_UNKNOWN;
 
 	/* set default table name to DEFAULT */
 	strncpy(info->name, "DEFAULT", IPT_ACCOUNT_NAME_LEN);
Index: extensions/libipt_pkttype.c
===================================================================
--- extensions/libipt_pkttype.c	(revision 3656)
+++ extensions/libipt_pkttype.c	(working copy)
@@ -69,11 +69,6 @@
 	{0}
 };
 
-static void init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	*nfcache |= NFC_UNKNOWN;
-}
-
 static void parse_pkttype(const char *pkttype, struct ipt_pkttype_info *info)
 {
 	unsigned int	i;
@@ -159,7 +154,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_pkttype_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_pkttype_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse, 
 	.final_check	= &final_check, 
 	.print		= &print,
Index: extensions/libip6t_random.c
===================================================================
--- extensions/libip6t_random.c	(revision 3656)
+++ extensions/libip6t_random.c	(working copy)
@@ -52,7 +52,6 @@
 init(struct ip6t_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_rand_info *randinfo = (struct ip6t_rand_info *)(m)->data;
-	*nfcache |= NFC_UNKNOWN;
 
 	/* We assign the average to be 50 which is our default value */
 	/* 50 * 2.55 = 128 */
Index: extensions/libipt_IPV4OPTSSTRIP.c
===================================================================
--- extensions/libipt_IPV4OPTSSTRIP.c	(revision 3656)
+++ extensions/libipt_IPV4OPTSSTRIP.c	(working copy)
@@ -13,11 +13,6 @@
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 
-static void init(struct ipt_entry_target *t, unsigned int *nfcache) 
-{
-        *nfcache |= NFC_UNKNOWN;
-}
-
 static void help(void) 
 {
 	printf("IPV4OPTSSTRIP v%s target takes no option !! Make sure you use it in the mangle table.\n",
@@ -66,7 +61,6 @@
 	.size		= IPT_ALIGN(0),
 	.userspacesize	= IPT_ALIGN(0),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_childlevel.c
===================================================================
--- extensions/libipt_childlevel.c	(revision 3656)
+++ extensions/libipt_childlevel.c	(working copy)
@@ -39,12 +39,6 @@
 	{ .name = 0 }
 };
 
-/* Initialize the match. */
-static void init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	*nfcache |= NFC_UNKNOWN;
-}
-
 /* Function which parses command options; returns true if it ate an option */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry, unsigned int *nfcache,
@@ -108,7 +102,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_childlevel_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_childlevel_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_conntrack.c
===================================================================
--- extensions/libipt_conntrack.c	(revision 3656)
+++ extensions/libipt_conntrack.c	(working copy)
@@ -56,14 +56,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 static int
 parse_state(const char *state, size_t strlen, struct ipt_conntrack_info *sinfo)
 {
@@ -538,7 +530,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_conntrack_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_conntrack_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libip6t_multiport.c
===================================================================
--- extensions/libip6t_multiport.c	(revision 3656)
+++ extensions/libip6t_multiport.c	(working copy)
@@ -117,7 +117,6 @@
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
 		multiinfo->flags = IP6T_MULTIPORT_SOURCE;
-		*nfcache |= NFC_IP6_SRC_PT;
 		break;
 
 	case '2':
@@ -126,7 +125,6 @@
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
 		multiinfo->flags = IP6T_MULTIPORT_DESTINATION;
-		*nfcache |= NFC_IP6_DST_PT;
 		break;
 
 	case '3':
@@ -135,7 +133,6 @@
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
 		multiinfo->flags = IP6T_MULTIPORT_EITHER;
-		*nfcache |= NFC_IP6_SRC_PT | NFC_IP6_DST_PT;
 		break;
 
 	default:
Index: extensions/libipt_multiport.c
===================================================================
--- extensions/libipt_multiport.c	(revision 3656)
+++ extensions/libipt_multiport.c	(working copy)
@@ -179,7 +179,6 @@
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
 		multiinfo->flags = IPT_MULTIPORT_SOURCE;
-		*nfcache |= NFC_IP_SRC_PT;
 		break;
 
 	case '2':
@@ -188,7 +187,6 @@
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
 		multiinfo->flags = IPT_MULTIPORT_DESTINATION;
-		*nfcache |= NFC_IP_DST_PT;
 		break;
 
 	case '3':
@@ -197,7 +195,6 @@
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
 		multiinfo->flags = IPT_MULTIPORT_EITHER;
-		*nfcache |= NFC_IP_SRC_PT | NFC_IP_DST_PT;
 		break;
 
 	default:
@@ -231,7 +228,6 @@
 		proto = check_proto(entry);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = IPT_MULTIPORT_SOURCE;
-		*nfcache |= NFC_IP_SRC_PT;
 		break;
 
 	case '2':
@@ -239,7 +235,6 @@
 		proto = check_proto(entry);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = IPT_MULTIPORT_DESTINATION;
-		*nfcache |= NFC_IP_DST_PT;
 		break;
 
 	case '3':
@@ -247,7 +242,6 @@
 		proto = check_proto(entry);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = IPT_MULTIPORT_EITHER;
-		*nfcache |= NFC_IP_SRC_PT | NFC_IP_DST_PT;
 		break;
 
 	default:
Index: extensions/libipt_REDIRECT.c
===================================================================
--- extensions/libipt_REDIRECT.c	(revision 3656)
+++ extensions/libipt_REDIRECT.c	(working copy)
@@ -33,8 +33,6 @@
 	/* Actually, it's 0, but it's ignored at the moment. */
 	mr->rangesize = 1;
 
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* Parses ports */
Index: extensions/libipt_addrtype.c
===================================================================
--- extensions/libipt_addrtype.c	(revision 3656)
+++ extensions/libipt_addrtype.c	(working copy)
@@ -48,12 +48,6 @@
 	help_types();
 }
 
-static void init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* caching not yet implemented */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 static int
 parse_type(const char *name, size_t strlen, u_int16_t *mask)
 {
@@ -199,7 +193,6 @@
 	.size 		= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
 	.userspacesize 	= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
 	.help 		= &help,
-	.init 		= &init,
 	.parse 		= &parse,
 	.final_check 	= &final_check,
 	.print 		= &print,
Index: extensions/libip6t_fuzzy.c
===================================================================
--- extensions/libip6t_fuzzy.c	(revision 3656)
+++ extensions/libip6t_fuzzy.c	(working copy)
@@ -44,8 +44,6 @@
 init(struct ip6t_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_fuzzy_info *presentinfo = (struct ip6t_fuzzy_info *)(m)->data;
-	*nfcache |= NFC_UNKNOWN;
-
 	/*
 	 * Default rates ( I'll improve this very soon with something based
 	 * on real statistics of the running machine ) .
Index: extensions/libipt_length.c
===================================================================
--- extensions/libipt_length.c	(revision 3656)
+++ extensions/libipt_length.c	(working copy)
@@ -25,13 +25,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	*nfcache |= NFC_UNKNOWN;
-}
-
 static u_int16_t
 parse_length(const char *s)
 {
@@ -145,7 +138,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_length_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_length_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_hashlimit.c
===================================================================
--- extensions/libipt_hashlimit.c	(revision 3656)
+++ extensions/libipt_hashlimit.c	(working copy)
@@ -104,8 +104,6 @@
 	r->cfg.gc_interval = IPT_HASHLIMIT_GCINTERVAL;
 	r->cfg.expire = IPT_HASHLIMIT_EXPIRE;
 
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 
Index: extensions/libipt_MASQUERADE.c
===================================================================
--- extensions/libipt_MASQUERADE.c	(revision 3656)
+++ extensions/libipt_MASQUERADE.c	(working copy)
@@ -33,8 +33,6 @@
 	/* Actually, it's 0, but it's ignored at the moment. */
 	mr->rangesize = 1;
 
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* Parses ports */
Index: extensions/libipt_fuzzy.c
===================================================================
--- extensions/libipt_fuzzy.c	(revision 3656)
+++ extensions/libipt_fuzzy.c	(working copy)
@@ -43,7 +43,6 @@
 init(struct ipt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_fuzzy_info *presentinfo = (struct ipt_fuzzy_info *)(m)->data;
-	*nfcache |= NFC_UNKNOWN;
 
 	/*
 	 * Default rates ( I'll improve this very soon with something based 
Index: extensions/libipt_set.c
===================================================================
--- extensions/libipt_set.c	(revision 3656)
+++ extensions/libipt_set.c	(working copy)
@@ -47,8 +47,6 @@
 
 	memset(info, 0, sizeof(struct ipt_set_info_match));
 
-	/* Can't cache this - XXX */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* Function which parses command options; returns true if it ate an option */
Index: extensions/libipt_realm.c
===================================================================
--- extensions/libipt_realm.c	(revision 3656)
+++ extensions/libipt_realm.c	(working copy)
@@ -28,14 +28,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -122,7 +114,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_realm_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_realm_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_connbytes.c
===================================================================
--- extensions/libipt_connbytes.c	(revision 3656)
+++ extensions/libipt_connbytes.c	(working copy)
@@ -27,15 +27,7 @@
 	{0}
 };
 
-/* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
-}
-
-static void
 parse_range(const char *arg, struct ipt_connbytes_info *si)
 {
 	char *colon,*p;
@@ -199,7 +191,6 @@
 	.size 		= IPT_ALIGN(sizeof(struct ipt_connbytes_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_connbytes_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_tos.c
===================================================================
--- extensions/libipt_tos.c	(revision 3656)
+++ extensions/libipt_tos.c	(working copy)
@@ -47,14 +47,7 @@
 	{0}
 };
 
-/* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	*nfcache |= NFC_IP_TOS;
-}
-
-static void
 parse_tos(const unsigned char *s, struct ipt_tos_info *info)
 {
 	unsigned int i;
@@ -166,7 +159,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_tos_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_tos_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libip6t_LOG.c
===================================================================
--- extensions/libip6t_LOG.c	(revision 3656)
+++ extensions/libip6t_LOG.c	(working copy)
@@ -42,8 +42,6 @@
 
 	loginfo->level = LOG_DEFAULT_LEVEL;
 
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 struct ip6t_log_names {
Index: extensions/libipt_POOL.c
===================================================================
--- extensions/libipt_POOL.c	(revision 3656)
+++ extensions/libipt_POOL.c	(working copy)
@@ -51,8 +51,6 @@
 	ipi->src = ipi->dst = IP_POOL_NONE;
 	ipi->flags = 0;
 
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* Function which parses command options; returns true if it
Index: extensions/libipt_TCPLAG.c
===================================================================
--- extensions/libipt_TCPLAG.c	(revision 3656)
+++ extensions/libipt_TCPLAG.c	(working copy)
@@ -70,18 +70,6 @@
  * our own private data structure (which is at t->data).
  * Probably we could fiddle with t->tflags too but there is
  * no great advantage in doing so.
- * 
- * TODO: Find documentation for the above flags which
- *       can be ored into nfcache...
- *
- * NFC_IP6_DST_PT
- * NFC_IP6_PROTO_UNKNOWN
- * NFC_IP6_SRC_PT
- * NFC_IP6_TCPFLAGS
- * NFC_IP_DST_PT
- * NFC_IP_SRC_PT
- * NFC_IP_TOS
- * NFC_UNKNOWN             -- This one seems safest
  */
 static void init( struct ipt_entry_target *t, unsigned int *nfcache )
 {
@@ -89,7 +77,6 @@
 	memset( el, 0, sizeof( struct ipt_tcplag ));
 	el->level = 4; /* Default to warning level */
 	strcpy( el->prefix, "TCPLAG:" ); /* Give a reasonable default prefix */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /*
Index: extensions/libip6t_udp.c
===================================================================
--- extensions/libip6t_udp.c	(revision 3656)
+++ extensions/libip6t_udp.c	(working copy)
@@ -109,7 +109,6 @@
 		if (invert)
 			udpinfo->invflags |= IP6T_UDP_INV_SRCPT;
 		*flags |= UDP_SRC_PORTS;
-		*nfcache |= NFC_IP6_SRC_PT;
 		break;
 
 	case '2':
@@ -121,7 +120,6 @@
 		if (invert)
 			udpinfo->invflags |= IP6T_UDP_INV_DSTPT;
 		*flags |= UDP_DST_PORTS;
-		*nfcache |= NFC_IP6_DST_PT;
 		break;
 
 	default:
Index: extensions/libipt_recent.c
===================================================================
--- extensions/libipt_recent.c	(revision 3656)
+++ extensions/libipt_recent.c	(working copy)
@@ -72,7 +72,6 @@
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)(match)->data;
 
-	*nfcache |= NFC_UNKNOWN;
 
 	strncpy(info->name,"DEFAULT",IPT_RECENT_NAME_LEN);
 	/* eventhough IPT_RECENT_NAME_LEN is currently defined as 200,
Index: extensions/libipt_random.c
===================================================================
--- extensions/libipt_random.c	(revision 3656)
+++ extensions/libipt_random.c	(working copy)
@@ -51,7 +51,6 @@
 init(struct ipt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_rand_info *randinfo = (struct ipt_rand_info *)(m)->data;
-	*nfcache |= NFC_UNKNOWN;
 
 	/* We assign the average to be 50 which is our default value */
 	/* 50 * 2.55 = 128 */
Index: extensions/libipt_unclean.c
===================================================================
--- extensions/libipt_unclean.c	(revision 3656)
+++ extensions/libipt_unclean.c	(working copy)
@@ -17,14 +17,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this. */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -49,7 +41,6 @@
 	.size		= IPT_ALIGN(0),
 	.userspacesize	= IPT_ALIGN(0),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= NULL,
Index: extensions/libipt_dstlimit.c
===================================================================
--- extensions/libipt_dstlimit.c	(revision 3656)
+++ extensions/libipt_dstlimit.c	(working copy)
@@ -105,8 +105,6 @@
 	r->cfg.gc_interval = IPT_DSTLIMIT_GCINTERVAL;
 	r->cfg.expire = IPT_DSTLIMIT_EXPIRE;
 
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 #define PARAM_LIMIT		0x00000001
Index: extensions/libipt_nth.c
===================================================================
--- extensions/libipt_nth.c	(revision 3656)
+++ extensions/libipt_nth.c	(working copy)
@@ -50,13 +50,6 @@
 	{ 0 }
 };
 
-/* Initialize the target. */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	*nfcache |= NFC_UNKNOWN;
-}
-
 #define IPT_NTH_OPT_EVERY	0x01
 #define IPT_NTH_OPT_NOT_EVERY	0x02
 #define IPT_NTH_OPT_START	0x04
@@ -224,7 +217,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_nth_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_nth_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_mac.c
===================================================================
--- extensions/libipt_mac.c	(revision 3656)
+++ extensions/libipt_mac.c	(working copy)
@@ -28,15 +28,7 @@
 	{0}
 };
 
-/* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
-}
-
-static void
 parse_mac(const char *mac, struct ipt_mac_info *info)
 {
 	unsigned int i = 0;
@@ -135,7 +127,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_mac_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_mac_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_TARPIT.c
===================================================================
--- extensions/libipt_TARPIT.c	(revision 3656)
+++ extensions/libipt_TARPIT.c	(working copy)
@@ -15,13 +15,6 @@
 	{ 0 }
 };
 
-static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
-{
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
@@ -52,7 +45,6 @@
 	.size		= IPT_ALIGN(0),
 	.userspacesize	= IPT_ALIGN(0),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_ttl.c
===================================================================
--- extensions/libipt_ttl.c	(revision 3656)
+++ extensions/libipt_ttl.c	(working copy)
@@ -24,12 +24,6 @@
 , IPTABLES_VERSION);
 }
 
-static void init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* caching not yet implemented */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 static int parse(int c, char **argv, int invert, unsigned int *flags,
 		const struct ipt_entry *entry, unsigned int *nfcache,
 		struct ipt_entry_match **match)
@@ -156,7 +150,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_ttl_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_ttl_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_SNAT.c
===================================================================
--- extensions/libipt_SNAT.c	(revision 3656)
+++ extensions/libipt_SNAT.c	(working copy)
@@ -33,14 +33,6 @@
 	{ 0 }
 };
 
-/* Initialize the target. */
-static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
-{
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 static struct ipt_natinfo *
 append_range(struct ipt_natinfo *info, const struct ip_nat_range *range)
 {
@@ -236,7 +228,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_tcpmss.c
===================================================================
--- extensions/libipt_tcpmss.c	(revision 3656)
+++ extensions/libipt_tcpmss.c	(working copy)
@@ -24,13 +24,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	*nfcache |= NFC_IP_PROTO_UNKNOWN;
-}
-
 static u_int16_t
 parse_tcp_mssvalue(const char *mssvalue)
 {
@@ -146,7 +139,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_tcpmss_match_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_tcpmss_match_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_connrate.c
===================================================================
--- extensions/libipt_connrate.c	(revision 3656)
+++ extensions/libipt_connrate.c	(working copy)
@@ -34,14 +34,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* caching not yet implemented */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 static u_int32_t
 parse_value(const char *arg, u_int32_t def)
 {
@@ -174,7 +166,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_connrate_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_connrate_info)),
 	.help 		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libip6t_tcp.c
===================================================================
--- extensions/libip6t_tcp.c	(revision 3656)
+++ extensions/libip6t_tcp.c	(working copy)
@@ -187,7 +187,6 @@
 		if (invert)
 			tcpinfo->invflags |= IP6T_TCP_INV_SRCPT;
 		*flags |= TCP_SRC_PORTS;
-		*nfcache |= NFC_IP6_SRC_PT;
 		break;
 
 	case '2':
@@ -199,7 +198,6 @@
 		if (invert)
 			tcpinfo->invflags |= IP6T_TCP_INV_DSTPT;
 		*flags |= TCP_DST_PORTS;
-		*nfcache |= NFC_IP6_DST_PT;
 		break;
 
 	case '3':
@@ -209,7 +207,6 @@
 				   " allowed");
 		parse_tcp_flags(tcpinfo, "SYN,RST,ACK", "SYN", invert);
 		*flags |= TCP_FLAGS;
-		*nfcache |= NFC_IP6_TCPFLAGS;
 		break;
 
 	case '4':
@@ -228,7 +225,6 @@
 				invert);
 		optind++;
 		*flags |= TCP_FLAGS;
-		*nfcache |= NFC_IP6_TCPFLAGS;
 		break;
 
 	case '5':
@@ -240,7 +236,6 @@
 		if (invert)
 			tcpinfo->invflags |= IP6T_TCP_INV_OPTION;
 		*flags |= TCP_OPTION;
-		*nfcache |= NFC_IP6_PROTO_UNKNOWN;
 		break;
 
 	default:
Index: extensions/libipt_state.c
===================================================================
--- extensions/libipt_state.c	(revision 3656)
+++ extensions/libipt_state.c	(working copy)
@@ -28,14 +28,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 static int
 parse_state(const char *state, size_t strlen, struct ipt_state_info *sinfo)
 {
@@ -158,7 +150,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_state_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_state_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libip6t_owner.c
===================================================================
--- extensions/libip6t_owner.c	(revision 3656)
+++ extensions/libip6t_owner.c	(working copy)
@@ -47,14 +47,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this. */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -243,7 +235,6 @@
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_owner_info)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_owner_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_IPMARK.c
===================================================================
--- extensions/libipt_IPMARK.c	(revision 3656)
+++ extensions/libipt_IPMARK.c	(working copy)
@@ -53,7 +53,6 @@
 	ipmarkinfo->andmask=0xffffffff;
 	ipmarkinfo->ormask=0;
 
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* Function which parses command options; returns true if it
Index: extensions/libipt_owner.c
===================================================================
--- extensions/libipt_owner.c	(revision 3656)
+++ extensions/libipt_owner.c	(working copy)
@@ -49,14 +49,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this. */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -245,7 +237,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_owner_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_owner_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_mport.c
===================================================================
--- extensions/libipt_mport.c	(revision 3656)
+++ extensions/libipt_mport.c	(working copy)
@@ -140,7 +140,6 @@
 		proto = check_proto(entry);
 		parse_multi_ports(argv[optind-1], minfo, proto);
 		minfo->flags = IPT_MPORT_SOURCE;
-		*nfcache |= NFC_IP_SRC_PT;
 		break;
 
 	case '2':
@@ -148,7 +147,6 @@
 		proto = check_proto(entry);
 		parse_multi_ports(argv[optind-1], minfo, proto);
 		minfo->flags = IPT_MPORT_DESTINATION;
-		*nfcache |= NFC_IP_DST_PT;
 		break;
 
 	case '3':
@@ -156,7 +154,6 @@
 		proto = check_proto(entry);
 		parse_multi_ports(argv[optind-1], minfo, proto);
 		minfo->flags = IPT_MPORT_EITHER;
-		*nfcache |= NFC_IP_SRC_PT | NFC_IP_DST_PT;
 		break;
 
 	default:
Index: extensions/libip6t_REJECT.c
===================================================================
--- extensions/libip6t_REJECT.c	(revision 3656)
+++ extensions/libip6t_REJECT.c	(working copy)
@@ -79,8 +79,6 @@
 	/* default */
 	reject->with = IP6T_ICMP6_PORT_UNREACH;
 
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* Function which parses command options; returns true if it
Index: extensions/libipt_NETLINK.c
===================================================================
--- extensions/libipt_NETLINK.c	(revision 3656)
+++ extensions/libipt_NETLINK.c	(working copy)
@@ -32,7 +32,6 @@
 	
 	nld->flags=0;
 	
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* Parse command options */
Index: extensions/libipt_sctp.c
===================================================================
--- extensions/libipt_sctp.c	(revision 3656)
+++ extensions/libipt_sctp.c	(working copy)
@@ -293,7 +293,6 @@
 		if (invert)
 			einfo->invflags |= IPT_SCTP_SRC_PORTS;
 		*flags |= IPT_SCTP_SRC_PORTS;
-		*nfcache |= NFC_IP_SRC_PT;
 		break;
 
 	case '2':
@@ -306,7 +305,6 @@
 		if (invert)
 			einfo->invflags |= IPT_SCTP_DEST_PORTS;
 		*flags |= IPT_SCTP_DEST_PORTS;
-		*nfcache |= NFC_IP_DST_PT;
 		break;
 
 	case '3':
Index: extensions/libipt_u32.c
===================================================================
--- extensions/libipt_u32.c	(revision 3656)
+++ extensions/libipt_u32.c	(working copy)
@@ -37,13 +37,6 @@
 	{ 0 }
 };
 
-/* Initialize the match. */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	*nfcache |= NFC_UNKNOWN;
-}
-
 /* shared printing code */
 static void print_u32(struct ipt_u32 *data)
 {
@@ -257,7 +250,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_u32)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_u32)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libip6t_condition.c
===================================================================
--- extensions/libip6t_condition.c	(revision 3656)
+++ extensions/libip6t_condition.c	(working copy)
@@ -24,14 +24,6 @@
 	{ .name = 0 }
 };
 
-
-static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
-{
-	*nfcache |= NFC_UNKNOWN;
-}
-
-
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry, unsigned int *nfcache,
@@ -99,7 +91,6 @@
 	.size = IP6T_ALIGN(sizeof(struct condition6_info)),
 	.userspacesize = IP6T_ALIGN(sizeof(struct condition6_info)),
 	.help = &help,
-	.init = &init,
 	.parse = &parse,
 	.final_check = &final_check,
 	.print = &print,
Index: extensions/libip6t_eui64.c
===================================================================
--- extensions/libip6t_eui64.c	(revision 3656)
+++ extensions/libip6t_eui64.c	(working copy)
@@ -26,14 +26,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -71,7 +63,6 @@
 	.size		= IP6T_ALIGN(sizeof(int)),
 	.userspacesize	= IP6T_ALIGN(sizeof(int)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_record_rpc.c
===================================================================
--- extensions/libipt_record_rpc.c	(revision 3656)
+++ extensions/libipt_record_rpc.c	(working copy)
@@ -16,14 +16,6 @@
 	{0}
 };
 
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this. */
-	*nfcache |= NFC_UNKNOWN;
-}
-
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -53,19 +45,18 @@
 }
 
 static
-struct iptables_match record_rpc
-= { NULL,
-    "record_rpc",
-    IPTABLES_VERSION,
-    IPT_ALIGN(0),
-    IPT_ALIGN(0),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+struct iptables_match record_rpc = { 
+	.next		= NULL,
+	.name 		= "record_rpc",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(0),
+	.userspacesize	= IPT_ALIGN(0),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
 };
 
 void _init(void)
Index: extensions/libipt_rpc.c
===================================================================
--- extensions/libipt_rpc.c	(revision 3656)
+++ extensions/libipt_rpc.c	(working copy)
@@ -180,8 +180,6 @@
 	struct ipt_rpc_info *rpcinfo = ((struct ipt_rpc_info *)match->data);
 
 
-	/* caching not yet implemented */
-        *nfcache |= NFC_UNKNOWN;
 
 	/* initialise those funky user vars */
 	rpcinfo->i_procs = -1;
Index: extensions/libipt_SAME.c
===================================================================
--- extensions/libipt_SAME.c	(revision 3656)
+++ extensions/libipt_SAME.c	(working copy)
@@ -43,8 +43,6 @@
 	mr->info = 0;
 	mr->ipnum = 0;
 	
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* Parses range of IPs */
Index: extensions/libipt_condition.c
===================================================================
--- extensions/libipt_condition.c	(revision 3656)
+++ extensions/libipt_condition.c	(working copy)
@@ -24,14 +24,6 @@
 	{ .name = 0 }
 };
 
-
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	*nfcache |= NFC_UNKNOWN;
-}
-
-
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry, unsigned int *nfcache,
@@ -99,7 +91,6 @@
 	.size 		= IPT_ALIGN(sizeof(struct condition_info)),
 	.userspacesize 	= IPT_ALIGN(sizeof(struct condition_info)),
 	.help 		= &help,
-	.init 		= &init,
 	.parse 		= &parse,
 	.final_check	= &final_check,
 	.print 		= &print,
Index: extensions/libipt_icmp.c
===================================================================
--- extensions/libipt_icmp.c	(revision 3656)
+++ extensions/libipt_icmp.c	(working copy)
@@ -114,7 +114,7 @@
 	{0}
 };
 
-static unsigned int
+static void 
 parse_icmp(const char *icmptype, u_int8_t *type, u_int8_t code[])
 {
 	unsigned int limit = sizeof(icmp_codes)/sizeof(struct icmp_names);
@@ -165,10 +165,6 @@
 			code[1] = 0xFF;
 		}
 	}
-
-	if (code[0] == 0 && code[1] == 0xFF)
-		return NFC_IP_SRC_PT;
-	else return NFC_IP_SRC_PT | NFC_IP_DST_PT;
 }
 
 /* Initialize the match. */
@@ -194,9 +190,8 @@
 	switch (c) {
 	case '1':
 		check_inverse(optarg, &invert, &optind, 0);
-		*nfcache |= parse_icmp(argv[optind-1],
-				       &icmpinfo->type,
-				       icmpinfo->code);
+		parse_icmp(argv[optind-1], &icmpinfo->type, 
+			   icmpinfo->code);
 		if (invert)
 			icmpinfo->invflags |= IPT_ICMP_INV;
 		break;
Index: extensions/libipt_quota.c
===================================================================
--- extensions/libipt_quota.c	(revision 3656)
+++ extensions/libipt_quota.c	(working copy)
@@ -24,14 +24,6 @@
                " --quota quota			quota (bytes)\n" "\n");
 }
 
-/* initialise match */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-        /* no can cache */
-        *nfcache |= NFC_UNKNOWN;
-}
-
 /* print matchinfo */
 static void
 print(const struct ipt_ip *ip, const struct ipt_entry_match *match, int numeric)
@@ -100,7 +92,6 @@
 	.size		= IPT_ALIGN(sizeof (struct ipt_quota_info)),
 	.userspacesize	= IPT_ALIGN(sizeof (struct ipt_quota_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_string.c
===================================================================
--- extensions/libipt_string.c	(revision 3656)
+++ extensions/libipt_string.c	(working copy)
@@ -44,16 +44,7 @@
 	{ .name = 0 }
 };
 
-
-/* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	*nfcache |= NFC_UNKNOWN;
-}
-
-
-static void
 parse_string(const unsigned char *s, struct ipt_string_info *info)
 {	
 	if (strlen(s) <= BM_MAX_NLEN) strcpy(info->string, s);
@@ -279,7 +270,6 @@
     .size          = IPT_ALIGN(sizeof(struct ipt_string_info)),
     .userspacesize = IPT_ALIGN(sizeof(struct ipt_string_info)),
     .help          = &help,
-    .init          = &init,
     .parse         = &parse,
     .final_check   = &final_check,
     .print         = &print,
Index: extensions/libipt_ULOG.c
===================================================================
--- extensions/libipt_ULOG.c	(revision 3656)
+++ extensions/libipt_ULOG.c	(working copy)
@@ -60,8 +60,6 @@
 	loginfo->nl_group = ULOG_DEFAULT_NLGROUP;
 	loginfo->qthreshold = ULOG_DEFAULT_QTHRESHOLD;
 
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 #define IPT_LOG_OPT_NLGROUP 0x01
Index: extensions/libip6t_ipv6header.c
===================================================================
--- extensions/libip6t_ipv6header.c	(revision 3656)
+++ extensions/libip6t_ipv6header.c	(working copy)
@@ -162,8 +162,6 @@
 	info->matchflags = 0x00;
 	info->invflags = 0x00;
 	info->modeflag = 0x00;
-	/* No caching (yet) */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 static unsigned int
Index: extensions/libip6t_hl.c
===================================================================
--- extensions/libip6t_hl.c	(revision 3656)
+++ extensions/libip6t_hl.c	(working copy)
@@ -25,12 +25,6 @@
 , IPTABLES_VERSION);
 }
 
-static void init(struct ip6t_entry_match *m, unsigned int *nfcache)
-{
-	/* caching not yet implemented */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 static int parse(int c, char **argv, int invert, unsigned int *flags,
 		const struct ip6t_entry *entry, unsigned int *nfcache,
 		struct ip6t_entry_match **match)
@@ -141,7 +135,6 @@
 	.size          = IP6T_ALIGN(sizeof(struct ip6t_hl_info)),
 	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_hl_info)),
 	.help          = &help,
-	.init          = &init,
 	.parse         = &parse,
 	.final_check   = &final_check,
 	.print         = &print,
Index: extensions/libipt_dscp.c
===================================================================
--- extensions/libipt_dscp.c	(revision 3656)
+++ extensions/libipt_dscp.c	(working copy)
@@ -24,11 +24,6 @@
 /* This is evil, but it's my code - HW*/
 #include "libipt_dscp_helper.c"
 
-static void init(struct ipt_entry_match *m, unsigned int *nfcache) 
-{
-	*nfcache |= NFC_IP_TOS;
-}
-
 static void help(void) 
 {
 	printf(
@@ -164,7 +159,6 @@
 	.size 		= IPT_ALIGN(sizeof(struct ipt_dscp_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_dscp_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_mark.c
===================================================================
--- extensions/libipt_mark.c	(revision 3656)
+++ extensions/libipt_mark.c	(working copy)
@@ -25,14 +25,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this. */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -138,7 +130,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_mark_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_mark_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libip6t_icmpv6.c
===================================================================
--- extensions/libip6t_icmpv6.c	(revision 3656)
+++ extensions/libip6t_icmpv6.c	(working copy)
@@ -90,7 +90,7 @@
 	{0}
 };
 
-static unsigned int
+static void
 parse_icmpv6(const char *icmpv6type, u_int8_t *type, u_int8_t code[])
 {
 	unsigned int limit = sizeof(icmpv6_codes)/sizeof(struct icmpv6_names);
@@ -141,10 +141,6 @@
 			code[1] = 0xFF;
 		}
 	}
-
-	if (code[0] == 0 && code[1] == 0xFF)
-		return NFC_IP6_SRC_PT;
-	else return NFC_IP6_SRC_PT | NFC_IP6_DST_PT;
 }
 
 /* Initialize the match. */
@@ -169,9 +165,8 @@
 	switch (c) {
 	case '1':
 		check_inverse(optarg, &invert, &optind, 0);
-		*nfcache |= parse_icmpv6(argv[optind-1],
-				       &icmpv6info->type,
-				       icmpv6info->code);
+		parse_icmpv6(argv[optind-1], &icmpv6info->type, 
+			     icmpv6info->code);
 		if (invert)
 			icmpv6info->invflags |= IP6T_ICMP_INV;
 		break;
Index: extensions/libipt_time.c
===================================================================
--- extensions/libipt_time.c	(revision 3656)
+++ extensions/libipt_time.c	(working copy)
@@ -57,8 +57,6 @@
 {
 	struct ipt_time_info *info = (struct ipt_time_info *)m->data;
 	globaldays = 0;
-	/* caching not yet implemented */
-        *nfcache |= NFC_UNKNOWN;
         /* By default, we match on everyday */
 	info->days_match = 127;
 	/* By default, we match on every hour:min of the day */
Index: extensions/libipt_ipv4options.c
===================================================================
--- extensions/libipt_ipv4options.c	(revision 3656)
+++ extensions/libipt_ipv4options.c	(working copy)
@@ -35,14 +35,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* caching not yet implemented */
-        *nfcache |= NFC_UNKNOWN;
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -306,7 +298,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_ipv4options_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_ipv4options_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_comment.c
===================================================================
--- extensions/libipt_comment.c	(revision 3656)
+++ extensions/libipt_comment.c	(working copy)
@@ -29,14 +29,7 @@
 	{0}
 };
 
-/* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	*nfcache |= NFC_UNKNOWN;
-}
-
-static void
 parse_comment(const unsigned char *s, struct ipt_comment_info *info)
 {	
 	int slen = strlen(s);
@@ -113,7 +106,6 @@
     .size 		= IPT_ALIGN(sizeof(struct ipt_comment_info)),
     .userspacesize	= IPT_ALIGN(sizeof(struct ipt_comment_info)),
     .help		= &help,
-    .init 		= &init,
     .parse 		= &parse,
     .final_check 	= &final_check,
     .print 		= &print,
Index: extensions/libipt_pool.c
===================================================================
--- extensions/libipt_pool.c	(revision 3656)
+++ extensions/libipt_pool.c	(working copy)
@@ -43,8 +43,6 @@
 	info->src = IP_POOL_NONE;
 	info->dst = IP_POOL_NONE;
 	info->flags = 0;
-	/* Can't cache this - XXX */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* Function which parses command options; returns true if it ate an option */
Index: extensions/libipt_REJECT.c
===================================================================
--- extensions/libipt_REJECT.c	(revision 3656)
+++ extensions/libipt_REJECT.c	(working copy)
@@ -94,8 +94,6 @@
 	/* default */
 	reject->with = IPT_ICMP_PORT_UNREACHABLE;
 
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* Function which parses command options; returns true if it
Index: extensions/libipt_helper.c
===================================================================
--- extensions/libipt_helper.c	(revision 3656)
+++ extensions/libipt_helper.c	(working copy)
@@ -24,14 +24,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this. */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -96,7 +88,6 @@
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_helper_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libip6t_nth.c
===================================================================
--- extensions/libip6t_nth.c	(revision 3656)
+++ extensions/libip6t_nth.c	(working copy)
@@ -50,13 +50,6 @@
 	{ 0 }
 };
 
-/* Initialize the target. */
-static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
-{
-	*nfcache |= NFC_UNKNOWN;
-}
-
 #define IP6T_NTH_OPT_EVERY	0x01
 #define IP6T_NTH_OPT_NOT_EVERY	0x02
 #define IP6T_NTH_OPT_START	0x04
@@ -223,7 +216,6 @@
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_nth_info)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_nth_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_LOG.c
===================================================================
--- extensions/libipt_LOG.c	(revision 3656)
+++ extensions/libipt_LOG.c	(working copy)
@@ -50,8 +50,6 @@
 
 	loginfo->level = LOG_DEFAULT_LEVEL;
 
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 struct ipt_log_names {
Index: extensions/libipt_NETMAP.c
===================================================================
--- extensions/libipt_NETMAP.c	(revision 3656)
+++ extensions/libipt_NETMAP.c	(working copy)
@@ -63,8 +63,6 @@
 	/* Actually, it's 0, but it's ignored at the moment. */
 	mr->rangesize = 1;
 
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* Parses network address */
Index: extensions/libipt_BALANCE.c
===================================================================
--- extensions/libipt_BALANCE.c	(revision 3656)
+++ extensions/libipt_BALANCE.c	(working copy)
@@ -35,8 +35,6 @@
 	/* Actually, it's 0, but it's ignored at the moment. */
 	mr->rangesize = 1;
 
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* Parses range of IPs */
Index: extensions/libip6t_mac.c
===================================================================
--- extensions/libip6t_mac.c	(revision 3656)
+++ extensions/libip6t_mac.c	(working copy)
@@ -28,15 +28,7 @@
 	{0}
 };
 
-/* Initialize the match. */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
-}
-
-static void
 parse_mac(const char *mac, struct ip6t_mac_info *info)
 {
 	unsigned int i = 0;
@@ -134,7 +126,6 @@
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_mac_info)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_mac_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_udp.c
===================================================================
--- extensions/libipt_udp.c	(revision 3656)
+++ extensions/libipt_udp.c	(working copy)
@@ -109,7 +109,6 @@
 		if (invert)
 			udpinfo->invflags |= IPT_UDP_INV_SRCPT;
 		*flags |= UDP_SRC_PORTS;
-		*nfcache |= NFC_IP_SRC_PT;
 		break;
 
 	case '2':
@@ -121,7 +120,6 @@
 		if (invert)
 			udpinfo->invflags |= IPT_UDP_INV_DSTPT;
 		*flags |= UDP_DST_PORTS;
-		*nfcache |= NFC_IP_DST_PT;
 		break;
 
 	default:
Index: extensions/libipt_SET.c
===================================================================
--- extensions/libipt_SET.c	(revision 3656)
+++ extensions/libipt_SET.c	(working copy)
@@ -51,8 +51,6 @@
 	info->add_set.index =
 	info->del_set.index = IP_SET_INVALID_ID;
 
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 static void
Index: extensions/libip6t_limit.c
===================================================================
--- extensions/libip6t_limit.c	(revision 3656)
+++ extensions/libip6t_limit.c	(working copy)
@@ -81,8 +81,6 @@
 	parse_rate(IP6T_LIMIT_AVG, &r->avg);
 	r->burst = IP6T_LIMIT_BURST;
 
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* FIXME: handle overflow:
Index: extensions/libipt_ecn.c
===================================================================
--- extensions/libipt_ecn.c	(revision 3656)
+++ extensions/libipt_ecn.c	(working copy)
@@ -16,11 +16,6 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ecn.h>
 
-static void init(struct ipt_entry_match *m, unsigned int *nfcache) 
-{
-	*nfcache |= NFC_IP_TOS;
-}
-
 static void help(void) 
 {
 	printf(
@@ -163,7 +158,6 @@
     .size          = IPT_ALIGN(sizeof(struct ipt_ecn_info)),
     .userspacesize = IPT_ALIGN(sizeof(struct ipt_ecn_info)),
     .help          = &help,
-    .init          = &init,
     .parse         = &parse,
     .final_check   = &final_check,
     .print         = &print,
Index: extensions/libip6t_length.c
===================================================================
--- extensions/libip6t_length.c	(revision 3656)
+++ extensions/libip6t_length.c	(working copy)
@@ -26,13 +26,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
-{
-	*nfcache |= NFC_UNKNOWN;
-}
-
 static u_int16_t
 parse_length(const char *s)
 {
@@ -146,7 +139,6 @@
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_length_info)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_length_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_limit.c
===================================================================
--- extensions/libipt_limit.c	(revision 3656)
+++ extensions/libipt_limit.c	(working copy)
@@ -81,8 +81,6 @@
 	parse_rate(IPT_LIMIT_AVG, &r->avg);
 	r->burst = IPT_LIMIT_BURST;
 
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* FIXME: handle overflow:
Index: extensions/libip6t_mark.c
===================================================================
--- extensions/libip6t_mark.c	(revision 3656)
+++ extensions/libip6t_mark.c	(working copy)
@@ -25,14 +25,6 @@
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this. */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -137,7 +129,6 @@
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_mark_info)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_mark_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_iprange.c
===================================================================
--- extensions/libipt_iprange.c	(revision 3656)
+++ extensions/libipt_iprange.c	(working copy)
@@ -26,15 +26,7 @@
 	{0}
 };
 
-/* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this. */
-	*nfcache |= NFC_UNKNOWN;
-}
-
-static void
 parse_iprange(char *arg, struct ipt_iprange *range)
 {
 	char *dash;
@@ -180,7 +172,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ipt_iprange_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_iprange_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_tcp.c
===================================================================
--- extensions/libipt_tcp.c	(revision 3656)
+++ extensions/libipt_tcp.c	(working copy)
@@ -187,7 +187,6 @@
 		if (invert)
 			tcpinfo->invflags |= IPT_TCP_INV_SRCPT;
 		*flags |= TCP_SRC_PORTS;
-		*nfcache |= NFC_IP_SRC_PT;
 		break;
 
 	case '2':
@@ -199,7 +198,6 @@
 		if (invert)
 			tcpinfo->invflags |= IPT_TCP_INV_DSTPT;
 		*flags |= TCP_DST_PORTS;
-		*nfcache |= NFC_IP_DST_PT;
 		break;
 
 	case '3':
@@ -209,7 +207,6 @@
 				   " allowed");
 		parse_tcp_flags(tcpinfo, "SYN,RST,ACK", "SYN", invert);
 		*flags |= TCP_FLAGS;
-		*nfcache |= NFC_IP_TCPFLAGS;
 		break;
 
 	case '4':
@@ -228,7 +225,6 @@
 				invert);
 		optind++;
 		*flags |= TCP_FLAGS;
-		*nfcache |= NFC_IP_TCPFLAGS;
 		break;
 
 	case '5':
@@ -240,7 +236,6 @@
 		if (invert)
 			tcpinfo->invflags |= IPT_TCP_INV_OPTION;
 		*flags |= TCP_OPTION;
-		*nfcache |= NFC_IP_PROTO_UNKNOWN;
 		break;
 
 	default:
Index: extensions/libipt_DNAT.c
===================================================================
--- extensions/libipt_DNAT.c	(revision 3656)
+++ extensions/libipt_DNAT.c	(working copy)
@@ -33,14 +33,6 @@
 	{ 0 }
 };
 
-/* Initialize the target. */
-static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
-{
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 static struct ipt_natinfo *
 append_range(struct ipt_natinfo *info, const struct ip_nat_range *range)
 {
@@ -236,7 +228,6 @@
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: extensions/libipt_psd.c
===================================================================
--- extensions/libipt_psd.c	(revision 3656)
+++ extensions/libipt_psd.c	(working copy)
@@ -56,8 +56,6 @@
 	psdinfo->delay_threshold = SCAN_DELAY_THRESHOLD;
 	psdinfo->lo_ports_weight = PORT_WEIGHT_PRIV;
 	psdinfo->hi_ports_weight = PORT_WEIGHT_HIGH;
-	/* Can't cache this */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 
Index: extensions/libipt_osf.c
===================================================================
--- extensions/libipt_osf.c	(revision 3656)
+++ extensions/libipt_osf.c	(working copy)
@@ -54,13 +54,6 @@
 	{ .name = 0 }
 };
 
-
-static void init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-	*nfcache |= NFC_UNKNOWN;
-}
-
-
 static void parse_string(const unsigned char *s, struct ipt_osf_info *info)
 {
 	if (strlen(s) < MAXGENRELEN) 
@@ -142,7 +135,6 @@
     .size          = IPT_ALIGN(sizeof(struct ipt_osf_info)),
     .userspacesize = IPT_ALIGN(sizeof(struct ipt_osf_info)),
     .help          = &help,
-    .init          = &init,
     .parse         = &parse,
     .final_check   = &final_check,
     .print         = &print,
Index: ip6tables.c
===================================================================
--- ip6tables.c	(revision 3656)
+++ ip6tables.c	(working copy)
@@ -1887,7 +1887,6 @@
 			    && (fw.ipv6.invflags & IP6T_INV_PROTO))
 				exit_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
-			fw.nfcache |= NFC_IP6_PROTO;
 			break;
 
 		case 's':
@@ -1895,7 +1894,6 @@
 			set_option(&options, OPT_SOURCE, &fw.ipv6.invflags,
 				   invert);
 			shostnetworkmask = argv[optind-1];
-			fw.nfcache |= NFC_IP6_SRC;
 			break;
 
 		case 'd':
@@ -1903,7 +1901,6 @@
 			set_option(&options, OPT_DESTINATION, &fw.ipv6.invflags,
 				   invert);
 			dhostnetworkmask = argv[optind-1];
-			fw.nfcache |= NFC_IP6_DST;
 			break;
 
 		case 'j':
@@ -1935,7 +1932,6 @@
 			parse_interface(argv[optind-1],
 					fw.ipv6.iniface,
 					fw.ipv6.iniface_mask);
-			fw.nfcache |= NFC_IP6_IF_IN;
 			break;
 
 		case 'o':
@@ -1945,7 +1941,6 @@
 			parse_interface(argv[optind-1],
 					fw.ipv6.outiface,
 					fw.ipv6.outiface_mask);
-			fw.nfcache |= NFC_IP6_IF_OUT;
 			break;
 
 		case 'v':

--------------030503080105060003030600--
