From: "Nicolas Bouliane" <nib@cookinglinux.org>
Subject: Re: [PATCH 2.4/2.6]: TTL target
Date: Sun, 25 Jul 2004 21:37:48 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1526.192.168.1.16.1090805868.squirrel@192.168.1.16>
References: <1400.192.168.1.16.1090797821.squirrel@192.168.1.16>
    <41044BAC.7060705@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <41044BAC.7060705@trash.net>
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

Hi Patrick,

Patrick McHardy wrote:
>
> The kernel-part is fine, the userspace has some minor problems,
> see my comments below. Could you please send a new version ?
>

Sure, thanks for having taken a look.
Your comments was appreciated and instructive.

New patch below.


Signed-off-by: Nicolas Bouliane <nib@cookinglinux.org>


diff -urpN extensions/libipt_TTL.c.orig extensions/libipt_TTL.c
--- extensions/libipt_TTL.c.orig	2004-07-25 21:03:19.000000000 -0400
+++ extensions/libipt_TTL.c	2004-07-25 21:10:45.000000000 -0400
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

@@ -35,7 +35,7 @@ static int parse(int c, char **argv, int
 		struct ipt_entry_target **target)
 {
 	struct ipt_TTL_info *info =3D (struct ipt_TTL_info *) (*target)->data;
-	u_int8_t value;
+	u_int32_t value;

 	if (*flags & IPT_TTL_USED) {
 		exit_error(PARAMETER_PROBLEM,
@@ -50,7 +50,9 @@ static int parse(int c, char **argv, int
 		exit_error(PARAMETER_PROBLEM,
 				"TTL: unexpected `!'");

-	value =3D atoi(optarg);
+	if (string_to_number(optarg, 0, 255, &value) =3D=3D -1)
+      exit_error(PARAMETER_PROBLEM,
+            "TTL: Expected value between 0 and 255");

 	switch (c) {

--
Nicolas Bouliane,
Samuel Jean
at cookinglinux.org
