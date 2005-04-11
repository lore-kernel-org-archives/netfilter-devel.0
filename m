From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [PATCH] Some parameter fixes for ip(6)tables.c
Date: Mon, 11 Apr 2005 10:30:40 +0000
Message-ID: <425A51D0.4060504@outerspace.dyndns.org>
References: <424144D6.2090107@outerspace.dyndns.org>
	<20050401063500.GM19835@sunbeam.de.gnumonks.org>
	<425866CC.3020809@outerspace.dyndns.org>
	<20050410204305.GR9155@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020809000108090801010108"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050410204305.GR9155@sunbeam.de.gnumonks.org>
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
--------------020809000108090801010108
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting Harald Welte on 2005-04-10 20:43 UTC:

New patch includes fixes 2, 3 and 4 (since you already applied fix 1):

|>|> 2. the commands_v_options two-dimensional array lacks a column for the
|>|> -c flag. I tried to deduce feasible values, please look at them before
|>|> accepting :)

for the record; the values were deduced from the commandline help texts.

|>|> 3. the inverse_for_options array lacks a row for the -c flag. By
|>|> looking at the code I figured it does not allow the "!" inversion
|>|> option, so I constructed the line accordingly.

| just remove CMD_CHECK and anything relating to it.

4. Removed CMD_CHECK; updated bitmasks and commands_v_options accordingly

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCWlHOxyF48ZTvn+4RAo1XAKC3O1J8qQ6jEenNy/OGrgrEo4CJ3gCdGhsM
qhya1K1gwxoc8Lw1+p6zTqs=
=ctxE
-----END PGP SIGNATURE-----

--------------020809000108090801010108
Content-Type: text/x-patch;
 name="iptables-1.3.1-c_flag_and_CHECK.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="iptables-1.3.1-c_flag_and_CHECK.patch"

diff --exclude-from=/tmp/srcdiff.excludes.AIs1cV -Np -ur orig-iptables-1.3.1/ip6tables.c iptables-1.3.1/ip6tables.c
--- orig-iptables-1.3.1/ip6tables.c	2005-04-02 09:38:39.000000000 +0300
+++ iptables-1.3.1/ip6tables.c	2005-04-11 13:18:10.000000000 +0300
@@ -81,11 +81,10 @@
 #define CMD_NEW_CHAIN		0x0100U
 #define CMD_DELETE_CHAIN	0x0200U
 #define CMD_SET_POLICY		0x0400U
-#define CMD_CHECK		0x0800U
-#define CMD_RENAME_CHAIN	0x1000U
-#define NUMBER_OF_CMD	13
-static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-				 'N', 'X', 'P', 'E' };
+#define CMD_RENAME_CHAIN	0x0800U
+#define NUMBER_OF_CMD	12
+static const char cmdflags[NUMBER_OF_CMD]
+= { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z', 'N', 'X', 'P', 'E' };
 
 #define OPTION_OFFSET 256
 
@@ -159,20 +158,19 @@ static unsigned int global_option_offset
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
+/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x',   'x'}
 };
 
 static int inverse_for_options[NUMBER_OF_OPT] =
@@ -186,7 +184,8 @@ static int inverse_for_options[NUMBER_OF
 /* -x */ 0,
 /* -i */ IP6T_INV_VIA_IN,
 /* -o */ IP6T_INV_VIA_OUT,
-/*--line*/ 0
+/*--line*/ 0,
+/* -c */ 0,
 };
 
 const char *program_version;
diff --exclude-from=/tmp/srcdiff.excludes.AIs1cV -Np -ur orig-iptables-1.3.1/iptables.c iptables-1.3.1/iptables.c
--- orig-iptables-1.3.1/iptables.c	2005-04-02 09:38:39.000000000 +0300
+++ iptables-1.3.1/iptables.c	2005-04-11 13:17:49.000000000 +0300
@@ -78,11 +78,10 @@
 #define CMD_NEW_CHAIN		0x0100U
 #define CMD_DELETE_CHAIN	0x0200U
 #define CMD_SET_POLICY		0x0400U
-#define CMD_CHECK		0x0800U
-#define CMD_RENAME_CHAIN	0x1000U
-#define NUMBER_OF_CMD	13
-static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-				 'N', 'X', 'P', 'E' };
+#define CMD_RENAME_CHAIN	0x0800U
+#define NUMBER_OF_CMD	12
+static const char cmdflags[NUMBER_OF_CMD]
+= { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z', 'N', 'X', 'P', 'E' };
 
 #define OPTION_OFFSET 256
 
@@ -158,20 +157,19 @@ static unsigned int global_option_offset
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
+/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x',   'x'}
 };
 
 static int inverse_for_options[NUMBER_OF_OPT] =
@@ -186,7 +184,8 @@ static int inverse_for_options[NUMBER_OF
 /* -i */ IPT_INV_VIA_IN,
 /* -o */ IPT_INV_VIA_OUT,
 /* -f */ IPT_INV_FRAG,
-/*--line*/ 0
+/*--line*/ 0,
+/* -c */ 0,
 };
 
 const char *program_version;

--------------020809000108090801010108--
