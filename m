Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CAF51FCC7
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 18:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788548047; cv=none; b=myvL7eoQnAIuIpvkDOqe3UE0Y9d2mBC/f0FwQ5EJIfTJccUAnUPl+4OHel9gLFOw9CdLEquVfhsmipo8SVA4WKSJ4S2V0Mfif2l/n0/wJL358vy9ISw7x1MmJEqloNBQZ2mrqoJsPbauU3okiSksJl+iBOswSA5F7HmG27lwDZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788548047; c=relaxed/simple;
	bh=9Ix0hMCpIbtDQHFIenvnngda2x3DcLos4hj+iXxuTCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdbU3vV0lhg7AdM+h1fLr01JkdkDighu2RcF0SMrTwFzgt2MlWlCoeIAgju3c9CAYkxA+ooKuN19pk6nhnbRgh1c2Uvh4XhNhaRHAcdBVw/OB7tYrTk0Atm+f0ZQu+of9Zo9sixLjAXMJ5p8Q9RryAiZtI7yiNJi1mvPS+nRkOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9718A60491; Fri, 04 Sep 2026 20:54:03 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 07/13] netfilter: ipset: remove obsolete data_next stubs
Date: Fri,  4 Sep 2026 20:53:15 +0200
Message-ID: <20260904185321.30313-8-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904185321.30313-1-fw@strlen.de>
References: <20260904185321.30313-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Was used in the generic resize code.  This code is now gone, we only
need this is a few selected set backends for netmask expansion on
insert.

Retain it in those specific helpers and remove all the obsolete/unused
stubs.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_gen.h        |  4 ----
 net/netfilter/ipset/ip_set_hash_ip.c         |  5 -----
 net/netfilter/ipset/ip_set_hash_ipmac.c      | 13 -------------
 net/netfilter/ipset/ip_set_hash_ipmark.c     |  6 ------
 net/netfilter/ipset/ip_set_hash_ipport.c     |  7 -------
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  7 -------
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  7 -------
 net/netfilter/ipset/ip_set_hash_mac.c        |  6 ------
 net/netfilter/ipset/ip_set_hash_net.c        |  6 ------
 net/netfilter/ipset/ip_set_hash_netiface.c   |  6 ------
 net/netfilter/ipset/ip_set_hash_netnet.c     |  6 ------
 net/netfilter/ipset/ip_set_hash_netport.c    |  7 -------
 net/netfilter/ipset/ip_set_hash_netportnet.c |  7 -------
 13 files changed, 87 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 4d2e1e867606..4efc93333aef 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -135,7 +135,6 @@ static const union nf_inet_addr zeromask = {};
 #undef mtype_data_reset_flags
 #undef mtype_data_netmask
 #undef mtype_data_list
-#undef mtype_data_next
 #undef mtype_elem
 
 #undef mtype_rht_elem
@@ -189,7 +188,6 @@ static const union nf_inet_addr zeromask = {};
 #define mtype_data_reset_flags	IPSET_TOKEN(MTYPE, _data_reset_flags)
 #define mtype_data_netmask	IPSET_TOKEN(MTYPE, _data_netmask)
 #define mtype_data_list		IPSET_TOKEN(MTYPE, _data_list)
-#define mtype_data_next		IPSET_TOKEN(MTYPE, _data_next)
 #define mtype_elem		IPSET_TOKEN(MTYPE, _elem)
 
 #define mtype_rht_elem		IPSET_TOKEN(MTYPE, _rht_elem)
@@ -913,8 +911,6 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	if (ret == -EEXIST)
 		ret = flag_exist ? 0 : -IPSET_ERR_EXIST;
 
-	if (0)	/* to be removed */
-		mtype_data_next(&h->next, d);
 out_rcu_unlock:
 	rcu_read_unlock_bh();
 	return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index c9f4e3859663..9b82ec5d4037 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -198,11 +198,6 @@ hash_ip6_data_list(struct sk_buff *skb, const struct hash_ip6_elem *e)
 	return true;
 }
 
-static void
-hash_ip6_data_next(struct hash_ip6_elem *next, const struct hash_ip6_elem *e)
-{
-}
-
 #undef MTYPE
 #undef HOST_MASK
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index b9a2681e2488..dced4c5f3ca3 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -68,13 +68,6 @@ hash_ipmac4_data_list(struct sk_buff *skb, const struct hash_ipmac4_elem *e)
 	return true;
 }
 
-static void
-hash_ipmac4_data_next(struct hash_ipmac4_elem *next,
-		      const struct hash_ipmac4_elem *e)
-{
-	next->ip = e->ip;
-}
-
 #define MTYPE		hash_ipmac4
 #define PF		4
 #define HOST_MASK	32
@@ -176,12 +169,6 @@ hash_ipmac6_data_list(struct sk_buff *skb, const struct hash_ipmac6_elem *e)
 	return true;
 }
 
-static void
-hash_ipmac6_data_next(struct hash_ipmac6_elem *next,
-		      const struct hash_ipmac6_elem *e)
-{
-}
-
 #undef MTYPE
 #undef PF
 #undef HOST_MASK
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index e26ca2a370e3..6196b0112cf9 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -201,12 +201,6 @@ hash_ipmark6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static void
-hash_ipmark6_data_next(struct hash_ipmark6_elem *next,
-		       const struct hash_ipmark6_elem *d)
-{
-}
-
 #undef MTYPE
 #undef HOST_MASK
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 41ca24a22a02..7842ff4ad74f 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -245,13 +245,6 @@ hash_ipport6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static void
-hash_ipport6_data_next(struct hash_ipport6_elem *next,
-		       const struct hash_ipport6_elem *d)
-{
-	next->port = d->port;
-}
-
 #undef MTYPE
 #undef HOST_MASK
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index b9ac2efaa15c..b1b24358c810 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -244,13 +244,6 @@ hash_ipportip6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static void
-hash_ipportip6_data_next(struct hash_ipportip6_elem *next,
-			 const struct hash_ipportip6_elem *d)
-{
-	next->port = d->port;
-}
-
 #undef MTYPE
 #undef HOST_MASK
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 195853a25b06..58a47a0f89f0 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -375,13 +375,6 @@ hash_ipportnet6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static void
-hash_ipportnet6_data_next(struct hash_ipportnet6_elem *next,
-			  const struct hash_ipportnet6_elem *d)
-{
-	next->port = d->port;
-}
-
 #undef MTYPE
 #undef HOST_MASK
 
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index 41a122591fe2..4c195db349f7 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -57,12 +57,6 @@ hash_mac4_data_list(struct sk_buff *skb, const struct hash_mac4_elem *e)
 	return true;
 }
 
-static void
-hash_mac4_data_next(struct hash_mac4_elem *next,
-		    const struct hash_mac4_elem *e)
-{
-}
-
 #define MTYPE		hash_mac4
 #define HOST_MASK	32
 #define IP_SET_EMIT_CREATE
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 092f3c9281b8..157660674f1d 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -269,12 +269,6 @@ hash_net6_data_list(struct sk_buff *skb, const struct hash_net6_elem *data)
 	return true;
 }
 
-static void
-hash_net6_data_next(struct hash_net6_elem *next,
-		    const struct hash_net6_elem *d)
-{
-}
-
 #undef MTYPE
 #undef HOST_MASK
 
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index edadd6307675..82b00337cfef 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -370,12 +370,6 @@ hash_netiface6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static void
-hash_netiface6_data_next(struct hash_netiface6_elem *next,
-			 const struct hash_netiface6_elem *d)
-{
-}
-
 #undef MTYPE
 #undef HOST_MASK
 
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index f7c8a1cc30fc..4e77e40ebc2c 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -359,12 +359,6 @@ hash_netnet6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static void
-hash_netnet6_data_next(struct hash_netnet6_elem *next,
-		       const struct hash_netnet6_elem *d)
-{
-}
-
 #undef MTYPE
 #undef HOST_MASK
 
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 5de4b511de76..dfe8f995abbe 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -330,13 +330,6 @@ hash_netport6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static void
-hash_netport6_data_next(struct hash_netport6_elem *next,
-			const struct hash_netport6_elem *d)
-{
-	next->port = d->port;
-}
-
 #undef MTYPE
 #undef HOST_MASK
 
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 61af1ce27127..0dc79d37beac 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -421,13 +421,6 @@ hash_netportnet6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static void
-hash_netportnet6_data_next(struct hash_netportnet6_elem *next,
-			   const struct hash_netportnet6_elem *d)
-{
-	next->port = d->port;
-}
-
 #undef MTYPE
 #undef HOST_MASK
 
-- 
2.55.0

