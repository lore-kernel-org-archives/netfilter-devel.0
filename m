Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD4686347;
	Thu, 30 Oct 2025 12:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761826811; cv=none; b=QUrcM1QlCGrUbU6JbUCMS296VhxPKcCc7c2SEhJe75hwetSb2g8vBo0epJegK/QX1KD0JOos48gtZ7vRk+eGjtQvLtrEtl2SVnOcF/oj1BaSsvF4RRbwxmoYIJtyRIVFbxxmKVGJ1j4gUrw4B2mJG1HDBdtetjI6S5uDihU5JFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761826811; c=relaxed/simple;
	bh=F055XNK2zrHSAYOm28I4AwYYbPoEohkR7ls7XV7Ic2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxQWXoUtVbnCKibXS7+dCiMIjJTY6HLxtP8FMvpKc6XVmJgW/cWcOD0o/n3XgqTx47qxoHDJ6wqOoE4QsWR2jBD7xzN5fegw+0pRhxyOZhPpDq2HMgDaa9V+EXj2rtPbieb/b47H/RBEvV4JteKZ9eNnD65VtJGWdosDZxAL1R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1793F60202; Thu, 30 Oct 2025 13:20:08 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 2/3] netfilter: conntrack: disable 0 value for conntrack_max setting
Date: Thu, 30 Oct 2025 13:19:53 +0100
Message-ID: <20251030121954.29175-3-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251030121954.29175-1-fw@strlen.de>
References: <20251030121954.29175-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Undocumented historical artifact inherited from ip_conntrack.
If value is 0, then no limit is applied at all, conntrack table
can grow to huge value, only limited by size of conntrack hashes and
the kernel-internal upper limit on the hash chain lengths.

This feature makes no sense; users can just set
conntrack_max=2147483647 (INT_MAX).

Disallow a 0 value.  This will make it slightly easier to allow
per-netns constraints for this value in a future patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c       | 2 +-
 net/netfilter/nf_conntrack_standalone.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 344f88295976..0b95f226f211 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1668,7 +1668,7 @@ __nf_conntrack_alloc(struct net *net,
 	/* We don't want any race condition at early drop stage */
 	ct_count = atomic_inc_return(&cnet->count);
 
-	if (nf_conntrack_max && unlikely(ct_count > nf_conntrack_max)) {
+	if (unlikely(ct_count > nf_conntrack_max)) {
 		if (!early_drop(net, hash)) {
 			if (!conntrack_gc_work.early_drop)
 				conntrack_gc_work.early_drop = true;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 708b79380f04..207b240b14e5 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -648,7 +648,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
+		.extra1		= SYSCTL_ONE,
 		.extra2		= SYSCTL_INT_MAX,
 	},
 	[NF_SYSCTL_CT_COUNT] = {
@@ -929,7 +929,7 @@ static struct ctl_table nf_ct_netfilter_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
+		.extra1		= SYSCTL_ONE,
 		.extra2		= SYSCTL_INT_MAX,
 	},
 };
-- 
2.51.0

