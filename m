Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B764470EB6
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 16:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785342716; cv=none; b=XYkJdrq2GpBcoHxZsIqhzguT51r2yAS+6QoNHO4phvlqtNU9SdEBvRA2yed/x8m2ZWqD4xCecS+HtKuDV+M6Sq1Aq1q79FCOArEux+XGwudDL1kIoOTarYZ5n8roeARdkzI5Sj7OYJTNPCr9JIMAwNzZzdS6yXV11hYXsB6bd+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785342716; c=relaxed/simple;
	bh=YX7xq17ZotAraFEouO18/SjlA5AtqpZW3D7IbWm/iNI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Is+aDjmaYMnTxwVsYi1geB/PBGopm39ts2hNbsHA40D4Nt/zUuEnYnRdZlu3/hin5B1yZ2CQdqRA+BskkJ5xZkphDqdzh8THg4R+WvqD7e2vnxPbgKTA8PMM6kPAJm7N9DU0HMeSgyn+TmKSiyiXh9/yT+sTpRx623HMH+CRtM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ir5njEj9; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ir5njEj9"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ccdce28edeso1427165ad.0
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 09:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785342715; x=1785947515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kEGJ1DAV4pFcJgYI6xWwOeKrc0EBFfRn/eUaXfgAG40=;
        b=Ir5njEj9UfO7xLd1Ns2oEE0D08SnabHtLYw3LRVlk+89A5O8G1BlpBPjY+zjhBNT6G
         1TCb700cYko1shRnVrkNxbzJkL30DETpzpm2gX8NA9Hrvi984zvgFBEqKXv29xWAUmcn
         tCmseYdxai6vuTKMdxIadNUh/cTm8GOqhsyCLhXYXlIuIeSVrBiSVUI3Y7qvyz5vadvS
         C1dsj3G9WOSijfVJEvmh+XdAFWzgyn9F6M5oAkp1OnkSIL+2kPm0HqNRO7uD04mo1VU4
         9yjlLLrNikDvKIUP+TJfnxrHm3vBElGr9eloJz3Wj0JclzuQsZqa0WwF4SeIZ/T1w2Nc
         4S3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785342715; x=1785947515;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kEGJ1DAV4pFcJgYI6xWwOeKrc0EBFfRn/eUaXfgAG40=;
        b=EfSff18ii6K+FP/gHjToTiGSCym5AhaPfL+9XzF4q9ve0XQ6aj6tdYs+zfjmeAIQrl
         IiJ3EtogYazU1tKFhDbHz2lIkvjI8pyPn9KZWY6EnSD0975mPJbqJCXXBkI7DyGo6hWn
         Ku8UAzBVttbJTUxj18pB2eOfq9socnM4tnJwuqV4FC37Grx81wmwAoc19BJeJWEsOICF
         FPnVRsX7LknPfhT4SI2rQj1hAkWZrD63zTcuYp3m+T1i3gZiQGd1cPo8To3uo6DJDePa
         lzBDEHG04i+9jzyCdD2K1hPy6v0pruRRRKdmZk9OiQ5PcWbLhdML7RKwm0XKZDegurrI
         30/w==
X-Gm-Message-State: AOJu0YyLQQVIpuLNGIEBhgGoov1/cp3AlBELpIwR7Pfa5DA68k/kZJcr
	GTld11+igT2JXDDJYAH+zv53sriwmYICRorLOPO3rRaHUYsGo80TZx/x
X-Gm-Gg: AR+sD11/oIzNf+pmKsIx7dzh9/bAYqKT/g8+mNi81srv3rEY6nRhGITH8b0Gl3qMugB
	X1VcTcJ7hIT9wuoeCmgCwUyKcwxaOmah6G3Iccw6XByc/F31Z925Ew/gV3ScM/R0w9Q4I/qb1D1
	xtPJhLE5P3dTHAsSEHDQUKhZ/9L0/sGou+5B8jMW+YNeQYswyxLa4FLaY+rdsVwp2R6FdFaIyVk
	vov14DFByym0ksRw0UR+OAXkPs2JUmaZf5OfabWoEYXKUkcFuQ3w6QAoKQhRqJSw+12p8fAwm9h
	3RuA0/Y7n/XaOatc5BWIJL2gQNivu1fKnRrZEiT9Pbsy2Vdv4hOVG/NTHLUm7t0rSrMMo0P3z++
	VNJ6a2FJX/Lk2J3lfwrdpUwPWcAqJv1Vv6HKD5wtuUjLewusyVw5ZuzG5D/qO88LVVgtQq9dEs6
	Kx7xn2OBYObR4jTG/FDH/pS06RbQx3Ht1CpuGKrA3KnF6riZgimk5Ac+ZNsE+Si/rGq4sBUOUjh
	0dSvfqSdiZd+JSPVkzCGs2Gr4hCYHLnoGreibhZpmwQaAjqQN2OPr8=
X-Received: by 2002:a17:902:d4ce:b0:2c9:b96a:2855 with SMTP id d9443c01a7336-2d01e844abemr75415205ad.0.1785342714500;
        Wed, 29 Jul 2026 09:31:54 -0700 (PDT)
Received: from localhost.localdomain (45.78.65.84.16clouds.com. [45.78.65.84])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504cc73b6sm11245292eec.18.2026.07.29.09.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 09:31:53 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>
Subject: [PATCH bpf] bpf: Fix netns reference imbalance in conntrack kfuncs
Date: Thu, 30 Jul 2026 00:31:41 +0800
Message-ID: <20260729163141.213611-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The opts argument of the BPF conntrack kfuncs can point to a shared map
value.  __bpf_nf_ct_lookup() and __bpf_nf_ct_alloc_entry() read
opts->netns_id separately when acquiring and releasing the network
namespace reference.

The reference imbalance can occur as follows:

  CPU 0                                  CPU 1
  read opts->netns_id (-1)
  skip get_net_ns_by_id()
                                         write opts->netns_id (id)
  read opts->netns_id (id)
  put_net(net) /* no matching get */

The reverse transition leaks the reference.  Repeating the unmatched put
can destroy a live namespace and crash later users.

The kernel reported:

  Oops: general protection fault, probably for non-canonical address
  KASAN: null-ptr-deref in range [0x00000000000000e8-0x00000000000000ef]
  RIP: 0010:bpf_prog_test_run_xdp+0x52c/0x1700
  Call Trace:
   __sys_bpf+0x1662/0x50c0
   __x64_sys_bpf+0x73/0xb0
   do_syscall_64+0xf9/0x540
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  Kernel panic - not syncing: Fatal exception

Read netns_id once with READ_ONCE() and use that value for validation
and the matching get/put pair.  Each invocation then consistently uses
either the calling namespace or a referenced namespace.

Fixes: aed8ee7feb44 ("net: netfilter: Deduplicate code in bpf_{xdp,skb}_ct_lookup")
Fixes: d7e79c97c00c ("net: netfilter: Add kfuncs to allocate and insert CT")
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
Please queue this fix for stable kernels.

 net/netfilter/nf_conntrack_bpf.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index f98d1d4b42c3..8b540846f299 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -122,6 +122,7 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
 	struct nf_conntrack_tuple otuple, rtuple;
 	struct nf_conntrack_zone ct_zone;
 	struct nf_conn *ct;
+	s32 netns_id;
 	int err;
 
 	if (!(opts_len == NF_BPF_CT_OPTS_SZ || opts_len == 12))
@@ -134,7 +135,8 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
 			return ERR_PTR(-EINVAL);
 	}
 
-	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
+	netns_id = READ_ONCE(opts->netns_id);
+	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
 		return ERR_PTR(-EINVAL);
 
 	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
@@ -147,8 +149,8 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
 	if (err < 0)
 		return ERR_PTR(err);
 
-	if (opts->netns_id >= 0) {
-		net = get_net_ns_by_id(net, opts->netns_id);
+	if (netns_id >= 0) {
+		net = get_net_ns_by_id(net, netns_id);
 		if (unlikely(!net))
 			return ERR_PTR(-ENONET);
 	}
@@ -171,7 +173,7 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
 	__nf_ct_set_timeout(ct, timeout * HZ);
 
 out:
-	if (opts->netns_id >= 0)
+	if (netns_id >= 0)
 		put_net(net);
 
 	return ct;
@@ -186,6 +188,7 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_zone ct_zone;
 	struct nf_conn *ct;
+	s32 netns_id;
 	int err;
 
 	if (!opts || !bpf_tuple)
@@ -201,7 +204,8 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 	}
 	if (unlikely(opts->l4proto != IPPROTO_TCP && opts->l4proto != IPPROTO_UDP))
 		return ERR_PTR(-EPROTO);
-	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
+	netns_id = READ_ONCE(opts->netns_id);
+	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
 		return ERR_PTR(-EINVAL);
 
 	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
@@ -209,8 +213,8 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 	if (err < 0)
 		return ERR_PTR(err);
 
-	if (opts->netns_id >= 0) {
-		net = get_net_ns_by_id(net, opts->netns_id);
+	if (netns_id >= 0) {
+		net = get_net_ns_by_id(net, netns_id);
 		if (unlikely(!net))
 			return ERR_PTR(-ENONET);
 	}
@@ -225,7 +229,7 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 	}
 
 	hash = nf_conntrack_find_get(net, &ct_zone, &tuple);
-	if (opts->netns_id >= 0)
+	if (netns_id >= 0)
 		put_net(net);
 	if (!hash)
 		return ERR_PTR(-ENOENT);
-- 
2.43.0

