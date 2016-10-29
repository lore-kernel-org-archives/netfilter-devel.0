From: Jon Jensen <jon@endpoint.com>
Subject: [PATCH] Correct description of -n/--numeric option
Date: Fri, 28 Oct 2016 22:18:11 -0600
Message-ID: <1477714691-8043-1-git-send-email-jon@endpoint.com>
Cc: Jon Jensen <jon@endpoint.com>
To: netfilter-devel@vger.kernel.org, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.endcrypt.com ([50.97.100.2]:56742 "EHLO mail.endcrypt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751028AbcJ2ESQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Oct 2016 00:18:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"When used twice" was used twice in the manpage. :)

And as Florian Westphal <fw@strlen.de> pointed out, it was also incorrect
for the -nn case.

Update the manpage and built-in help in main.c to match actual behavior.

Signed-off-by: Jon Jensen <jon@endpoint.com>
---
 doc/nft.xml | 12 +++++-------
 src/main.c  |  5 ++---
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index cc1e4a4..827458a 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -111,12 +111,10 @@ vi:ts=4 sw=4
 				<term><option>-n, --numeric</option></term>
 				<listitem>
 					<para>
-						Numeric output: Addresses and other information
-						that might need network traffic to resolve to symbolic names
-						are shown numerically (default behaviour). When used twice,
-						internet services are translated. When used twice, internet
-						services and UIDs/GIDs are also shown numerically. When used
-						three times, protocol numbers are also shown numerically.
+						Show data numerically. When used once (the default behaviour), skip
+						lookup of addresses to symbolic names. Use twice to also show Internet
+						services (port numbers) numerically. Use three times to also show
+						protocols and UIDs/GIDs numerically.
 					</para>
 				</listitem>
 			</varlistentry>
@@ -124,7 +122,7 @@ vi:ts=4 sw=4
 				<term><option>-N</option></term>
 				<listitem>
 					<para>
-						Translate IP addresses to DNS names.
+						Translate IP addresses to names. Usually requires network traffic for DNS lookup.
 					</para>
 				</listitem>
 			</varlistentry>
diff --git a/src/main.c b/src/main.c
index 39a47bb..5c72fc0 100644
--- a/src/main.c
+++ b/src/main.c
@@ -114,9 +114,8 @@ static void show_help(const char *name)
 "  -i, --interactive		Read input from interactive CLI\n"
 "\n"
 "  -n, --numeric			When specified once, show network addresses numerically (default behaviour).\n"
-"  				When specified twice, show Internet services,\n"
-"				user IDs and group IDs numerically.\n"
-"				When specified thrice, also show protocols numerically.\n"
+"  				Specify twice to also show Internet services (port numbers) numerically.\n"
+"				Specify three times to also show protocols, user IDs, and group IDs numerically.\n"
 "  -N				Translate IP addresses to names.\n"
 "  -a, --handle			Output rule handle.\n"
 "  -I, --includepath <directory>	Add <directory> to the paths searched for include files.\n"
-- 
2.7.4

