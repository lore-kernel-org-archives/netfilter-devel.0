From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [conntrack-tools PATCH] include/network.h: fix erroneus comment in
 NTA_(S|D)NAT_IPV6
Date: Fri, 03 Jun 2016 10:55:21 +0200
Message-ID: <146494412135.11445.11203183861526839776.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:44863 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932326AbcFCIz2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jun 2016 04:55:28 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 99ECB51F28A
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jun 2016 08:55:25 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9ENJPZXrm7Fe for <netfilter-devel@vger.kernel.org>;
	Fri,  3 Jun 2016 10:55:20 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	(Authenticated sender: servers@cica.es)
	by smtp.cica.es (Postfix) with ESMTP id 9AF8D51F284
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jun 2016 10:55:20 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We don't use 'struct nfct_attr_grp_ipv6', actually 'uint32_t * 4'.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/network.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/network.h b/include/network.h
index ab04591..ec9fadf 100644
--- a/include/network.h
+++ b/include/network.h
@@ -229,8 +229,8 @@ enum nta_attr {
 	NTA_TCP_WSCALE_REPL,	/* uint8_t */
 	NTA_HELPER_NAME,	/* string (variable length) */
 	NTA_LABELS,		/* array of uint32_t (variable length) */
-	NTA_SNAT_IPV6,		/* struct nfct_attr_grp_ipv6 */
-	NTA_DNAT_IPV6,		/* struct nfct_attr_grp_ipv6 */
+	NTA_SNAT_IPV6,		/* uint32_t * 4 */
+	NTA_DNAT_IPV6,		/* uint32_t * 4 */
 	NTA_MAX
 };
 

