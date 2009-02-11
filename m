From: Tino Keitel <tkeitel@innominate.com>
Subject: [PATCH] fix source code corruption in ebtables Makefile
Date: Wed, 11 Feb 2009 17:31:42 +0100
Message-ID: <20090211163142.GA28401@tkeitel002.bln.innominate.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: bart.de.schuymer@pandora.be, ebtables-devel@lists.sourceforge.net,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:58423 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbZBKQcA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:32:00 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

the attached patch fixes source code corruption in the static: target
of the ebtables userspace Makefile. The sed magic tries to clean up the
modified source files, but fails. It ends up with this modifications:

diff -ru ebtables-v2.0.8-2.orig/extensions/ebt_nflog.c
ebtables-v2.0.8-2/extensions/ebt_nflog.c
--- ebtables-v2.0.8-2.orig/extensions/ebt_nflog.c       2009-02-11
16:21:37.000000000 +0100
+++ ebtables-v2.0.8-2/extensions/ebt_nflog.c    2009-02-11
17:22:58.000000000 +0100
@@ -45,7 +45,7 @@
               "in-kernel queue\n");
 }
 
-static void nflog_init(struct ebt_entry_watcher *watcher)
+static _init(struct ebt_entry_watcher *watcher)
 {
        struct ebt_nflog_info *info = (struct ebt_nflog_info
*)watcher->data;
 
@@ -165,7 +165,7 @@
        .name = "nflog",
        .size = sizeof(struct ebt_nflog_info),
        .help = nflog_help,
-       .init = nflog_init,
+       .init _init,
        .parse = nflog_parse,
        .final_check = nflog_final_check,
        .print = nflog_print,

With the patch, the Makefile makes a backup of the original files and
restores it after compilation.

Signed-off-by: Tino Keitel <tino.keitel@innominate.com>

-- 
Tino Keitel
Software Engineer
 
Innominate Security Technologies AG
/protecting industrial networks/
Tel: +49.30.921028-206
Fax: +49.30.921028-020
Rudower Chaussee 13
12489 Berlin / Germany
http://www.innominate.com/

Register Court: AG Charlottenburg, HRB 81603 Management Board: Dirk
Seewald, Chairman of the Supervisory Board: Volker Bibelhausen

INNOMINATE HAS MOVED. PLEASE NOTE THAT OUR BUSINESS CONTACT DATA HAS
CHANGED.
