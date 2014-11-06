From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] nft: don't resolve hostnames by default
Date: Thu, 6 Nov 2014 11:31:00 +0100
Message-ID: <20141106103100.GA4783@salvia>
References: <20141106080458.24488.47600.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45221 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaKFK3P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:29:15 -0500
Content-Disposition: inline
In-Reply-To: <20141106080458.24488.47600.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 06, 2014 at 09:05:28AM +0100, Arturo Borrero Gonzalez wrote:
> This patch changes the behaviour of nft to don't translate IP
> addresses to hostnames when printing rules.

Thanks. I took over this patch and gave it another spin. Find it
attached.

--45Z9DzgjV8m4Oswq
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-nft-don-t-resolve-hostnames-by-default.patch"

>From 15fe0f576a882aaffe2e620211d28f16a7ce7797 Mon Sep 17 00:00:00 2001
From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Date: Thu, 6 Nov 2014 09:05:28 +0100
Subject: [PATCH] nft: don't resolve hostnames by default

This patch changes the default behaviour of nft to not translate IP
addresses to hostnames when printing rules if no options are passed.

The options regarding translations after this patch are:

 <no -n/-N>             show IP addresses numerically (default behaviour)
 -n                     show IP addresses numerically
 -nn			show Internet services and uid/gid numerically
 -nnn			show protocols numerically
 -N (--reversedns)	translate IP addresses to names

The idea is to avoid breaking existing scripts that most likely rely on
'-n' to save the ruleset, so we reduce the impact of this patch and
provide a default behaviour that doesn't generate network traffic when
listing / saving the ruleset.

Suggested-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.xml        |   15 ++++++++++++---
 include/nftables.h |    1 +
 src/datatype.c     |    4 ++--
 src/main.c         |   16 +++++++++++++---
 4 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index cec5ef3..e45a593 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -101,9 +101,18 @@ vi:ts=4 sw=4
 					<para>
 						Numeric output: Addresses and other information
 						that might need network traffic to resolve to symbolic names
-						are shown numerically. When used twice, internet services
-						and UIDs/GIDs are also shown numerically. When used thrice,
-						protocol numbers are also shown numerically.
+						are shown numerically (default behaviour). When used twice,
+						internet services are translated. When used twice, internet
+						services and UIDs/GIDs are also shown numerically. When used
+						three times, protocol numbers are also shown numerically.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
+				<term><option>-N</option></term>
+				<listitem>
+					<para>
+						Translate IP addresses to DNS names.
 					</para>
 				</listitem>
 			</varlistentry>
diff --git a/include/nftables.h b/include/nftables.h
index c3d3dbf..4c33ec6 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -26,6 +26,7 @@ enum debug_level {
 
 extern unsigned int max_errors;
 extern unsigned int numeric_output;
+extern unsigned int ip2name_output;
 extern unsigned int handle_output;
 extern unsigned int debug_level;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
diff --git a/src/datatype.c b/src/datatype.c
index 8ad211c..5f976aa 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -379,7 +379,7 @@ static void ipaddr_type_print(const struct expr *expr)
 	sin.sin_addr.s_addr = mpz_get_be32(expr->value);
 	err = getnameinfo((struct sockaddr *)&sin, sizeof(sin), buf,
 			  sizeof(buf), NULL, 0,
-			  numeric_output ? NI_NUMERICHOST : 0);
+			  ip2name_output ? 0 : NI_NUMERICHOST);
 	if (err != 0) {
 		getnameinfo((struct sockaddr *)&sin, sizeof(sin), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
@@ -437,7 +437,7 @@ static void ip6addr_type_print(const struct expr *expr)
 
 	err = getnameinfo((struct sockaddr *)&sin6, sizeof(sin6), buf,
 			  sizeof(buf), NULL, 0,
-			  numeric_output ? NI_NUMERICHOST : 0);
+			  ip2name_output ? 0 : NI_NUMERICHOST);
 	if (err != 0) {
 		getnameinfo((struct sockaddr *)&sin6, sizeof(sin6), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
diff --git a/src/main.c b/src/main.c
index 3607bd5..1625914 100644
--- a/src/main.c
+++ b/src/main.c
@@ -28,6 +28,7 @@
 
 unsigned int max_errors = 10;
 unsigned int numeric_output;
+unsigned int ip2name_output;
 unsigned int handle_output;
 #ifdef DEBUG
 unsigned int debug_level;
@@ -43,12 +44,13 @@ enum opt_vals {
 	OPT_INTERACTIVE		= 'i',
 	OPT_INCLUDEPATH		= 'I',
 	OPT_NUMERIC		= 'n',
+	OPT_IP2NAME		= 'N',
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
+		.name		= "reversedns",
+		.val		= OPT_IP2NAME,
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
+"  -n/--numeric			When specified once, show network addresses numerically (default behaviour).\n"
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
+		case OPT_IP2NAME:
+			ip2name_output++;
+			break;
 #ifdef DEBUG
 		case OPT_DEBUG:
 			for (;;) {
-- 
1.7.10.4


--45Z9DzgjV8m4Oswq--
