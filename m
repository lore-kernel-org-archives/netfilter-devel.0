Received: from sonic307-16.consmr.mail.ne1.yahoo.com (sonic307-16.consmr.mail.ne1.yahoo.com [66.163.190.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F385B437456
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 22:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.190.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788386549; cv=none; b=bA8iUls5/GZSxGfkBHFI4Dk0XQc5gPGH5sPW3gJDPuPjR85Bf3vDKas2UrLWc4mZN7sWRe4B36G+lv1WJJkEL1pNE2B48+zWniYdl5u291SLjIOg+kuqol8vF5nuf9NjMS9RO6VQogMCFTHHBzLBuT4VfLAs2595oSc4Lz0iMig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788386549; c=relaxed/simple;
	bh=LNWXFljLkpq0sNTIZjo7ZVj+8YP01OWnm3kOOlz8cgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUNR6XAxlwid2Im97/k7g+rvjgQf5LFHMIQhi1kzzYxIA40O4X+9GOOlkOlfUi0jXd47NKpKUWd7vAPGiuHvu8F6mVwZsTk4CVDC/mlWv1yVUgC21LDY0PN3ibirpKP5TUf0SL31e10z3FFXpujZn4JZD1PlT7P21LTOvoK6mZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=qonSmkDE; arc=none smtp.client-ip=66.163.190.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="qonSmkDE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386532; bh=+G7f48kgSLF3lQnxkxKP4UiGFczw6mAmMwToOl2pe+Y=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=qonSmkDEBI1NuWkPbbis7lpjot4HoRjXSmLQr41ucSQoYnmZUnrpd/klelUwNxxK9ZcHktUlUAxCypDGOU0y6u5zX5uq6MHDfg1A0NMsPHqscoMLeYQCzGaTsVACE998OtPgA8UqEqymwCbb8t1JOFQeX3dJDQmoGku/xJkilrJ1F/uU+a+yCN6Q9JYQuf8dsad7TVBpf7r22CiV0uICvMs+rjHTLp46EUmtNaFOkm6z+g93btG7dyuRqKN9kXYSZG99k/KCx269m3741dA8IM+v6J17nnSWDpNlv58gFd2COGQInv/QhncSkMPA4VNLGMrwrGexuNrfu2L+SI53Uw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386532; bh=9bOYfY1LOYSdUNpXlGr8JF5OfWJHlCXA5rv56d7gv0q=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=gddnD7C7yyYNuHc3OZXO2jNqNav8x7zIlE/cucxUT1ULWh4JVJ8dgpU99GcBF2tAr2q+c0zrVbZiXW+QjGtPBFjNoU2Vf0KRFn53ensLtpxI4ccOY2HSqC5c5fr7tPXla545TTW5rVRxlWz/EZCuKIS7rLcJQW/iql0R+pDAx5bi7X6NvP9KhWZB1eB5iKV9VUJ6AWLlB0hg1tYXe3+W7HJOPWp8MZThdIyZ21Ea8iLs+ijy82fMyqQgdFgfTw4AU+8s3qwEu+NTXAeMSYyCmYpb+X1o8/hn40YwHqeQRa0EJyrjnKXTtC2sS8fKD8uYX0fJmwW4q0zEoO7C7zRq3g==
X-YMail-OSG: reL6sYIVM1m8.gW7L2kC8i8u.CgmWzkhk_i6xMX4cZ8BqQdfTGflDcagw6GIZd0
 PT4w.tTgaI6143G0MnQgn2xwVKG1FgIPZSkEbwIs_fTvDBCXtkxbA0OIn7k4CTYOJ3xhIKx2CxzV
 KW5Q3S1rglQ0TdT5TCsjzLfx95nRoE318JQHttq_f8BY_WxVft0DpQF87Lxe7EzA.C6IvCmB7hsP
 O6smIbOM.F4Ck2fC59mS6Aj0DBwJmBYZWz_2mDqiZEw4J.WJDBFALMI7Bt5_LdjSEp0C0fexwJfG
 N.U33CQRj2iPNucwMevRU2UwAmYIRQlMSngZFsQb3r7KAJAi6K9kJkyfrgsNTbKpOFMl5PhHW2Op
 6PYmOUAb5nobBFoByXnFXEQ.hHt3dTllJBN0GG.h_auhBssqLEb8XynoxqC1MLiIkDISxjQ0PWzH
 DZnw3ikEV2nGdficd1XeD2ImqTwDptWbnuIya_O851mlEzSkwh4ssmjilbxzi4Wx8ns3OsW52c0d
 XlI2Pqo1i2PmKxz7fcb5Ia6eFCtKwE5uTBl4kCbSLReWtaeet5e5r3t9JQ3d4KUrrw0VZ0gJ6phz
 C0fZkmhGp6Z6.XVFpRhW1QVkmEZBCriMTVUa.yLSD.HyFq6g_l9qgtUj2UJpcDjnCjG_V9CflZWN
 uaUgPQkJAQR5WxBeqAZZmGaRDrLLXLsmcG0XIaGZThrg94E0bNr43JxI1ldVtmonfiK35pkZn1Pe
 iEqEyMwReRw.vDU1JApq0b87f7diyHLFC1yvzsv3Hjw9SnFSnT.fhwWNVCYA6Ry4Unm9y8COZFYT
 FZArtIQE8H34k7k8H69ll.5jjAMLUGYnb3Z7bweiPthO6Ul3g3areAk39A5X9tr7hhNaoodXPItp
 RT3lC8nls6GOoqfNBtYHxG0TRK7X1SCbAJKNpGz16Rsai8emihKH8fYCO8LI38XLc4Q0ge3K2myB
 lY5McAdg1ukMDUC9Hhn4PmMWDw2SRY5B9Xdpv1WtCoop7lbr7NphUFr6egjp.6jckG5IwfrHrpXd
 Eg4B2jT17Ok3exmPRfFfT4cpHEiUDWJTu4Swinm5NpTCN_HjXCItzdJUTwNGKhPMfKFZDYHHkRKQ
 jV0KgCe5Dh9Qfvjm2pooFVh5rBXzirYAVInYr85ZL1dF27dwKF4QA7nMn.zEIFqYGuN8ICLknibr
 tRXKv2mEjXebaEL2mHASnr4SAjewGFsWAwoVEqs27UeZJAInxgis9MP4DW6fYdIsxNudoFxlPrUq
 3jNEEmWcaoRQ68vQfOx_uIjpM7XhAY9CPcDIJeqRfR3wrNm_1jafOc2LTuD5PX7OO32gXaWKC6oH
 99hi63zqW4zxZeEI7tsJHSlxmxEm6IbPiNa4RSUCnbWf3PLgWxDAM4pnlSy77k8ovVKqrYf8J2Sv
 OYnSKqsfierC9gDzFI2KCcYDM5UiiYEgKKriQVeodV55h7U4VWd0l_eGryB5K2Ifm3AjTW4trvgR
 GmoK0y6xmvNYtjqSq1p._RX.akRlpb8kSb.7wq3l25.k9YgkBQcBirW5xTkiXkhM1KspR6H1lT.j
 qlHPuMWY7Z4ImC6HYrD5niLS.qoubQqeLX0oyyLzAhjbMob4uzslBrXM30KQaVHYrcxw_8xrWqZn
 J1j5LXePHBLdp2msyPYLyetCVblWFltmZfCqurGI2pRPr7EbLflkABX.1KnvpsLDY_foWK0cmBQl
 A9LULFJUfg1WeU4NQOjeBP.7h6MXJQtPi3D.O0lm16vlDfGVWoMoALxW80kvz5.6T9NCMcjDrNLM
 Ir3WJXcWPSLFQhnsr3yNNYEkInwLxgRsQsqcVWWW6mxSjMOl5mq_yBrr0EtyuPJ430.n6sspqag0
 0nYqvxP0Q2ZFFD9v4cnW3trqRAHyPrUoJpJ_1joyOR1ougYc38JgG_lbH8Xz1pEusXuMeC2X01vv
 Q.QZkQRnBNJqUyRK.scfQRSwjBKE1zsJTJIPOHg8yGuyQOVxKM4ExWwdE1Rg5sZ9y1ReVwHMFClx
 Qqq1TgqWrJS7ZTHe_k5PbYXhBZ4SSs2cQ8ZLB1ZqOeK16UqWVJ3KdJm6LacsxYwURixM2BXoc53N
 4DetV_HJlurVqCIlqcPOkKJXwwc7ubeXhMT7PwcncLz.uEUNxa4OWyVQ5ExCF18HCIjnkBCEyyMY
 rTDlL0uwJ_Z_2qdbkxZVwK.jh7KOSAI1gqnRUP_Zh33VVGZBQfp_YjlXxN9iLewE2UwRC9BGi1fG
 ugWDtnLzX7ABBfWGQo43zdw8ORe5iOtKzxNK.fObjv9EpHZ4_H3UvYxJ1LhRroTroJcv2eTgC1U6
 Txdat6T.UI89b0yhdt9VrRnmFaQ--
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 6dcff937-1b8f-4d29-b520-af074db5d2da
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Wed, 2 Sep 2026 22:02:12 +0000
Received: by hermes--production-gq1-678d9dd684-dljdn (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 39a905a7360d4d1389754a332443770a;
          Wed, 02 Sep 2026 22:02:05 +0000 (UTC)
From: Casey Schaufler <casey@schaufler-ca.com>
To: casey@schaufler-ca.com,
	paul@paul-moore.com,
	linux-security-module@vger.kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc
Cc: linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	jmorris@namei.org,
	serge@hallyn.com,
	keescook@chromium.org,
	john.johansen@canonical.com,
	penguin-kernel@i-love.sakura.ne.jp,
	stephen.smalley.work@gmail.com,
	selinux@vger.kernel.org
Subject: [PATCH v2 2/7] LSM: Implement x array functions for secmarks
Date: Wed,  2 Sep 2026 15:01:45 -0700
Message-ID: <20260902220150.18586-3-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260902220150.18586-1-casey@schaufler-ca.com>
References: <20260902220150.18586-1-casey@schaufler-ca.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement, but don't use (yet) the functions required to use
xarray indexes in secmarks.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 include/linux/lsm_secxa.h |  19 ++++---
 security/Makefile         |   1 +
 security/lsm_secxa.c      | 109 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 121 insertions(+), 8 deletions(-)
 create mode 100644 security/lsm_secxa.c

diff --git a/include/linux/lsm_secxa.h b/include/linux/lsm_secxa.h
index 926257d4730c..84b06c093460 100644
--- a/include/linux/lsm_secxa.h
+++ b/include/linux/lsm_secxa.h
@@ -7,19 +7,22 @@
 #ifndef __LINUX_LSM_SECXA_H
 #define __LINUX_LSM_SECXA_H
 
-#ifdef CONFIG_NETWORK_SECMARK
+#ifdef CONFIG_SECURITY
 
-#include <linux/security.h>
-#include <linux/skbuff.h>
+struct lsm_prop;
 
-static inline void secxa_set_secmark(struct sk_buff *skb, u32 secxa)
-{
-	skb->secmark = secxa;
-}
-#else /* CONFIG_NETWORK_SECMARK */
+int secxa_from_lsmprop(struct lsm_prop *prop, u32 *secxa);
+int secxa_get_lsmprop(struct lsm_prop **pro, u32 secxa);
+
+#endif /* CONFIG_SECURITY */
+
+#ifdef CONFIG_NETWORK_SECMARK
 
 struct sk_buff;
 
+void secxa_set_secmark(struct sk_buff *skb, u32 secxa);
+#else /* CONFIG_NETWORK_SECMARK */
+
 static inline void secxa_set_secmark(struct sk_buff *skb, u32 secxa)
 {
 }
diff --git a/security/Makefile b/security/Makefile
index 4601230ba442..e93be00bb6ae 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_KEYS)			+= keys/
 # always enable default capabilities
 obj-y					+= commoncap.o
 obj-$(CONFIG_SECURITY) 			+= lsm_syscalls.o
+obj-$(CONFIG_NETWORK_SECMARK)		+= lsm_secxa.o
 obj-$(CONFIG_MMU)			+= min_addr.o
 
 # Object file lists
diff --git a/security/lsm_secxa.c b/security/lsm_secxa.c
new file mode 100644
index 000000000000..ccbe78095d70
--- /dev/null
+++ b/security/lsm_secxa.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+/*
+ * Implement functions supporting an x array for LSM properties.
+ *
+ * Copyright (C) 2026 Casey Schaufler <casey@schaufler-ca.com>
+ */
+#define pr_fmt(fmt) "secxa: "fmt
+
+#include <linux/xarray.h>
+#include <linux/export.h>
+#include <linux/security.h>
+#include <linux/lsm_secxa.h>
+#include <linux/skbuff.h>
+
+/*
+ * An Xarray of lsm_prop structures.
+ */
+struct xarray secxa_xa;
+
+/**
+ * secxa_init - initialize the xarry of lsm_prop structures.
+ */
+static int __init secxa_init(void)
+{
+	xa_init_flags(&secxa_xa, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH);
+
+	return 0;
+}
+core_initcall(secxa_init);
+
+/**
+ * secxa_get_lsmprop - get the lsm_prop associated with a secxa
+ * @pro: destination for the lsm_prop pointer
+ * @secxa: index to look up
+ *
+ * Find the lsm_prop associated with @secxa and place a pointer
+ * to it in @pro.
+ *
+ * Returns 0, or -EINVAL if the mapping can't be found.
+ */
+int secxa_get_lsmprop(struct lsm_prop **pro, u32 secxa)
+{
+	struct lsm_prop *lp;
+
+	if (!secxa)
+		return -EINVAL;
+
+	lp = xa_load(&secxa_xa, secxa);
+	if (!lp)
+		return -EINVAL;
+
+	*pro = lp;
+	return 0;
+}
+EXPORT_SYMBOL(secxa_get_lsmprop);
+
+/**
+ * secxa_from_lsmprop - get the secxa associated with a lsm_prop
+ * @prop: lsm_prop pointer
+ * @secxa: result
+ *
+ * Find the secxa associated with @prop. If there is none, create it.
+ *
+ * Returns 0, or an error if the mapping cannot be created
+ */
+int secxa_from_lsmprop(struct lsm_prop *prop, u32 *secxa)
+{
+	struct lsm_prop *lp;
+	unsigned long il;
+	u32 index = 0;
+	int rc;
+
+	xa_for_each(&secxa_xa, il, lp) {
+		if (!memcmp(prop, lp, sizeof(*prop))) {
+			*secxa = il;
+			return 0;
+		}
+	}
+
+	lp = kzalloc(sizeof(*lp), GFP_ATOMIC);
+	if (!lp)
+		return -ENOMEM;
+	*lp = *prop;
+
+	rc = xa_alloc_bh(&secxa_xa, &index, lp, xa_limit_31b, GFP_ATOMIC);
+	if (rc) {
+		kfree(lp);
+		return -EINVAL;
+	}
+
+	*secxa = index;
+	return 0;
+}
+EXPORT_SYMBOL(secxa_from_lsmprop);
+
+/**
+ * secxa_set_secmark - add LSM information to a secmark
+ * @skb: buffer with the secmark
+ * @secxa: index of the information to add
+ *
+ * If the secmark in @skb is not set, set it to @secxa.
+ */
+void secxa_set_secmark(struct sk_buff *skb, u32 secxa)
+{
+	if (!skb->secmark)
+		skb->secmark = secxa;
+}
+EXPORT_SYMBOL(secxa_set_secmark);
-- 
2.54.0

