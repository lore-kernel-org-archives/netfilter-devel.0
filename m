From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH]: fix all iptables problems with "!" (hopefully)
Date: Mon, 06 Jan 2003 09:15:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E193B0E.9030602@trash.net>
References: <35565.195.97.5.193.1041816667.squirrel@fs.tsaousis.gr> <20030106020219.GC423@comet.rv-int>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020206090807070507030502"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?ISO-8859-1?Q?Herv=E9_Eychenne?= <rv@wallfire.org>
In-Reply-To: <20030106020219.GC423@comet.rv-int>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020206090807070507030502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by el-zoido.localnet id h068EDR05586

Herv=E9 Eychenne wrote:

>On Mon, Jan 06, 2003 at 03:31:07AM +0200, Costa Tsaousis wrote:
>
> Hi,
>
> =20
>
>>I believe I have faced another, not-mentioned-in-2002, bug:
>>[...]
>>then iptables-save gives this:
>>
>>-A OUTPUT -d ! 127.0.0.1 -p tcp -m owner --uid-owner !squid -m tcp --dp=
ort
>>80 -j DNAT --to-destination 127.0.0.1:3128
>>
>>which produces a "user '!squid' not found" error when restored.
>>   =20
>>
>
>It seems to me that no single week passes without any post about this
>kind of error (no space before a negation) in some save output module.
>Sigh.
>I must admit it seems quite strange to me that noone in the coreteam
>didn't do that already. (hope I won't hurt anybody's feelings too
>much though) ;-)
>
>Would someone who's even more fed up than me with these recurrent
>messages have time to audit the whole bunch of existing modules in
>the CVS tree and fix this particular kind of problem _once and for all_?
>
> =20
>
I did, here is the (untested) patch, hopefully i didn't miss any.
I didn't change any of the "save"-functions, this patch just replaces=20
all uses
of optarg after check_inverse by argv[optind-1].

Regards,
Patrick

>Thanks in advance,
>
> Herve
>
> =20
>


--------------020206090807070507030502
Content-Type: text/plain;
 name="extensions_save.diff"
Content-Disposition: inline;
 filename="extensions_save.diff"
Content-Transfer-Encoding: 7bit

Index: extensions/libip6t_mark.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/libip6t_mark.c,v
retrieving revision 1.4
diff -u -r1.4 libip6t_mark.c
--- extensions/libip6t_mark.c	29 May 2002 13:08:16 -0000	1.4
+++ extensions/libip6t_mark.c	6 Jan 2003 08:03:44 -0000
@@ -46,13 +46,13 @@
 		char *end;
 	case '1':
 		check_inverse(optarg, &invert, &optind, 0);
-		markinfo->mark = strtoul(optarg, &end, 0);
+		markinfo->mark = strtoul(argv[optind-1], &end, 0);
 		if (*end == '/') {
 			markinfo->mask = strtoul(end+1, &end, 0);
 		} else
 			markinfo->mask = 0xffffffff;
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
+		if (*end != '\0' || end == argv[optind-1])
+			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", argv[optind-1]);
 		if (invert)
 			markinfo->invert = 1;
 		*flags = 1;
Index: extensions/libip6t_owner.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/libip6t_owner.c,v
retrieving revision 1.4
diff -u -r1.4 libip6t_owner.c
--- extensions/libip6t_owner.c	29 May 2002 13:08:16 -0000	1.4
+++ extensions/libip6t_owner.c	6 Jan 2003 08:03:45 -0000
@@ -57,12 +57,12 @@
 	case '1':
 		check_inverse(optarg, &invert, &optind, 0);
 
-		if ((pwd = getpwnam(optarg)))
+		if ((pwd = getpwnam(argv[optind-1])))
 			ownerinfo->uid = pwd->pw_uid;
 		else {
-			ownerinfo->uid = strtoul(optarg, &end, 0);
-			if (*end != '\0' || end == optarg)
-				exit_error(PARAMETER_PROBLEM, "Bad OWNER UID value `%s'", optarg);
+			ownerinfo->uid = strtoul(argv[optind-1], &end, 0);
+			if (*end != '\0' || end == argv[optind-1])
+				exit_error(PARAMETER_PROBLEM, "Bad OWNER UID value `%s'", argv[optind-1]);
 		}
 		if (invert)
 			ownerinfo->invert |= IP6T_OWNER_UID;
@@ -72,12 +72,12 @@
 
 	case '2':
 		check_inverse(optarg, &invert, &optind, 0);
-		if ((grp = getgrnam(optarg)))
+		if ((grp = getgrnam(argv[optind-1])))
 			ownerinfo->gid = grp->gr_gid;
 		else {
-			ownerinfo->gid = strtoul(optarg, &end, 0);
-			if (*end != '\0' || end == optarg)
-				exit_error(PARAMETER_PROBLEM, "Bad OWNER GID value `%s'", optarg);
+			ownerinfo->gid = strtoul(argv[optind-1], &end, 0);
+			if (*end != '\0' || end == argv[optind-1])
+				exit_error(PARAMETER_PROBLEM, "Bad OWNER GID value `%s'", argv[optind-1]);
 		}
 		if (invert)
 			ownerinfo->invert |= IP6T_OWNER_GID;
@@ -87,9 +87,9 @@
 
 	case '3':
 		check_inverse(optarg, &invert, &optind, 0);
-		ownerinfo->pid = strtoul(optarg, &end, 0);
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad OWNER PID value `%s'", optarg);
+		ownerinfo->pid = strtoul(argv[optind-1], &end, 0);
+		if (*end != '\0' || end == argv[optind-1])
+			exit_error(PARAMETER_PROBLEM, "Bad OWNER PID value `%s'", argv[optind-1]);
 		if (invert)
 			ownerinfo->invert |= IP6T_OWNER_PID;
 		ownerinfo->match |= IP6T_OWNER_PID;
@@ -98,9 +98,9 @@
 
 	case '4':
 		check_inverse(optarg, &invert, &optind, 0);
-		ownerinfo->sid = strtoul(optarg, &end, 0);
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad OWNER SID value `%s'", optarg);
+		ownerinfo->sid = strtoul(argv[optind-1], &end, 0);
+		if (*end != '\0' || end == argv[optind-1])
+			exit_error(PARAMETER_PROBLEM, "Bad OWNER SID value `%s'", argv[optind-1]);
 		if (invert)
 			ownerinfo->invert |= IP6T_OWNER_SID;
 		ownerinfo->match |= IP6T_OWNER_SID;
Index: extensions/libipt_connmark.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/libipt_connmark.c,v
retrieving revision 1.5
diff -u -r1.5 libipt_connmark.c
--- extensions/libipt_connmark.c	20 Sep 2002 15:25:13 -0000	1.5
+++ extensions/libipt_connmark.c	6 Jan 2003 08:03:45 -0000
@@ -46,13 +46,13 @@
 		char *end;
 	case '1':
 		check_inverse(optarg, &invert, &optind, 0);
-		markinfo->mark = strtoul(optarg, &end, 0);
+		markinfo->mark = strtoul(argv[optind-1], &end, 0);
 		if (*end == '/') {
 			markinfo->mask = strtoul(end+1, &end, 0);
 		} else
 			markinfo->mask = 0xffffffff;
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
+		if (*end != '\0' || end == argv[optind-1])
+			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", argv[optind-1]);
 		if (invert)
 			markinfo->invert = 1;
 		*flags = 1;
Index: extensions/libipt_ecn.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/libipt_ecn.c,v
retrieving revision 1.3
diff -u -r1.3 libipt_ecn.c
--- extensions/libipt_ecn.c	5 Aug 2002 19:35:52 -0000	1.3
+++ extensions/libipt_ecn.c	6 Jan 2003 08:03:45 -0000
@@ -80,7 +80,7 @@
 			einfo->invert |= IPT_ECN_OP_MATCH_IP;
 		*flags |= IPT_ECN_OP_MATCH_IP;
 		einfo->operation |= IPT_ECN_OP_MATCH_IP;
-		if (string_to_number(optarg, 0, 3, &result))
+		if (string_to_number(argv[optind-1], 0, 3, &result))
 			exit_error(PARAMETER_PROBLEM,
 				   "ECN match: Value out of range");
 		einfo->ip_ect = result;
Index: extensions/libipt_helper.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/libipt_helper.c,v
retrieving revision 1.3
diff -u -r1.3 libipt_helper.c
--- extensions/libipt_helper.c	29 May 2002 13:08:16 -0000	1.3
+++ extensions/libipt_helper.c	6 Jan 2003 08:03:45 -0000
@@ -44,8 +44,8 @@
 
 	switch (c) {
 	case '1':
-		check_inverse(optarg, &invert, &invert, 0);
-		strncpy(info->name, optarg, 29);
+		check_inverse(optarg, &invert, &optind, 0);
+		strncpy(info->name, argv[optind-1], 29);
 		if (invert)
 			info->invert = 1;
 		*flags = 1;
Index: extensions/libipt_mark.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/libipt_mark.c,v
retrieving revision 1.8
diff -u -r1.8 libipt_mark.c
--- extensions/libipt_mark.c	20 Sep 2002 15:25:13 -0000	1.8
+++ extensions/libipt_mark.c	6 Jan 2003 08:03:45 -0000
@@ -46,13 +46,13 @@
 		char *end;
 	case '1':
 		check_inverse(optarg, &invert, &optind, 0);
-		markinfo->mark = strtoul(optarg, &end, 0);
+		markinfo->mark = strtoul(argv[optind-1], &end, 0);
 		if (*end == '/') {
 			markinfo->mask = strtoul(end+1, &end, 0);
 		} else
 			markinfo->mask = 0xffffffff;
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
+		if (*end != '\0' || end == argv[optind-1])
+			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", argv[optind-1]);
 		if (invert)
 			markinfo->invert = 1;
 		*flags = 1;
Index: extensions/libipt_owner.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/libipt_owner.c,v
retrieving revision 1.8
diff -u -r1.8 libipt_owner.c
--- extensions/libipt_owner.c	29 May 2002 13:08:16 -0000	1.8
+++ extensions/libipt_owner.c	6 Jan 2003 08:03:45 -0000
@@ -71,12 +71,12 @@
 		struct group *grp;
 	case '1':
 		check_inverse(optarg, &invert, &optind, 0);
-		if ((pwd = getpwnam(optarg)))
+		if ((pwd = getpwnam(argv[optind-1])))
 			ownerinfo->uid = pwd->pw_uid;
 		else {
-			ownerinfo->uid = strtoul(optarg, &end, 0);
-			if (*end != '\0' || end == optarg)
-				exit_error(PARAMETER_PROBLEM, "Bad OWNER UID value `%s'", optarg);
+			ownerinfo->uid = strtoul(argv[optind-1], &end, 0);
+			if (*end != '\0' || end == argv[optind-1])
+				exit_error(PARAMETER_PROBLEM, "Bad OWNER UID value `%s'", argv[optind-1]);
 		}
 		if (invert)
 			ownerinfo->invert |= IPT_OWNER_UID;
@@ -86,12 +86,12 @@
 
 	case '2':
 		check_inverse(optarg, &invert, &optind, 0);
-		if ((grp = getgrnam(optarg)))
+		if ((grp = getgrnam(argv[optind-1])))
 			ownerinfo->gid = grp->gr_gid;
 		else {
-			ownerinfo->gid = strtoul(optarg, &end, 0);
-			if (*end != '\0' || end == optarg)
-				exit_error(PARAMETER_PROBLEM, "Bad OWNER GID value `%s'", optarg);
+			ownerinfo->gid = strtoul(argv[optind-1], &end, 0);
+			if (*end != '\0' || end == argv[optind-1])
+				exit_error(PARAMETER_PROBLEM, "Bad OWNER GID value `%s'", argv[optind-1]);
 		}
 		if (invert)
 			ownerinfo->invert |= IPT_OWNER_GID;
@@ -101,9 +101,9 @@
 
 	case '3':
 		check_inverse(optarg, &invert, &optind, 0);
-		ownerinfo->pid = strtoul(optarg, &end, 0);
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad OWNER PID value `%s'", optarg);
+		ownerinfo->pid = strtoul(argv[optind-1], &end, 0);
+		if (*end != '\0' || end == argv[optind-1])
+			exit_error(PARAMETER_PROBLEM, "Bad OWNER PID value `%s'", argv[optind-1]);
 		if (invert)
 			ownerinfo->invert |= IPT_OWNER_PID;
 		ownerinfo->match |= IPT_OWNER_PID;
@@ -112,9 +112,9 @@
 
 	case '4':
 		check_inverse(optarg, &invert, &optind, 0);
-		ownerinfo->sid = strtoul(optarg, &end, 0);
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad OWNER SID value `%s'", optarg);
+		ownerinfo->sid = strtoul(argv[optind-1], &end, 0);
+		if (*end != '\0' || end == argv[optind-1])
+			exit_error(PARAMETER_PROBLEM, "Bad OWNER SID value `%s'", argv[optind-1]);
 		if (invert)
 			ownerinfo->invert |= IPT_OWNER_SID;
 		ownerinfo->match |= IPT_OWNER_SID;
@@ -124,10 +124,11 @@
 #ifdef IPT_OWNER_COMM
 	case '5':
 		check_inverse(optarg, &invert, &optind, 0);
-		if(strlen(optarg) > sizeof(ownerinfo->comm))
-			exit_error(PARAMETER_PROBLEM, "OWNER CMD `%s' too long, max %d characters", optarg, sizeof(ownerinfo->comm));
+		if(strlen(argv[optind-1]) > sizeof(ownerinfo->comm))
+			exit_error(PARAMETER_PROBLEM, "OWNER CMD `%s' too long, max %d characters",
+			           argv[optind-1], sizeof(ownerinfo->comm));
 
-		strncpy(ownerinfo->comm, optarg, sizeof(ownerinfo->comm));
+		strncpy(ownerinfo->comm, argv[optind-1], sizeof(ownerinfo->comm));
 
 		if (invert)
 			ownerinfo->invert |= IPT_OWNER_COMM;
Index: extensions/libipt_realm.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/libipt_realm.c,v
retrieving revision 1.4
diff -u -r1.4 libipt_realm.c
--- extensions/libipt_realm.c	29 May 2002 13:08:16 -0000	1.4
+++ extensions/libipt_realm.c	6 Jan 2003 08:03:45 -0000
@@ -50,13 +50,13 @@
 		char *end;
 	case '1':
 		check_inverse(optarg, &invert, &optind, 0);
-		realminfo->id = strtoul(optarg, &end, 0);
+		realminfo->id = strtoul(argv[optind-1], &end, 0);
 		if (*end == '/') {
 			realminfo->mask = strtoul(end+1, &end, 0);
 		} else
 			realminfo->mask = 0xffffffff;
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad REALM value `%s'", optarg);
+		if (*end != '\0' || end == argv[optind-1])
+			exit_error(PARAMETER_PROBLEM, "Bad REALM value `%s'", argv[optind-1]);
 		if (invert)
 			realminfo->invert = 1;
 		*flags = 1;

--------------020206090807070507030502--
