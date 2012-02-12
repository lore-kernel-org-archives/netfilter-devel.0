From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] ulogd2 / DBI / table name
Date: Sun, 12 Feb 2012 23:56:27 +0100
Message-ID: <20120212225627.GH3216@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="xA/XKXTdy9G3iaIz"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:60630 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab2BLXHG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Feb 2012 18:07:06 -0500
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.72)
	(envelope-from <laforge@netfilter.org>)
	id 1RwiVc-0006vu-Oj
	for netfilter-devel@vger.kernel.org; Mon, 13 Feb 2012 00:07:05 +0100
Received: from laforge by nataraja.de.gnumonks.org with local (Exim 4.77)
	(envelope-from <laforge@netfilter.org>)
	id 1RwiLL-0000A6-LZ
	for netfilter-devel@vger.kernel.org; Sun, 12 Feb 2012 23:56:27 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--xA/XKXTdy9G3iaIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

I've tried to use the DBI plugin of ulogd2 for NFCT based accounting,
and despite using table="conntrack", it always insisted in using the
table "ulog" for deriving the keys/columns to be stored.

I've hacked up a quick fix, and it seems to work as expected (though no
proper null temrmination after strncpy).

As I've been absent from ulogd and netfilter hacking for some time, I
tohught I'd post it here rather than pushing something to the git
repo...

Regards,
	Harald

-- 
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xA/XKXTdy9G3iaIz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ulogd2-dbi-table.diff"

diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index 88730e6..4b3ec16 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -102,7 +102,8 @@ static void str_tolower(char *s)
 static int get_columns_dbi(struct ulogd_pluginstance *upi)
 {
 	struct dbi_instance *pi = (struct dbi_instance *) upi->private;
-	char query[256] = "SELECT * FROM ulog\0";
+	char *table = table_ce(upi->config_kset).u.string;
+	char query[256];
 	unsigned int ui;
 
 	if (!pi->dbh) {
@@ -110,6 +111,8 @@ static int get_columns_dbi(struct ulogd_pluginstance *upi)
 		return 1;
 	}
 
+	snprintf(query, 256, "SELECT * FROM %s", table);
+
 	ulogd_log(ULOGD_DEBUG, "%s\n", query);
 	pi->result = dbi_conn_query(pi->dbh,query);
 	if (!pi->result) {

--xA/XKXTdy9G3iaIz--
