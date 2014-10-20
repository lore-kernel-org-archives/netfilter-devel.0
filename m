From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH v2] utils: fix arp family number
Date: Mon, 20 Oct 2014 12:51:05 +0200
Message-ID: <20141020105022.24332.84204.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:58075 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753060AbaJTKvP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:51:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NFPROTO_ARP = 3 in kernel space.

We need the same value here in userspace in order to correctly communicate
with the kernel.

The failure solved by this patch made that {XML|JSON}-parsed tables of ARP
family unable to be directly injected into kernel.

To prevent future errors, this patch changes raw and AF_* values by the mathing
NFPROTO_* couterpart as seen in linux/netfilter.h in both functions:
 * nft_family2str()
 * nft_str2family()

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: rework+fix using the array-matching approach suggested by Pablo.

 src/utils.c |   43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/src/utils.c b/src/utils.c
index d70fbf1..e9ef547 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -20,38 +20,33 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 
+static const char *nft_family_str[NFPROTO_NUMPROTO] = {
+	[NFPROTO_INET]		= "inet",
+	[NFPROTO_IPV4]		= "ip",
+	[NFPROTO_ARP]		= "arp",
+	[NFPROTO_BRIDGE]	= "bridge",
+	[NFPROTO_IPV6]		= "ip6",
+};
+
 const char *nft_family2str(uint32_t family)
 {
-	switch (family) {
-	case AF_INET:
-		return "ip";
-	case AF_INET6:
-		return "ip6";
-	case 1:
-		return "inet";
-	case AF_BRIDGE:
-		return "bridge";
-	case 3: /* NFPROTO_ARP */
-		return "arp";
-	default:
+	if (nft_family_str[family] == NULL)
 		return "unknown";
-	}
+
+	return nft_family_str[family];
 }
 
 int nft_str2family(const char *family)
 {
-	if (strcmp(family, "ip") == 0)
-		return AF_INET;
-	else if (strcmp(family, "ip6") == 0)
-		return AF_INET6;
-	else if (strcmp(family, "inet") == 0)
-		return 1;
-	else if (strcmp(family, "bridge") == 0)
-		return AF_BRIDGE;
-	else if (strcmp(family, "arp") == 0)
-		return 0;
+	int i;
 
-	errno = EAFNOSUPPORT;
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
+		if (nft_family_str[i] == NULL)
+			continue;
+
+		if (strcmp(nft_family_str[i], family) == 0)
+			return i;
+	}
 	return -1;
 }
 

