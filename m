From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnetfilter-conntrack PATCH] qa: update test_api with IPv6 NAT
Date: Tue, 24 May 2016 11:09:39 +0200
Message-ID: <146408097950.11122.5672229125585867763.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:41359 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754965AbcEXJJs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2016 05:09:48 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id C8B0A51F28A
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 09:09:44 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h8EeuCAAX_jV for <netfilter-devel@vger.kernel.org>;
	Tue, 24 May 2016 11:09:39 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	(Authenticated sender: servers@cica.es)
	by smtp.cica.es (Postfix) with ESMTP id DD6FD51F208
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:09:39 +0200 (CEST)
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
 

