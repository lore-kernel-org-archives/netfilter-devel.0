Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D02D19B5A7
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Jul 2025 22:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753395127; cv=none; b=tIWSwRG91xAkyoIcngrda6VnwUqfeN/PeL47g7FJZPmjmIY1suwP2iMqvslrTBp+rORHiB6/9c9D3MG6t78vpd/WI0milGwD4lIqnhAWy18iI3qZ5cnFZMsIhhYBMQHHDokDtcvPcgjXbC2WTWGYu1C1px/2xaBGCucccE4WB28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753395127; c=relaxed/simple;
	bh=rdkzlNIYlnhSIMalhgmANbVbNLM0W0gDUfQgQL4O4hs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n3/GsTYutH+f0+j4sDN6hc2+O7FItTbs2beT4l/nbo3Yz8Vxaw4fhXsgqhdymaYWbyBaf3WAkRb03RTD10ls0ccJZLF3tq35k6FeZcDNg4Zoz1gPZXBwvUSzGAP3iw6ret9xisKSkUWJazLWkIhKVAOiddKsDeBptbtyYI0lPxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=f+lBhVpk; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="f+lBhVpk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sDQ7elN8pNMShPpNmen/l25zChdxbUIhLdiNCV0QwxU=; b=f+lBhVpk/UNnwVsIhoe9f9XwXa
	85/HQchjD1LEDWkKTRELlAAPq4URGPRKH+D7+elmkRVKjaDK2paAa7bIaZ5wYFwfbDZyfjY7olt3H
	nvevn4HLfRitlkGCyxAZBlSjp2GVtpjJyug1GU5cr+ncjwsgQv1nQryN+Gc9eKZx63kBBlWda3i8W
	2clTI7aAx7xw1C47KVgSb6IJEUXo7cJhVybJH8S4chLaIg+HmRZ6RjdIzAfAxC4WSa82nn+lHVC2C
	hu7ZzD7U0RW+L2t+HzL69Th7PchEpkNDVL+ndQvkBXj5/47yeyl1S/zx/9DV+8NVG3H49pFvQlHTV
	DiFarc5A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uf4AN-000000003P0-2bO7;
	Fri, 25 Jul 2025 00:11:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nf-next RFC] netfilter: nf_tables: Introduce NFTA_DEVICE_WILDCARD
Date: Fri, 25 Jul 2025 00:00:31 +0200
Message-ID: <20250724221150.10502-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On netlink receive side, this attribute is just another name for
NFTA_DEVICE_NAME and handled equally. It enables user space to detect
lack of wildcard interface spec support as older kernels will reject it.

On netlink send side, it is used for wildcard interface specs to avoid
confusing or even crashing old user space with non NUL-terminated
strings in attributes which are expected to be NUL-terminated.

Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
While this works, I wonder if it should be named NFTA_DEVICE_PREFIX
instead and contain NUL-terminated strings just like NFTA_DEVICE_NAME.
Kernel-internally I would continue using strncmp() and hook->ifnamelen,
but handling in user space might be simpler.

A downside of this approach is that we mix NFTA_DEVICE_NAME and
NFTA_DEVICE_WILDCARD attributes in NFTA_FLOWTABLE_HOOK_DEVS and
NFTA_HOOK_DEVS nested attributes, even though old user space will reject
the whole thing and not just take the known attributes and ignore the
rest.
---
 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c            | 16 +++++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 2beb30be2c5f..ed85b61afcd8 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1788,6 +1788,7 @@ enum nft_synproxy_attributes {
 enum nft_devices_attributes {
 	NFTA_DEVICE_UNSPEC,
 	NFTA_DEVICE_NAME,
+	NFTA_DEVICE_WILDCARD,
 	__NFTA_DEVICE_MAX
 };
 #define NFTA_DEVICE_MAX		(__NFTA_DEVICE_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 04795af6e586..f65b4fba5225 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1959,6 +1959,14 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 	return -ENOSPC;
 }
 
+static int hook_device_attr(struct nft_hook *hook)
+{
+	if (hook->ifname[hook->ifnamelen - 1] == '\0')
+		return NFTA_DEVICE_NAME;
+
+	return NFTA_DEVICE_WILDCARD;
+}
+
 static int nft_dump_basechain_hook(struct sk_buff *skb,
 				   const struct net *net, int family,
 				   const struct nft_base_chain *basechain,
@@ -1990,7 +1998,7 @@ static int nft_dump_basechain_hook(struct sk_buff *skb,
 			if (!first)
 				first = hook;
 
-			if (nla_put(skb, NFTA_DEVICE_NAME,
+			if (nla_put(skb, hook_device_attr(hook),
 				    hook->ifnamelen, hook->ifname))
 				goto nla_put_failure;
 			n++;
@@ -1998,6 +2006,7 @@ static int nft_dump_basechain_hook(struct sk_buff *skb,
 		nla_nest_end(skb, nest_devs);
 
 		if (n == 1 &&
+		    hook_device_attr(first) != NFTA_DEVICE_WILDCARD &&
 		    nla_put(skb, NFTA_HOOK_DEV,
 			    first->ifnamelen, first->ifname))
 			goto nla_put_failure;
@@ -2376,7 +2385,8 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 	int rem, n = 0, err;
 
 	nla_for_each_nested(tmp, attr, rem) {
-		if (nla_type(tmp) != NFTA_DEVICE_NAME) {
+		if (nla_type(tmp) != NFTA_DEVICE_NAME &&
+		    nla_type(tmp) != NFTA_DEVICE_WILDCARD) {
 			err = -EINVAL;
 			goto err_hook;
 		}
@@ -9427,7 +9437,7 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 
 	list_for_each_entry_rcu(hook, hook_list, list,
 				lockdep_commit_lock_is_held(net)) {
-		if (nla_put(skb, NFTA_DEVICE_NAME,
+		if (nla_put(skb, hook_device_attr(hook),
 			    hook->ifnamelen, hook->ifname))
 			goto nla_put_failure;
 	}
-- 
2.49.0

