From: "Nicolas Bouliane" <nib@cookinglinux.org>
Subject: [PATCH 2.4/2.6]: TTL target
Date: Sun, 25 Jul 2004 19:23:41 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1400.192.168.1.16.1090797821.squirrel@192.168.1.16>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi guys,

We attached three patches that fixe some problems with the TTL target.

1) When using a value > 255 or < 0, there's an overflow with
   u_int8_t value;

   This means that giving 256 as a value will create a rule with
   a value of 0.

   The first patch adds some error controls in TTL library avoiding this.

2) There is a little, but significative, bug in the TTL target module.
   Instead of decreasing the TTL, this is increasing it.

   The second patch is for 2.4

3) Same as second patch, but for 2.6

Let us know if there is some problems. Thanks you.

Patches below.

Signed-off-by: Nicolas Bouliane <nib@cookinglinux.org>


diff -urpN extensions/libipt_TTL.c.orig extensions/libipt_TTL.c
--- extensions/libipt_TTL.c.orig	2004-07-24 21:17:24.000000000 -0400
+++ extensions/libipt_TTL.c	2004-07-25 18:00:39.000000000 -0400
@@ -24,9 +24,9 @@ static void help(void)
 {
 	printf(
 "TTL target v%s options\n"
-"  --ttl-set value		Set TTL to <value>\n"
-"  --ttl-dec value		Decrement TTL by <value>\n"
-"  --ttl-inc value		Increment TTL by <value>\n"
+"  --ttl-set value		Set TTL to <value 0-255>\n"
+"  --ttl-dec value		Decrement TTL by <value 1-255>\n"
+"  --ttl-inc value		Increment TTL by <value 1-255>\n"
 , IPTABLES_VERSION);
 }

@@ -35,7 +35,8 @@ static int parse(int c, char **argv, int
 		struct ipt_entry_target **target)
 {
 	struct ipt_TTL_info *info =3D (struct ipt_TTL_info *) (*target)->data;
-	u_int8_t value;
+   u_int16_t value;
+   u_int8_t alpha;

 	if (*flags & IPT_TTL_USED) {
 		exit_error(PARAMETER_PROBLEM,
@@ -49,28 +50,36 @@ static int parse(int c, char **argv, int
 	if (check_inverse(optarg, &invert, NULL, 0))
 		exit_error(PARAMETER_PROBLEM,
 				"TTL: unexpected `!'");
-
-	value =3D atoi(optarg);
-
+
+   if ((strlen(optarg) > 3) ||
+      (sscanf(optarg, "%hd%c", &value, &alpha) !=3D 1))
+      exit_error(PARAMETER_PROBLEM,
+            "TTL: Invalid value");
+
 	switch (c) {

 		case '1':
+         if (value > 255) {
+            exit_error(PARAMETER_PROBLEM,
+               "TTL: Invalid value");
+         }
+
 			info->mode =3D IPT_TTL_SET;
 			break;

 		case '2':
-			if (value =3D=3D 0) {
-				exit_error(PARAMETER_PROBLEM,
-					"TTL: decreasing by 0?");
+         if (value > 255 || value < 1) {
+   			exit_error(PARAMETER_PROBLEM,
+					"TTL: Invalid value");
 			}

 			info->mode =3D IPT_TTL_DEC;
 			break;

 		case '3':
-			if (value =3D=3D 0) {
+         if (value > 255 || value < 1) {
 				exit_error(PARAMETER_PROBLEM,
-					"TTL: increasing by 0?");
+   				"TTL: Invalid value");
 			}

 			info->mode =3D IPT_TTL_INC;



diff -urpN linux/net/ipv4/netfilter/ipt_TTL.c.orig
linux/net/ipv4/netfilter/ipt_TTL.c
--- linux/net/ipv4/netfilter/ipt_TTL.c.orig	2004-07-24 21:09:23.000000000
-0400
+++ linux/net/ipv4/netfilter/ipt_TTL.c	2004-07-25 18:15:08.000000000 -040=
0
@@ -37,7 +37,7 @@ static unsigned int ipt_ttl_target(struc
 				new_ttl =3D 255;
 			break;
 		case IPT_TTL_DEC:
-			new_ttl =3D iph->ttl + info->ttl;
+			new_ttl =3D iph->ttl - info->ttl;
 			if (new_ttl < 0)
 				new_ttl =3D 0;
 			break;
@@ -85,11 +85,6 @@ static int ipt_ttl_checkentry(const char
 		return 0;
 	}

-	if ((info->mode !=3D IPT_TTL_SET) && (info->ttl =3D=3D 0)) {
-		printk(KERN_WARNING "TTL: increment/decrement doesn't make sense with
value 0\n");
-		return 0;
-	}
-
 	return 1;
 }



diff -urpN linux-2.6/net/ipv4/netfilter/ipt_TTL.c.orig
linux-2.6/net/ipv4/netfilter/ipt_TTL.c
--- linux-2.6/net/ipv4/netfilter/ipt_TTL.c.orig	2004-07-25
18:30:56.000000000 -0400
+++ linux-2.6/net/ipv4/netfilter/ipt_TTL.c	2004-07-25 18:31:52.000000000
-0400
@@ -43,7 +43,7 @@ ipt_ttl_target(struct sk_buff **pskb, co
 				new_ttl =3D 255;
 			break;
 		case IPT_TTL_DEC:
-			new_ttl =3D iph->ttl + info->ttl;
+			new_ttl =3D iph->ttl - info->ttl;
 			if (new_ttl < 0)
 				new_ttl =3D 0;
 			break;
@@ -91,11 +91,6 @@ static int ipt_ttl_checkentry(const char
 		return 0;
 	}

-	if ((info->mode !=3D IPT_TTL_SET) && (info->ttl =3D=3D 0)) {
-		printk(KERN_WARNING "TTL: increment/decrement doesn't make sense with
value 0\n");
-		return 0;
-	}
-
 	return 1;
 }

--
Nicolas Bouliane,
Samuel Jean
at cookinglinux.org
