Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.125
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755040;
	b=sXAnWzRQa6/ljnxnCc5865JzEgXoKLD7PRChZ/UD/owLjoUdvbr7Ow+QY/ekvovv5gnX
	 Q/CxaN8+2cuO8uiyVPp3Z8UIu4yVM++VO/iToOFsiw5d6T2swhM1ezZkM7QcbQ60w0X6r
	 Tbj4jg1v0Wi/IdM6OJ5yDXYpb2Ed3EEbfcGOWydcnwtI1h3CwQVRWTcKJF4S7boroU94V
	 nCfIfjtP9x+9bmSrjzhh5tehZKP1iBlPL9ub3CyGx1wilD0fS+KQ671b1+R/2/1BqLI63
	 wt2ymCgUFcS0Paa1iaAfbB7oRJ0+DtToFRca5Xw6isgMcgj6Oss7KER2I0SoJKsvcsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755040;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=532i/bG/6bgU/Qx7BjHvFfDGqADAt9yzpQ8usFi7AE4=;
	b=Bgj7hA/rhuIOezN8XIeA3JCM2MjySueiJ+gw0kELQHEfL36F7Ab+UpJZ0mdr57+R49sL
	 ysqAQmPXoZRr9rCnjz+cQCTR5i/zFLW2bjPxrANA0+GPsywE4gRuiv+1zb0S2GON5iokS
	 aZRLN3XlrI4SQTXNWPspUlVCepdY8UavlWaR9aS7BRXVO6+lEXhshrZz0XIqG8Qwwym7M
	 XCc0e/TOVHMnZHU+OVF8yBcdoBDZmTSlOJd10ztI1a+3iynOHYHgMpWmLDiegRdaQCo3Z
	 WnwRCSzQDIf26SxJOh2KDx9tq3UP5WFD0dmXYVWCQa75CXABoAbOCnSwYr1O9ASFHRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=viDw1emv;
	arc=none smtp.remote-ip=91.218.175.125
Received: from mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37BF606A31A
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 15:03:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E37BF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=viDw1emv
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OMC7H5pGSV1cvbo4FBVlff9QG8S2skAFgdr47JJ6Gfg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794755037; v=1; x=1795359837;
 b=viDw1emvxD8kIOcnAqaEIOFOsXcdca/zWYaM2U33bSi6NEp2+oYSSsldA4i6oEuxTh4i4rQ1
 dm2HH/xe2mvVibDt+Z5eikhN8t0iTp+TIyLr5S0VlWslOy07rGmfHGxdWkz5FlxS3BTJ5AJJ01M
 Qr40nHSsjWpgqqKUogKGXZEA=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 27a4e190672cde65;
	Sun, 15 Nov 2026 15:03:57 +0000
X-Mizu-Trace-ID: 27a4e190672cde65
X-Migadu-Flow: FLOW_OUT
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2 1/3] netfilter: conntrack: annotate data-races around conntrack sysctls
Date: Sun, 15 Nov 2026 23:03:40 +0800
Message-ID: <20261115150342.86521-1-jiayuan.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
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

nf_conntrack_acct, nf_conntrack_events, nf_conntrack_timestamp,
nf_conntrack_checksum, nf_conntrack_log_invalid, nf_conntrack_max and
nf_conntrack_expect_max are read without any lock while their sysctl
handlers update them with WRITE_ONCE(), and nf_ct_set_acct() stores
sysctl_acct with a plain write. Add READ_ONCE() to the readers and
WRITE_ONCE() to nf_ct_set_acct().

KCSAN reports it when nf_conntrack_checksum is changed while packets go
through conntrack:

  BUG: KCSAN: data-race in nf_conntrack_icmpv4_error / proc_dou8vec_minmax

  write (marked) to 0xffffffff8ee29b6d of 1 bytes by task 568 on cpu 0:
   proc_dou8vec_minmax+0x1ab/0x1f0
   proc_sys_call_handler+0x282/0x3a0
   proc_sys_write+0x13/0x20
   ...

  read to 0xffffffff8ee29b6d of 1 bytes by interrupt on cpu 2:
   nf_conntrack_icmpv4_error+0xb3/0x240
   nf_conntrack_in+0xa85/0xb20
   ipv4_conntrack_local+0xb0/0x120
   nf_hook_slow+0x7e/0x180
   nf_hook+0x1fa/0x4e0
   __ip_local_out+0x1ac/0x3f0
   ip_push_pending_frames+0x65/0x160
   icmp_push_reply+0x17a/0x200
   __icmp_send+0xb7d/0x1a10
   udp_rcv+0x95c/0x14e0
   ...

  value changed: 0x00 -> 0x01

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
---
v1: https://lore.kernel.org/netdev/20261109025425.328445-1-jiayuan.chen@linux.dev/
Split out of the net-next series and sent to nf-next separately.
---
 include/net/netfilter/nf_conntrack_acct.h      | 6 +++---
 include/net/netfilter/nf_conntrack_timestamp.h | 2 +-
 net/netfilter/nf_conntrack_core.c              | 6 +++---
 net/netfilter/nf_conntrack_ecache.c            | 2 +-
 net/netfilter/nf_conntrack_expect.c            | 2 +-
 net/netfilter/nf_conntrack_netlink.c           | 2 +-
 net/netfilter/nf_conntrack_proto.c             | 6 +++---
 net/netfilter/nf_conntrack_proto_icmp.c        | 2 +-
 net/netfilter/nf_conntrack_proto_icmpv6.c      | 2 +-
 net/netfilter/nf_conntrack_proto_sctp.c        | 2 +-
 net/netfilter/nf_conntrack_proto_tcp.c         | 2 +-
 net/netfilter/nf_conntrack_proto_udp.c         | 2 +-
 12 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index a120685cac932..4e5a46b628831 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -33,7 +33,7 @@ struct nf_conn_acct *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
 	struct net *net = nf_ct_net(ct);
 	struct nf_conn_acct *acct;
 
-	if (!net->ct.sysctl_acct)
+	if (!READ_ONCE(net->ct.sysctl_acct))
 		return NULL;
 
 	acct = nf_ct_ext_add(ct, NF_CT_EXT_ACCT, gfp);
@@ -51,7 +51,7 @@ struct nf_conn_acct *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
 static inline bool nf_ct_acct_enabled(struct net *net)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	return net->ct.sysctl_acct != 0;
+	return READ_ONCE(net->ct.sysctl_acct) != 0;
 #else
 	return false;
 #endif
@@ -61,7 +61,7 @@ static inline bool nf_ct_acct_enabled(struct net *net)
 static inline void nf_ct_set_acct(struct net *net, bool enable)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	net->ct.sysctl_acct = enable;
+	WRITE_ONCE(net->ct.sysctl_acct, enable);
 #endif
 }
 
diff --git a/include/net/netfilter/nf_conntrack_timestamp.h b/include/net/netfilter/nf_conntrack_timestamp.h
index 57138d974a9f7..59751be856ce9 100644
--- a/include/net/netfilter/nf_conntrack_timestamp.h
+++ b/include/net/netfilter/nf_conntrack_timestamp.h
@@ -29,7 +29,7 @@ struct nf_conn_tstamp *nf_ct_tstamp_ext_add(struct nf_conn *ct, gfp_t gfp)
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
 	struct net *net = nf_ct_net(ct);
 
-	if (!net->ct.sysctl_tstamp)
+	if (!READ_ONCE(net->ct.sysctl_tstamp))
 		return NULL;
 
 	return nf_ct_ext_add(ct, NF_CT_EXT_TSTAMP, gfp);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 931b76aacd934..5c7054753722e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1508,7 +1508,7 @@ static void gc_worker(struct work_struct *work)
 
 	i = gc_work->next_bucket;
 	if (gc_work->early_drop)
-		nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
+		nf_conntrack_max95 = READ_ONCE(nf_conntrack_max) / 100u * 95u;
 
 	if (i == 0) {
 		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
@@ -1658,7 +1658,7 @@ __nf_conntrack_alloc(struct net *net,
 	/* We don't want any race condition at early drop stage */
 	ct_count = atomic_inc_return(&cnet->count);
 
-	if (unlikely(ct_count > nf_conntrack_max)) {
+	if (unlikely(ct_count > READ_ONCE(nf_conntrack_max))) {
 		if (!early_drop(net, hash)) {
 			if (!conntrack_gc_work.early_drop)
 				conntrack_gc_work.early_drop = true;
@@ -1793,7 +1793,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	ecache = tmpl ? nf_ct_ecache_find(tmpl) : NULL;
 
-	if ((ecache || net->ct.sysctl_events) &&
+	if ((ecache || READ_ONCE(net->ct.sysctl_events)) &&
 	    !nf_ct_ecache_ext_add(ct, ecache ? ecache->ctmask : 0,
 				  ecache ? ecache->expmask : 0,
 				  GFP_ATOMIC)) {
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index fb731ee235d89..2846511c5318c 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -321,7 +321,7 @@ bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp
 	struct net *net = nf_ct_net(ct);
 	struct nf_conntrack_ecache *e;
 
-	switch (net->ct.sysctl_events) {
+	switch (READ_ONCE(net->ct.sysctl_events)) {
 	case 0:
 		 /* assignment via template / ruleset? ignore sysctl. */
 		if (ctmask || expmask)
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 06242c86e1dc8..43594283bcc76 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -518,7 +518,7 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 	}
 
 	cnet = nf_ct_pernet(net);
-	if (cnet->expect_count >= nf_ct_expect_max) {
+	if (cnet->expect_count >= READ_ONCE(nf_ct_expect_max)) {
 		net_warn_ratelimited("nf_conntrack: expectation table full\n");
 		ret = -EMFILE;
 	}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1f8d94a052403..0f1d42a10b347 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2591,7 +2591,7 @@ ctnetlink_stat_ct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (nla_put_be32(skb, CTA_STATS_GLOBAL_ENTRIES, htonl(nr_conntracks)))
 		goto nla_put_failure;
 
-	if (nla_put_be32(skb, CTA_STATS_GLOBAL_MAX_ENTRIES, htonl(nf_conntrack_max)))
+	if (nla_put_be32(skb, CTA_STATS_GLOBAL_MAX_ENTRIES, htonl(READ_ONCE(nf_conntrack_max))))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 7a40e4e0e33e6..83dc169f87df5 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -51,12 +51,12 @@ void nf_l4proto_log_invalid(const struct sk_buff *skb,
 			    u8 protonum,
 			    const char *fmt, ...)
 {
+	u8 log_invalid = READ_ONCE(state->net->ct.sysctl_log_invalid);
 	struct net *net = state->net;
 	struct va_format vaf;
 	va_list args;
 
-	if (net->ct.sysctl_log_invalid != protonum &&
-	    net->ct.sysctl_log_invalid != IPPROTO_RAW)
+	if (log_invalid != protonum && log_invalid != IPPROTO_RAW)
 		return;
 
 	va_start(args, fmt);
@@ -86,7 +86,7 @@ void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
 	lockdep_assert_not_held(&ct->lock);
 
 	net = nf_ct_net(ct);
-	if (likely(net->ct.sysctl_log_invalid == 0))
+	if (likely(READ_ONCE(net->ct.sysctl_log_invalid) == 0))
 		return;
 
 	va_start(args, fmt);
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index 32148a3a8509a..330c6d83d670a 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -217,7 +217,7 @@ int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
 	}
 
 	/* See nf_conntrack_proto_tcp.c */
-	if (state->net->ct.sysctl_checksum &&
+	if (READ_ONCE(state->net->ct.sysctl_checksum) &&
 	    state->hook == NF_INET_PRE_ROUTING &&
 	    nf_ip_checksum(skb, state->hook, dataoff, IPPROTO_ICMP)) {
 		icmp_error_log(skb, state, "bad hw icmp checksum");
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index e508b3aa370a7..803221781de39 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -198,7 +198,7 @@ int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
 	}
 
 	if (state->hook == NF_INET_PRE_ROUTING &&
-	    state->net->ct.sysctl_checksum &&
+	    READ_ONCE(state->net->ct.sysctl_checksum) &&
 	    nf_ip6_checksum(skb, state->hook, dataoff, IPPROTO_ICMPV6)) {
 		icmpv6_error_log(skb, state, "ICMPv6 checksum failed");
 		return -NF_ACCEPT;
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 71cc920f68568..49ec8478746ad 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -304,7 +304,7 @@ static bool sctp_error(struct sk_buff *skb,
 		goto out_invalid;
 	}
 	if (state->hook == NF_INET_PRE_ROUTING &&
-	    state->net->ct.sysctl_checksum &&
+	    READ_ONCE(state->net->ct.sysctl_checksum) &&
 	    skb->ip_summed == CHECKSUM_NONE) {
 		if (skb_ensure_writable(skb, dataoff + sizeof(*sh))) {
 			logmsg = "nf_ct_sctp: failed to read header ";
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ad6f1986d52a6..b859e409f0796 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -856,7 +856,7 @@ static bool tcp_error(const struct tcphdr *th,
 	 * because the checksum is assumed to be correct.
 	 */
 	/* FIXME: Source route IP option packets --RR */
-	if (state->net->ct.sysctl_checksum &&
+	if (READ_ONCE(state->net->ct.sysctl_checksum) &&
 	    state->hook == NF_INET_PRE_ROUTING &&
 	    nf_checksum(skb, state->hook, dataoff, IPPROTO_TCP, state->pf)) {
 		tcp_error_log(skb, state, "bad checksum");
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index a7edfefd6fd14..9ea4062752238 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -82,7 +82,7 @@ static bool udp_error(struct sk_buff *skb,
 	 * because the checksum is assumed to be correct.
 	 * FIXME: Source route IP option packets --RR */
 	if (state->hook == NF_INET_PRE_ROUTING &&
-	    state->net->ct.sysctl_checksum &&
+	    READ_ONCE(state->net->ct.sysctl_checksum) &&
 	    nf_checksum(skb, state->hook, dataoff, IPPROTO_UDP, state->pf)) {
 		udp_error_log(skb, state, "bad checksum");
 		return true;
-- 
2.43.0

