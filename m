From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] nftables: add additional --numeric level
Date: Thu, 15 Aug 2013 16:24:11 -0700
Message-ID: <20130815232411.GA22555@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="mYCpIKhGyMATD0i+"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:59532 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab3HOXYH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Aug 2013 19:24:07 -0400
Received: by mail-pd0-f180.google.com with SMTP id y10so1401347pdj.11
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2013 16:24:05 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Personally, I like seeing ports and IPs numerically, but prefer protocols
to be shown by name.  As such, add a third --numeric level which will
show protocols by number, splitting them out from ports.

  -n/--numeric                  When specified once, show network addresses numerically.
                                When specified twice, also show Internet services,
                                user IDs and group IDs numerically.
                                When specified thrice, also show protocols numerically.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-nftables-numeric

diff --git a/include/nftables.h b/include/nftables.h
index ec21d37..12f3c49 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -8,6 +8,7 @@
 enum numeric_level {
 	NUMERIC_NONE,
 	NUMERIC_ADDR,
+	NUMERIC_PORT,
 	NUMERIC_ALL,
 };
 
diff --git a/src/datatype.c b/src/datatype.c
index 55368ee..243760d 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -487,7 +487,7 @@ static void inet_service_type_print(const struct expr *expr)
 	sin.sin_port = mpz_get_be16(expr->value);
 	err = getnameinfo((struct sockaddr *)&sin, sizeof(sin), NULL, 0,
 			  buf, sizeof(buf),
-			  numeric_output < NUMERIC_ALL ? 0 : NI_NUMERICSERV);
+			  numeric_output < NUMERIC_PORT ? 0 : NI_NUMERICSERV);
 	if (err != 0) {
 		getnameinfo((struct sockaddr *)&sin, sizeof(sin), NULL,
 			    0, buf, sizeof(buf), NI_NUMERICSERV);
diff --git a/src/main.c b/src/main.c
index 48d4e03..1a40b9e 100644
--- a/src/main.c
+++ b/src/main.c
@@ -104,8 +104,9 @@ static void show_help(const char *name)
 "  -i/--interactive		Read input from interactive CLI\n"
 "\n"
 "  -n/--numeric			When specified once, show network addresses numerically.\n"
-"  				When specified twice, also show Internet protocols,\n"
-"				Internet services, user IDs and group IDs numerically.\n"
+"  				When specified twice, also show Internet services,\n"
+"				user IDs and group IDs numerically.\n"
+"				When specified thrice, also show protocols numerically.\n"
 "  -a/--handle			Output rule handle.\n"
 "  -I/--includepath <directory>	Add <directory> to the paths searched for include files.\n"
 #ifdef DEBUG

--mYCpIKhGyMATD0i+--
