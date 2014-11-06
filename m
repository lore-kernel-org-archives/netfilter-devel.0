From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH v2] nft: don't resolve hostnames by default
Date: Thu, 06 Nov 2014 09:05:28 +0100
Message-ID: <20141106080458.24488.47600.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57612 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751141AbaKFIFn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:05:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch changes the behaviour of nft to don't translate IP
addresses to hostnames when printing rules.

So, the behaviour of nft ends like this:
 <no -n given>		show IP addresses numerically
 -n			show IP addresses numerically
 -nn			show Internet services and uid/gid numerically
 -nnn			show protocols numerically
 -N			translate IP addresses to names

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: add the -N switch to translate IP addresses to names.

 doc/nft.xml        |   14 +++++++++++---
 include/nftables.h |    1 +
 src/datatype.c     |    4 ++--
 src/main.c         |   16 +++++++++++++---
 4 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index cec5ef3..45fd976 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -99,15 +99,23 @@ vi:ts=4 sw=4
 				<term><option>-n/--numeric</option></term>
 				<listitem>
 					<para>
-						Numeric output: Addresses and other information
-						that might need network traffic to resolve to symbolic names
-						are shown numerically. When used twice, internet services
+						Numeric output: Information that might need network
+						traffic to resolve to symbolic names
+						are translated. When used twice, internet services
 						and UIDs/GIDs are also shown numerically. When used thrice,
 						protocol numbers are also shown numerically.
 					</para>
 				</listitem>
 			</varlistentry>
 			<varlistentry>
+				<term><option>-N</option></term>
+				<listitem>
+					<para>
+						Translate IP addresses to DNS names.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
 				<term><option>-a/--handle</option></term>
 				<listitem>
 					<para>
diff --git a/include/nftables.h b/include/nftables.h
index c3d3dbf..a46af47 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -26,6 +26,7 @@ enum debug_level {
 
 extern unsigned int max_errors;
 extern unsigned int numeric_output;
+extern unsigned int ip2names_output;
 extern unsigned int handle_output;
 extern unsigned int debug_level;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
diff --git a/src/datatype.c b/src/datatype.c
index 8ad211c..84a058b 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -379,7 +379,7 @@ static void ipaddr_type_print(const struct expr *expr)
 	sin.sin_addr.s_addr = mpz_get_be32(expr->value);
 	err = getnameinfo((struct sockaddr *)&sin, sizeof(sin), buf,
 			  sizeof(buf), NULL, 0,
-			  numeric_output ? NI_NUMERICHOST : 0);
+			  ip2names_output ? 0 : NI_NUMERICHOST);
 	if (err != 0) {
 		getnameinfo((struct sockaddr *)&sin, sizeof(sin), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
@@ -437,7 +437,7 @@ static void ip6addr_type_print(const struct expr *expr)
 
 	err = getnameinfo((struct sockaddr *)&sin6, sizeof(sin6), buf,
 			  sizeof(buf), NULL, 0,
-			  numeric_output ? NI_NUMERICHOST : 0);
+			  ip2names_output ? 0 : NI_NUMERICHOST);
 	if (err != 0) {
 		getnameinfo((struct sockaddr *)&sin6, sizeof(sin6), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
diff --git a/src/main.c b/src/main.c
index 3607bd5..3e251d5 100644
--- a/src/main.c
+++ b/src/main.c
@@ -28,6 +28,7 @@
 
 unsigned int max_errors = 10;
 unsigned int numeric_output;
+unsigned int ip2names_output;
 unsigned int handle_output;
 #ifdef DEBUG
 unsigned int debug_level;
@@ -43,12 +44,13 @@ enum opt_vals {
 	OPT_INTERACTIVE		= 'i',
 	OPT_INCLUDEPATH		= 'I',
 	OPT_NUMERIC		= 'n',
+	OPT_IP2NAMES		= 'N',
 	OPT_DEBUG		= 'd',
 	OPT_HANDLE_OUTPUT	= 'a',
 	OPT_INVALID		= '?',
 };
 
-#define OPTSTRING	"hvf:iI:vna"
+#define OPTSTRING	"hvf:iI:vnNa"
 
 static const struct option options[] = {
 	{
@@ -73,6 +75,10 @@ static const struct option options[] = {
 		.val		= OPT_NUMERIC,
 	},
 	{
+		.name		= "ip2names",
+		.val		= OPT_IP2NAMES,
+	},
+	{
 		.name		= "includepath",
 		.val		= OPT_INCLUDEPATH,
 		.has_arg	= 1,
@@ -105,10 +111,11 @@ static void show_help(const char *name)
 "  -f/--file <filename>		Read input from <filename>\n"
 "  -i/--interactive		Read input from interactive CLI\n"
 "\n"
-"  -n/--numeric			When specified once, show network addresses numerically.\n"
-"  				When specified twice, also show Internet services,\n"
+"  -n/--numeric			When specified once, nothing happens.\n"
+"  				When specified twice, show Internet services,\n"
 "				user IDs and group IDs numerically.\n"
 "				When specified thrice, also show protocols numerically.\n"
+"  -N				Translate IP addresses to names.\n"
 "  -a/--handle			Output rule handle.\n"
 "  -I/--includepath <directory>	Add <directory> to the paths searched for include files.\n"
 #ifdef DEBUG
@@ -279,6 +286,9 @@ int main(int argc, char * const *argv)
 		case OPT_NUMERIC:
 			numeric_output++;
 			break;
+		case OPT_IP2NAMES:
+			ip2names_output = 1;
+			break;
 #ifdef DEBUG
 		case OPT_DEBUG:
 			for (;;) {

