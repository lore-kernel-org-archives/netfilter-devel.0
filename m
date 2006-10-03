From: =?iso-8859-1?q?R=E9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Subject: Re: [PATCH] iptables: ip6table version support and
	libip6t_multiport.fix
Date: Tue, 3 Oct 2006 22:58:28 +0300
Message-ID: <200610032258.30338@auguste.remlab.net>
References: <cd6061db0610011837u5c9419ecld21645cabab37661@mail.gmail.com>
	<200610021747.42658@auguste.remlab.net>
	<200610031430.k93EUJgA008197@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: ljlane@debian.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200610031430.k93EUJgA008197@toshiba.co.jp>
Content-Disposition: inline
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

Le mardi 3 octobre 2006 17:30, vous avez =E9crit :
> IPv4 multiport match (and policy match, too) would help you. It has
> the line
>
> 	#include ../../include/netfilter_ipv4/ipt_multiport.h
>
> and definitions for old kernel are included in the header.

Ok. This time there is no trace of (xt|XT)_ at all:

diff -Nru iptables-1.3.5.orig/extensions/libip6t_multiport.c=20
iptables-1.3.5/extensions/libip6t_multiport.c
=2D-- iptables-1.3.5.orig/extensions/libip6t_multiport.c	2005-02-19=20
21:19:17.000000000 +0200
+++ iptables-1.3.5/extensions/libip6t_multiport.c	2006-08-27=20
13:03:36.000000000 +0300
@@ -20,6 +20,23 @@
 " --dports ...\n"
 "				match destination port(s)\n"
 " --ports port[,port,port]\n"
+"				match both source and destination port(s)\n"
+" NOTE: this kernel does not support port ranges in multiport.\n",
+IPTABLES_VERSION);
+}
+
+static void
+help_v1(void)
+{
+	printf(
+"multiport v%s options:\n"
+" --source-ports [!] port[,port:port,port...]\n"
+" --sports ...\n"
+"				match source port(s)\n"
+" --destination-ports [!] port[,port:port,port...]\n"
+" --dports ...\n"
+"				match destination port(s)\n"
+" --ports [!] port[,port:port,port]\n"
 "				match both source and destination port(s)\n",
 IPTABLES_VERSION);
 }
@@ -49,7 +66,7 @@
 {
 	unsigned int portnum;
=20
=2D	if ((string_to_number(port, 0, 65535, &portnum)) !=3D -1 ||
+	if (string_to_number(port, 0, 65535, &portnum) !=3D -1 ||
 	    (portnum =3D service_to_port(port, proto)) !=3D -1)
 		return (u_int16_t)portnum;
=20
@@ -77,6 +94,46 @@
 	return i;
 }
=20
+static void
+parse_multi_ports_v1(const char *portstring,=20
+		     struct xt_multiport_v1 *multiinfo,
+		     const char *proto)
+{
+	char *buffer, *cp, *next, *range;
+	unsigned int i;
+	u_int16_t m;
+
+	buffer =3D strdup(portstring);
+	if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
+
+	for (i=3D0; i<XT_MULTI_PORTS; i++)
+		multiinfo->pflags[i] =3D 0;
+=20
+	for (cp=3Dbuffer, i=3D0; cp && i<XT_MULTI_PORTS; cp=3Dnext, i++) {
+		next=3Dstrchr(cp, ',');
+ 		if (next) *next++=3D'\0';
+		range =3D strchr(cp, ':');
+		if (range) {
+			if (i =3D=3D XT_MULTI_PORTS-1)
+				exit_error(PARAMETER_PROBLEM,
+					   "too many ports specified");
+			*range++ =3D '\0';
+		}
+		multiinfo->ports[i] =3D parse_port(cp, proto);
+		if (range) {
+			multiinfo->pflags[i] =3D 1;
+			multiinfo->ports[++i] =3D parse_port(range, proto);
+			if (multiinfo->ports[i-1] >=3D multiinfo->ports[i])
+				exit_error(PARAMETER_PROBLEM,
+					   "invalid portrange specified");
+			m <<=3D 1;
+		}
+ 	}
+	multiinfo->count =3D i;
+ 	if (cp) exit_error(PARAMETER_PROBLEM, "too many ports specified");
+ 	free(buffer);
+}
+
 /* Initialize the match. */
 static void
 init(struct ip6t_entry_match *m, unsigned int *nfcache)
@@ -150,6 +207,52 @@
 	return 1;
 }
=20
+static int
+parse_v1(int c, char **argv, int invert, unsigned int *flags,
+	 const struct ip6t_entry *entry,
+	 unsigned int *nfcache,
+	 struct ip6t_entry_match **match)
+{
+	const char *proto;
+	struct xt_multiport_v1 *multiinfo
+		=3D (struct xt_multiport_v1 *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
+		proto =3D check_proto(entry);
+		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
+		multiinfo->flags =3D IP6T_MULTIPORT_SOURCE;
+		break;
+
+	case '2':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
+		proto =3D check_proto(entry);
+		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
+		multiinfo->flags =3D IP6T_MULTIPORT_DESTINATION;
+		break;
+
+	case '3':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
+		proto =3D check_proto(entry);
+		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
+		multiinfo->flags =3D IP6T_MULTIPORT_EITHER;
+		break;
+
+	default:
+		return 0;
+	}
+
+	if (invert)
+		multiinfo->invert =3D 1;
+
+	if (*flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "multiport can only have one option");
+	*flags =3D 1;
+	return 1;
+}
+
 /* Final check; must specify something. */
 static void
 final_check(unsigned int flags)
@@ -218,6 +321,49 @@
 	printf(" ");
 }
=20
+static void
+print_v1(const struct ip6t_ip6 *ip,
+	 const struct ip6t_entry_match *match,
+	 int numeric)
+{
+	const struct xt_multiport_v1 *multiinfo
+		=3D (const struct xt_multiport_v1 *)match->data;
+	unsigned int i;
+
+	printf("multiport ");
+
+	switch (multiinfo->flags) {
+	case IP6T_MULTIPORT_SOURCE:
+		printf("sports ");
+		break;
+
+	case IP6T_MULTIPORT_DESTINATION:
+		printf("dports ");
+		break;
+
+	case IP6T_MULTIPORT_EITHER:
+		printf("ports ");
+		break;
+
+	default:
+		printf("ERROR ");
+		break;
+	}
+
+	if (multiinfo->invert)
+		printf("! ");
+
+	for (i=3D0; i < multiinfo->count; i++) {
+		printf("%s", i ? "," : "");
+		print_port(multiinfo->ports[i], ip->proto, numeric);
+		if (multiinfo->pflags[i]) {
+			printf(":");
+			print_port(multiinfo->ports[++i], ip->proto, numeric);
+		}
+	}
+	printf(" ");
+}
+
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
 static void save(const struct ip6t_ip6 *ip, const struct=20
ip6t_entry_match *match)
 {
@@ -246,6 +392,41 @@
 	printf(" ");
 }
=20
+static void save_v1(const struct ip6t_ip6 *ip,=20
+		    const struct ip6t_entry_match *match)
+{
+	const struct xt_multiport_v1 *multiinfo
+		=3D (const struct xt_multiport_v1 *)match->data;
+	unsigned int i;
+
+	switch (multiinfo->flags) {
+	case IP6T_MULTIPORT_SOURCE:
+		printf("--sports ");
+		break;
+
+	case IP6T_MULTIPORT_DESTINATION:
+		printf("--dports ");
+		break;
+
+	case IP6T_MULTIPORT_EITHER:
+		printf("--ports ");
+		break;
+	}
+
+	if (multiinfo->invert)
+		printf("! ");
+
+	for (i=3D0; i < multiinfo->count; i++) {
+		printf("%s", i ? "," : "");
+		print_port(multiinfo->ports[i], ip->proto, 1);
+		if (multiinfo->pflags[i]) {
+			printf(":");
+			print_port(multiinfo->ports[++i], ip->proto, 1);
+		}
+	}
+	printf(" ");
+}
+
 static struct ip6tables_match multiport =3D {
 	.name		=3D "multiport",
 	.version	=3D IPTABLES_VERSION,
@@ -260,8 +441,25 @@
 	.extra_opts	=3D opts,
 };
=20
+static struct ip6tables_match multiport_v1 =3D {=20
+	.next		=3D NULL,
+	.name		=3D "multiport",
+	.revision	=3D 1,
+	.version	=3D IPTABLES_VERSION,
+	.size		=3D IP6T_ALIGN(sizeof(struct xt_multiport_v1)),
+	.userspacesize	=3D IP6T_ALIGN(sizeof(struct xt_multiport_v1)),
+	.help		=3D &help_v1,
+	.init		=3D &init,
+	.parse		=3D &parse_v1,
+	.final_check	=3D &final_check,
+	.print		=3D &print_v1,
+	.save		=3D &save_v1,
+	.extra_opts	=3D opts
+};
+
 void
 _init(void)
 {
 	register_match6(&multiport);
+	register_match6(&multiport_v1);
 }
diff -Nru iptables-1.3.5.orig/include/ip6tables.h=20
iptables-1.3.5/include/ip6tables.h
=2D-- iptables-1.3.5.orig/include/ip6tables.h	2006-01-30=20
10:43:09.000000000 +0200
+++ iptables-1.3.5/include/ip6tables.h	2006-08-27 13:02:55.000000000=20
+0300
@@ -22,6 +22,9 @@
=20
 	ip6t_chainlabel name;
=20
+	/* Revision of match (0 by default). */
+	u_int8_t revision;
+
 	const char *version;
=20
 	/* Size of match data. */
diff -Nru iptables-1.3.5.orig/ip6tables.c iptables-1.3.5/ip6tables.c
=2D-- iptables-1.3.5.orig/ip6tables.c	2006-01-30 10:43:12.000000000 +0200
+++ iptables-1.3.5/ip6tables.c	2006-08-27 13:13:37.000000000 +0300
@@ -193,6 +193,8 @@
 const char *program_name;
 char *lib_dir;
=20
+int kernel_version;
+
 /* Keeping track of external matches and targets: linked lists.  */
 struct ip6tables_match *ip6tables_matches =3D NULL;
 struct ip6tables_target *ip6tables_targets =3D NULL;
@@ -1047,10 +1049,51 @@
 	return merge;
 }
=20
+static int compatible_revision(const char *name, u_int8_t revision, int=20
opt)
+{
+	struct ip6t_get_revision rev;
+	socklen_t s =3D sizeof(rev);
+	int max_rev, sockfd;
+
+	sockfd =3D socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
+	if (sockfd < 0) {
+		fprintf(stderr, "Could not open socket to kernel: %s\n",
+			strerror(errno));
+		exit(1);
+	}
+
+	strcpy(rev.name, name);
+	rev.revision =3D revision;
+
+	max_rev =3D getsockopt(sockfd, IPPROTO_IPV6, opt, &rev, &s);
+	if (max_rev < 0) {
+		/* Definitely don't support this? */
+		if (errno =3D=3D EPROTONOSUPPORT) {
+			close(sockfd);
+			return 0;
+		} else if (errno =3D=3D ENOPROTOOPT) {
+			close(sockfd);
+			/* Assume only revision 0 support (old kernel) */
+			return (revision =3D=3D 0);
+		} else {
+			fprintf(stderr, "getsockopt failed strangely: %s\n",
+				strerror(errno));
+			exit(1);
+		}
+	}
+	close(sockfd);
+	return 1;
+}
+
+static int compatible_match_revision(const char *name, u_int8_t=20
revision)
+{
+	return compatible_revision(name, revision,=20
IP6T_SO_GET_REVISION_MATCH);
+}
+
 void
 register_match6(struct ip6tables_match *me)
 {
=2D	struct ip6tables_match **i;
+	struct ip6tables_match **i, *old;
=20
 	if (strcmp(me->version, program_version) !=3D 0) {
 		fprintf(stderr, "%s: match `%s' v%s (I'm v%s).\n",
@@ -1058,12 +1101,36 @@
 		exit(1);
 	}
=20
=2D	if (find_match(me->name, DURING_LOAD, NULL)) {
=2D		fprintf(stderr, "%s: match `%s' already registered.\n",
+	/* Revision field stole a char from name. */
+	if (strlen(me->name) >=3D IP6T_FUNCTION_MAXNAMELEN-1) {
+		fprintf(stderr, "%s: target `%s' has invalid name\n",
 			program_name, me->name);
 		exit(1);
 	}
=20
+	old =3D find_match(me->name, DURING_LOAD, NULL);
+	if (old) {
+		if (old->revision =3D=3D me->revision) {
+			fprintf(stderr,
+				"%s: match `%s' already registered.\n",
+				program_name, me->name);
+			exit(1);
+		}
+
+		/* Now we have two (or more) options, check compatibility. */
+		if (compatible_match_revision(old->name, old->revision)
+		    && old->revision > me->revision)
+			return;
+
+		/* Replace if compatible. */
+		if (!compatible_match_revision(me->name, me->revision))
+			return;
+
+		/* Delete old one. */
+		for (i =3D &ip6tables_matches; *i!=3Dold; i =3D &(*i)->next);
+		*i =3D old->next;
+	}
+=09
 	if (me->size !=3D IP6T_ALIGN(me->size)) {
 		fprintf(stderr, "%s: match `%s' has invalid size %u.\n",
 			program_name, me->name, (unsigned int)me->size);
@@ -1700,6 +1767,14 @@
 	*matches =3D NULL;
 }
=20
+static void set_revision(char *name, u_int8_t revision)
+{
+	/* Old kernel sources don't have ".revision" field,
+	   but we stole a byte from name. */
+	name[IP6T_FUNCTION_MAXNAMELEN - 2] =3D '\0';
+	name[IP6T_FUNCTION_MAXNAMELEN - 1] =3D revision;
+}
+
 int do_command6(int argc, char *argv[], char **table, ip6tc_handle_t=20
*handle)
 {
 	struct ip6t_entry fw, *e =3D NULL;
@@ -1978,6 +2053,7 @@
 			m->m =3D fw_calloc(1, size);
 			m->m->u.match_size =3D size;
 			strcpy(m->m->u.user.name, m->name);
+			set_revision(m->m->u.user.name, m->revision);
 			if (m->init !=3D NULL)
 				m->init(m->m, &fw.nfcache);
 			opts =3D merge_options(opts, m->extra_opts, &m->option_offset);
@@ -2120,6 +2196,8 @@
 					m->m =3D fw_calloc(1, size);
 					m->m->u.match_size =3D size;
 					strcpy(m->m->u.user.name, m->name);
+					set_revision(m->m->u.user.name,
+						     m->revision);
 					if (m->init !=3D NULL)
 						m->init(m->m, &fw.nfcache);
=20

=2D-=20
R=E9mi Denis-Courmont
http://www.remlab.net/
