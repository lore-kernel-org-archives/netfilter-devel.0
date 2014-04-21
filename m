From: Bob Hockney <zeus@ix.netcom.com>
Subject: [ ulogd PATCH 2/2 ] fix to allow not using connstring parameter in
 pgsql plugin
Date: Mon, 21 Apr 2014 14:16:02 -0600
Message-ID: <53557C82.5030100@ix.netcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:39448 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbaDUUYg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2014 16:24:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit a565216f3f772514356a067d68b775331b01832a
Author: Bob Hockney <zeus@ix.netcom.com>
Date:   Sat Apr 19 12:43:37 2014 -0600

     Connection parameters other than connstring are ignored, forcing its
     use.  u.string in config_keyset in conffile.h is a character array,
     not a pointer, and is initialized as a zero length string, not a null
     pointer, so the pointer assignment to connstr will always be a valid
     pointer, not NULL, so (! connstr) will always be false.

     Signed-off-by: Bob Hockney <zeus@ix.netcom.com>

diff --git a/output/pgsql/ulogd_output_PGSQL.c 
b/output/pgsql/ulogd_output_PGSQL.c
index fda289e..ac87a64 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -236,7 +236,7 @@ static int open_db_pgsql(struct ulogd_pluginstance *upi)
      char *schema = NULL;
      char pgbuf[128];

-    if (!connstr) {
+    if (! strlen(connstr)) {
          char *server = host_ce(upi->config_kset).u.string;
          unsigned int port = port_ce(upi->config_kset).u.value;
          char *user = user_ce(upi->config_kset).u.string;
