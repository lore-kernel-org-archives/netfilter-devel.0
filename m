Received: from sonic306-27.consmr.mail.ne1.yahoo.com (sonic306-27.consmr.mail.ne1.yahoo.com [66.163.189.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6AF41D11E
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 20:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.189.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786654159; cv=none; b=Ki7h5pNY2IgO/cW0JGT49+w+H7hVA9J3lVOuWSE8p3CCBM5yLXN/VuoIxgvyEeehsUZiQuzQhsCvBNmd4H36A+kB1CJfjzeuIeMcTSEcWjd93qx9rnOf6xGxJtX6YotoRJRs9OAtB/Ai77ydbJU/LPCczexUaM+Tw7h2jyZY2m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786654159; c=relaxed/simple;
	bh=Q8hEe4FiSMW9doEYD8CNbwdNQfjUKt9PxQ+C5vtNY48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQzOI5AzXPxumUXBqk/cjjbKLi5pWVKmy5UC/27fih50hoxaWmDpe/noUp9+Y6OVcT9Nxq7F986JUSYU2lpIEArmyUZ6FWFYBO5Bdq09ac6yncORd2SFCztR2dazAppwMafoUUKNi4a/ZktPC9Kuy8MRcdHZFswvIFZS5y4px0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=Kkohvl02; arc=none smtp.client-ip=66.163.189.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="Kkohvl02"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654156; bh=c9a770N4aWkurPkhcE57WAQe+ui08GmePE/hiOSNuLc=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=Kkohvl02WxctfJW4GBWRE7ufsW3DIQRzX9716BTxL3z3CRbaEZzgAZTv2JZRajLVHsPev5pW0PtAXQGNRs5mct4u/nB7u/n3imuR1WmI3O+zV/WhXgyah2P5coZUDAWEPEAN+9+kaXCZtrNXKukrXDjSmnLAzS8aISsZI1myCZtQqYxz+TOwCcCuTM2MDcbV9g+GU1TKL+Hh5dG4D0o/Yu6+jbYuj4DyUdgXo6S8yrPfa3wNx6TGgaM3lB1gRVYC2Rw8HkEXLI2fGsniqvVhj/2w4NO1jBhhCZ1aPYixut90zHUr2VwsNxpAr6LvDhg3ktwPYwr7V7+eYMsmNLfTRQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654156; bh=3aL5er3R/rhZ8gN8/01dUxnbbEAtc5cYqR+++wsR9a2=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=pDbZzcxYT3uqSTots7o3Sy08CQm2W5oHrzVOiM0RVDUWgAFiyLxzeVyO4yeF5NbfhSsp/FTqGyqSuGrF79SUHlEaUevksPPdmdyspkfDGrJUpgdFstdSOgSmPhFGX7Y9hkz1nXHjbW3ddv19MPCMG0fBfqivzQLWGq4LXIHYPLFLZTfRLsfaZAJzwIp97s0Ki9GNXJnsUL8azc19R13+lLWltna/WYVwgnxOptOCVrLI1lu4CUrlDO+eRC/c03zJCiJznPsbdQnkvvwtY2xpFBhf0NU6R/FCeurJTMammBFZATL0cMctyHYjEo1cU4Tzq/Mq3YqnMdVP+rC2jIK+mg==
X-YMail-OSG: iyvScPAVM1kAfnf_1rwQsZBKM383riop4vM17pJ3tT0Z8PGNJIfIMx3AElPMBCR
 Lg1O5vVthRI9LB.wbf8R8zuW47nFg6uLeankoi8rlW3JG8Qk39VQs.HZiikJdNMNjZLFLm6teF3j
 XMNZj.Ymvh9cnMczWlys7v834.7kYcTexH4BJtM0_laUrcncsZBsnbxSDNqWHJzrhZrdrizzD7S_
 2r5J0KHe95nH6DNk7uK3_s4Po.X1epMwOcII8IFP1i8zY20b_C99ci9vbTQrqE86cXOxwDMRV6Dq
 8.1RWDpdx6A1F1e9zMwh9sPZ2Lv_3Z1X8eLIRfgB4hIs9EkI3.e4aIhAuMSd6ub1kLckTuB8VpzD
 nqBBteceYLg0YFI2xRKemiiQKnv4qXi5QCQsSjFyNPZd4WBpL2pYAVInoQUul6Mn3TYJUL2hvugZ
 otHnpnFbC1QOW6UQQKC5zGaVKwXUBW982nWvmviYssyySoA_9E6_Lqy22B4PhM_.lmw5pnmlEipi
 QMzajKvkymYGMSjRSH.yzms2abgSokqtOuhAoPhLXgfnwsnFE3P3Q0LE1KDoA6sO2fU9YeiL1Y4h
 3uN5lDUFuYhdTQN0fWk_7FASc9Riil9zuwjmS8qgN71HzfoRH7XT2DzHc50CI_OqW4eTCXQfvfWx
 OZ2qlv9psh4r5cxot.aBbL4HTKLEB0BL6LiDMjiPha7UH0spH4YuXuLEUVtmajs5h7BCWDdqU5E8
 hM_d7fRWiH853WIaRMpU4vh0Llj1C7AgXk038qiARBfWWepTJRryIAvmSSjuxM4ZwCx4gao3VKPM
 T4eqpHyKtTEQ6lU75IIcwo_soDzoN62TytSR6yRHK8Y2L08P354IZFgUX.6y4JpIJoCsXYcPsFjN
 bEyUc_Wx3p1zeNPHWkM1O3IYtd1guDg7oCFS.nEQ0.KIM.4PMTRQ8KmTnAZfF73uhDbYdrOCjoUj
 m5M0VjzcbccYHkOXC32rIQUpmi2Zd6h5fgvFHvZs62zXirq1ylljWSgeMNiGcLBRl.dZ_jrXe_7j
 u.WtPZoyl.hT.1Tvmar5Br1mHSzhT6vNXcGAado9gczwjcj93KcxXVyRMhfhXQN49betLwnRSZgf
 3MLs9OxrbdoTepHYhA.2WKQta5N3ljXdMinc7MZ1r7vGrAZnNXmLdSuVy.K3LeNatZe.YUv7XcqS
 H8dY.OgHv0yU.kcjSZwvnQ3uugPhK.dWC60JtaIGF.1y1aoiTu3g8ivU7kegnyEvBXF17V_Vvx4O
 HRbbD5FWZUrHFFObL1fyfkPbTjNN2mst8D7VSiEPi0H6mAZpDI5qnUvqiAm.4LtMcMOq4fpC_zfc
 iub71cD5FTYWEYPrUJBNUa6JsdwLHVA3hFE0qjELQSPwwsf6oS3W0b0M1ZmVTOXB0cIhHgqHtQzn
 Ieey9Yf0F3DtCas5oVTAbOmeTRtEtJ.3cOh4yP8nyy9WwXW.4g54t162.NTMOa1TRZzSnwcha9b0
 3pce8QTZ_QWM0acJcOer8Jsev6u7OJ2j8CF.aiFr5k2KE.s1KLFUo4fmz7G2Lqs_RT_0bRSBU8WY
 e1ylGTeC3Ryyb1lkMSHzPxPrwgVaRG_A7OA1Hpf3XBaqiCGW8HayHceNNTceiJUVw_2xWX6Aq41P
 zMvtyV0Vd.SpRqgwGYCMIRvO7ioFw6RNiqYxkelGo3TqjyZA2p3hr21G.CczmkQ_80MAoz9nYTiL
 daot1FrUyzuG0jwTFQqMnx6i01G4RXJubiNuit.J6qRcTfA32aBJFo8_JSUa5ZBaAwg7y9mbvZUE
 B0y9Pn8g2mCFIPQivJfOF_Xa3LtGs9UGMZHuKHxhXquaW3bRYpK5z2T92vx8oxNTLA4Fx8bi7Yyz
 k1B3svmaJE0l6zeC5D22quO9YCpmTTucRszYzxDwCgfxz485wexdhCtvAQgXWxgTuqIy7NZgNeIa
 pFb8wgswLDyzv8jNiXoMVFJQ.0NS76eLE5kZZYdabA_KZTxomwN2VZGXVq6PJZwh3dJ3kK4oYbkk
 WGr81UfUN6T1hpmE0gt3dNGkRMiZSn.fVuaKdTDSK7RqCxtxpodPYlj1FCH5iKK7glPDUj77Zj8k
 uiHR.NxRqxrptH9JP4l1qFj8f8Yv63gtEjH_6atGD9.f3gVTE6.zxOilwfWZnenpasFusZ1ClYfj
 XiZDvUbqARUBBhogxjDUul9AEstPWhsOf5_nHjRMyHuhSQckn_p9BiVS2fgOqoiG4rR.TkW0QoT3
 96lCwNR6AX5W9PkmiQJ.8i2m0dP8JLS3bYmh31HpkvGgCo1TTJwV7htMiFec593wXSLSXL8jor9B
 dl9_uV_AUyOdJVn0WKvgY1yPC.6bH
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 959a22f4-34b1-4722-bb2a-6303523f9cc4
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Thu, 13 Aug 2026 20:49:16 +0000
Received: by hermes--production-gq1-678d9dd684-6hkng (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID afc5ff34d004487469fb59f8ce77dff6;
          Thu, 13 Aug 2026 20:49:10 +0000 (UTC)
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
Subject: [PATCH 2/7] LSM: Implement x array functions for secmarks
Date: Thu, 13 Aug 2026 13:48:49 -0700
Message-ID: <20260813204854.19211-3-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813204854.19211-1-casey@schaufler-ca.com>
References: <20260813204854.19211-1-casey@schaufler-ca.com>
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
 include/linux/lsm_secxa.h |  10 ++--
 security/Makefile         |   1 +
 security/lsm_secxa.c      | 107 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+), 5 deletions(-)
 create mode 100644 security/lsm_secxa.c

diff --git a/include/linux/lsm_secxa.h b/include/linux/lsm_secxa.h
index f4c732d26680..ffdc354b93fc 100644
--- a/include/linux/lsm_secxa.h
+++ b/include/linux/lsm_secxa.h
@@ -10,12 +10,12 @@
 #ifdef CONFIG_SECURITY
 
 #include <linux/security.h>
-#include <linux/skbuff.h>
 
-static inline void secxa_set_secmark(struct sk_buff *skb, u32 secxa)
-{
-	skb->secmark = secxa;
-}
+struct sk_buff;
+
+int secxa_from_lsmprop(struct lsm_prop *prop);
+int secxa_get_lsmprop(struct lsm_prop **pro, u32 secxa);
+void secxa_set_secmark(struct sk_buff *skb, u32 secxa);
 
 #endif /* CONFIG_SECURITY */
 
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
index 000000000000..5b67d8218fd2
--- /dev/null
+++ b/security/lsm_secxa.c
@@ -0,0 +1,107 @@
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
+	xa_init_flags(&secxa_xa, XA_FLAGS_ALLOC1);
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
+ *
+ * Find the secxa associated with @prop. If there is none, create it.
+ *
+ * Returns 0, or an error if the mapping cannot be created
+ */
+int secxa_from_lsmprop(struct lsm_prop *prop)
+{
+	struct lsm_prop *lp;
+	unsigned long il;
+	unsigned int index = 0;
+	int rc;
+
+	xa_for_each(&secxa_xa, il, lp) {
+		if (!memcmp(prop, lp, sizeof(*prop)))
+			pr_info("%s found at index %lu\n", __func__, il);
+		if (!memcmp(prop, lp, sizeof(*prop)))
+			return il;
+	}
+
+	lp = kzalloc(sizeof(*lp), GFP_ATOMIC);
+	if (!lp)
+		return -ENOMEM;
+
+	rc = xa_alloc(&secxa_xa, &index, lp, xa_limit_32b, GFP_ATOMIC);
+	if (rc) {
+		kfree(lp);
+		return -EINVAL;
+	}
+	*lp = *prop;
+
+	return index;
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

