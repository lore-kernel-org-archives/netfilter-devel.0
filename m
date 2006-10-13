From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] iptables: ip6table version support and
 libip6t_multiport.fix
Date: Fri, 13 Oct 2006 09:50:44 +0900 (JST)
Message-ID: <200610130050.k9D0oj3O013113@toshiba.co.jp>
References: <200610032258.30338@auguste.remlab.net>
	<200610120811.k9C8B4Pg002384@toshiba.co.jp>
	<200610121729.36069@auguste.remlab.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Oct_13_09_50_44_2006_248)--"
Content-Transfer-Encoding: 7bit
Cc: ljlane@debian.org, netfilter-devel@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: rdenis@simphalempin.com
In-Reply-To: <200610121729.36069@auguste.remlab.net>
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

----Next_Part(Fri_Oct_13_09_50_44_2006_248)--
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable


Hello,

> Le jeudi 12 octobre 2006 11:11, Yasuyuki KOZAKAI a =E9crit :
> > ??? Did you send intended patch ? It includes XT_MULTI_PORTS as
> > folows.
> =

> Hmm, probably resent the old one accidentally then.
> =

> Sending the correct patch as attachment to avoid further breakages.

Thanks,

OK, I've update your patch (please see below comments in detail), and a=
lso
tested with kernel 2.4.33.3 and 2.6 linus tree and ip6tables build with=

headers in each of them.

If no objection, I'll commit the attached patch next week.

I appreciate if you tries to build with 2.4 kernel for such changes
from next time.


From: R=E9mi Denis-Courmont <rdenis@simphalempin.com>
Date: Thu, 12 Oct 2006 17:29:35 +0300

> Index: iptables/include/ip6tables.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- iptables/include/ip6tables.h	(r=C3=A9vision 6687)
> +++ iptables/include/ip6tables.h	(copie de travail)
> @@ -33,6 +33,9 @@
>  =

>  	ip6t_chainlabel name;
>  =

> +	/* Revision of match (0 by default). */
> +	u_int8_t revision;
> +
>  	const char *version;

The declaration for ip6t_get_revision is missing. That doesn't exist
in 2.4 kernel.

> Index: iptables/ip6tables.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- iptables/ip6tables.c	(r=C3=A9vision 6687)
> +++ iptables/ip6tables.c	(copie de travail)
> @@ -193,6 +193,8 @@
>  const char *program_name;
>  char *lib_dir;
>  =

> +int kernel_version;

This isn't used anywhere.

Regards,


----Next_Part(Fri_Oct_13_09_50_44_2006_248)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="multiport6.patch"

diff --git a/extensions/libip6t_multiport.c b/extensions/libip6t_multiport.c
index ed5fffe..166abce 100644
--- a/extensions/libip6t_multiport.c
+++ b/extensions/libip6t_multiport.c
@@ -5,7 +5,8 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <ip6tables.h>
-#include <linux/netfilter_ipv6/ip6t_multiport.h>
+/* To ensure that iptables compiles with an old kernel */
+#include "../include/linux/netfilter_ipv6/ip6t_multiport.h"
 
 /* Function which prints out usage message. */
 static void
@@ -20,6 +21,23 @@ help(void)
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
@@ -70,6 +88,46 @@ parse_multi_ports(const char *portstring
 	return i;
 }
 
+static void
+parse_multi_ports_v1(const char *portstring, 
+		     struct ip6t_multiport_v1 *multiinfo,
+		     const char *proto)
+{
+	char *buffer, *cp, *next, *range;
+	unsigned int i;
+	u_int16_t m;
+
+	buffer = strdup(portstring);
+	if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
+
+	for (i=0; i<IP6T_MULTI_PORTS; i++)
+		multiinfo->pflags[i] = 0;
+ 
+	for (cp=buffer, i=0; cp && i<IP6T_MULTI_PORTS; cp=next, i++) {
+		next=strchr(cp, ',');
+ 		if (next) *next++='\0';
+		range = strchr(cp, ':');
+		if (range) {
+			if (i == IP6T_MULTI_PORTS-1)
+				exit_error(PARAMETER_PROBLEM,
+					   "too many ports specified");
+			*range++ = '\0';
+		}
+		multiinfo->ports[i] = parse_port(cp, proto);
+		if (range) {
+			multiinfo->pflags[i] = 1;
+			multiinfo->ports[++i] = parse_port(range, proto);
+			if (multiinfo->ports[i-1] >= multiinfo->ports[i])
+				exit_error(PARAMETER_PROBLEM,
+					   "invalid portrange specified");
+			m <<= 1;
+		}
+ 	}
+	multiinfo->count = i;
+ 	if (cp) exit_error(PARAMETER_PROBLEM, "too many ports specified");
+ 	free(buffer);
+}
+
 /* Initialize the match. */
 static void
 init(struct ip6t_entry_match *m, unsigned int *nfcache)
@@ -143,6 +201,52 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
+static int
+parse_v1(int c, char **argv, int invert, unsigned int *flags,
+	 const struct ip6t_entry *entry,
+	 unsigned int *nfcache,
+	 struct ip6t_entry_match **match)
+{
+	const char *proto;
+	struct ip6t_multiport_v1 *multiinfo
+		= (struct ip6t_multiport_v1 *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
+		proto = check_proto(entry);
+		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
+		multiinfo->flags = IP6T_MULTIPORT_SOURCE;
+		break;
+
+	case '2':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
+		proto = check_proto(entry);
+		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
+		multiinfo->flags = IP6T_MULTIPORT_DESTINATION;
+		break;
+
+	case '3':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
+		proto = check_proto(entry);
+		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
+		multiinfo->flags = IP6T_MULTIPORT_EITHER;
+		break;
+
+	default:
+		return 0;
+	}
+
+	if (invert)
+		multiinfo->invert = 1;
+
+	if (*flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "multiport can only have one option");
+	*flags = 1;
+	return 1;
+}
+
 /* Final check; must specify something. */
 static void
 final_check(unsigned int flags)
@@ -210,6 +314,49 @@ print(const struct ip6t_ip6 *ip,
 	printf(" ");
 }
 
+static void
+print_v1(const struct ip6t_ip6 *ip,
+	 const struct ip6t_entry_match *match,
+	 int numeric)
+{
+	const struct ip6t_multiport_v1 *multiinfo
+		= (const struct ip6t_multiport_v1 *)match->data;
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
+	for (i=0; i < multiinfo->count; i++) {
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
 static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
 {
@@ -238,6 +385,41 @@ static void save(const struct ip6t_ip6 *
 	printf(" ");
 }
 
+static void save_v1(const struct ip6t_ip6 *ip, 
+		    const struct ip6t_entry_match *match)
+{
+	const struct ip6t_multiport_v1 *multiinfo
+		= (const struct ip6t_multiport_v1 *)match->data;
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
+	for (i=0; i < multiinfo->count; i++) {
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
 static struct ip6tables_match multiport = {
 	.name		= "multiport",
 	.version	= IPTABLES_VERSION,
@@ -252,8 +434,25 @@ static struct ip6tables_match multiport 
 	.extra_opts	= opts,
 };
 
+static struct ip6tables_match multiport_v1 = { 
+	.next		= NULL,
+	.name		= "multiport",
+	.revision	= 1,
+	.version	= IPTABLES_VERSION,
+	.size		= IP6T_ALIGN(sizeof(struct ip6t_multiport_v1)),
+	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_multiport_v1)),
+	.help		= &help_v1,
+	.init		= &init,
+	.parse		= &parse_v1,
+	.final_check	= &final_check,
+	.print		= &print_v1,
+	.save		= &save_v1,
+	.extra_opts	= opts
+};
+
 void
 _init(void)
 {
 	register_match6(&multiport);
+	register_match6(&multiport_v1);
 }
diff --git a/include/ip6tables.h b/include/ip6tables.h
index b1140b3..406f255 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -15,6 +15,18 @@
 #define IPPROTO_DCCP 33
 #endif
 
+#ifndef IP6T_SO_GET_REVISION_MATCH /* Old kernel source. */
+#define IP6T_SO_GET_REVISION_MATCH	(IP6T_BASE_CTL + 2)
+#define IP6T_SO_GET_REVISION_TARGET	(IP6T_BASE_CTL + 3)
+
+struct ip6t_get_revision
+{
+	char name[IP6T_FUNCTION_MAXNAMELEN-1];
+
+	u_int8_t revision;
+};
+#endif /* IP6T_SO_GET_REVISION_MATCH   Old kernel source */
+
 struct ip6tables_rule_match
 {
 	struct ip6tables_rule_match *next;
@@ -33,6 +45,9 @@ struct ip6tables_match
 
 	ip6t_chainlabel name;
 
+	/* Revision of match (0 by default). */
+	u_int8_t revision;
+
 	const char *version;
 
 	/* Size of match data. */
diff --git a/include/linux/netfilter_ipv6/ip6t_multiport.h b/include/linux/netfilter_ipv6/ip6t_multiport.h
new file mode 100644
index 0000000..8c2cc9d
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_multiport.h
@@ -0,0 +1,30 @@
+#ifndef _IP6T_MULTIPORT_H
+#define _IP6T_MULTIPORT_H
+
+enum ip6t_multiport_flags
+{
+	IP6T_MULTIPORT_SOURCE,
+	IP6T_MULTIPORT_DESTINATION,
+	IP6T_MULTIPORT_EITHER
+};
+
+#define IP6T_MULTI_PORTS	15
+
+/* Must fit inside union xt_matchinfo: 16 bytes */
+struct ip6t_multiport
+{
+	u_int8_t flags;				/* Type of comparison */
+	u_int8_t count;				/* Number of ports */
+	u_int16_t ports[IP6T_MULTI_PORTS];	/* Ports */
+};
+
+struct ip6t_multiport_v1
+{
+	u_int8_t flags;				/* Type of comparison */
+	u_int8_t count;				/* Number of ports */
+	u_int16_t ports[IP6T_MULTI_PORTS];	/* Ports */
+	u_int8_t pflags[IP6T_MULTI_PORTS];	/* Port flags */
+	u_int8_t invert;			/* Invert flag */
+};
+
+#endif /*_IP6T_MULTIPORT_H*/
diff --git a/ip6tables.c b/ip6tables.c
index 659041f..92e434c 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1102,10 +1102,51 @@ merge_options(struct option *oldopts, co
 	return merge;
 }
 
+static int compatible_revision(const char *name, u_int8_t revision, int opt)
+{
+	struct ip6t_get_revision rev;
+	socklen_t s = sizeof(rev);
+	int max_rev, sockfd;
+
+	sockfd = socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
+	if (sockfd < 0) {
+		fprintf(stderr, "Could not open socket to kernel: %s\n",
+			strerror(errno));
+		exit(1);
+	}
+
+	strcpy(rev.name, name);
+	rev.revision = revision;
+
+	max_rev = getsockopt(sockfd, IPPROTO_IPV6, opt, &rev, &s);
+	if (max_rev < 0) {
+		/* Definitely don't support this? */
+		if (errno == EPROTONOSUPPORT) {
+			close(sockfd);
+			return 0;
+		} else if (errno == ENOPROTOOPT) {
+			close(sockfd);
+			/* Assume only revision 0 support (old kernel) */
+			return (revision == 0);
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
+static int compatible_match_revision(const char *name, u_int8_t revision)
+{
+	return compatible_revision(name, revision, IP6T_SO_GET_REVISION_MATCH);
+}
+
 void
 register_match6(struct ip6tables_match *me)
 {
-	struct ip6tables_match **i;
+	struct ip6tables_match **i, *old;
 
 	if (strcmp(me->version, program_version) != 0) {
 		fprintf(stderr, "%s: match `%s' v%s (I'm v%s).\n",
@@ -1113,12 +1154,36 @@ register_match6(struct ip6tables_match *
 		exit(1);
 	}
 
-	if (find_match(me->name, DURING_LOAD, NULL)) {
-		fprintf(stderr, "%s: match `%s' already registered.\n",
+	/* Revision field stole a char from name. */
+	if (strlen(me->name) >= IP6T_FUNCTION_MAXNAMELEN-1) {
+		fprintf(stderr, "%s: target `%s' has invalid name\n",
 			program_name, me->name);
 		exit(1);
 	}
 
+	old = find_match(me->name, DURING_LOAD, NULL);
+	if (old) {
+		if (old->revision == me->revision) {
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
+		for (i = &ip6tables_matches; *i!=old; i = &(*i)->next);
+		*i = old->next;
+	}
+	
 	if (me->size != IP6T_ALIGN(me->size)) {
 		fprintf(stderr, "%s: match `%s' has invalid size %u.\n",
 			program_name, me->name, (unsigned int)me->size);
@@ -1761,6 +1826,14 @@ void clear_rule_matches(struct ip6tables
 	*matches = NULL;
 }
 
+static void set_revision(char *name, u_int8_t revision)
+{
+	/* Old kernel sources don't have ".revision" field,
+	   but we stole a byte from name. */
+	name[IP6T_FUNCTION_MAXNAMELEN - 2] = '\0';
+	name[IP6T_FUNCTION_MAXNAMELEN - 1] = revision;
+}
+
 int do_command6(int argc, char *argv[], char **table, ip6tc_handle_t *handle)
 {
 	struct ip6t_entry fw, *e = NULL;
@@ -2041,6 +2114,7 @@ int do_command6(int argc, char *argv[], 
 			m->m = fw_calloc(1, size);
 			m->m->u.match_size = size;
 			strcpy(m->m->u.user.name, m->name);
+			set_revision(m->m->u.user.name, m->revision);
 			if (m->init != NULL)
 				m->init(m->m, &fw.nfcache);
 			if (m != m->next)
@@ -2185,6 +2259,8 @@ int do_command6(int argc, char *argv[], 
 					m->m = fw_calloc(1, size);
 					m->m->u.match_size = size;
 					strcpy(m->m->u.user.name, m->name);
+					set_revision(m->m->u.user.name,
+						     m->revision);
 					if (m->init != NULL)
 						m->init(m->m, &fw.nfcache);
 

----Next_Part(Fri_Oct_13_09_50_44_2006_248)----
