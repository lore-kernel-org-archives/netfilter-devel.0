From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] ip6tables: don't print out /128
Date: Thu, 20 Jun 2013 16:11:38 -0400
Message-ID: <20130620201138.GA11634@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52681 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423073Ab3FVANR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jun 2013 20:13:17 -0400
Received: by mail-pa0-f49.google.com with SMTP id ld11so8557869pab.36
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2013 17:13:16 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Similar to how iptables does not print /32 on IPv4 addresses, ip6tables
should not print out /128 on IPv6 addresses.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-no_128

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index ebc77b6..ef5bc07 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1597,7 +1597,11 @@ const char *xtables_ip6mask_to_numeric(const struct in6_addr *addrp)
 		strcat(buf, xtables_ip6addr_to_numeric(addrp));
 		return buf;
 	}
-	sprintf(buf, "/%d", l);
+	/* we don't want to see "/128" */
+	if (l == 128)
+		return "";
+	else
+		sprintf(buf, "/%d", l);
 	return buf;
 }
 

--gKMricLos+KVdGMg--
