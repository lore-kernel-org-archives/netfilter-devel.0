Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B48526ED40;
	Fri, 31 Jul 2026 15:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785511103; cv=none; b=JeVaCJV22AP0/gfrjFF9I7EkQgtQB35e2O35nyvP6b6ReB1L5d2+5o2Ni07TUie6tjTp94LFQcS52zdwaV4/Pfo4wDrOW07jBOGYO5b9NRaV1PVFhqLcVhU8kqQSrJggPZzJa69o9VdhuSquMXc2ezYJEay3VdwePjpjDyAUcXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785511103; c=relaxed/simple;
	bh=tpnb+MDmAA3d2zaaisJySj7y1rWETCeErWdCgxJYI2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mF/pQA9HHHHlSUXsS41e917VaWJRpgkqWeaV4BHPCC9Diri0QlkrSu43S+aAhjapiJbm33I041MxTR5GAwQ0f0eOKrh5o8SSd5Ueb0+GCiPinNtMwGvJvYLg/1z5LfplZUkOlPTn7DZscm6kJyCk+z1ZATtHkul1RDF9f0HFcZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YiAa15Bu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YiAa15Bu"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C6DC96027A;
	Fri, 31 Jul 2026 17:18:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785511095;
	bh=S/AqZ0Om7790o31yXwxNe8HYJ3Er6fWYTlj6PYGJfts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YiAa15Bu0nXB0anhaZ0zcVVR8XmGyrqh/MUQuKALKGOZvifJWfueTtpsydVD2PFhM
	 YX4LENZOwUUrnUZGmuLq3lIGGu6mTD7xQcqO46DAy+ly4RSRbzgUqOck0OaI1Jyg1j
	 psLT5f6P3n+z4K3D5OnmcuyprkDWBjYItDbPPQ3I3nHdL+5rVmNG1MfJYlCA13YSOV
	 B1xVh6RHzjleRFbiKUXGQgGAudcXecnrkq4rvpn3THXfjC4ay7a2fS5wYHeDIASdkf
	 Un85eco/182zuki3IdfQgMAuCsl80sWnsFWihWuTQxO6560tIG+v68QSKwme+xMVwS
	 9E0QBlM3twECQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 02/10] netfilter: ebt_nflog: pin the NFLOG backend
Date: Fri, 31 Jul 2026 17:17:58 +0200
Message-ID: <20260731151806.849724-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731151806.849724-1-pablo@netfilter.org>
References: <20260731151806.849724-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chengfeng Ye <nicoyip.dev@gmail.com>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.47.3

