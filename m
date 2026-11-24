Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525696;
	b=W4b7EPm359m/ymvX25nKI1fLsDyJfzSI5iaJWBUbC/Wq7nPFupVsh7NCMn/1bjWuPpjZ
	 QCFGf87sXDXynoYTL5YXsnNi41JtWF6SRqxq5Sy9eYLmoEFW85ZF2beCaJaD9aNbS6y9z
	 ZfLLuoLYVvzQZJdAHfKZOBLhnHpiUzwawztKZZ4F7lOzSryEaIi+JJQ/34dP48J8Fwon/
	 jvaDX8tMQbwqRneJ3dltLszlnqZjRLuPBxz0TlS5f1kd7/LFQOpyksxrbjmWXKCy9Wai0
	 AM8coNG3Kf+a1hqp1DsLLilaDb9Q1cU0dDaynXPEMxxLZp/Qlfm+tGz74OcHVSlHK8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525696;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Gbwli+3jGR+ys5kSnBS4mEXqow+bmaiRcBn2LYzp6yA=;
	b=GsacR3vytNfT7CIY6iH/yZBcTEnWmMJhrv9h2REv24F47nsKZU7gxSmwce6cxVmH1U2F
	 2inrcE2rGbpqMSlergzdj4kueg4NtrzQnLitBgdsZncj1MFSfiAX9hBp+t646ViT2UbOn
	 wJyLBGyvDfIvnR8cfihP+NS1ZOlkR4B9X/AUAhiFPTNOdjNdnsQ0DGnF7KAjwa2377gSH
	 0xBh0+TyUYzpDYpQvN4RUhWrwByFUbJacpqUE2LHoa1UW/8p6NSP2Xv6AwcNVTMx1wJcw
	 O5s1Oxa8qwLIKiLGEZfPc4leU/4wESsSFnF9VOStbD6sTu+hqAJ8XxMBPNyt2vvlWqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RuyPA1g3;
	arc=none smtp.remote-ip=91.218.175.124
Received: from mta0.migadu.com (out-124.mta0.migadu.com [91.218.175.124])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236C1606A322
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 13:08:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 236C1606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RuyPA1g3
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1OtbO6cAmhEg7HnV0uuoWP9DuSDGmj8P3KgcqLq16Kc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795525694; v=1; x=1796130494;
 b=RuyPA1g3jj2oOv0KjQwAWoO4GQkYn8Ka4XNqbvhO6RvR9WQcv/cIz5MDJk8uqFBdstrtYnFa
 F/MOoEQguV0FqHaavFdCoj/c/F0cCazNwD0Orq15/0d0gaqqsWkayNCCZuaZX4huzs7Kv83fgAi
 oER8y/gpCgAOJ5yx1IGvtQbg=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 04409754ab00363b;
	Tue, 24 Nov 2026 13:08:14 +0000
X-Mizu-Trace-ID: 04409754ab00363b
X-Migadu-Flow: FLOW_OUT
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mptcp@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Subject: [PATCH net-next v1 4/6] net: avoid stack canaries in skb_try_coalesce() callers
Date: Tue, 24 Nov 2026 22:06:29 +0900
Message-ID: <20261124130631.1886963-5-xuanqiang.luo@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261124130631.1886963-1-xuanqiang.luo@linux.dev>
References: <20261124130631.1886963-1-xuanqiang.luo@linux.dev>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

skb_try_coalesce() returns the stolen head indication and the truesize
delta through pointers to locals of its callers.

With CONFIG_STACKPROTECTOR_STRONG=y, this forces a stack canary in
all of them, some are in TCP receive fast paths.

Rename it to __skb_try_coalesce(), and return its results by value in
a small structure.

skb_try_coalesce() is now an inline wrapper, callers do not change.

A successful merge never has a negative delta, so that a negative value
can be used to report a failure.

$ scripts/bloat-o-meter -t vmlinux.old vmlinux.new
add/remove: 2/2 grow/shrink: 1/8 up/down: 1303/-1677 (-374)
Function                                     old     new   delta
__skb_try_coalesce                             -    1255   +1255
tcp_data_queue                              4393    4425     +32
__pfx___skb_try_coalesce                       -      16     +16
mptcp_recvmsg                               2108    2092     -16
alloc_skb_with_frags                         534     518     -16
__pfx_skb_try_coalesce                        16       -     -16
tcp_try_coalesce                             386     359     -27
skb_copy_ubufs                              1645    1613     -32
__mptcp_move_skbs_from_subflow              1215    1167     -48
tcp_add_backlog                             1576    1527     -49
mptcp_try_coalesce                           235     168     -67
inet_frag_reasm_finish                       672     598     -74
skb_try_coalesce                            1332       -   -1332
Total: Before=24067978, After=24067604, chg -0.00%

Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
---
 include/linux/skbuff.h | 35 +++++++++++++++++++++++++++--
 net/core/skbuff.c      | 50 +++++++++++++++++++++++-------------------
 2 files changed, 60 insertions(+), 25 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 55ab6392301a..bbdf64811aed 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1370,8 +1370,39 @@ void __consume_stateless_skb(struct sk_buff *skb);
 void  __kfree_skb(struct sk_buff *skb);
 
 void kfree_skb_partial(struct sk_buff *skb, bool head_stolen);
-bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
-		      bool *fragstolen, int *delta_truesize);
+
+/* Result of __skb_try_coalesce(). */
+struct skb_coalesce_res {
+	int	delta_truesize;	/* negative if not coalesced */
+	bool	fragstolen;
+};
+
+struct skb_coalesce_res __skb_try_coalesce(struct sk_buff *to,
+					   struct sk_buff *from);
+
+/**
+ * skb_try_coalesce - try to merge skb to prior one
+ * @to: prior buffer
+ * @from: buffer to add
+ * @fragstolen: pointer to boolean
+ * @delta_truesize: how much more was allocated than was requested
+ *
+ * Return: true if @from was merged into @to, false otherwise.
+ */
+static __always_inline bool skb_try_coalesce(struct sk_buff *to,
+					     struct sk_buff *from,
+					     bool *fragstolen,
+					     int *delta_truesize)
+{
+	struct skb_coalesce_res res = __skb_try_coalesce(to, from);
+
+	*fragstolen = res.fragstolen;
+	if (res.delta_truesize < 0)
+		return false;
+
+	*delta_truesize = res.delta_truesize;
+	return true;
+}
 
 struct sk_buff *__alloc_skb(unsigned int size, gfp_t priority, int flags,
 			    int node);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e5b0209aec1c..1da20a7a0bb4 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6602,23 +6602,26 @@ void kfree_skb_partial(struct sk_buff *skb, bool head_stolen)
 EXPORT_SYMBOL(kfree_skb_partial);
 
 /**
- * skb_try_coalesce - try to merge skb to prior one
+ * __skb_try_coalesce - try to merge skb to prior one
  * @to: prior buffer
  * @from: buffer to add
- * @fragstolen: pointer to boolean
- * @delta_truesize: how much more was allocated than was requested
+ *
+ * Helper for skb_try_coalesce(), returning its results by value so that
+ * callers do not need a stack canary.
+ *
+ * Return: @delta_truesize is negative if @from was not merged.
  */
-bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
-		      bool *fragstolen, int *delta_truesize)
+struct skb_coalesce_res __skb_try_coalesce(struct sk_buff *to,
+					   struct sk_buff *from)
 {
+	const struct skb_coalesce_res fail = { .delta_truesize = -1 };
 	struct skb_shared_info *to_shinfo, *from_shinfo;
 	unsigned int len = from->len;
+	bool fragstolen = false;
 	int i, delta;
 
-	*fragstolen = false;
-
 	if (skb_cloned(to))
-		return false;
+		return fail;
 
 	/* In general, avoid mixing page_pool and non-page_pool allocated
 	 * pages within the same SKB. In theory we could take full
@@ -6627,14 +6630,14 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	 * rare, so not worth dealing with.
 	 */
 	if (to->pp_recycle != from->pp_recycle)
-		return false;
+		return fail;
 
 	/* All frags in an skb must either all be struct page-backed or all
 	 * belong to the same memory provider instance; do not coalesce skbs
 	 * that would mix them.
 	 */
 	if (skb_frags_readable(from) != skb_frags_readable(to))
-		return false;
+		return fail;
 
 	if (len <= skb_tailroom(to) && skb_frags_readable(from)) {
 		if (len) {
@@ -6642,41 +6645,40 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 						   skb_tail_pointer(to),
 						   len))) {
 				DEBUG_NET_WARN_ON_ONCE(1);
-				return false;
+				return fail;
 			}
 			skb_put(to, len);
 		}
-		*delta_truesize = 0;
-		return true;
+		return (struct skb_coalesce_res){ .delta_truesize = 0 };
 	}
 
 	to_shinfo = skb_shinfo(to);
 	from_shinfo = skb_shinfo(from);
 	if (to_shinfo->frag_list || from_shinfo->frag_list)
-		return false;
+		return fail;
 	if (skb_zcopy(to) || skb_zcopy(from))
-		return false;
+		return fail;
 
 	if (skb_headlen(from) != 0) {
 		if (to_shinfo->nr_frags +
 		    from_shinfo->nr_frags >= MAX_SKB_FRAGS)
-			return false;
+			return fail;
 
 		if (skb_head_is_locked(from))
-			return false;
+			return fail;
 
 		delta = from->truesize - SKB_DATA_ALIGN(sizeof(struct sk_buff));
 	} else {
 		if (to_shinfo->nr_frags +
 		    from_shinfo->nr_frags > MAX_SKB_FRAGS)
-			return false;
+			return fail;
 
 		delta = from->truesize - SKB_TRUESIZE(skb_end_offset(from));
 	}
 
 	/* @from claims more data than it has memory for.  Leave @to alone. */
 	if (WARN_ON_ONCE(delta < 0 || delta < len))
-		return false;
+		return fail;
 
 	if (skb_headlen(from) != 0) {
 		struct page *page = virt_to_head_page(from->head);
@@ -6685,7 +6687,7 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 		offset = from->data - (unsigned char *)page_address(page);
 		skb_fill_page_desc(to, to_shinfo->nr_frags,
 				   page, offset, skb_headlen(from));
-		*fragstolen = true;
+		fragstolen = true;
 	}
 
 	memcpy(to_shinfo->frags + to_shinfo->nr_frags,
@@ -6708,10 +6710,12 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	to->len += len;
 	to->data_len += len;
 
-	*delta_truesize = delta;
-	return true;
+	return (struct skb_coalesce_res){
+		.delta_truesize = delta,
+		.fragstolen = fragstolen,
+	};
 }
-EXPORT_SYMBOL(skb_try_coalesce);
+EXPORT_SYMBOL(__skb_try_coalesce);
 
 static void skb_ext_scrub(struct sk_buff *skb)
 {
-- 
2.43.0

