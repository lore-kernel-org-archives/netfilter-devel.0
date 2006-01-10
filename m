From: "Gilles Espinasse" <g.esp@free.fr>
Subject: Re: iptables 1.3.4 kernel 2.4.31 string match
Date: Tue, 10 Jan 2006 21:02:54 +0100
Message-ID: <0ba501c61620$d8c547d0$f9b5a8c0@pii350>
References: <1136294032.43ba78906f44c@imp4-g19.free.fr>
	<43BBFBC8.7010604@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0BA2_01C61629.39D86130"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Pablo Neira Ayuso" <pablo@eurodev.net>
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

------=_NextPart_000_0BA2_01C61629.39D86130
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit


----- Original Message ----- 
From: "Pablo Neira Ayuso" <pablo@eurodev.net>
To: "Gilles Espinasse" <g.esp@free.fr>
Cc: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
Sent: Wednesday, January 04, 2006 5:46 PM
Subject: Re: iptables 1.3.4 kernel 2.4.31 string match


> Bonjour,
>
> Gilles Espinasse wrote:
> > [snip]
> >
> >>>As I understand, iptables 1.3.4 *can* use the kernel string matching
> >>>available starting in kernel 2.6.14.
> >>>
> >>>However, we are using kernel 2.4.31 (which iptables 1.3.4 doc says is
OK).
> >>
> >>So, I updated the manpage. Attached a patch that applies to netfilter
SVN.
> >>
> >>
> >>>However, according to our "compile guy" (Thomas):
> >>>
> >>>"iptables 1.3.4 does not compile when I have strings matching.  That
is, the
> >>>string match patch does something that makes iptables 1.3.4 not
compile."
> >>
> >>iptables doesn't compile the string match if it's not present in the
> >>current kernel, eg. if you compile iptables against a linux kernel <=
> >>2.6.14, the string match won't be compiled.
> >>
> >>
> >>>So, g
>
> iven that we continue to use kernel 2.4.31, is their any applicable
> >>>patch or approach;  We would like to use our kernel (2.4.31) with
iptables
> >>>1.3.4 and still have string matching.
> >>
> >>There's no backport available. The only existing way to add support for
> >>string matching is upgrading your kernel at the moment.
> >>
> >
> >
> > Having done a diff iptables-1.3.3 iptables-1.3.4, I extract the changes
related
> > to string and reverse the patch against iptables-1.3.4.
> >
> > It does compile and I am starting to test this solution with
kernel-2.4.31 and
> > 2.4.32.
> > Could something prevent this solution to work?
>
> The problem is that the kernel part is missing (textsearch
> infrastructure + ipt_string). So, that won't work :(
>
I don't attempt to use the new 'string' code on kernel-2.4.
I just find better to use the previous 'string' version than not be able to
use iptables-1.3.4 with 2.4 kernel

You should have miss  the fact I apply the reverse patch
cd $(DIR_SRC)/iptables-1.3.4 && patch -Np1 -R <
$(DIR_SRC)/src/patches/iptables-1.3.4-old-string.patch

In fact I revert to the previous string implentation with the diff
iptables-1.3.3 iptables-1.3.4 applied with -R switch

It was an answer to the original question to use iptables-1.3.4, string
extension and kernel-2.4.x

Gilles

------=_NextPart_000_0BA2_01C61629.39D86130
Content-Type: application/octet-stream; name="iptables-1.3.4-old-string.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="iptables-1.3.4-old-string.patch"

Used to revert to old 'string' implementation as it is the only one know =
by pom for kernel 2.4

diff -Nru iptables-1.3.3/extensions/libipt_string.c =
iptables-1.3.4/extensions/libipt_string.c=0A=
--- iptables-1.3.3/extensions/libipt_string.c	2005-02-19 =
19:19:17.000000000 +0000=0A=
+++ iptables-1.3.4/extensions/libipt_string.c	2005-10-31 =
19:03:50.000000000 +0000=0A=
@@ -2,6 +2,11 @@=0A=
  * =0A=
  * Copyright (C) 2000 Emmanuel Roger  <winfield@freegates.be>=0A=
  *=0A=
+ * 2005-08-05 Pablo Neira Ayuso <pablo@eurodev.net>=0A=
+ * 	- reimplemented to use new string matching iptables match=0A=
+ * 	- add functionality to match packets by using window offsets=0A=
+ * 	- add functionality to select the string matching algorithm=0A=
+ *=0A=
  * ChangeLog=0A=
  *     29.12.2003: Michael Rash <mbr@cipherdyne.org>=0A=
  *             Fixed iptables save/restore for ascii strings=0A=
@@ -21,36 +26,62 @@=0A=
 #include <stdlib.h>=0A=
 #include <getopt.h>=0A=
 #include <ctype.h>=0A=
-=0A=
 #include <iptables.h>=0A=
+#include <stddef.h>=0A=
 #include <linux/netfilter_ipv4/ipt_string.h>=0A=
 =0A=
-=0A=
 /* Function which prints out usage message. */=0A=
 static void=0A=
 help(void)=0A=
 {=0A=
 	printf(=0A=
 "STRING match v%s options:\n"=0A=
+"--from                       Offset to start searching from\n"=0A=
+"--to                         Offset to stop searching\n"=0A=
+"--algo	                      Algorithm\n"=0A=
 "--string [!] string          Match a string in a packet\n"=0A=
 "--hex-string [!] string      Match a hex string in a packet\n",=0A=
 IPTABLES_VERSION);=0A=
 }=0A=
 =0A=
-=0A=
 static struct option opts[] =3D {=0A=
-	{ .name =3D "string",     .has_arg =3D 1, .flag =3D 0, .val =3D '1' },=0A=
-	{ .name =3D "hex-string", .has_arg =3D 1, .flag =3D 0, .val =3D '2' },=0A=
-	{ .name =3D 0 }=0A=
+	{ "from", 1, 0, '1' },=0A=
+	{ "to", 1, 0, '2' },=0A=
+	{ "algo", 1, 0, '3' },=0A=
+	{ "string", 1, 0, '4' },=0A=
+	{ "hex-string", 1, 0, '5' },=0A=
+	{0}=0A=
 };=0A=
 =0A=
 static void=0A=
+init(struct ipt_entry_match *m, unsigned int *nfcache)=0A=
+{=0A=
+	struct ipt_string_info *i =3D (struct ipt_string_info *) m->data;=0A=
+=0A=
+	if (i->to_offset =3D=3D 0)=0A=
+		i->to_offset =3D (u_int16_t) ~0UL;=0A=
+}=0A=
+=0A=
+static void=0A=
 parse_string(const unsigned char *s, struct ipt_string_info *info)=0A=
 {	=0A=
-	if (strlen(s) <=3D BM_MAX_NLEN) strcpy(info->string, s);=0A=
-	else exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);=0A=
+	if (strlen(s) <=3D IPT_STRING_MAX_PATTERN_SIZE) {=0A=
+		strncpy(info->pattern, s, IPT_STRING_MAX_PATTERN_SIZE);=0A=
+		info->patlen =3D strlen(s);=0A=
+		return;=0A=
+	}=0A=
+	exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);=0A=
 }=0A=
 =0A=
+static void=0A=
+parse_algo(const unsigned char *s, struct ipt_string_info *info)=0A=
+{=0A=
+	if (strlen(s) <=3D IPT_STRING_MAX_ALGO_NAME_SIZE) {=0A=
+		strncpy(info->algo, s, IPT_STRING_MAX_ALGO_NAME_SIZE);=0A=
+		return;=0A=
+	}=0A=
+	exit_error(PARAMETER_PROBLEM, "ALGO too long `%s'", s);=0A=
+}=0A=
 =0A=
 static void=0A=
 parse_hex_string(const unsigned char *s, struct ipt_string_info *info)=0A=
@@ -92,7 +123,7 @@=0A=
 				exit_error(PARAMETER_PROBLEM,=0A=
 					"Bad literal placement at end of string");=0A=
 			}=0A=
-			info->string[sindex] =3D s[i+1];=0A=
+			info->pattern[sindex] =3D s[i+1];=0A=
 			i +=3D 2;  /* skip over literal char */=0A=
 			literal_f =3D 0;=0A=
 		} else if (hex_f) {=0A=
@@ -114,22 +145,26 @@=0A=
 			if (! sscanf(hextmp, "%x", &schar))=0A=
 				exit_error(PARAMETER_PROBLEM,=0A=
 					"Invalid hex char `%c'", s[i]);=0A=
-			info->string[sindex] =3D (char) schar;=0A=
+			info->pattern[sindex] =3D (char) schar;=0A=
 			if (s[i+2] =3D=3D ' ')=0A=
 				i +=3D 3;  /* spaces included in the hex block */=0A=
 			else=0A=
 				i +=3D 2;=0A=
 		} else {  /* the char is not part of hex data, so just copy */=0A=
-			info->string[sindex] =3D s[i];=0A=
+			info->pattern[sindex] =3D s[i];=0A=
 			i++;=0A=
 		}=0A=
-		if (sindex > BM_MAX_NLEN)=0A=
+		if (sindex > IPT_STRING_MAX_PATTERN_SIZE)=0A=
 			exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);=0A=
 		sindex++;=0A=
 	}=0A=
-	info->len =3D sindex;=0A=
+	info->patlen =3D sindex;=0A=
 }=0A=
 =0A=
+#define STRING 0x1=0A=
+#define ALGO   0x2=0A=
+#define FROM   0x4=0A=
+#define TO     0x8=0A=
 =0A=
 /* Function which parses command options; returns true if it=0A=
    ate an option */=0A=
@@ -143,28 +178,48 @@=0A=
 =0A=
 	switch (c) {=0A=
 	case '1':=0A=
-		if (*flags)=0A=
+		if (*flags & FROM)=0A=
 			exit_error(PARAMETER_PROBLEM,=0A=
-				   "Can't specify multiple strings");=0A=
-=0A=
+				   "Can't specify multiple --from");=0A=
+		stringinfo->from_offset =3D atoi(optarg);=0A=
+		*flags |=3D FROM;=0A=
+		break;=0A=
+	case '2':=0A=
+		if (*flags & TO)=0A=
+			exit_error(PARAMETER_PROBLEM,=0A=
+				   "Can't specify multiple --to");=0A=
+		stringinfo->to_offset =3D atoi(optarg);=0A=
+		*flags |=3D TO;=0A=
+		break;=0A=
+	case '3':=0A=
+		if (*flags & ALGO)=0A=
+			exit_error(PARAMETER_PROBLEM,=0A=
+				   "Can't specify multiple --algo");=0A=
+		parse_algo(optarg, stringinfo);=0A=
+		*flags |=3D ALGO;=0A=
+		break;=0A=
+	case '4':=0A=
+		if (*flags & STRING)=0A=
+			exit_error(PARAMETER_PROBLEM,=0A=
+				   "Can't specify multiple --string");=0A=
 		check_inverse(optarg, &invert, &optind, 0);=0A=
 		parse_string(argv[optind-1], stringinfo);=0A=
 		if (invert)=0A=
 			stringinfo->invert =3D 1;=0A=
-		stringinfo->len=3Dstrlen((char *)&stringinfo->string);=0A=
-		*flags =3D 1;=0A=
+		stringinfo->patlen=3Dstrlen((char *)&stringinfo->pattern);=0A=
+		*flags |=3D STRING;=0A=
 		break;=0A=
 =0A=
-	case '2':=0A=
-		if (*flags)=0A=
+	case '5':=0A=
+		if (*flags & STRING)=0A=
 			exit_error(PARAMETER_PROBLEM,=0A=
-				   "Can't specify multiple strings");=0A=
+				   "Can't specify multiple --hex-string");=0A=
 =0A=
 		check_inverse(optarg, &invert, &optind, 0);=0A=
 		parse_hex_string(argv[optind-1], stringinfo);  /* sets length */=0A=
 		if (invert)=0A=
 			stringinfo->invert =3D 1;=0A=
-		*flags =3D 1;=0A=
+		*flags |=3D STRING;=0A=
 		break;=0A=
 =0A=
 	default:=0A=
@@ -178,9 +233,13 @@=0A=
 static void=0A=
 final_check(unsigned int flags)=0A=
 {=0A=
-	if (!flags)=0A=
+	if (!(flags & STRING))=0A=
+		exit_error(PARAMETER_PROBLEM,=0A=
+			   "STRING match: You must specify `--string' or "=0A=
+			   "`--hex-string'");=0A=
+	if (!(flags & ALGO))=0A=
 		exit_error(PARAMETER_PROBLEM,=0A=
-			   "STRING match: You must specify `--string' or `--hex-string'");=0A=
+			   "STRING match: You must specify `--algo'");=0A=
 }=0A=
 =0A=
 /* Test to see if the string contains non-printable chars or quotes */=0A=
@@ -237,13 +296,18 @@=0A=
 	const struct ipt_string_info *info =3D=0A=
 	    (const struct ipt_string_info*) match->data;=0A=
 =0A=
-	if (is_hex_string(info->string, info->len)) {=0A=
+	if (is_hex_string(info->pattern, info->patlen)) {=0A=
 		printf("STRING match %s", (info->invert) ? "!" : "");=0A=
-		print_hex_string(info->string, info->len);=0A=
+		print_hex_string(info->pattern, info->patlen);=0A=
 	} else {=0A=
 		printf("STRING match %s", (info->invert) ? "!" : "");=0A=
-		print_string(info->string, info->len);=0A=
+		print_string(info->pattern, info->patlen);=0A=
 	}=0A=
+	printf("ALGO name %s ", info->algo);=0A=
+	if (info->from_offset !=3D 0)=0A=
+		printf("FROM %u ", info->from_offset);=0A=
+	if (info->to_offset !=3D 0)=0A=
+		printf("TO %u", info->to_offset);=0A=
 }=0A=
 =0A=
 =0A=
@@ -254,27 +318,33 @@=0A=
 	const struct ipt_string_info *info =3D=0A=
 	    (const struct ipt_string_info*) match->data;=0A=
 =0A=
-	if (is_hex_string(info->string, info->len)) {=0A=
+	if (is_hex_string(info->pattern, info->patlen)) {=0A=
 		printf("--hex-string %s", (info->invert) ? "! ": "");=0A=
-		print_hex_string(info->string, info->len);=0A=
+		print_hex_string(info->pattern, info->patlen);=0A=
 	} else {=0A=
 		printf("--string %s", (info->invert) ? "! ": "");=0A=
-		print_string(info->string, info->len);=0A=
+		print_string(info->pattern, info->patlen);=0A=
 	}=0A=
+	printf("--algo %s ", info->algo);=0A=
+	if (info->from_offset !=3D 0)=0A=
+		printf("--from-offset %u ", info->from_offset);=0A=
+	if (info->to_offset !=3D 0)=0A=
+		printf("--to-offset %u ", info->to_offset);=0A=
 }=0A=
 =0A=
 =0A=
 static struct iptables_match string =3D {=0A=
-    .name          =3D "string",=0A=
-    .version       =3D IPTABLES_VERSION,=0A=
-    .size          =3D IPT_ALIGN(sizeof(struct ipt_string_info)),=0A=
-    .userspacesize =3D IPT_ALIGN(sizeof(struct ipt_string_info)),=0A=
-    .help          =3D &help,=0A=
-    .parse         =3D &parse,=0A=
-    .final_check   =3D &final_check,=0A=
-    .print         =3D &print,=0A=
-    .save          =3D &save,=0A=
-    .extra_opts    =3D opts=0A=
+    .name		=3D "string",=0A=
+    .version		=3D IPTABLES_VERSION,=0A=
+    .size		=3D IPT_ALIGN(sizeof(struct ipt_string_info)),=0A=
+    .userspacesize	=3D offsetof(struct ipt_string_info, config),=0A=
+    .help		=3D help,=0A=
+    .init		=3D init,=0A=
+    .parse		=3D parse,=0A=
+    .final_check	=3D final_check,=0A=
+    .print		=3D print,=0A=
+    .save		=3D save,=0A=
+    .extra_opts		=3D opts=0A=
 };=0A=
 =0A=
 =0A=

------=_NextPart_000_0BA2_01C61629.39D86130--
