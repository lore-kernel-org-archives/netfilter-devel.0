From: Simon Lodal <simon@parknet.dk>
Subject: Re: [PATCH] Named realm - updated
Date: Sat, 2 Sep 2006 01:27:40 +0200
Message-ID: <200609020127.40248.simon@parknet.dk>
References: <200606042135.49361.simonl@parknet.dk> <4496C7B8.5020006@trash.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_sHM+EcWdeurEo2P"
Cc: Netfilter Developer <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4496C7B8.5020006@trash.net>
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

--Boundary-00=_sHM+EcWdeurEo2P
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Ok, here is a new version.


On Monday 19 June 2006 17:50, Patrick McHardy wrote:
> Simon Lodal wrote:
> > Make the realm match accept named realms, defined in
> > /etc/iproute2/rt_realms.
> >
> > First sent 2006-05-21, improved since then:
> > - Only load rt_realms once, keep in memory.
> > - Output realm by name if it was originally specified that way, except if
> > iptables -n.
>
> Thanks. I still have a few points before we can merge this, please
> see below.
>
> > ------------------------------------------------------------------------
> >
> > Index: linux-2.6/include/linux/netfilter/xt_realm.h
> > ===================================================================
> > --- linux-2.6/include/linux/netfilter/xt_realm.h	(revision 44)
> > +++ linux-2.6/include/linux/netfilter/xt_realm.h	(revision 45)
> > @@ -5,6 +5,7 @@
> >  	u_int32_t id;
> >  	u_int32_t mask;
> >  	u_int8_t invert;
> > +	u_int8_t is_named_realm;
>
> No no no :) This breaks compatibility (well, it does not due to
> structure padding, but still, structures shared between kernel and
> userspace should be considered untouchable). Names are to be shown
> when numeric == 0, otherwise not. It doesn't matter in which format
> the user specified the rule.

The compatibility policy is good at preventing a lot of good ideas from 
becoming anything but that.

Anyway, ok.


> >  };
> >
> >  #endif /* _XT_REALM_H */
> >
> >
> > ------------------------------------------------------------------------
> >
> > diff -ruN iptables-1.3.5.base/extensions/libipt_realm.c
> > iptables-1.3.5/extensions/libipt_realm.c ---
> > iptables-1.3.5.base/extensions/libipt_realm.c	2006-06-04
> > 01:49:33.000000000 +0200 +++
> > iptables-1.3.5/extensions/libipt_realm.c	2006-06-04 01:50:06.000000000
> > +0200 @@ -3,6 +3,8 @@
> >  #include <netdb.h>
> >  #include <string.h>
> >  #include <stdlib.h>
> > +#include <errno.h>
> > +#include <ctype.h>
> >  #include <getopt.h>
> >  #if defined(__GLIBC__) && __GLIBC__ == 2
> >  #include <net/ethernet.h>
> > @@ -28,6 +30,116 @@
> >  	{0}
> >  };
> >
> > +struct realmname {
> > +	int	id;
> > +	char*	name;
> > +	int	len;
> > +	struct realmname* next;
> > +};
> > +
> > +/* array of realms from /etc/iproute2/rt_realms */
> > +static struct realmname *realms = NULL;
> > +/* 1 if loading failed */
> > +static int rdberr = 0;
> > +
> > +
> > +void load_realms()
> > +{
> > +	const char* rfnm = "/etc/iproute2/rt_realms";
> > +	char buf[512];
> > +	FILE *fil;
> > +	char *cur, *nxt;
> > +	int id;
> > +	struct realmname *oldnm = NULL, *newnm = NULL;
> > +
> > +	fil = fopen(rfnm, "r");
> > +	if (!fil) {
> > +		rdberr = 1;
> > +		return;
> > +	}
> > +
> > +	while (fgets(buf, sizeof(buf), fil)) {
> > +		cur = buf;
> > +		while ((*cur == ' ') || (*cur == '\t')) cur++;
> > +		if ((*cur == '#') || (*cur == '\n') || (*cur == 0))
> > +			continue;
> > +
> > +		/* iproute2 allows hex and dec format */
> > +		errno = 0;
>
> Why do you need to fiddle with errno? Unless you missed to check it
> before that shouldn't be necessary.

I am not sure it is set to zero on success, and can not hurt anyway.


> > +		id = strtoul(cur, &nxt, strncmp(cur, "0x", 2) ? 10 : 16);
> > +		if ((nxt == cur) || errno) {
> > +			continue;
> > +		}
> > +
> > +		/* same boundaries as in iproute2 */
> > +		if (id < 0 || id > 256) continue;
>
> That doesn't look right. There is a limit of 256 for tables, but realms
> are 32 bit values.

I checked again, it is really the way iproute2 does it. You can have 32bit 
id's, but only the first 256 can be named.

iproute2-2.6.16-060323/lib/rt_names.c rtnl_tab_initialize() is called with 
size=256 so named ID's are limited to 0-255.


>
> > +		cur = nxt;
> > +
> > +		if (!isspace(*cur)) continue;
> > +		while ((*cur == ' ') || (*cur == '\t')) cur++;
> > +		if ((*cur == '#') || (*cur == '\n') || (*cur == 0))
> > +			continue;
> > +		nxt = cur;
> > +		while ((*nxt != 0) && !isspace(*nxt)) nxt++;
>
> nxt++ goes on the next line

ok


> > +		if (nxt == cur) continue;
>
> continue goes on the next line. There are more instances of this, please
> just fix all of them.

ok


> > +
> > +		/* found valid data */
> > +		newnm = (struct realmname*)malloc(sizeof(struct realmname));
> > +		if (NULL == newnm) {
>
> Please stick to the coding style used commonly within iptables, i.e.
> newnm == NULL. Same for the other comparisons.

ok


> > +			perror("libipt_realm: malloc failed");
> > +			exit(1);
> > +		}
> > +		newnm->id = id;
> > +		newnm->len = nxt - cur;
> > +		newnm->name = (char*)malloc(newnm->len + 1);
> > +		if (NULL == newnm->name) {
> > +			perror("libipt_realm: malloc failed");
> > +			exit(1);
> > +		}
> > +		strncpy(newnm->name, cur, newnm->len);
> > +		newnm->name[newnm->len] = 0;
> > +		newnm->next = NULL;
> > +
> > +		if (oldnm) {
> > +			oldnm->next = newnm;
> > +		} else {
> > +			realms = newnm;
> > +		}
> > +		oldnm = newnm;
> > +	}
> > +
> > +	fclose(fil);
> > +}
> > +
> > +/* get realm id for name, -1 if error/not found */
> > +int realm_name2id(const char* name)
> > +{
> > +	if ((NULL == realms) && (0 == rdberr)) load_realms();
> > +	if (NULL == realms) return -1;
> > +
> > +	struct realmname* cur = realms;
>
> Besided beeing ugly in my opinion, declarations after statements are not
> supported by gcc-2.95.

ok


> > +	while (cur) {
> > +		if (!strncmp(name, cur->name, cur->len + 1)) return cur->id;
> > +		cur = cur->next;
> > +	}
> > +	return -1;
> > +}
> > +
> > +/* get realm name for id, NULL if error/not found */
> > +const char* realm_id2name(int id)
> > +{
> > +	if ((NULL == realms) && (0 == rdberr)) load_realms();
> > +	if (NULL == realms) return NULL;
> > +
> > +	struct realmname* cur = realms;
> > +	while (cur) {
> > +		if (id == cur->id) return cur->name;
> > +		cur = cur->next;
> > +	}
> > +	return NULL;
> > +}
> > +
> > +
> >  /* Function which parses command options; returns true if it
> >     ate an option */
> >  static int
> > @@ -42,14 +154,26 @@
> >  		char *end;
> >  	case '1':
> >  		check_inverse(argv[optind-1], &invert, &optind, 0);
> > -		optarg = argv[optind-1];
> > +		end = optarg = argv[optind-1];
> >  		realminfo->id = strtoul(optarg, &end, 0);
> > -		if (*end == '/') {
> > -			realminfo->mask = strtoul(end+1, &end, 0);
> > -		} else
> > +		if ((end != optarg) && (('/' == *end) || ('\0' == *end))) {
> > +			if (*end == '/') {
> > +				realminfo->mask = strtoul(end+1, &end, 0);
> > +			} else
> > +				realminfo->mask = 0xffffffff;
> > +			if (*end != '\0' || end == optarg)
> > +				exit_error(PARAMETER_PROBLEM,
> > +					   "Bad realm value `%s'", optarg);
> > +		} else {
> > +			int id = realm_name2id(optarg);
> > +			if (-1 == id) {
> > +				exit_error(PARAMETER_PROBLEM,
> > +					   "Realm `%s' not found", optarg);
> > +			}
> > +			realminfo->id = (u_int32_t)id;
> >  			realminfo->mask = 0xffffffff;
> > -		if (*end != '\0' || end == optarg)
> > -			exit_error(PARAMETER_PROBLEM, "Bad realm value `%s'", optarg);
> > +			realminfo->is_named_realm = 1;
> > +		}
> >  		if (invert)
> >  			realminfo->invert = 1;
> >  		*flags = 1;
> > @@ -62,12 +186,22 @@
> >  }
> >
> >  static void
> > -print_realm(unsigned long id, unsigned long mask)
> > +print_realm(unsigned long id, unsigned long mask, int is_named)
> >  {
> > +	const char* name = NULL;
> > +
> >  	if (mask != 0xffffffff)
> >  		printf("0x%lx/0x%lx ", id, mask);
> > -	else
> > -		printf("0x%lx ", id);
> > +	else {
> > +		if (1 == is_named) {
> > +			name = realm_id2name(id);
> > +		}
> > +		if (name) {
> > +			printf("%s ", name);
> > +		} else {
> > +			printf("0x%lx ", id);
> > +		}
> > +	}
> >  }
> >
> >  /* Prints out the matchinfo. */
> > @@ -82,7 +216,7 @@
> >  		printf("! ");
> >
> >  	printf("realm ");
> > -	print_realm(ri->id, ri->mask);
> > +	print_realm(ri->id, ri->mask, numeric ? 0 : ri->is_named_realm);
> >  }
> >
> >
> > @@ -96,7 +230,7 @@
> >  		printf("! ");
> >
> >  	printf("--realm ");
> > -	print_realm(ri->id, ri->mask);
> > +	print_realm(ri->id, ri->mask, ri->is_named_realm);
> >  }
> >
> >  /* Final check; must have specified --mark. */
> > diff -ruN iptables-1.3.5.base/extensions/libipt_realm.man
> > iptables-1.3.5/extensions/libipt_realm.man ---
> > iptables-1.3.5.base/extensions/libipt_realm.man	2004-10-10
> > 11:56:27.000000000 +0200 +++
> > iptables-1.3.5/extensions/libipt_realm.man	2006-06-04 01:50:15.000000000
> > +0200 @@ -1,5 +1,7 @@
> >  This matches the routing realm.  Routing realms are used in complex
> > routing setups involving dynamic routing protocols like BGP.
> >  .TP
> > -.BI "--realm " "[!]" "value[/mask]"
> > -Matches a given realm number (and optionally mask).
> > +.BI "--realm " "[!] " "value[/mask]"
> > +Matches a given realm number (and optionally mask). If not a number,
> > value +can be a named realm from /etc/iproute2/rt_realms (mask can not be
> > used in +that case).


Simon

--Boundary-00=_sHM+EcWdeurEo2P
Content-Type: text/x-diff; charset="iso-8859-15";
	name="realm_named_realm.2006-09-02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="realm_named_realm.2006-09-02.diff"

diff -ruN iptables_svn_2006-09-02.orig/extensions/libipt_realm.c iptables_svn_2006-09-02.mod/extensions/libipt_realm.c
--- iptables_svn_2006-09-02.orig/extensions/libipt_realm.c	2006-09-01 23:47:21.000000000 +0200
+++ iptables_svn_2006-09-02.mod/extensions/libipt_realm.c	2006-09-02 00:16:27.000000000 +0200
@@ -3,6 +3,8 @@
 #include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
+#include <errno.h>
+#include <ctype.h>
 #include <getopt.h>
 #if defined(__GLIBC__) && __GLIBC__ == 2
 #include <net/ethernet.h>
@@ -28,6 +30,129 @@
 	{0}
 };
 
+struct realmname { 
+	int	id;
+	char*	name;
+	int	len;
+	struct realmname* next;
+};
+
+/* array of realms from /etc/iproute2/rt_realms */
+static struct realmname *realms = NULL;
+/* 1 if loading failed */
+static int rdberr = 0;
+
+
+void load_realms()
+{
+	const char* rfnm = "/etc/iproute2/rt_realms";
+	char buf[512];
+	FILE *fil;
+	char *cur, *nxt;
+	int id;
+	struct realmname *oldnm = NULL, *newnm = NULL;
+
+	fil = fopen(rfnm, "r");
+	if (!fil) {
+		rdberr = 1;
+		return;
+	}
+
+	while (fgets(buf, sizeof(buf), fil)) {
+		cur = buf;
+		while ((*cur == ' ') || (*cur == '\t'))
+			cur++;
+		if ((*cur == '#') || (*cur == '\n') || (*cur == 0))
+			continue;
+
+		/* iproute2 allows hex and dec format */
+		errno = 0;
+		id = strtoul(cur, &nxt, strncmp(cur, "0x", 2) ? 10 : 16);
+		if ((nxt == cur) || errno)
+			continue;
+
+		/* same boundaries as in iproute2 */
+		if (id < 0 || id > 255)
+			continue;
+		cur = nxt;
+
+		if (!isspace(*cur))
+			continue;
+		while ((*cur == ' ') || (*cur == '\t'))
+			cur++;
+		if ((*cur == '#') || (*cur == '\n') || (*cur == 0))
+			continue;
+		nxt = cur;
+		while ((*nxt != 0) && !isspace(*nxt))
+			nxt++;
+		if (nxt == cur)
+			continue;
+
+		/* found valid data */
+		newnm = (struct realmname*)malloc(sizeof(struct realmname));
+		if (newnm == NULL) {
+			perror("libipt_realm: malloc failed");
+			exit(1);
+		}
+		newnm->id = id;
+		newnm->len = nxt - cur;
+		newnm->name = (char*)malloc(newnm->len + 1);
+		if (newnm->name == NULL) {
+			perror("libipt_realm: malloc failed");
+			exit(1);
+		}
+		strncpy(newnm->name, cur, newnm->len);
+		newnm->name[newnm->len] = 0;
+		newnm->next = NULL;
+
+		if (oldnm) {
+			oldnm->next = newnm;
+		} else {
+			realms = newnm;
+		}
+		oldnm = newnm;
+	}
+
+	fclose(fil);
+}
+
+/* get realm id for name, -1 if error/not found */
+int realm_name2id(const char* name)
+{
+	struct realmname* cur;
+
+	if ((realms == NULL) && (rdberr == 0))
+		load_realms();
+	cur = realms;
+	if (cur == NULL)
+		return -1;
+	while (cur) {
+		if (!strncmp(name, cur->name, cur->len + 1))
+			return cur->id;
+		cur = cur->next;
+	}
+	return -1;
+}
+
+/* get realm name for id, NULL if error/not found */
+const char* realm_id2name(int id)
+{
+	struct realmname* cur;
+
+	if ((realms == NULL) && (rdberr == 0))
+		load_realms();
+	cur = realms;
+	if (cur == NULL)
+		return NULL;
+	while (cur) {
+		if (id == cur->id)
+			return cur->name;
+		cur = cur->next;
+	}
+	return NULL;
+}
+
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -37,19 +162,31 @@
       struct ipt_entry_match **match)
 {
 	struct ipt_realm_info *realminfo = (struct ipt_realm_info *)(*match)->data;
+	int id;
 
 	switch (c) {
 		char *end;
 	case '1':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
-		optarg = argv[optind-1];
+		end = optarg = argv[optind-1];
 		realminfo->id = strtoul(optarg, &end, 0);
-		if (*end == '/') {
-			realminfo->mask = strtoul(end+1, &end, 0);
-		} else
+		if ((end != optarg) && ((*end == '/') || (*end == '\0'))) {
+			if (*end == '/') {
+				realminfo->mask = strtoul(end+1, &end, 0);
+			} else
+				realminfo->mask = 0xffffffff;
+			if (*end != '\0' || end == optarg)
+				exit_error(PARAMETER_PROBLEM,
+					   "Bad realm value `%s'", optarg);
+		} else {
+			id = realm_name2id(optarg);
+			if (id == -1) {
+				exit_error(PARAMETER_PROBLEM,
+					   "Realm `%s' not found", optarg);
+			}
+			realminfo->id = (u_int32_t)id;
 			realminfo->mask = 0xffffffff;
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad realm value `%s'", optarg);
+		}
 		if (invert)
 			realminfo->invert = 1;
 		*flags = 1;
@@ -62,12 +199,22 @@
 }
 
 static void
-print_realm(unsigned long id, unsigned long mask)
+print_realm(unsigned long id, unsigned long mask, int numeric)
 {
+	const char* name = NULL;
+
 	if (mask != 0xffffffff)
 		printf("0x%lx/0x%lx ", id, mask);
-	else
-		printf("0x%lx ", id);
+	else {
+		if (numeric == 0) {
+			name = realm_id2name(id);
+		}
+		if (name) {
+			printf("%s ", name);
+		} else {
+			printf("0x%lx ", id);
+		}
+	}
 }
 
 /* Prints out the matchinfo. */
@@ -82,7 +229,7 @@
 		printf("! ");
 
 	printf("realm ");
-	print_realm(ri->id, ri->mask);
+	print_realm(ri->id, ri->mask, numeric);
 }
 
 
@@ -96,7 +243,7 @@
 		printf("! ");
 
 	printf("--realm ");
-	print_realm(ri->id, ri->mask);
+	print_realm(ri->id, ri->mask, 0);
 }
 
 /* Final check; must have specified --mark. */
diff -ruN iptables_svn_2006-09-02.orig/extensions/libipt_realm.man iptables_svn_2006-09-02.mod/extensions/libipt_realm.man
--- iptables_svn_2006-09-02.orig/extensions/libipt_realm.man	2006-09-01 23:47:21.000000000 +0200
+++ iptables_svn_2006-09-02.mod/extensions/libipt_realm.man	2006-09-02 00:16:30.000000000 +0200
@@ -1,5 +1,7 @@
 This matches the routing realm.  Routing realms are used in complex routing
 setups involving dynamic routing protocols like BGP.
 .TP
-.BI "--realm " "[!]" "value[/mask]"
-Matches a given realm number (and optionally mask).
+.BI "--realm " "[!] " "value[/mask]"
+Matches a given realm number (and optionally mask). If not a number, value
+can be a named realm from /etc/iproute2/rt_realms (mask can not be used in
+that case).

--Boundary-00=_sHM+EcWdeurEo2P--
