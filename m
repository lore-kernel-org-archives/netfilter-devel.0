From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: [PATCH] Some parameter fixes for ip(6)tables.c
Date: Wed, 23 Mar 2005 12:28:38 +0200
Message-ID: <424144D6.2090107@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090603010400040305040102"
To: netfilter-devel@lists.netfilter.org
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
--------------090603010400040305040102
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

iptables.c and ip6tables.c IMO have three parameter problems, which I
attempt to fix with the attached patch. Both files have the same defects,
and thus both files have logically identical fixes.

1. the optflags array contains a '3' for the OPT_LINENUMBERS entry while
everywhere else '0' is used. Thus the fix changes it

2. the commands_v_options two-dimensional array lacks a column for the -c
flag. I tried to deduce feasible values, please look at them before accepting :)

3. the inverse_for_options array lacks a row for the -c flag. By looking at
the code I figured it does not allow the "!" inversion option, so I
constructed the line accordingly.

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCQUTSxyF48ZTvn+4RAq5vAJ4g5FCblhR4TWJgZJoiK1nSRRa8oACcDLbz
myTf8ISAGl/t4AhwNf1si8k=
=Mha+
-----END PGP SIGNATURE-----

--------------090603010400040305040102
Content-Type: text/x-patch; name="iptables-1.3.1-c_flag_and_linenumbers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="iptables-1.3.1-c_flag_and_linenumbers.patch"

diff --exclude-from=/tmp/srcdiff.excludes.NOfFZH -Np -ur orig/iptables-1.3.1/ip6tables.c iptables-1.3.1-fix/ip6tables.c
--- orig-iptables-1.3.1/ip6tables.c	2005-02-19 21:19:17.000000000 +0200
+++ iptables-1.3.1-fix/ip6tables.c	2005-03-23 12:05:32.000000000 +0200
@@ -103,7 +103,7 @@ static const char cmdflags[] = { 'I', 'D
 #define OPT_COUNTERS	0x00400U
 #define NUMBER_OF_OPT	11
 static const char optflags[NUMBER_OF_OPT]
-= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '3', 'c'};
+= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c'};
 
 static struct option original_opts[] = {
 	{ "append", 1, 0, 'A' },
@@ -159,20 +159,20 @@ static unsigned int global_option_offset
 static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
-	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o  --line */
-/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x'},
-/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x'},
-/*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x'},
-/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ','x'},
-/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x'},
-/*LIST*/      {' ','x','x','x','x',' ',' ','x','x',' '},
-/*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x'},
-/*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x'},
-/*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x'},
-/*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x'},
-/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x'},
-/*CHECK*/     {'x','+','+','+','x',' ','x',' ',' ','x'},
-/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x'}
+	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o  --line -c */
+/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',   ' '},
+/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',   'x'},
+/*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x',   'x'},
+/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ','x',   'x'},
+/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',   ' '},
+/*LIST*/      {' ','x','x','x','x',' ',' ','x','x',' ',   'x'},
+/*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x',   'x'},
+/*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x',   'x'},
+/*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x',   'x'},
+/*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x',   'x'},
+/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',   'x'},
+/*CHECK*/     {'x','+','+','+','x',' ','x',' ',' ','x',   'x'},
+/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x',   'x'}
 };
 
 static int inverse_for_options[NUMBER_OF_OPT] =
@@ -186,7 +186,8 @@ static int inverse_for_options[NUMBER_OF
 /* -x */ 0,
 /* -i */ IP6T_INV_VIA_IN,
 /* -o */ IP6T_INV_VIA_OUT,
-/*--line*/ 0
+/*--line*/ 0,
+/* -c */ 0,
 };
 
 const char *program_version;
diff --exclude-from=/tmp/srcdiff.excludes.NOfFZH -Np -ur orig/iptables-1.3.1/iptables.c iptables-1.3.1-fix/iptables.c
--- orig-iptables-1.3.1/iptables.c	2005-02-19 21:19:17.000000000 +0200
+++ iptables-1.3.1-fix/iptables.c	2005-03-23 12:06:24.000000000 +0200
@@ -101,7 +101,7 @@ static const char cmdflags[] = { 'I', 'D
 #define OPT_COUNTERS	0x00800U
 #define NUMBER_OF_OPT	12
 static const char optflags[NUMBER_OF_OPT]
-= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', 'f', '3', 'c'};
+= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', 'f', '0', 'c'};
 
 static struct option original_opts[] = {
 	{ "append", 1, 0, 'A' },
@@ -158,20 +158,20 @@ static unsigned int global_option_offset
 static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
-	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o  -f  --line */
-/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x'},
-/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x'},
-/*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x'},
-/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x'},
-/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x'},
-/*LIST*/      {' ','x','x','x','x',' ',' ','x','x','x',' '},
-/*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x'},
-/*CHECK*/     {'x','+','+','+','x',' ','x',' ',' ',' ','x'},
-/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x'}
+	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o  -f  --line -c */
+/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x',   ' '},
+/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x',   'x'},
+/*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x',   'x'},
+/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x',   'x'},
+/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x',   ' '},
+/*LIST*/      {' ','x','x','x','x',' ',' ','x','x','x',' ',   'x'},
+/*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x',   'x'},
+/*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x',   'x'},
+/*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x',   'x'},
+/*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x',   'x'},
+/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x',   'x'},
+/*CHECK*/     {'x','+','+','+','x',' ','x',' ',' ',' ','x',   'x'},
+/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x',   'x'}
 };
 
 static int inverse_for_options[NUMBER_OF_OPT] =
@@ -186,7 +186,8 @@ static int inverse_for_options[NUMBER_OF
 /* -i */ IPT_INV_VIA_IN,
 /* -o */ IPT_INV_VIA_OUT,
 /* -f */ IPT_INV_FRAG,
-/*--line*/ 0
+/*--line*/ 0,
+/* -c */ 0,
 };
 
 const char *program_version;

--------------090603010400040305040102--
