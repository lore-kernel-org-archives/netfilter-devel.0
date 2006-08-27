From: =?utf-8?q?R=C3=A9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Subject: [PATCH] Support for IPv6 multiport ports range
Date: Sun, 27 Aug 2006 14:39:45 +0300
Message-ID: <200608271439.46183@auguste.remlab.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

	Hello,

While merging ipt_multiport and ip6t_multiport to xt_multiport in kernel=20
2.6.17, ip6t_multiport gained support for port ranges. However,=20
iptables userland does not currently support the feature.

The first patch adds revision matching support for match extensions in=20
ip6tables, and the second actually adds port range support to=20
libip6t_multiport.

=2D--- ip6tables-revision.patch ----
Index: include/ip6tables.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- include/ip6tables.h	(r=C3=A9vision 6665)
+++ include/ip6tables.h	(copie de travail)
@@ -33,6 +33,9 @@
=20
 	ip6t_chainlabel name;
=20
+	/* Revision of match (0 by default). */
+	u_int8_t revision;
+
 	const char *version;
=20
 	/* Size of match data. */
Index: ip6tables.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- ip6tables.c	(r=C3=A9vision 6665)
+++ ip6tables.c	(copie de travail)
@@ -193,6 +193,8 @@
 const char *program_name;
 char *lib_dir;
=20
+int kernel_version;
+
 /* Keeping track of external matches and targets: linked lists.  */
 struct ip6tables_match *ip6tables_matches =3D NULL;
 struct ip6tables_target *ip6tables_targets =3D NULL;
@@ -1102,10 +1104,51 @@
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
@@ -1113,12 +1156,36 @@
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
@@ -1761,6 +1828,14 @@
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
@@ -2041,6 +2116,7 @@
 			m->m =3D fw_calloc(1, size);
 			m->m->u.match_size =3D size;
 			strcpy(m->m->u.user.name, m->name);
+			set_revision(m->m->u.user.name, m->revision);
 			if (m->init !=3D NULL)
 				m->init(m->m, &fw.nfcache);
 			if (m !=3D m->next)
@@ -2185,6 +2261,8 @@
 					m->m =3D fw_calloc(1, size);
 					m->m->u.match_size =3D size;
 					strcpy(m->m->u.user.name, m->name);
+					set_revision(m->m->u.user.name,
+						     m->revision);
 					if (m->init !=3D NULL)
 						m->init(m->m, &fw.nfcache);
=20
=2D--- end ----
=2D--- ipv6-multiport-v1.patch ----
Index: extensions/libip6t_multiport.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- extensions/libip6t_multiport.c	(r=C3=A9vision 6665)
+++ extensions/libip6t_multiport.c	(copie de travail)
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
@@ -70,6 +87,46 @@
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
@@ -143,6 +200,52 @@
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
@@ -210,6 +313,49 @@
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
@@ -238,6 +384,41 @@
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
@@ -252,8 +433,25 @@
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
=2D--- end ----

Regards,

=2D-=20
R=C3=A9mi Denis-Courmont
http://www.remlab.net/
