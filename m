From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH next-3.14] expr: fix registers datatypes
Date: Fri, 10 Jan 2014 13:07:51 +0100
Message-ID: <20140110120751.9047.7872.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47835 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751062AbaAJMH5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:07:57 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id BB0D351ED65
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2014 12:07:54 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cFBByE-BgFsU for <netfilter-devel@vger.kernel.org>;
	Fri, 10 Jan 2014 13:07:54 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 8610851ED6B
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2014 13:07:54 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Registers datatypes must be enum nft_registers.

Pablo Neira says:
<< From the kernel representation point of view, it doesn't make any
sense to have set both sreg and dreg, but we should not make such
assumption from userspace. If the user sets both sreg and dreg, it's
wrong and the kernel should reply -EINVAL so the user knows that it
has to fix its userspace code. This requires a bit more memory in
userspace, but we don't have the memory restrictions that we have in
kernelspace, so a bit more consumption won't harm. >>

So, while at it, delete the meta expr union for registers.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/cmp.c  |    2 +-
 src/expr/meta.c |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 246f22f..ab244ac 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -26,7 +26,7 @@
 
 struct nft_expr_cmp {
 	union nft_data_reg	data;
-	uint8_t			sreg;	/* enum nft_registers */
+	enum nft_registers	sreg;
 	uint8_t			op;	/* enum nft_cmp_ops */
 };
 
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 490d64a..7fd0af1 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -28,10 +28,8 @@
 
 struct nft_expr_meta {
 	uint8_t			key;	/* enum nft_meta_keys */
-	union {
-		uint8_t		dreg;	/* enum nft_registers */
-		uint8_t		sreg;   /* enum nft_registers */
-	};
+	enum nft_registers	dreg;
+	enum nft_registers	sreg;
 };
 
 static int

