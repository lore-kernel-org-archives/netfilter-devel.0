From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] nft: don't resolve hostnames by default
Date: Sat, 18 Oct 2014 21:26:02 +0200
Message-ID: <20141018192602.11369.83759.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54661 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751335AbaJRT0Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Oct 2014 15:26:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch changes the behaviour of nft to don't translate IP
addresses to hostnames when printing rules.

So, the behaviour of '-n' ends like this:
 <no -n given>		show IP addresses numerically
 -n			translate IP addresses to names
 -nn			show Internet services and uid/gid numerically
 -nnn			show protocols numerically

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 doc/nft.xml    |    2 +-
 src/datatype.c |    4 ++--
 src/main.c     |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index cec5ef3..8f4642b 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -101,7 +101,7 @@ vi:ts=4 sw=4
 					<para>
 						Numeric output: Addresses and other information
 						that might need network traffic to resolve to symbolic names
-						are shown numerically. When used twice, internet services
+						are translated. When used twice, internet services
 						and UIDs/GIDs are also shown numerically. When used thrice,
 						protocol numbers are also shown numerically.
 					</para>
diff --git a/src/datatype.c b/src/datatype.c
index 8ad211c..4ff08c1 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -379,7 +379,7 @@ static void ipaddr_type_print(const struct expr *expr)
 	sin.sin_addr.s_addr = mpz_get_be32(expr->value);
 	err = getnameinfo((struct sockaddr *)&sin, sizeof(sin), buf,
 			  sizeof(buf), NULL, 0,
-			  numeric_output ? NI_NUMERICHOST : 0);
+			  numeric_output ? 0 : NI_NUMERICHOST);
 	if (err != 0) {
 		getnameinfo((struct sockaddr *)&sin, sizeof(sin), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
@@ -437,7 +437,7 @@ static void ip6addr_type_print(const struct expr *expr)
 
 	err = getnameinfo((struct sockaddr *)&sin6, sizeof(sin6), buf,
 			  sizeof(buf), NULL, 0,
-			  numeric_output ? NI_NUMERICHOST : 0);
+			  numeric_output ? 0 : NI_NUMERICHOST);
 	if (err != 0) {
 		getnameinfo((struct sockaddr *)&sin6, sizeof(sin6), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
diff --git a/src/main.c b/src/main.c
index 3607bd5..ced627d 100644
--- a/src/main.c
+++ b/src/main.c
@@ -105,8 +105,8 @@ static void show_help(const char *name)
 "  -f/--file <filename>		Read input from <filename>\n"
 "  -i/--interactive		Read input from interactive CLI\n"
 "\n"
-"  -n/--numeric			When specified once, show network addresses numerically.\n"
-"  				When specified twice, also show Internet services,\n"
+"  -n/--numeric			When specified once, translate network addresses to names.\n"
+"  				When specified twice, show Internet services,\n"
 "				user IDs and group IDs numerically.\n"
 "				When specified thrice, also show protocols numerically.\n"
 "  -a/--handle			Output rule handle.\n"

