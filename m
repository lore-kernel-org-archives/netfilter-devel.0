Received: from gosford.compton.nu (gosford.compton.nu [217.169.17.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D15716DC07;
	Tue,  6 Aug 2024 11:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.17.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722942013; cv=none; b=uLPtFFcis0Vkf3aJo6r0FdpwJwQNNAteuarRRJh9/4Kf+FZIbRaiyfIEPd0ZfI0w+lEuPRZImYQWAsGuLFfSbpJZvjNAuRXKVVdSCMFeAr8SOK5qk9xM6SPk7dY2g5JywuoVDuhmJvup9Y48deE9sC+X6aW6ORY27L1ueNzFweY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722942013; c=relaxed/simple;
	bh=K+q601JkCTnwIUvBbNbmIGhA+FM9h0Z4Dmi+fgenXjg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NgmPqDR6+nJvzkOo6KrsFR2IxpJuToyZ0Psoh1mEdL+K3yNIlQHiegh7XaJNq/g5pCTTLL335IAmfE7ryMiUO33te/Si801CVnW9oUrp463LpgrhA6BQldnRazHKfRNZL4xA4hyQ+XjE78XhzIl0cbtnft6fv6HzOQUJmPZHCNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=compton.nu; spf=pass smtp.mailfrom=compton.nu; dkim=pass (2048-bit key) header.d=compton.nu header.i=tom@compton.nu header.b=WWGOsyQR; arc=none smtp.client-ip=217.169.17.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=compton.nu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=compton.nu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=compton.nu header.i=tom@compton.nu header.b="WWGOsyQR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=compton.nu;
	s=20200130; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Vx/8NUHHR7uGlkEW5lOU5IjJ2dWZYtOJ1SSV9gYHE2Q=; i=tom@compton.nu;
	t=1722942011; x=1724151611; b=WWGOsyQRmJpreD969qnHeJpsnUIBDPSa3FgzsWnKUEgFNO+
	AJTNYTAK0tBSs3BU6nItjA1ls2U0cY0XssRsZEo6ldT9vnsIXdgBNS7CtMNIWrWdfOuxIRFt1Qxrl
	8lM3Iecc0uqcCBascOPQRt24KS3RSzpJvaO8i5IX9aQ/6GJVvkmmGnIz9BMI6bkacIgzc606hl0EQ
	GxpftvM5SdxGlKDVOT+AsQFRH74/VUcfotJCAs1bvaHGc2BPJoTun84Sqr7+TGePDEXcS/z1XXiaC
	RPhsPVkVkxBL5OWL7iAbMkvm18gD1ohM06rpO6QP9+cx+OTWWb4QKvSuURyk62cA==;
Authentication-Results: gosford.compton.nu;
	iprev=pass (bericote.compton.nu) smtp.remote-ip=2001:8b0:bd:1:1881:14ff:fe46:3cc7
Received: from bericote.compton.nu ([2001:8b0:bd:1:1881:14ff:fe46:3cc7]:45800)
	by gosford.compton.nu with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98)
	(envelope-from <tom@compton.nu>)
	id 1sbHtJ-0000000GZcr-3n3r;
	Tue, 06 Aug 2024 11:58:13 +0100
Received: from tom by bericote.compton.nu with local (Exim 4.98)
	(envelope-from <tom@compton.nu>)
	id 1sbHtJ-0000000DoED-3Bna;
	Tue, 06 Aug 2024 11:58:09 +0100
From: Tom Hughes <tom@compton.nu>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	Tom Hughes <tom@compton.nu>
Subject: [PATCH] netfilter: allow ipv6 fragments to arrive on different devices
Date: Tue,  6 Aug 2024 11:57:51 +0100
Message-ID: <20240806105751.3291225-1-tom@compton.nu>
X-Mailer: git-send-email 2.45.2
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

