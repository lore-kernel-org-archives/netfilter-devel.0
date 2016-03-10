From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH 2/2] iptables/xtables-arp.c: fix typo,
 wierd vs weird
Date: Thu, 10 Mar 2016 11:35:51 +0100
Message-ID: <145760615172.4027.14167970874816721054.stgit@r2d2.cica.es>
References: <145760614615.4027.14453402278808172625.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:50077 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932895AbcCJLRh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 06:17:37 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id BACAF51F1BB
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 10:35:56 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pXJoP_0s2iM0 for <netfilter-devel@vger.kernel.org>;
	Thu, 10 Mar 2016 11:35:51 +0100 (CET)
Received: from r2d2.cica.es (r2d2.cica.es [IPv6:2a00:9ac0:c1ca:27::150])
	by smtp.cica.es (Postfix) with ESMTP id C37BF51F191
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 11:35:51 +0100 (CET)
In-Reply-To: <145760614615.4027.14453402278808172625.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reported by Debian lintian tool.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/xtables-arp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 26ece01..346bece 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -727,7 +727,7 @@ parse_interface(const char *arg, char *vianame, unsigned char *mask)
 			if (!isalnum(vianame[i])
 			    && vianame[i] != '_'
 			    && vianame[i] != '.') {
-				printf("Warning: wierd character in interface"
+				printf("Warning: weird character in interface"
 				       " `%s' (No aliases, :, ! or *).\n",
 				       vianame);
 				break;

