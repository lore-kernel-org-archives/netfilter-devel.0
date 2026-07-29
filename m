Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D65637D118
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 17:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346314; cv=none; b=bjjNXwt1YnlNdMfUiZWJ6xM8t+OYKSjGvaj/vXImVMSHi6kZExCOdrrhrMiDcebUfXVuyZbIQEDXnWXA0h7gkplNZdjkW5fvdY2OYc1N+h2R3B3cxlnGKH3Gz+iu5wE184d05X/fE6IANpHD6esMuPbEHKNvfHGHC7Nw6aHUbU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346314; c=relaxed/simple;
	bh=Jc7G6StL/c7Ytj+6YqLr8/+Jzh8vDBmz4m0lxtPGPWE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nc8DKMOoRdPEZS3/AFS4nLb/jWmlREDsnSsCZZuRhWK4oSpCS4iwXUqHSrixhF11JiZKr9JIjeoxihvxJ50h+jCY6HEa/0JHqnGraDPkyVjTIrR+177MtdFDQ/Ue1auDyJvR+L0li0KP+ePMKyG492F+kzRlWgFW7jYwhqZYEQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YeHq1R5O; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YeHq1R5O"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3856d4015e0so105909a91.2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 10:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785346312; x=1785951112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=38ZcQuiK7/9UCGF364MaZa4PYPgvUUkg1FUph1SOAX0=;
        b=YeHq1R5OqrLek+DRCgOjL0Z6dNhKL+Uzu7y3u/KAZrlL9XJhPFQetMY+JrZ7pxSWFl
         tG3NChC11B9yXq9ys6CXnqxwYZd8zjXh4QIJUXNIRSZ8JBtAlVV+bHqL50NX044WUxlr
         9Vmg0T2VUTplLl96doEZ29mFo0MsZOlIL1sGdOjGIqnFp+fNJ0KCuwfvPrat29sK/T5P
         Zc2Xx/Tk4zYXXVUlhEeXLeWw7AC/hpiyaQLvH9uTsE9OVFCK9ZMzjq/yr7Xr8hvmc+jh
         IIAy9rTZNNhZdvSxTGNhg9xA7gGF+MUMsXftG3GbLu5rNWTuveFj2gCHBzJBHOsIM9Fv
         B31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785346312; x=1785951112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=38ZcQuiK7/9UCGF364MaZa4PYPgvUUkg1FUph1SOAX0=;
        b=IqKQVcChvsDhBsXiG0C8K65mWKDPOn39kt+FOxJ6k7wDy1cd0TAmhuTeZcGyMG7kz3
         SRuqKh/H/X5fL8nH1jvMbVR5W8uwxAM/+iK1ND4sxjCw1AQly9LNhcwHpWmw66VEOWoV
         OJD6xMMMiSaJnhOdiXK0MI5TDL2rJ8Bfdv4pIa/WjqliwS8k7KQ3q4ABPUOGO3FIiST8
         QNGMLZkm9XXKzrV8PWBJCoByXpSbRWdGdlSZOv5vUcx0uy0X/OQj/S2PVNJVoixeQaMJ
         rP0tCMIchK5Z6X+AcL5QemUMY09E11VggTRYoiNgWH94IsiYT9Y6qAz/pss8dYeg1/Dg
         OE+g==
X-Gm-Message-State: AOJu0YzQIFNRa1zkWucmaC8Myae2wx62seIyo/P3UVQ4yPeot0cgE7m5
	jrH95bNjr1oFLwDE9s1Ouq0NGKYDvHvj2kbtlu0tMw7UBIohqolkofmz
X-Gm-Gg: AR+sD13jP6mCBWQ+H+QWdMInpuZ2TYrRRWY76BPOjFOuqNG2EVdYYes+swIADFrxgh+
	llD+ceWKO1oH2qAb2caCL1XFyPpBMH72JeGE/uA9mS6l/xt/S1HGMafApqVycigAp6b5kp1Fa5H
	5+5I/ngke6TlE8VGKm0QuUjjsKSODi1hCUDMX86ARZyt6njmBqsv+MC8mjuFruWZlesCOpOcPQP
	7zQnH8SeoQM/1pQYOx/5PPTyRUbmjQufNstYdaOXltRCke1KyINeP2sxgEz5mgrnaSLCYHdyTEL
	XPXWPiXQd62wZ7/ZNfhDL4nuULw0s+o9oj/MFHFMhLcOXhteB2ZBuSAy5IZ5ifoKGaiyg7SGxfl
	P9KDMBtPFwpRXyfy8Tbw01uf0SHPforZz/Xvwqbm7lET1/Mr8RGrLWqP2jvTePAvlJBKJlIowRg
	6A6XZLQz9dIeX+TvyrsGL4OoiAaQb8LQ5cMCvbb1zjtxyzrjF2jZ+l09lnsyLfepFYzvkGzIAhW
	7Gds68WJMmV79SQPPX8vDfkOPBJsWu48uCUJ/nFaQ9pa4RMJzP45XI=
X-Received: by 2002:a17:90b:3e44:b0:37f:eda5:516f with SMTP id 98e67ed59e1d1-38f6a1b8dc3mr7154386a91.0.1785346312247;
        Wed, 29 Jul 2026 10:31:52 -0700 (PDT)
Received: from localhost.localdomain (45.78.65.84.16clouds.com. [45.78.65.84])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504d480c5sm19583850eec.25.2026.07.29.10.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 10:31:51 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] netfilter: ebt_nflog: pin the NFLOG backend
Date: Thu, 30 Jul 2026 01:31:00 +0800
Message-ID: <20260729173100.216916-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_log_unregister() runs after the per-net teardown so its final RCU
grace period also drains readers that obtained the logger from a per-net
binding.  However, ebt_nflog passes an explicit ULOG log type to
nf_log_packet() without holding a reference on the selected logger module,
unlike the xt_NFLOG and nft_log frontends.

An ebtables nflog rule can therefore remain callable while nfnetlink_log
is unloaded.  The resulting interleaving is:

  CPU 0                               CPU 1
  nfnetlink_log_fini()
    unregister_pernet_subsys()
      kfree(nfnl_log_pernet(net))
                                      ebt_nflog_tg()
                                        nf_log_packet()
                                          nfulnl_log_packet()
                                            instance_lookup_get_rcu()

The global ULOG logger is still registered at this point, so CPU 1
dereferences the per-net state after CPU 0 has freed it.  KASAN reported:

  BUG: KASAN: slab-use-after-free in instance_lookup_get_rcu
  Read of size 8 at addr ff110001052e6210 by task poc/92
  Call Trace:
   instance_lookup_get_rcu+0x1ce/0x1f0 [nfnetlink_log]
   nfulnl_log_packet+0x248/0x2fb0 [nfnetlink_log]
   nf_log_packet+0x204/0x300
   ebt_nflog_tg+0x351/0x550
   ebt_do_table+0xedf/0x22b0
  Allocated by task 90:
   __kmalloc_noprof+0x186/0x470
   ops_init+0x6d/0x420
   register_pernet_operations+0x2f6/0x670
   register_pernet_subsys+0x23/0x40
  Freed by task 93:
   kfree+0x131/0x3c0
   ops_undo_list+0x3e3/0x700
   unregister_pernet_operations+0x232/0x490
   unregister_pernet_subsys+0x1c/0x30
   nfnetlink_log_fini+0x34/0x450 [nfnetlink_log]

Acquire the ULOG logger module reference when an ebt_nflog rule is
validated and release it when the rule is destroyed.  Request the NFLOG
backend for legacy callers when needed, matching xt_NFLOG.  This prevents
module teardown until all ebt_nflog rules have stopped using the logger.

Fixes: c83fa19603bd ("netfilter: nf_log: don't call synchronize_rcu in nf_log_unset")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
 net/bridge/netfilter/ebt_nflog.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index 61bf8f4465ab..426f8adc912c 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -41,11 +41,25 @@ ebt_nflog_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static int ebt_nflog_tg_check(const struct xt_tgchk_param *par)
 {
 	struct ebt_nflog_info *info = par->targinfo;
+	int ret;
 
 	if (info->flags & ~EBT_NFLOG_MASK)
 		return -EINVAL;
 	info->prefix[EBT_NFLOG_PREFIX_SIZE - 1] = '\0';
-	return 0;
+
+	ret = nf_logger_find_get(par->family, NF_LOG_TYPE_ULOG);
+	if (ret != 0 && !par->nft_compat) {
+		request_module("%s", "nfnetlink_log");
+
+		ret = nf_logger_find_get(par->family, NF_LOG_TYPE_ULOG);
+	}
+
+	return ret;
+}
+
+static void ebt_nflog_tg_destroy(const struct xt_tgdtor_param *par)
+{
+	nf_logger_put(par->family, NF_LOG_TYPE_ULOG);
 }
 
 static struct xt_target ebt_nflog_tg_reg __read_mostly = {
@@ -54,6 +68,7 @@ static struct xt_target ebt_nflog_tg_reg __read_mostly = {
 	.family     = NFPROTO_BRIDGE,
 	.target     = ebt_nflog_tg,
 	.checkentry = ebt_nflog_tg_check,
+	.destroy    = ebt_nflog_tg_destroy,
 	.targetsize = sizeof(struct ebt_nflog_info),
 	.me         = THIS_MODULE,
 };
-- 
2.43.0

