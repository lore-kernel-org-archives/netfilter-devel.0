Received: from gosford.compton.nu (gosford.compton.nu [217.169.17.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA401C379B;
	Tue,  6 Aug 2024 11:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.17.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722944469; cv=none; b=mYyMGIlDyge2xe+JeZ6LfqOHVX7DUdHD5XiZe9kanS7lLUjq/WsmyLz52QWhPQV4JeomEgkDD9JrrD2xWk/KdqKc1su3KSC6HZGMLpO2/XeUztIARxA2+YQvc9twNop3m4uKSJSA4cRVMX+gNdEzkxpOKcz/23oQZJT+AqGiqIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722944469; c=relaxed/simple;
	bh=n4b/ILV/lU7hETE2VdFNFVO+PAmyfrGrQpfQKLrRlhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNXrheTlEC4SIQhIG15Xj4ai1w4qyBK711kIxPao+sMrggU4lqLCNJETVx4NcjyiiHd6v1woh6WKk0Hw2Qpmi3qBqu0b1vkzxPeFp3VKoYwi/cqLcZyVsaVcW5rOWHII0WZj3s6SZjWbX9RUCQCl3LYcJw6ERZum6xjH1ZkfvCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=compton.nu; spf=pass smtp.mailfrom=compton.nu; dkim=pass (2048-bit key) header.d=compton.nu header.i=tom@compton.nu header.b=1l3lSuSx; arc=none smtp.client-ip=217.169.17.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=compton.nu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=compton.nu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=compton.nu header.i=tom@compton.nu header.b="1l3lSuSx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=compton.nu;
	s=20200130; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=s2MWslhLKOgrf45qJJmyrbAdMeYmGiFIlHkAtGRvjMA=; i=tom@compton.nu;
	t=1722944465; x=1724154065; b=1l3lSuSx7Gw73GRobELwCernYqws6JkoAtQmqe+ZvHjJ9tn
	XfTgF/Fvo4KZuaySUhJA1gzFwAXFYuQR6hD/nB/ErIyzCmfWxh5s7XaUFSlY6SECia8JJYVdD/UFj
	RXMzacXRYl5KdKQGwSV2OWaLPYMMp7TONyLoH8on0EsAjYm6kpvmDvA/+Y9m5AW6K7lDvEfRtnHaQ
	utz8JzyZKKn8tf95GF4Nd5VFStOJCk4Du+h0YJ1yFdqjB/+TyatxJNZDSrBz3/+ufkns1VZLoeedT
	YAXPSbzXyNVHdPDR/oRvPVEQMkkaR5pJyTCySZvhyy9GoW2IWrP+DynE5HazfUAw==;
Authentication-Results: gosford.compton.nu;
	iprev=pass (bericote.compton.nu) smtp.remote-ip=2001:8b0:bd:1:1881:14ff:fe46:3cc7
Received: from bericote.compton.nu ([2001:8b0:bd:1:1881:14ff:fe46:3cc7]:35034)
	by gosford.compton.nu with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98)
	(envelope-from <tom@compton.nu>)
	id 1sbIYl-0000000GbT7-3KJk;
	Tue, 06 Aug 2024 12:41:03 +0100
Received: from tom by bericote.compton.nu with local (Exim 4.98)
	(envelope-from <tom@compton.nu>)
	id 1sbIYl-0000000DtM4-2nEK;
	Tue, 06 Aug 2024 12:40:59 +0100
From: Tom Hughes <tom@compton.nu>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	Tom Hughes <tom@compton.nu>
Subject: [PATCH v2] netfilter: allow ipv6 fragments to arrive on different devices
Date: Tue,  6 Aug 2024 12:40:52 +0100
Message-ID: <20240806114052.3311004-1-tom@compton.nu>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240806105751.3291225-1-tom@compton.nu>
References: <20240806105751.3291225-1-tom@compton.nu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 264640fc2c5f4 ("ipv6: distinguish frag queues by device
for multicast and link-local packets") modified the ipv6 fragment
reassembly logic to distinguish frag queues by device for multicast
and link-local packets but in fact only the main reassembly code
limits the use of the device to those address types and the netfilter
reassembly code uses the device for all packets.

This means that if fragments of a packet arrive on different interfaces
then netfilter will fail to reassemble them and the fragments will be
expired without going any further through the filters.

Fixes: 648700f76b03 ("inet: frags: use rhashtables for reassembly units")
Signed-off-by: Tom Hughes <tom@compton.nu>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 6f0844c9315d..4120e67a8ce6 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -154,6 +154,10 @@ static struct frag_queue *fq_find(struct net *net, __be32 id, u32 user,
 	};
 	struct inet_frag_queue *q;
 
+	if (!(ipv6_addr_type(&hdr->daddr) & (IPV6_ADDR_MULTICAST |
+					    IPV6_ADDR_LINKLOCAL)))
+		key.iif = 0;
+
 	q = inet_frag_find(nf_frag->fqdir, &key);
 	if (!q)
 		return NULL;
-- 
2.45.2

