Received: from sonic310-31.consmr.mail.ne1.yahoo.com (sonic310-31.consmr.mail.ne1.yahoo.com [66.163.186.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC723C1400
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 22:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.186.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788216504; cv=none; b=mPaLq3Rf/gVb4UHukbIajbAFFgON40AnZU1vhPVRicWjowTsDlJgEK1meqPZc+UMoc4RjTKdxZXaDhKe/23X7p1rc0aJ84iM3ICrpKPNb+isPXuVFsZqa5GDAymPRurE/EjyfNL7uKcdwOKWJ5PIp/zuPmEXbdoRNDk45gtXK+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788216504; c=relaxed/simple;
	bh=bcsih4BP082rlDrqXJcE7iTam1hxh1NuNkNWgcTrHLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rk3OmKkeNsQ2fEgm+Te4rlWx7GD6jdm4D5cfgE8jyDADJEdnGPoLuRQXHUDlZyqiAANu5SvR4HKLNYyW3jTOFCUh3sUr9NxOncKFUkfyOYPyn2G82bSiyqawMwWM4pERWTIpxm4HOv3Rf9kDDxshOe6XUytkL5Y+TyxKN0Bs2kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=ZwewcORb; arc=none smtp.client-ip=66.163.186.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="ZwewcORb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788216501; bh=zAA4p9HWXZaBkM7aUTYtkxbtIbeYO06Idd07zx5BtSk=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=ZwewcORbflS3/3jagYEeFo+m8HZCIiijEU2DDQONahWCI3rVsSt736iVIZGgIhIUJ0MqsKbw3TREJSczeBhPshl+drs+VkOjjIu2ClvIGlkpb5LKEld9okotQcozclQ8a8GZmoToqkhtJ1qw1E90Nzjdw9HuIsCxXQOedkT82M91gDZCTb2rq2PP0vuxMmqOwpga/bMsZuQDfsIOoeTrU59XbaSiNwHYgc3K8zupNJY8qD0A7Iq9UVxLsef5Dwk3KI+zUt0safFQ4325BC4Zq6KmABY9UTxi8+fciuVd9IBrrexmoxuhXiTUVnATdKkPWTbVkMeV0Pc2kOjUXZJsZg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788216501; bh=qoVhynkV8gQAKau/HJck6QF4dx2g0s522SORn9aY4CI=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=tQnnJyJLaOW8r0AS+IIwErbhPd9j8KO0RI+9wsbhTtfnbBWggH/ELefJSyL0FloQoN2XgUG9j03cQub5i/2s4tLnNDwn7tokKkBsIsMsdpNMpeIyZk8TK+2pJH6AdnrbbEnnzcHD77xgjDKVfkpkLtXPVzKoNi2/v/aRXeIpxLn5v60dMcGfsmoFyHrfg+pPbtd49zFm9YEuWO6IAE60UJeEQhGh9r+OAkXECI8vlx29Fyr5k/tQ1eQBWZgFbnh784vtPXUXHHw7s39ezLPNPzTJrqw5My5+3YwHHxNahr/vhps7Nx5khn6B+b0hPGO1EOl9zK0o/FPJIGPMazRVgA==
X-YMail-OSG: QOx3Zw8VM1k.P0Yr4C9fK4ehm8UpkJfD.O1V7iassadsfNj2Aykv1hQfa05djml
 HBhTrimuZ9sdmuj1VNKE.tq7TybtuxYfRQqSN8l_sy7XHR9Zv2EJIuR1jfKJQIz_W8LqLzHpRs53
 ckEsVgMmDYn69oPtT1C0Fn8ETuNOs1HLYxWwO8lktY1Jb2JlrUOOeY1m9U_NULshRgECKQx74JJl
 nSRlcDUs9v_cug7S46sHLR6CT5JRYyD.5oVOjSus.144DHIJBMcQOIjpzD8191vtQuz1DB7rT80R
 44t4tJ0UAvyB4bs9o8jpdh.1sHKnOOis826GTR1Ui0lKk3oYuPu5hSAZh_NSBoJRI8hGIHnDiS9q
 qczlOBtkvYRtG1WhFv9zFhvcjWhpUKxRJos3jLz5FuLXQ8J9_FYnpeXvQzZvT2HJW7tMbPx8fWhG
 bNmnVNyD88TQPzXrt9MQ_xe6Dt9zZEeBQbJe41.tFtMLYZ2yecQcwHzVGMKGyoiS6h29IDkeP4Rf
 gzhUo7v_skCrWK0E.acG293EeDeH0CBEt6kD4fky9RHTPJiHI2kklUxISFSyDSvKxEZCsMn39ucW
 9fvjSYdgw0YxIC60r.aOPeHQ3ASnSc3rivliB_bTxeoEkSCYfnIHOjxcjpwaWQFvfuXKow.9kjcF
 ioGvvSK8MVQyPuXCXdEIRDTR88YHqj5n_2SFajA0Kbyi6nQ.BbBN5sb3o.GUXBIdeGCkbZnXKlzJ
 WJWGlRPDIFaeMs.5G2wwkDLiwD3a5AanMPGdRuuaRTIc.SRe8dLsr_knDTLTzf3Z1nCBIlwppqsP
 2uXH4kgIIgwW0.ylzCdl9b8HhYf2WCaw.Dnhl09csqHdR.3o7s5DOce7WLW9Sis9aWSX1oQKco6.
 e3asJJBl3AHoObQ.VrWAJW9s00KOitBxrVCubdm4afaK2egLKRSVOmwF3v1egqXDYIHcM629t6gM
 57pKD58UHkL9EZWNxusJeQFbS4S7lNlzi8Q7HahA7DZQzp2LDQF1G037GShquMrxXhvmz3Tx8Ip2
 osRNgrURQrGBI7vSwlgILjRZ1qLDuF5KOoC7qwjhiqZ9inm8.ltKob.67y.xYcMFhyVhAUY93TM9
 9i42BFw5UuUWHKei_mwuEIgqrVi4SP.rddvo9LKvScgecZG2fggn4msx7D9HpTw21WJ8mg9WY0G2
 C3ER3fAJOWUk8OIEzOAc1LIcwsALukPL0yh3uah2oFfm2EsvE1R4EQpUBzAvm0sR3ShctBMPWMqk
 wIKE.UeOdGk3dnsIh_SsyWATC2XMZ0XowA9Le7Z5xZ8gumdw8cLby9eUq35vD2p99KqB4fiopxS5
 lNTx0YNta6.mIcLYAb.Mx8hzFct6vFml8rWezfeK87V1OgdQxcUzboBQtbPSf0yVytHJ6zI1t10_
 pTtCsxGFdxA9NznVE95PkQCw9w2po8hBLXtupUjCn6Z7H0Um724nFMldJ_uGv3nBIMAzSoXUoJgs
 Lg1Sg4vkvyvsnm32wnYqBhMY9Db2exwsHUawiB.ADYK15pXXG5KQSPKWDz0inf9.3WRyO2LARKNn
 Qw0KYmNc5ayMI5OS9Wqm93LNHBrMarIXw0p7UkYNHTt.eMEQiyVCwQ79oMVgrJmcyUhvIP3QgfrN
 Q7rnSh7sZ66P8c1x_8.Q4it9hJW05DpIfGAZqD2.OFD6p2h3c3DXev5hW.SIRih7pL0wUE.ayHiX
 ZmIek7agczv05770U4JEMTPzv6TbASm.X255N64nlzIva.8lQL8LJvthGPVaLO8lDgrHLsIJokPU
 z76aE3KK8sL8tyZcLffKE_sWktY6pKJ3AFQEysqez41l4ytq87fi5RX2zddAYXwREkmAV__aSJ9I
 G3aiWcCIjhBHuNSJp1J3Y1HZp7Axnw9Akpt8HLxyaLmq1ijcErJ7maXB3ipkRruH0o1xkBJBVf7O
 d134gV_yLR_6JD1pbv7WNhX2P1Z8yb2GPBRkF1Qg3auN1KN458.5bdEBFBv1_APlKcjBH5pRKrkG
 2aR.gf3aFM5GBi6aodM5afNd6vAphcMwxI1yh3h2ZXC6udKuoFU1UCF_gpGLgwFIdGl7CzfFxJ16
 5aaixVHYJR6B6Izj0aK_ooikCopjaYmtFQaVHyr6opWkbyiTBMkMkRqO635GnEe4YJiNbBn_GeND
 uZ0aTmwF2QJZJe2Q9yrng1Bb93dEu0_zoDJ7zuyzxsM0o4ufxX_grZ9Nis4Xq9wUS122Lpqbz7qJ
 UrnPl7ar437_UHsb4U_KuXtj1DhFfq9w4q3U7G2dKb2eLvtgOlzjPoTGBRx5vWh1RrbkIyKApYxa
 9tshQUqWiGBO.E2T_Ihe_jb5_xII-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 8c0ff2ea-88b5-4ec1-bcd0-193f0bc1706d
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Mon, 31 Aug 2026 22:48:21 +0000
Received: by hermes--production-gq1-678d9dd684-vr75x (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 9afda7e456c775b6473ef75f34d3e2be;
          Mon, 31 Aug 2026 22:38:03 +0000 (UTC)
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
Date: Mon, 31 Aug 2026 15:37:43 -0700
Message-ID: <20260831223748.4304-3-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831223748.4304-1-casey@schaufler-ca.com>
References: <20260831223748.4304-1-casey@schaufler-ca.com>
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
 security/lsm_secxa.c      | 105 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 117 insertions(+), 8 deletions(-)
 create mode 100644 security/lsm_secxa.c

diff --git a/include/linux/lsm_secxa.h b/include/linux/lsm_secxa.h
index 926257d4730c..569c7f242b78 100644
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
index 000000000000..50ce613e35c0
--- /dev/null
+++ b/security/lsm_secxa.c
@@ -0,0 +1,105 @@
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
+ * @prop: lsm_prop pointer CBS * @secxa: result
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
+			*secxa = il; return 0; CBS }
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
+	*secxa = index; return 0; CBS
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

