From: Domen Puncer <domen.puncer@samsung.com>
Subject: [PATCH iptables] libxtables: fix getaddrinfo return value usage
Date: Tue, 10 Jun 2014 14:29:49 +0100
Message-ID: <5397084D.8020703@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47111 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaFJNar (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:30:47 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N6Y002CRG783L10@mailout3.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Tue, 10 Jun 2014 14:30:44 +0100 (BST)
Received: from ex1.seri.co.uk ([106.1.8.3])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0N6Y00GKGG78T6B0@eusync3.samsung.com> for
 netfilter-devel@vger.kernel.org; Tue, 10 Jun 2014 14:30:44 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

getaddrinfo return value on error can also be positive.

Signed-off-by: Domen Puncer Kugler <domen.puncer@samsung.com>
---
 libxtables/xtoptions.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 9b4c5aa..d26d2f8 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -519,7 +519,7 @@ static void xtopt_parse_host(struct xt_option_call *cb)
 	int ret;

 	ret = getaddrinfo(cb->arg, NULL, &hints, &res);
-	if (ret < 0)
+	if (ret != 0)
 		xt_params->exit_err(PARAMETER_PROBLEM,
 			"getaddrinfo: %s\n", gai_strerror(ret));

@@ -562,7 +562,7 @@ static int xtables_getportbyname(const char *name)
 	int ret;

 	ret = getaddrinfo(NULL, name, NULL, &res);
-	if (ret < 0)
+	if (ret != 0)
 		return -1;
 	ret = -1;
 	for (p = res; p != NULL; p = p->ai_next) {
@@ -675,7 +675,7 @@ static int xtopt_parse_mask(struct xt_option_call *cb)
 	int ret;

 	ret = getaddrinfo(cb->arg, NULL, &hints, &res);
-	if (ret < 0)
+	if (ret != 0)
 		return 0;

 	memcpy(&cb->val.hmask, xtables_sa_host(res->ai_addr, res->ai_family),
