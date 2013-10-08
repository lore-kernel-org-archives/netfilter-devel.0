From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables: spurious error in load_extension
Date: Tue, 8 Oct 2013 09:20:15 -0700
Message-ID: <20131008162015.GB18402@home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40041 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab3JHQUS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:20:18 -0400
Received: by mail-pa0-f42.google.com with SMTP id lj1so9189720pab.29
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Oct 2013 09:20:17 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In commit 927385017047d (iptables: improve error reporting with extension
loading troubles), a new error message was added in an attempt to handle
the case where a match does not support a particular protocol family. 
For instance, attempting to use the osf match on IPv6.

Unfortunately, this error message now triggers when creating a new chain
which has the same name as a match extension, because iptables calls
xtables_find_target with the name of the new chain to verify it does not
clash with an existing target.  For example:

    # iptables -N tcp
    /usr/lib/xtables/libxt_tcp.so: no "tcp" extension found for this protocol

I attempted to resolve this by adding a new XTF flag, but that required changes
in many different places (including -j handling).  It seems easiest just to
remove this warning and stick with the original error message of ENOENT, even
if less than precise. 

Signed-off-by: Phil Oester <kernel@linuxace.com>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-iptables-load_extension

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 8437baf..fb60c01 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -578,8 +578,6 @@ static void *load_extension(const char *search_path, const char *af_prefix,
 			if (ptr != NULL)
 				return ptr;
 
-			fprintf(stderr, "%s: no \"%s\" extension found for "
-				"this protocol\n", path, name);
 			errno = ENOENT;
 			return NULL;
 		}

--tKW2IUtsqtDRztdT--
