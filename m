From: "Laurence J. Lane" <ljlane@debian.org>
Subject: Re: [PATCH] iptables: ip6table version support and
	libip6t_multiport.fix
Date: Sun, 1 Oct 2006 21:37:54 -0400
Message-ID: <cd6061db0610011837u5c9419ecld21645cabab37661@mail.gmail.com>
References: <cd6061db0609101806g45614b09t25b42dd510385de3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <cd6061db0609101806g45614b09t25b42dd510385de3@mail.gmail.com>
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

On 9/10/06, Laurence J. Lane <ljlane@debian.org> wrote:

> details: http://bugs.debian.org/329775
>
> The 329775-submitter@bugs.debian.org address reaches all
> interested Debian parties.
>
> R=E9mi Denis-Courmont has submitted a patch to that adds version support
> to ip6tables and updates libip6t_multiport to v1. (R=E9mi also posted to =
the
> list but something appears to have gone wrong.)
>
> It Works for Me.

I guess the list software ate the attachment.

diff -Nru iptables-1.3.5.orig/extensions/libip6t_multiport.c
iptables-1.3.5/extensions/libip6t_multiport.c
--- iptables-1.3.5.orig/extensions/libip6t_multiport.c=092005-02-19
21:19:17.000000000 +0200
+++ iptables-1.3.5/extensions/libip6t_multiport.c=092006-08-27
13:03:36.000000000 +0300
@@ -20,6 +20,23 @@
 " --dports ...\n"
 "=09=09=09=09match destination port(s)\n"
 " --ports port[,port,port]\n"
+"=09=09=09=09match both source and destination port(s)\n"
+" NOTE: this kernel does not support port ranges in multiport.\n",
+IPTABLES_VERSION);
+}
+
+static void
+help_v1(void)
+{
+=09printf(
+"multiport v%s options:\n"
+" --source-ports [!] port[,port:port,port...]\n"
+" --sports ...\n"
+"=09=09=09=09match source port(s)\n"
+" --destination-ports [!] port[,port:port,port...]\n"
+" --dports ...\n"
+"=09=09=09=09match destination port(s)\n"
+" --ports [!] port[,port:port,port]\n"
 "=09=09=09=09match both source and destination port(s)\n",
 IPTABLES_VERSION);
 }
@@ -49,7 +66,7 @@
 {
 =09unsigned int portnum;

-=09if ((string_to_number(port, 0, 65535, &portnum)) !=3D -1 ||
+=09if (string_to_number(port, 0, 65535, &portnum) !=3D -1 ||
 =09    (portnum =3D service_to_port(port, proto)) !=3D -1)
 =09=09return (u_int16_t)portnum;

@@ -77,6 +94,46 @@
 =09return i;
 }

+static void
+parse_multi_ports_v1(const char *portstring,
+=09=09     struct xt_multiport_v1 *multiinfo,
+=09=09     const char *proto)
+{
+=09char *buffer, *cp, *next, *range;
+=09unsigned int i;
+=09u_int16_t m;
+
+=09buffer =3D strdup(portstring);
+=09if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
+
+=09for (i=3D0; i<XT_MULTI_PORTS; i++)
+=09=09multiinfo->pflags[i] =3D 0;
+
+=09for (cp=3Dbuffer, i=3D0; cp && i<XT_MULTI_PORTS; cp=3Dnext, i++) {
+=09=09next=3Dstrchr(cp, ',');
+ =09=09if (next) *next++=3D'\0';
+=09=09range =3D strchr(cp, ':');
+=09=09if (range) {
+=09=09=09if (i =3D=3D XT_MULTI_PORTS-1)
+=09=09=09=09exit_error(PARAMETER_PROBLEM,
+=09=09=09=09=09   "too many ports specified");
+=09=09=09*range++ =3D '\0';
+=09=09}
+=09=09multiinfo->ports[i] =3D parse_port(cp, proto);
+=09=09if (range) {
+=09=09=09multiinfo->pflags[i] =3D 1;
+=09=09=09multiinfo->ports[++i] =3D parse_port(range, proto);
+=09=09=09if (multiinfo->ports[i-1] >=3D multiinfo->ports[i])
+=09=09=09=09exit_error(PARAMETER_PROBLEM,
+=09=09=09=09=09   "invalid portrange specified");
+=09=09=09m <<=3D 1;
+=09=09}
+ =09}
+=09multiinfo->count =3D i;
+ =09if (cp) exit_error(PARAMETER_PROBLEM, "too many ports specified");
+ =09free(buffer);
+}
+
 /* Initialize the match. */
 static void
 init(struct ip6t_entry_match *m, unsigned int *nfcache)
@@ -150,6 +207,52 @@
 =09return 1;
 }

+static int
+parse_v1(int c, char **argv, int invert, unsigned int *flags,
+=09 const struct ip6t_entry *entry,
+=09 unsigned int *nfcache,
+=09 struct ip6t_entry_match **match)
+{
+=09const char *proto;
+=09struct xt_multiport_v1 *multiinfo
+=09=09=3D (struct xt_multiport_v1 *)(*match)->data;
+
+=09switch (c) {
+=09case '1':
+=09=09check_inverse(argv[optind-1], &invert, &optind, 0);
+=09=09proto =3D check_proto(entry);
+=09=09parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
+=09=09multiinfo->flags =3D IP6T_MULTIPORT_SOURCE;
+=09=09break;
+
+=09case '2':
+=09=09check_inverse(argv[optind-1], &invert, &optind, 0);
+=09=09proto =3D check_proto(entry);
+=09=09parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
+=09=09multiinfo->flags =3D IP6T_MULTIPORT_DESTINATION;
+=09=09break;
+
+=09case '3':
+=09=09check_inverse(argv[optind-1], &invert, &optind, 0);
+=09=09proto =3D check_proto(entry);
+=09=09parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
+=09=09multiinfo->flags =3D IP6T_MULTIPORT_EITHER;
+=09=09break;
+
+=09default:
+=09=09return 0;
+=09}
+
+=09if (invert)
+=09=09multiinfo->invert =3D 1;
+
+=09if (*flags)
+=09=09exit_error(PARAMETER_PROBLEM,
+=09=09=09   "multiport can only have one option");
+=09*flags =3D 1;
+=09return 1;
+}
+
 /* Final check; must specify something. */
 static void
 final_check(unsigned int flags)
@@ -218,6 +321,49 @@
 =09printf(" ");
 }

+static void
+print_v1(const struct ip6t_ip6 *ip,
+=09 const struct ip6t_entry_match *match,
+=09 int numeric)
+{
+=09const struct xt_multiport_v1 *multiinfo
+=09=09=3D (const struct xt_multiport_v1 *)match->data;
+=09unsigned int i;
+
+=09printf("multiport ");
+
+=09switch (multiinfo->flags) {
+=09case IP6T_MULTIPORT_SOURCE:
+=09=09printf("sports ");
+=09=09break;
+
+=09case IP6T_MULTIPORT_DESTINATION:
+=09=09printf("dports ");
+=09=09break;
+
+=09case IP6T_MULTIPORT_EITHER:
+=09=09printf("ports ");
+=09=09break;
+
+=09default:
+=09=09printf("ERROR ");
+=09=09break;
+=09}
+
+=09if (multiinfo->invert)
+=09=09printf("! ");
+
+=09for (i=3D0; i < multiinfo->count; i++) {
+=09=09printf("%s", i ? "," : "");
+=09=09print_port(multiinfo->ports[i], ip->proto, numeric);
+=09=09if (multiinfo->pflags[i]) {
+=09=09=09printf(":");
+=09=09=09print_port(multiinfo->ports[++i], ip->proto, numeric);
+=09=09}
+=09}
+=09printf(" ");
+}
+
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
 static void save(const struct ip6t_ip6 *ip, const struct
ip6t_entry_match *match)
 {
@@ -246,6 +392,41 @@
 =09printf(" ");
 }

+static void save_v1(const struct ip6t_ip6 *ip,
+=09=09    const struct ip6t_entry_match *match)
+{
+=09const struct xt_multiport_v1 *multiinfo
+=09=09=3D (const struct xt_multiport_v1 *)match->data;
+=09unsigned int i;
+
+=09switch (multiinfo->flags) {
+=09case IP6T_MULTIPORT_SOURCE:
+=09=09printf("--sports ");
+=09=09break;
+
+=09case IP6T_MULTIPORT_DESTINATION:
+=09=09printf("--dports ");
+=09=09break;
+
+=09case IP6T_MULTIPORT_EITHER:
+=09=09printf("--ports ");
+=09=09break;
+=09}
+
+=09if (multiinfo->invert)
+=09=09printf("! ");
+
+=09for (i=3D0; i < multiinfo->count; i++) {
+=09=09printf("%s", i ? "," : "");
+=09=09print_port(multiinfo->ports[i], ip->proto, 1);
+=09=09if (multiinfo->pflags[i]) {
+=09=09=09printf(":");
+=09=09=09print_port(multiinfo->ports[++i], ip->proto, 1);
+=09=09}
+=09}
+=09printf(" ");
+}
+
 static struct ip6tables_match multiport =3D {
 =09.name=09=09=3D "multiport",
 =09.version=09=3D IPTABLES_VERSION,
@@ -260,8 +441,25 @@
 =09.extra_opts=09=3D opts,
 };

+static struct ip6tables_match multiport_v1 =3D {
+=09.next=09=09=3D NULL,
+=09.name=09=09=3D "multiport",
+=09.revision=09=3D 1,
+=09.version=09=3D IPTABLES_VERSION,
+=09.size=09=09=3D IP6T_ALIGN(sizeof(struct xt_multiport_v1)),
+=09.userspacesize=09=3D IP6T_ALIGN(sizeof(struct xt_multiport_v1)),
+=09.help=09=09=3D &help_v1,
+=09.init=09=09=3D &init,
+=09.parse=09=09=3D &parse_v1,
+=09.final_check=09=3D &final_check,
+=09.print=09=09=3D &print_v1,
+=09.save=09=09=3D &save_v1,
+=09.extra_opts=09=3D opts
+};
+
 void
 _init(void)
 {
 =09register_match6(&multiport);
+=09register_match6(&multiport_v1);
 }
diff -Nru iptables-1.3.5.orig/include/ip6tables.h
iptables-1.3.5/include/ip6tables.h
--- iptables-1.3.5.orig/include/ip6tables.h=092006-01-30 10:43:09.000000000=
 +0200
+++ iptables-1.3.5/include/ip6tables.h=092006-08-27 13:02:55.000000000 +030=
0
@@ -22,6 +22,9 @@

 =09ip6t_chainlabel name;

+=09/* Revision of match (0 by default). */
+=09u_int8_t revision;
+
 =09const char *version;

 =09/* Size of match data. */
diff -Nru iptables-1.3.5.orig/ip6tables.c iptables-1.3.5/ip6tables.c
--- iptables-1.3.5.orig/ip6tables.c=092006-01-30 10:43:12.000000000 +0200
+++ iptables-1.3.5/ip6tables.c=092006-08-27 13:13:37.000000000 +0300
@@ -193,6 +193,8 @@
 const char *program_name;
 char *lib_dir;

+int kernel_version;
+
 /* Keeping track of external matches and targets: linked lists.  */
 struct ip6tables_match *ip6tables_matches =3D NULL;
 struct ip6tables_target *ip6tables_targets =3D NULL;
@@ -1047,10 +1049,51 @@
 =09return merge;
 }

+static int compatible_revision(const char *name, u_int8_t revision, int op=
t)
+{
+=09struct ip6t_get_revision rev;
+=09socklen_t s =3D sizeof(rev);
+=09int max_rev, sockfd;
+
+=09sockfd =3D socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
+=09if (sockfd < 0) {
+=09=09fprintf(stderr, "Could not open socket to kernel: %s\n",
+=09=09=09strerror(errno));
+=09=09exit(1);
+=09}
+
+=09strcpy(rev.name, name);
+=09rev.revision =3D revision;
+
+=09max_rev =3D getsockopt(sockfd, IPPROTO_IPV6, opt, &rev, &s);
+=09if (max_rev < 0) {
+=09=09/* Definitely don't support this? */
+=09=09if (errno =3D=3D EPROTONOSUPPORT) {
+=09=09=09close(sockfd);
+=09=09=09return 0;
+=09=09} else if (errno =3D=3D ENOPROTOOPT) {
+=09=09=09close(sockfd);
+=09=09=09/* Assume only revision 0 support (old kernel) */
+=09=09=09return (revision =3D=3D 0);
+=09=09} else {
+=09=09=09fprintf(stderr, "getsockopt failed strangely: %s\n",
+=09=09=09=09strerror(errno));
+=09=09=09exit(1);
+=09=09}
+=09}
+=09close(sockfd);
+=09return 1;
+}
+
+static int compatible_match_revision(const char *name, u_int8_t revision)
+{
+=09return compatible_revision(name, revision, IP6T_SO_GET_REVISION_MATCH);
+}
+
 void
 register_match6(struct ip6tables_match *me)
 {
-=09struct ip6tables_match **i;
+=09struct ip6tables_match **i, *old;

 =09if (strcmp(me->version, program_version) !=3D 0) {
 =09=09fprintf(stderr, "%s: match `%s' v%s (I'm v%s).\n",
@@ -1058,12 +1101,36 @@
 =09=09exit(1);
 =09}

-=09if (find_match(me->name, DURING_LOAD, NULL)) {
-=09=09fprintf(stderr, "%s: match `%s' already registered.\n",
+=09/* Revision field stole a char from name. */
+=09if (strlen(me->name) >=3D IP6T_FUNCTION_MAXNAMELEN-1) {
+=09=09fprintf(stderr, "%s: target `%s' has invalid name\n",
 =09=09=09program_name, me->name);
 =09=09exit(1);
 =09}

+=09old =3D find_match(me->name, DURING_LOAD, NULL);
+=09if (old) {
+=09=09if (old->revision =3D=3D me->revision) {
+=09=09=09fprintf(stderr,
+=09=09=09=09"%s: match `%s' already registered.\n",
+=09=09=09=09program_name, me->name);
+=09=09=09exit(1);
+=09=09}
+
+=09=09/* Now we have two (or more) options, check compatibility. */
+=09=09if (compatible_match_revision(old->name, old->revision)
+=09=09    && old->revision > me->revision)
+=09=09=09return;
+
+=09=09/* Replace if compatible. */
+=09=09if (!compatible_match_revision(me->name, me->revision))
+=09=09=09return;
+
+=09=09/* Delete old one. */
+=09=09for (i =3D &ip6tables_matches; *i!=3Dold; i =3D &(*i)->next);
+=09=09*i =3D old->next;
+=09}
+=09
 =09if (me->size !=3D IP6T_ALIGN(me->size)) {
 =09=09fprintf(stderr, "%s: match `%s' has invalid size %u.\n",
 =09=09=09program_name, me->name, (unsigned int)me->size);
@@ -1700,6 +1767,14 @@
 =09*matches =3D NULL;
 }

+static void set_revision(char *name, u_int8_t revision)
+{
+=09/* Old kernel sources don't have ".revision" field,
+=09   but we stole a byte from name. */
+=09name[IP6T_FUNCTION_MAXNAMELEN - 2] =3D '\0';
+=09name[IP6T_FUNCTION_MAXNAMELEN - 1] =3D revision;
+}
+
 int do_command6(int argc, char *argv[], char **table, ip6tc_handle_t *hand=
le)
 {
 =09struct ip6t_entry fw, *e =3D NULL;
@@ -1978,6 +2053,7 @@
 =09=09=09m->m =3D fw_calloc(1, size);
 =09=09=09m->m->u.match_size =3D size;
 =09=09=09strcpy(m->m->u.user.name, m->name);
+=09=09=09set_revision(m->m->u.user.name, m->revision);
 =09=09=09if (m->init !=3D NULL)
 =09=09=09=09m->init(m->m, &fw.nfcache);
 =09=09=09opts =3D merge_options(opts, m->extra_opts, &m->option_offset);
@@ -2120,6 +2196,8 @@
 =09=09=09=09=09m->m =3D fw_calloc(1, size);
 =09=09=09=09=09m->m->u.match_size =3D size;
 =09=09=09=09=09strcpy(m->m->u.user.name, m->name);
+=09=09=09=09=09set_revision(m->m->u.user.name,
+=09=09=09=09=09=09     m->revision);
 =09=09=09=09=09if (m->init !=3D NULL)
 =09=09=09=09=09=09m->init(m->m, &fw.nfcache);
