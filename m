From: Bryan Cardillo <dillo+netfilter@seas.upenn.edu>
Subject: [PATCH] 0/3 pom expire
Date: Thu, 4 Aug 2005 11:55:12 -0400
Message-ID: <20050804155512.GA1975@home.seas.upenn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

        this series of patches fixes a bug in the rule deletion
        portion of the expire match in patch-o-matic.  also included
        in this patch is the addition of an option to delay rule
        deletion once a rule has expired, better time parsing, and
        general code cleanup (for better adherence to the
        recommended kernel coding style).

        I think there's a race condition if two entries expire at
        the same time, so this is definitely still a work in
        progress, I'll tackle that bug next.  at some point, we
        should discuss the alternate implementation suggested, that
        is, if anyone actually starts using this module.

        Cheers,
        Bryan Cardillo

 help                                   |    4=20
 iptables/extensions/libip6t_expire.c   |  233 +++++++++++++++++++-------=
-------
 iptables/extensions/libip6t_expire.man |   11 +
 iptables/extensions/libipt_expire.c    |  233 +++++++++++++++++++-------=
-------
 iptables/extensions/libipt_expire.man  |   11 +
 5 files changed, 302 insertions(+), 190 deletions(-)

Index: patchlets/expire/help
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/expire/help	(revision 4210)
+++ patchlets/expire/help	(working copy)
@@ -2,7 +2,7 @@
 your iptables ruleset which will later be removed automatically.
=20
 Usage:
-	-m expire --expiration [time]
+	-m expire --expires [time]
=20
 Example:
-	iptables ... -m expire --expiration +30 ...
+	iptables ... -m expire --expires 30s ...
Index: patchlets/expire/iptables/extensions/libip6t_expire.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/expire/iptables/extensions/libip6t_expire.man	(revision 421=
0)
+++ patchlets/expire/iptables/extensions/libip6t_expire.man	(working copy=
)
@@ -1,5 +1,14 @@
 This module matches until its expiration time.
 .TP
-.BI "--expiration " "[\fItime\fP]"
+.BI "--expires " "[\fItime\fP]"
 Match against the other rule criteria until the expiration time.  After
 the expiration time, the entire rule will be removed from the table.
+.TP
+.BI "--delay " "[\fItime\fP]"
+Delay the deletion of the rule for the specified time.
+
+Times may be specified as absolute times of the format MMDDhhmmss[YYYY],
+or as relative using an integer and optional units.  The following
+units are recognized: \fIyears\fP (year, y), \fImonths\fP (month, mon),
+\fIweeks\fP (week, w), \fIdays\fP (day, d), \fIhours\fP (hour, h),
+\fIminutes\fP (min, m), \fIseconds\fP (sec, s).
Index: patchlets/expire/iptables/extensions/libipt_expire.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/expire/iptables/extensions/libipt_expire.c	(revision 4210)
+++ patchlets/expire/iptables/extensions/libipt_expire.c	(working copy)
@@ -16,7 +16,7 @@
  *      59 Temple Place, Suite 330
  *      Boston, MA  02111-1307  USA
  *
- * Copyright =A9 2005 Bryan Cardillo <dillo@seas.upenn.edu>
+ * Copyright (c) 2005 Bryan Cardillo <dillo@seas.upenn.edu>
  */
=20
 #include <stdio.h>
@@ -28,143 +28,190 @@
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ipt_expire.h>
=20
-static void ipt_exp_help(void);
-static int ipt_exp_parse(int, char **, int, unsigned int *,
-		const struct ipt_entry *, unsigned int *,
-		struct ipt_entry_match **);
-static void ipt_exp_final_check(unsigned int);
-static void ipt_exp_print(const struct ipt_ip *,
-		const struct ipt_entry_match *, int);
-static void ipt_exp_save(const struct ipt_ip *, const struct ipt_entry_m=
atch *);
-
-/**
- * options
- */
 static struct option ipt_exp_opts[] =3D {
-	{ "expiration", 1, 0, 'e' },
+	{ "expires", 1, 0, 'e' },
+	{ "delay", 1, 0, 'd' },
 	{ 0 }
 };
=20
-/**
- * match
- */
-static struct iptables_match ipt_expire_match =3D {
-	.next =3D NULL,
-	.name =3D "expire",
-	.version =3D IPTABLES_VERSION,
-	.size =3D IPT_ALIGN(sizeof(struct ipt_exp_info)),
-	.userspacesize =3D IPT_ALIGN(sizeof(struct ipt_exp_info)),
-	.help =3D &ipt_exp_help,
-	.parse =3D &ipt_exp_parse,
-	.final_check =3D &ipt_exp_final_check,
-	.print =3D &ipt_exp_print,
-	.save =3D &ipt_exp_save,
-	.extra_opts =3D ipt_exp_opts
-};
-
-/**
- * shared library initialization
- * @see register_match()
- */
-void
-_init(void)
+static void
+help(void)
 {
-	register_match(&ipt_expire_match);
+    printf("EXPIRE match options\n"
+	   "  --expires TIME\t\t"
+	   "rule expires in TIME\n"
+	   "  --delay TIME\t\t\t"
+	   "rule deletion will be delayed TIME\n\n");
 }
=20
-/**
- * print usage information
- */
-static void
-ipt_exp_help(void)
+#define cmp(s1, s2) \
+	strncasecmp(s1, s2, sizeof(s1))
+
+static int
+parse_time(char *arg, time_t *t)
 {
-    printf("EXPIRE match options\n"
-           "  --expiration [+]TIME\t\t"
-	   "rule expires at [in] TIME\n\n");
+	int n;
+	struct tm tm_time, tm_now;
+	*t =3D time(NULL);
+	memset(&tm_time, 0, sizeof(tm_time));
+	memcpy(&tm_now, localtime(t), sizeof(tm_now));
+=09
+	n =3D sscanf(arg, "%2d%2d%2d%2d%2d%d",
+			&tm_time.tm_mon, &tm_time.tm_mday,
+			&tm_time.tm_hour, &tm_time.tm_min,
+			&tm_time.tm_sec, &tm_time.tm_year);
+	switch (n) {
+		case 6:
+			tm_time.tm_year =3D tm_now.tm_year;
+		case 5:
+			tm_time.tm_isdst =3D tm_now.tm_isdst;
+			tm_time.tm_mon--;
+			break;
+		default: {
+			int i;
+			memcpy(&tm_time, &tm_now, sizeof(tm_time));
+			if (!sscanf(arg, "%d%n", &i, &n))
+				return -1;
+			arg +=3D n;
+			if (!cmp("y", arg) || !cmp("year", arg) ||
+					!cmp("years", arg))
+				tm_time.tm_year +=3D i;
+			else if (!cmp("mon", arg) || !cmp("month", arg) ||
+					!cmp("months", arg))
+				tm_time.tm_mon +=3D i;
+			else if (!cmp("w", arg) || !cmp("week", arg) ||
+					!cmp("weeks", arg))
+				tm_time.tm_mday +=3D i * 7;
+			else if (!cmp("d", arg) || !cmp("day", arg) ||
+					!cmp("days", arg))
+				tm_time.tm_mday +=3D i;
+			else if (!cmp("h", arg) || !cmp("hour", arg) ||
+					!cmp("hours", arg))
+				tm_time.tm_hour +=3D i;
+			else if (!cmp("m", arg) || !cmp("min", arg) ||
+					!cmp("minutes", arg))
+				tm_time.tm_min +=3D i;
+			else if (!cmp("s", arg) || !cmp("sec", arg) ||
+					!cmp("seconds", arg))
+				tm_time.tm_sec +=3D i;
+			else
+				return -1;
+			break;
+		}
+	}
+	if (tm_time.tm_year >=3D 1900)
+		tm_time.tm_year -=3D 1900;
+	*t =3D mktime(&tm_time);
+	return 0;
 }
=20
-/**
- * parse module specific options
- * @param c the short option character
- * @param argv the arguments array
- * @param invert is this an inverted argument
- * @param flags module specific flags
- * @param entry the entry
- * @param nfcache netfilter cache flags
- * @param match the match
- * @return zero if an option was found, non-zero otherwise
- */
 static int
-ipt_exp_parse(int c, char **argv, int invert, unsigned int *flags,
+parse(int c, char **argv, int invert, unsigned int *flags,
 	const struct ipt_entry *entry, unsigned int *nfcache,
 	struct ipt_entry_match **match)
 {
-	char *arg;
+	char *arg =3D argv[optind - 1];
 	struct ipt_exp_info *info;
 =09
 	info =3D (struct ipt_exp_info *)(*match)->data;
-	info->expiration =3D 0;
+	info->expires =3D 0;
+	info->delay =3D 0;
+
+	check_inverse(arg, &invert, &optind, 0);
+
 	switch (c) {
 		case 'e':
-			arg =3D argv[optind-1];
-			check_inverse(arg, &invert, &optind, 0);
 			if (invert)
 				exit_error(PARAMETER_PROBLEM,
-					"--expiration cannot be inverted");
-                        if (*arg =3D=3D '+')
-				arg++;
-			if (string_to_number_l(
-					arg, 1, 0, &info->expiration) < 0)
+					"--expires cannot be inverted");
+			if (parse_time(arg, &info->expires))
 				exit_error(PARAMETER_PROBLEM,
-					"invalid expiration time");
+					"invalid expiration");
+			if (info->expires <=3D 0)
+				exit_error(PARAMETER_PROBLEM,
+					"expiration has past");
 			*flags =3D 1;
-			if (*argv[optind-1] =3D=3D '+')
-				info->expiration +=3D time(NULL);
 			break;
+		case 'd':
+			if (invert)
+				exit_error(PARAMETER_PROBLEM,
+					"--delay cannot be inverted");
+			if (parse_time(arg, &info->delay))
+				exit_error(PARAMETER_PROBLEM, "invalid delay");
+			break;
 		default:
 			return 0;
 	}
+
 	return 1;
 }
=20
-/**
- * ensures an expiration was specified
- * @param flags module specific flags from options parsing
- */
 static void
-ipt_exp_final_check(unsigned int flags)
+final_check(unsigned int flags)
 {
 	if (flags !=3D 1)
 		exit_error(PARAMETER_PROBLEM,
-			"you must specify an expiration time (--expiration)");
+			"you must specify an expiration time (--expires)");
 }
=20
-/**
- * print information about an expiring match
- * in a format suitable for viewing
- * @param ip the address information
- * @param match the match
- * @param numeric the verbose level (?)
- */
 static void
-ipt_exp_print(const struct ipt_ip *ip,
+print(const struct ipt_ip *ip,
 	const struct ipt_entry_match *match, int numeric)
 {
+	double t;
+	char *units;
 	struct ipt_exp_info *info;
 	info =3D (struct ipt_exp_info *)match->data;
-	printf("expires in %lds ", info->expiration - time(NULL));
+	t =3D (double)(info->expires - time(NULL));
+	if (t < 60) {
+		units =3D "s";
+	} else if (t < 60 * 60) {
+		t /=3D 60;
+		units =3D "m";
+	} else if (t < 60 * 60 * 60) {
+		t /=3D (60 * 60);
+		units =3D "h";
+	} else if (t < 60 * 60 * 60 * 24) {
+		t /=3D (60 * 60 * 60);
+		units =3D "d";
+	} else if (t < 60 * 60 * 60 * 24 * 365) {
+		t /=3D (60 * 60 * 60 * 24);
+		units =3D "mon";
+	} else {
+		t /=3D (60 * 60 * 60 * 24 * 365);
+		units =3D "y";
+	}
+	printf("expires in %0.1f%s", t, units);
 }
=20
-/**
- * print information about an expiring match
- * in a format suitable for reconstructing the match
- * @param ip the address information
- * @param match the match
- */
 static void
-ipt_exp_save(const struct ipt_ip *ip, const struct ipt_entry_match *matc=
h)
+save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
 {
 	struct ipt_exp_info *info;
+	struct tm *t;
 	info =3D (struct ipt_exp_info *)match->data;
-	printf("-m expire --expiration %ld ", info->expiration);
+	t =3D localtime(&info->expires);
+	printf("-m expire --expires %02d%02d%02d%02d%02d%04d",
+		t->tm_mon + 1, t->tm_mday, t->tm_hour,
+		t->tm_min, t->tm_sec, t->tm_year + 1900);
 }
+
+static struct iptables_match ipt_expire_match =3D {
+	.next =3D NULL,
+	.name =3D "expire",
+	.version =3D IPTABLES_VERSION,
+	.size =3D IPT_ALIGN(sizeof(struct ipt_exp_info)),
+	.userspacesize =3D IPT_ALIGN(sizeof(struct ipt_exp_info)),
+	.help =3D &help,
+	.parse =3D &parse,
+	.final_check =3D &final_check,
+	.print =3D &print,
+	.save =3D &save,
+	.extra_opts =3D ipt_exp_opts
+};
+
+void
+_init(void)
+{
+	register_match(&ipt_expire_match);
+}
Index: patchlets/expire/iptables/extensions/libip6t_expire.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/expire/iptables/extensions/libip6t_expire.c	(revision 4210)
+++ patchlets/expire/iptables/extensions/libip6t_expire.c	(working copy)
@@ -16,7 +16,7 @@
  *      59 Temple Place, Suite 330
  *      Boston, MA  02111-1307  USA
  *
- * Copyright =A9 2005 Bryan Cardillo <dillo@seas.upenn.edu>
+ * Copyright (c) 2005 Bryan Cardillo <dillo@seas.upenn.edu>
  */
=20
 #include <stdio.h>
@@ -28,143 +28,190 @@
 #include <ip6tables.h>
 #include <linux/netfilter_ipv6/ip6t_expire.h>
=20
-static void ip6t_exp_help(void);
-static int ip6t_exp_parse(int, char **, int, unsigned int *,
-		const struct ip6t_entry *, unsigned int *,
-		struct ip6t_entry_match **);
-static void ip6t_exp_final_check(unsigned int);
-static void ip6t_exp_print(const struct ip6t_ip *,
-		const struct ip6t_entry_match *, int);
-static void ip6t_exp_save(const struct ip6t_ip *, const struct ip6t_entr=
y_match *);
-
-/**
- * options
- */
 static struct option ip6t_exp_opts[] =3D {
-	{ "expiration", 1, 0, 'e' },
+	{ "expires", 1, 0, 'e' },
+	{ "delay", 1, 0, 'd' },
 	{ 0 }
 };
=20
-/**
- * match
- */
-static struct iptables_match ip6t_expire_match =3D {
-	.next =3D NULL,
-	.name =3D "expire",
-	.version =3D IPTABLES_VERSION,
-	.size =3D IP6T_ALIGN(sizeof(struct ip6t_exp_info)),
-	.userspacesize =3D IP6T_ALIGN(sizeof(struct ip6t_exp_info)),
-	.help =3D &ip6t_exp_help,
-	.parse =3D &ip6t_exp_parse,
-	.final_check =3D &ip6t_exp_final_check,
-	.print =3D &ip6t_exp_print,
-	.save =3D &ip6t_exp_save,
-	.extra_opts =3D ip6t_exp_opts
-};
-
-/**
- * shared library initialization
- * @see register_match()
- */
-void
-_init(void)
+static void
+help(void)
 {
-	register_match(&ip6t_expire_match);
+    printf("EXPIRE match options\n"
+	   "  --expires TIME\t\t"
+	   "rule expires in TIME\n"
+	   "  --delay TIME\t\t\t"
+	   "rule deletion will be delayed TIME\n\n");
 }
=20
-/**
- * print usage information
- */
-static void
-ip6t_exp_help(void)
+#define cmp(s1, s2) \
+	strncasecmp(s1, s2, sizeof(s1))
+
+static int
+parse_time(char *arg, time_t *t)
 {
-    printf("EXPIRE match options\n"
-           "  --expiration [+]TIME\t\t"
-	   "rule expires at [in] TIME\n\n");
+	int n;
+	struct tm tm_time, tm_now;
+	*t =3D time(NULL);
+	memset(&tm_time, 0, sizeof(tm_time));
+	memcpy(&tm_now, localtime(t), sizeof(tm_now));
+=09
+	n =3D sscanf(arg, "%2d%2d%2d%2d%2d%d",
+			&tm_time.tm_mon, &tm_time.tm_mday,
+			&tm_time.tm_hour, &tm_time.tm_min,
+			&tm_time.tm_sec, &tm_time.tm_year);
+	switch (n) {
+		case 6:
+			tm_time.tm_year =3D tm_now.tm_year;
+		case 5:
+			tm_time.tm_isdst =3D tm_now.tm_isdst;
+			tm_time.tm_mon--;
+			break;
+		default: {
+			int i;
+			memcpy(&tm_time, &tm_now, sizeof(tm_time));
+			if (!sscanf(arg, "%d%n", &i, &n))
+				return -1;
+			arg +=3D n;
+			if (!cmp("y", arg) || !cmp("year", arg) ||
+					!cmp("years", arg))
+				tm_time.tm_year +=3D i;
+			else if (!cmp("mon", arg) || !cmp("month", arg) ||
+					!cmp("months", arg))
+				tm_time.tm_mon +=3D i;
+			else if (!cmp("w", arg) || !cmp("week", arg) ||
+					!cmp("weeks", arg))
+				tm_time.tm_mday +=3D i * 7;
+			else if (!cmp("d", arg) || !cmp("day", arg) ||
+					!cmp("days", arg))
+				tm_time.tm_mday +=3D i;
+			else if (!cmp("h", arg) || !cmp("hour", arg) ||
+					!cmp("hours", arg))
+				tm_time.tm_hour +=3D i;
+			else if (!cmp("m", arg) || !cmp("min", arg) ||
+					!cmp("minutes", arg))
+				tm_time.tm_min +=3D i;
+			else if (!cmp("s", arg) || !cmp("sec", arg) ||
+					!cmp("seconds", arg))
+				tm_time.tm_sec +=3D i;
+			else
+				return -1;
+			break;
+		}
+	}
+	if (tm_time.tm_year >=3D 1900)
+		tm_time.tm_year -=3D 1900;
+	*t =3D mktime(&tm_time);
+	return 0;
 }
=20
-/**
- * parse module specific options
- * @param c the short option character
- * @param argv the arguments array
- * @param invert is this an inverted argument
- * @param flags module specific flags
- * @param entry the entry
- * @param nfcache netfilter cache flags
- * @param match the match
- * @return zero if an option was found, non-zero otherwise
- */
 static int
-ip6t_exp_parse(int c, char **argv, int invert, unsigned int *flags,
+parse(int c, char **argv, int invert, unsigned int *flags,
 	const struct ip6t_entry *entry, unsigned int *nfcache,
 	struct ip6t_entry_match **match)
 {
-	char *arg;
+	char *arg =3D argv[optind - 1];
 	struct ip6t_exp_info *info;
 =09
 	info =3D (struct ip6t_exp_info *)(*match)->data;
-	info->expiration =3D 0;
+	info->expires =3D 0;
+	info->delay =3D 0;
+
+	check_inverse(arg, &invert, &optind, 0);
+
 	switch (c) {
 		case 'e':
-			arg =3D argv[optind-1];
-			check_inverse(arg, &invert, &optind, 0);
 			if (invert)
 				exit_error(PARAMETER_PROBLEM,
-					"--expiration cannot be inverted");
-                        if (*arg =3D=3D '+')
-				arg++;
-			if (string_to_number_l(
-					arg, 1, 0, &info->expiration) < 0)
+					"--expires cannot be inverted");
+			if (parse_time(arg, &info->expires))
 				exit_error(PARAMETER_PROBLEM,
-					"invalid expiration time");
+					"invalid expiration");
+			if (info->expires <=3D 0)
+				exit_error(PARAMETER_PROBLEM,
+					"expiration has past");
 			*flags =3D 1;
-			if (*argv[optind-1] =3D=3D '+')
-				info->expiration +=3D time(NULL);
 			break;
+		case 'd':
+			if (invert)
+				exit_error(PARAMETER_PROBLEM,
+					"--delay cannot be inverted");
+			if (parse_time(arg, &info->delay))
+				exit_error(PARAMETER_PROBLEM, "invalid delay");
+			break;
 		default:
 			return 0;
 	}
+
 	return 1;
 }
=20
-/**
- * ensures an expiration was specified
- * @param flags module specific flags from options parsing
- */
 static void
-ip6t_exp_final_check(unsigned int flags)
+final_check(unsigned int flags)
 {
 	if (flags !=3D 1)
 		exit_error(PARAMETER_PROBLEM,
-			"you must specify an expiration time (--expiration)");
+			"you must specify an expiration time (--expires)");
 }
=20
-/**
- * print information about an expiring match
- * in a format suitable for viewing
- * @param ip the address information
- * @param match the match
- * @param numeric the verbose level (?)
- */
 static void
-ip6t_exp_print(const struct ip6t_ip *ip,
+print(const struct ip6t_ip6 *ip,
 	const struct ip6t_entry_match *match, int numeric)
 {
+	double t;
+	char *units;
 	struct ip6t_exp_info *info;
 	info =3D (struct ip6t_exp_info *)match->data;
-	printf("expires in %lds ", info->expiration - time(NULL));
+	t =3D (double)(info->expires - time(NULL));
+	if (t < 60) {
+		units =3D "s";
+	} else if (t < 60 * 60) {
+		t /=3D 60;
+		units =3D "m";
+	} else if (t < 60 * 60 * 60) {
+		t /=3D (60 * 60);
+		units =3D "h";
+	} else if (t < 60 * 60 * 60 * 24) {
+		t /=3D (60 * 60 * 60);
+		units =3D "d";
+	} else if (t < 60 * 60 * 60 * 24 * 365) {
+		t /=3D (60 * 60 * 60 * 24);
+		units =3D "mon";
+	} else {
+		t /=3D (60 * 60 * 60 * 24 * 365);
+		units =3D "y";
+	}
+	printf("expires in %0.1f %s", t, units);
 }
=20
-/**
- * print information about an expiring match
- * in a format suitable for reconstructing the match
- * @param ip the address information
- * @param match the match
- */
 static void
-ip6t_exp_save(const struct ip6t_ip *ip, const struct ip6t_entry_match *m=
atch)
+save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
 {
 	struct ip6t_exp_info *info;
+	struct tm *t;
 	info =3D (struct ip6t_exp_info *)match->data;
-	printf("-m expire --expiration %ld ", info->expiration);
+	t =3D localtime(&info->expires);
+	printf("-m expire --expires %02d%02d%02d%02d%02d%04d",
+		t->tm_mon + 1, t->tm_mday, t->tm_hour,
+		t->tm_min, t->tm_sec, t->tm_year + 1900);
 }
+
+static struct ip6tables_match ip6t_expire_match =3D {
+	.next =3D NULL,
+	.name =3D "expire",
+	.version =3D IPTABLES_VERSION,
+	.size =3D IP6T_ALIGN(sizeof(struct ip6t_exp_info)),
+	.userspacesize =3D IP6T_ALIGN(sizeof(struct ip6t_exp_info)),
+	.help =3D &help,
+	.parse =3D &parse,
+	.final_check =3D &final_check,
+	.print =3D &print,
+	.save =3D &save,
+	.extra_opts =3D ip6t_exp_opts
+};
+
+void
+_init(void)
+{
+	register_match6(&ip6t_expire_match);
+}
Index: patchlets/expire/iptables/extensions/libipt_expire.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/expire/iptables/extensions/libipt_expire.man	(revision 4210=
)
+++ patchlets/expire/iptables/extensions/libipt_expire.man	(working copy)
@@ -1,5 +1,14 @@
 This module matches until its expiration time.
 .TP
-.BI "--expiration " "[\fItime\fP]"
+.BI "--expires " "[\fItime\fP]"
 Match against the other rule criteria until the expiration time.  After
 the expiration time, the entire rule will be removed from the table.
+.TP
+.BI "--delay " "[\fItime\fP]"
+Delay the deletion of the rule for the specified time.
+
+Times may be specified as absolute times of the format MMDDhhmmss[YYYY],
+or as relative using an integer and optional units.  The following
+units are recognized: \fIyears\fP (year, y), \fImonths\fP (month, mon),
+\fIweeks\fP (week, w), \fIdays\fP (day, d), \fIhours\fP (hour, h),
+\fIminutes\fP (min, m), \fIseconds\fP (sec, s).
