From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnetfilter_conntrack PATCH 3/3] qa: update test_api with IPv6 NAT
Date: Tue, 17 May 2016 14:50:42 +0200
Message-ID: <146348944247.4910.7175970817291513358.stgit@nfdev2.cica.es>
References: <146348935823.4910.10745657047372991575.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55672 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751724AbcEQMuu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2016 08:50:50 -0400
In-Reply-To: <146348935823.4910.10745657047372991575.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Comparators are not implemented.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 qa/test_api.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/qa/test_api.c b/qa/test_api.c
index 3742357..b96ecf7 100644
--- a/qa/test_api.c
+++ b/qa/test_api.c
@@ -178,6 +178,8 @@ static int test_nfct_cmp_api_single(struct nf_conntrack *ct1,
 	/* FIXME: not implemented comparators: */
 	case ATTR_SNAT_IPV4:
 	case ATTR_DNAT_IPV4:
+	case ATTR_SNAT_IPV6:
+	case ATTR_DNAT_IPV6:
 	case ATTR_SNAT_PORT:
 	case ATTR_DNAT_PORT:
 

