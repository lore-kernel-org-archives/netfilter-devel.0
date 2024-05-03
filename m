Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8AC158D99
	for <netfilter-devel@vger.kernel.org>; Fri,  3 May 2024 19:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714765849; cv=none; b=pEHWeCrswquiSIMsNvtvsOqO9kAfmSbrH7/oljbALZgcDOOSocYhx+8weA1huAvbwgS4SqA8xlV/aGv1xfTiNJztJxeBNE4MKVisQhw4s0vfSlXsWeyFEzMifgjYUFPBv2GFoV0UdZjFnLel5upMDmmxNJC2AH6/KcyOBizI8z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714765849; c=relaxed/simple;
	bh=MZdB60H2kZngb/cogNlK7WnvnxuSyLklaO1wlBH8s/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6DhDgVn+LNWnFBlDeG+sWB7ThuowVkfYH3KEEJANlgObCi4uJ4WqCe/4/KsDm86ENTvKyK0PldZft8frOk5eUBqXB5ykQDyFKz/fyRb0R6eKZDa8cerfBm3bQz/BHvya4ejl3pvW0NZzhUetg4TW8BBq9Lx7ZrxQdF5szsZ7a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bTq/tZ5s; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bTq/tZ5s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cpWfe9vKbz0tfT0wxz+WT0dP/KNww6btAw6ugLcx6U4=; b=bTq/tZ5stN9NuY+WM/ViA9u2an
	wetvCvZu39ARSixZWI3N12gAWZOoHQn1vRdgCfCzKvkWaeg7IeD07GnGnw2AHDxMLdtiPjyr3N6eA
	AbuYVPMT3PUE3GnAoKLBmBaAbpo18AWW22RpbwaU3pqH8ufz6UrV7WLhcJlSDU31uaegXFM6IqP0H
	BQL07jhVfqanLVC0GGAwlbmbmSgJL5pl3p5UZAfHXXBtogZTgHm8ofZG66o/v5//qn6Z87Z27O30U
	bNxrwLqeM+gE5DXccOG4WE4GBo/ibJ6xZQodGscnT/fVZAIS0CbL799k/OzRbcpxOiC94TRAygGPD
	PdvP/TRw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s2yve-000000007E8-0AHe;
	Fri, 03 May 2024 21:50:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: [nf-next PATCH 3/5] netfilter: nf_tables: Report active interfaces to user space
Date: Fri,  3 May 2024 21:50:43 +0200
Message-ID: <20240503195045.6934-4-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240503195045.6934-1-phil@nwl.cc>
References: <20240503195045.6934-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since netdev family chains and flowtables now report the interfaces they
were created for irrespective of their existence, introduce new netlink
attributes holding the currently active set of interfaces.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter/nf_tables.h |  6 +++++-
 net/netfilter/nf_tables_api.c            | 25 ++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index aa4094ca2444..adcac6ee619d 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -164,6 +164,7 @@ enum nft_list_attributes {
  * @NFTA_HOOK_PRIORITY: netfilter hook priority (NLA_U32)
  * @NFTA_HOOK_DEV: netdevice name (NLA_STRING)
  * @NFTA_HOOK_DEVS: list of netdevices (NLA_NESTED)
+ * @NFTA_HOOK_ACT_DEVS: list of active netdevices (NLA_NESTED)
  */
 enum nft_hook_attributes {
 	NFTA_HOOK_UNSPEC,
@@ -171,6 +172,7 @@ enum nft_hook_attributes {
 	NFTA_HOOK_PRIORITY,
 	NFTA_HOOK_DEV,
 	NFTA_HOOK_DEVS,
+	NFTA_HOOK_ACT_DEVS,
 	__NFTA_HOOK_MAX
 };
 #define NFTA_HOOK_MAX		(__NFTA_HOOK_MAX - 1)
@@ -1717,13 +1719,15 @@ enum nft_flowtable_attributes {
  *
  * @NFTA_FLOWTABLE_HOOK_NUM: netfilter hook number (NLA_U32)
  * @NFTA_FLOWTABLE_HOOK_PRIORITY: netfilter hook priority (NLA_U32)
- * @NFTA_FLOWTABLE_HOOK_DEVS: input devices this flow table is bound to (NLA_NESTED)
+ * @NFTA_FLOWTABLE_HOOK_DEVS: input devices this flow table is configured for (NLA_NESTED)
+ * @NFTA_FLOWTABLE_HOOK_ACT_DEVS: input devices this flow table is currently bound to (NLA_NESTED)
  */
 enum nft_flowtable_hook_attributes {
 	NFTA_FLOWTABLE_HOOK_UNSPEC,
 	NFTA_FLOWTABLE_HOOK_NUM,
 	NFTA_FLOWTABLE_HOOK_PRIORITY,
 	NFTA_FLOWTABLE_HOOK_DEVS,
+	NFTA_FLOWTABLE_HOOK_ACT_DEVS,
 	__NFTA_FLOWTABLE_HOOK_MAX
 };
 #define NFTA_FLOWTABLE_HOOK_MAX	(__NFTA_FLOWTABLE_HOOK_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 35990fbed444..87576accc2b2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1819,6 +1819,18 @@ static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 		    nla_put(skb, NFTA_HOOK_DEV,
 			    first->ifnamelen, first->ifname))
 			goto nla_put_failure;
+
+		nest_devs = nla_nest_start_noflag(skb, NFTA_HOOK_ACT_DEVS);
+		if (!nest_devs)
+			goto nla_put_failure;
+
+		list_for_each_entry(hook, hook_list, list) {
+			if (hook->ops.dev &&
+			    nla_put_string(skb, NFTA_DEVICE_NAME,
+					   hook->ops.dev->name))
+				goto nla_put_failure;
+		}
+		nla_nest_end(skb, nest_devs);
 	}
 	nla_nest_end(skb, nest);
 
@@ -8926,6 +8938,19 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest_devs);
+
+	nest_devs = nla_nest_start_noflag(skb, NFTA_FLOWTABLE_HOOK_ACT_DEVS);
+	if (!nest_devs)
+		goto nla_put_failure;
+
+	list_for_each_entry_rcu(hook, hook_list, list) {
+		if (hook->ops.dev &&
+		    nla_put_string(skb, NFTA_DEVICE_NAME,
+				   hook->ops.dev->name))
+			goto nla_put_failure;
+	}
+	nla_nest_end(skb, nest_devs);
+
 	nla_nest_end(skb, nest);
 
 	nlmsg_end(skb, nlh);
-- 
2.43.0

