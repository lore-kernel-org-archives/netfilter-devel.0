Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33111DA60D;
	Mon,  1 Jun 2026 11:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780315176; cv=none; b=BARmjGL7Aw6OMFzf/gE4Pec8yWx6D4bgeLR/l8gGGwJ7/M49kroJeqcFQp5pCV9D9vpSLsmgqJ7CAsaI/nEWDXI3leJ4e7R8fkSel5tK8XtqiYTpHnF7turfKNmHq43aqGzVk2spMdaG5xqCNEFDyEDHjnXzI7dbJE4v0CIStIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780315176; c=relaxed/simple;
	bh=gMryO+GUDj0Mrzn0TOtghewI2/kmcTwaBonfuN/0hCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5V6rB3eZ9cC/rPzU+HD9Vw3yPCtmLZslTDP9Nech7sjvG67QdOUKNvyBoyQPiCrikZHcIPB6M9XTcm9oRdtUO5Nf69VC400SjKMG0VuPORWSuUOzU+NEAVu0Qf4OCQtBa4Skbpvtt7+s2cTRIQEaBVFGwltrIgIthnoQf37s0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GmvasXSf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GmvasXSf"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0981D601A6;
	Mon,  1 Jun 2026 13:59:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780315173;
	bh=GBV7Izyq5SsFMiqD2t72nhYgYdmpWh2Cbiwtu6AddH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmvasXSfxS19ILtbGF+M1YUqsKc0/t0xiuaYAR7lWp4J3YhqAGamhIxzwXtiW7Jkl
	 eDKbnIzRvD/mVJZcIwmz6YJxQNjQiItyzbkQ/6XATNSUw1JO/hCKiZgj70awv/UgKv
	 PaSRxLR6L45R6YEHwz6pU8CXFqBtluopJAsX8rHnYmsRquCRmjpJl1TyZl8oo5c8ff
	 Z12HRNBXgLgArAK6BWrG/TvoA8DYAPOFmMK4AOailmBVehkccHb75NmzvMcb4Z4pWv
	 3+I7zxtV2zo9TzyHFVLkSTR335K0ouSYrFRuXheuao79cxQSzaHza1PkiAEMiY95mF
	 X7XzhLBc1TN4A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 4/9] netfilter: synproxy: add mutex to guard hook reference counting
Date: Mon,  1 Jun 2026 13:59:18 +0200
Message-ID: <20260601115923.433946-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260601115923.433946-1-pablo@netfilter.org>
References: <20260601115923.433946-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

As the synproxy infrastructure register netfilter hooks on-demand when a
user adds the first iptables target or nftables expression, if done
concurrently they can race each other.

Introduce a mutex to serialize the refcount control blocks access from
both frontends. While a per namespace mutex might be more efficient, it
is not needed for target/expression like SYNPROXY.

Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_synproxy_core.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 036c8586f49b..ed00114f65f3 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -22,6 +22,8 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_synproxy.h>
 
+static DEFINE_MUTEX(synproxy_mutex);
+
 unsigned int synproxy_net_id;
 EXPORT_SYMBOL_GPL(synproxy_net_id);
 
@@ -769,26 +771,31 @@ static const struct nf_hook_ops ipv4_synproxy_ops[] = {
 
 int nf_synproxy_ipv4_init(struct synproxy_net *snet, struct net *net)
 {
-	int err;
+	int err = 0;
 
+	mutex_lock(&synproxy_mutex);
 	if (snet->hook_ref4 == 0) {
 		err = nf_register_net_hooks(net, ipv4_synproxy_ops,
 					    ARRAY_SIZE(ipv4_synproxy_ops));
 		if (err)
-			return err;
+			goto out;
 	}
 
 	snet->hook_ref4++;
-	return 0;
+out:
+	mutex_unlock(&synproxy_mutex);
+	return err;
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv4_init);
 
 void nf_synproxy_ipv4_fini(struct synproxy_net *snet, struct net *net)
 {
+	mutex_lock(&synproxy_mutex);
 	snet->hook_ref4--;
 	if (snet->hook_ref4 == 0)
 		nf_unregister_net_hooks(net, ipv4_synproxy_ops,
 					ARRAY_SIZE(ipv4_synproxy_ops));
+	mutex_unlock(&synproxy_mutex);
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv4_fini);
 
@@ -1193,27 +1200,32 @@ static const struct nf_hook_ops ipv6_synproxy_ops[] = {
 int
 nf_synproxy_ipv6_init(struct synproxy_net *snet, struct net *net)
 {
-	int err;
+	int err = 0;
 
+	mutex_lock(&synproxy_mutex);
 	if (snet->hook_ref6 == 0) {
 		err = nf_register_net_hooks(net, ipv6_synproxy_ops,
 					    ARRAY_SIZE(ipv6_synproxy_ops));
 		if (err)
-			return err;
+			goto out;
 	}
 
 	snet->hook_ref6++;
-	return 0;
+out:
+	mutex_unlock(&synproxy_mutex);
+	return err;
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv6_init);
 
 void
 nf_synproxy_ipv6_fini(struct synproxy_net *snet, struct net *net)
 {
+	mutex_lock(&synproxy_mutex);
 	snet->hook_ref6--;
 	if (snet->hook_ref6 == 0)
 		nf_unregister_net_hooks(net, ipv6_synproxy_ops,
 					ARRAY_SIZE(ipv6_synproxy_ops));
+	mutex_unlock(&synproxy_mutex);
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv6_fini);
 #endif /* CONFIG_IPV6 */
-- 
2.47.3

