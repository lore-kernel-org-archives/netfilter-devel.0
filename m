Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3BB17A305
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Nov 2025 16:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762361341; cv=none; b=cYeieSBEOrHNm1nCJkRRdgAeJmX9U40hNmcpLUsazvpUDgf78K70rjH2HB8Dd2GYfrvSFtu0w3RpYaHAe5tCe25STb2X+xgIt9lY/RLoyW1W06uWriYhfpTGe3PLSHGyqFDpH5IXLKW1zXIWeTSykbwFDrA8f8SZ6nH1Ex4sQmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762361341; c=relaxed/simple;
	bh=KhJQQvmVlR6d9UJdW/2EfqxKM8Y+veCgxLPFopNmtEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3eOXrrbqOWj8XYP1gGR1E2VyQdFQzuPHMRI7bTFX/e04cZ9rPjvnARSr9MkO4sRDSulQoMQPymsvLlAYWxhlyt0/3JPBBok4Bbr6RLONuzgWQMm1CO5UdkblvDyEcsrGWVh4PzbyHqdb/p+GcowAj0wexLN8YbiunRhNhiJrdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 95C94603CA; Wed,  5 Nov 2025 17:48:58 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: pablo@netfilter.org
Subject: [RFC nf-next 10/11] netfilter: conntrack: allow non-init-net to change table size
Date: Wed,  5 Nov 2025 17:48:04 +0100
Message-ID: <20251105164805.3992-11-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105164805.3992-1-fw@strlen.de>
References: <20251105164805.3992-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This removes the init_net restriction on the bucket sysctl, i.e.
table size can be altered in a netns.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Documentation/networking/nf_conntrack-sysctl.rst | 1 -
 net/netfilter/nf_conntrack_standalone.c          | 2 --
 2 files changed, 3 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index eaf11ec1f4dc..a684d7664501 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -19,7 +19,6 @@ nf_conntrack_buckets - INTEGER
 	loading, the default size is calculated by dividing total memory
 	by 16384 to determine the number of buckets. The hash table will
 	never have fewer than 1024 and never more than 262144 buckets.
-	This sysctl is only writeable in the initial net namespace.
 
 nf_conntrack_checksum - BOOLEAN
 	- 0 - disabled
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index f31c95b77041..9170761caf96 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -660,7 +660,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	},
 	[NF_SYSCTL_CT_BUCKETS] = {
 		.procname       = "nf_conntrack_buckets",
-		.data           = &init_net.ct.nf_conntrack_htable_size,
 		.maxlen         = sizeof(unsigned int),
 		.mode           = 0644,
 		.proc_handler   = nf_conntrack_hash_sysctl,
@@ -1047,7 +1046,6 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	/* Don't allow non-init_net ns to alter global sysctls */
 	if (!net_eq(&init_net, net)) {
 		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
-		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
 	}
 
 	cnet->sysctl_header = register_net_sysctl_sz(net, "net/netfilter",
-- 
2.51.0

