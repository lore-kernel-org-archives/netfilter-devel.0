Received: from smtp.forwardemail.net (smtp.forwardemail.net [149.28.215.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E0A3AC08
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Mar 2024 04:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.28.215.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711686358; cv=none; b=ogVvPA30wP8jqfU2Us9KV20K21IXiAdYj4OABwNf97xSmoronABQLADj7097TzxR4pFgAdOysLu6HXAvou0oQAsjGP6V/D4lqz5maTgTkVdcbYZxcyMTv91DW+06tYRHW8c11ib329tp/cCv/667c+ULrFgLLHvtKlFyoFCRMiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711686358; c=relaxed/simple;
	bh=nNay1aV4TfSASqPJjXCxeAzelDK7osT+yJa9FnMByoA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lCM4B5CXFk6qAb9KmzA5NHbj4L+9AZxPakXSjr8V63cZ1lPlML02iPbBGRBvqRobgdqrT5DqPwXKcZCYfoNSwD97s+Se0S/109xsipGTMfEmPt9vxOpXXGZ+qUv41fwsFSjvu8xtaYm7aeRWdWcaRLiX8dMR5aXG/XvUWfdJ84M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=faucet.nz; spf=pass smtp.mailfrom=fe-bounces.faucet.nz; dkim=pass (1024-bit key) header.d=faucet.nz header.i=@faucet.nz header.b=dlRoWXaV; arc=none smtp.client-ip=149.28.215.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=faucet.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fe-bounces.faucet.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=faucet.nz header.i=@faucet.nz header.b="dlRoWXaV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=faucet.nz;
 h=Content-Transfer-Encoding: MIME-Version: Message-Id: Date: Subject: Cc:
 To: From; q=dns/txt; s=fe-4ed8c67516; t=1711686350;
 bh=CMNwW1fTsHqMDxsO3OxcQETZvoxbiQrweBGQH4nUay8=;
 b=dlRoWXaVQOdOuQOARy8mpfgbkrf3f53IJHGJQccuZnkM6Jkb4Ywx30QT4oX7pE8l1SWhSrAw5
 AqhzbOUlfnl0iroK7EBDHmipINGPa6VRPTettiSg8UbF2UsqCbn7ebkhQ2fWK4SHgmHyDzX9yF5
 Rmt4/frqpWL5HQ23/STS4bo=
From: Brad Cowie <brad@faucet.nz>
To: bpf@vger.kernel.org
Cc: lorenzo@kernel.org, memxor@gmail.com, pablo@netfilter.org,
 davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
 song@kernel.org, john.fastabend@gmail.com, sdf@google.com,
 jolsa@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, Brad Cowie <brad@faucet.nz>
Subject: [PATCH bpf-next] net: netfilter: Make ct zone id configurable for bpf ct helper functions
Date: Fri, 29 Mar 2024 17:14:30 +1300
Message-Id: <20240329041430.2176860-1-brad@faucet.nz>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Report-Abuse-To: abuse@forwardemail.net
X-Report-Abuse: abuse@forwardemail.net
X-Complaints-To: abuse@forwardemail.net
X-ForwardEmail-Version: 0.4.40
X-ForwardEmail-Sender: rfc822; brad@faucet.nz, smtp.forwardemail.net,
 149.28.215.223
X-ForwardEmail-ID: 660640461a1a38b2e7c2e855

Add ct zone id to bpf_ct_opts so that arbitrary ct zone can be
set for xdp/tc bpf ct helper functions bpf_{xdp,skb}_ct_alloc
and bpf_{xdp,skb}_ct_lookup.

Signed-off-by: Brad Cowie <brad@faucet.nz>
---
 net/netfilter/nf_conntrack_bpf.c              | 23 ++++++++++---------
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  1 -
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 13 ++---------
 3 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index d2492d050fe6..a0f8a64751ec 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -30,7 +30,6 @@
  * @error      - Out parameter, set for any errors encountered
  *		 Values:
  *		   -EINVAL - Passed NULL for bpf_tuple pointer
- *		   -EINVAL - opts->reserved is not 0
  *		   -EINVAL - netns_id is less than -1
  *		   -EINVAL - opts__sz isn't NF_BPF_CT_OPTS_SZ (12)
  *		   -EPROTO - l4proto isn't one of IPPROTO_TCP or IPPROTO_UDP
@@ -42,16 +41,14 @@
  *		 Values:
  *		   IPPROTO_TCP, IPPROTO_UDP
  * @dir:       - connection tracking tuple direction.
- * @reserved   - Reserved member, will be reused for more options in future
- *		 Values:
- *		   0
+ * @ct_zone    - connection tracking zone id.
  */
 struct bpf_ct_opts {
 	s32 netns_id;
 	s32 error;
 	u8 l4proto;
 	u8 dir;
-	u8 reserved[2];
+	u16 ct_zone;
 };
 
 enum {
@@ -104,11 +101,11 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
 			u32 timeout)
 {
 	struct nf_conntrack_tuple otuple, rtuple;
+	struct nf_conntrack_zone ct_zone;
 	struct nf_conn *ct;
 	int err;
 
-	if (!opts || !bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
-	    opts_len != NF_BPF_CT_OPTS_SZ)
+	if (!opts || !bpf_tuple || opts_len != NF_BPF_CT_OPTS_SZ)
 		return ERR_PTR(-EINVAL);
 
 	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
@@ -130,7 +127,9 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
 			return ERR_PTR(-ENONET);
 	}
 
-	ct = nf_conntrack_alloc(net, &nf_ct_zone_dflt, &otuple, &rtuple,
+	nf_ct_zone_init(&ct_zone, opts->ct_zone, NF_CT_DEFAULT_ZONE_DIR, 0);
+
+	ct = nf_conntrack_alloc(net, &ct_zone, &otuple, &rtuple,
 				GFP_ATOMIC);
 	if (IS_ERR(ct))
 		goto out;
@@ -152,11 +151,11 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 {
 	struct nf_conntrack_tuple_hash *hash;
 	struct nf_conntrack_tuple tuple;
+	struct nf_conntrack_zone ct_zone;
 	struct nf_conn *ct;
 	int err;
 
-	if (!opts || !bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
-	    opts_len != NF_BPF_CT_OPTS_SZ)
+	if (!opts || !bpf_tuple || opts_len != NF_BPF_CT_OPTS_SZ)
 		return ERR_PTR(-EINVAL);
 	if (unlikely(opts->l4proto != IPPROTO_TCP && opts->l4proto != IPPROTO_UDP))
 		return ERR_PTR(-EPROTO);
@@ -174,7 +173,9 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 			return ERR_PTR(-ENONET);
 	}
 
-	hash = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tuple);
+	nf_ct_zone_init(&ct_zone, opts->ct_zone, NF_CT_DEFAULT_ZONE_DIR, 0);
+
+	hash = nf_conntrack_find_get(net, &ct_zone, &tuple);
 	if (opts->netns_id >= 0)
 		put_net(net);
 	if (!hash)
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index b30ff6b3b81a..25c3c4e87ed5 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -103,7 +103,6 @@ static void test_bpf_nf_ct(int mode)
 		goto end;
 
 	ASSERT_EQ(skel->bss->test_einval_bpf_tuple, -EINVAL, "Test EINVAL for NULL bpf_tuple");
-	ASSERT_EQ(skel->bss->test_einval_reserved, -EINVAL, "Test EINVAL for reserved not set to 0");
 	ASSERT_EQ(skel->bss->test_einval_netns_id, -EINVAL, "Test EINVAL for netns_id < -1");
 	ASSERT_EQ(skel->bss->test_einval_len_opts, -EINVAL, "Test EINVAL for len__opts != NF_BPF_CT_OPTS_SZ");
 	ASSERT_EQ(skel->bss->test_eproto_l4proto, -EPROTO, "Test EPROTO for l4proto != TCP or UDP");
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index 77ad8adf68da..4adb73bc1b33 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -45,7 +45,8 @@ struct bpf_ct_opts___local {
 	s32 netns_id;
 	s32 error;
 	u8 l4proto;
-	u8 reserved[3];
+	u8 dir;
+	u16 ct_zone;
 } __attribute__((preserve_access_index));
 
 struct nf_conn *bpf_xdp_ct_alloc(struct xdp_md *, struct bpf_sock_tuple *, u32,
@@ -84,16 +85,6 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 	else
 		test_einval_bpf_tuple = opts_def.error;
 
-	opts_def.reserved[0] = 1;
-	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
-		       sizeof(opts_def));
-	opts_def.reserved[0] = 0;
-	opts_def.l4proto = IPPROTO_TCP;
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_einval_reserved = opts_def.error;
-
 	opts_def.netns_id = -2;
 	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
 		       sizeof(opts_def));
-- 
2.34.1

