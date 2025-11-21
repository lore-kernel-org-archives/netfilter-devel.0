Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2B7275AFF
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2025 10:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763722006; cv=none; b=bwL0bR+YS5iTOLCVVCe1PkINnCyNVg/HvMeR6WJ/fkyApx+UJefm7L4SXB+MRd1Iu26N8V/nFwhd6vY8I8TrAJK336kXV1OmEGmVBk7LpXR6rx4U+pKZ89XgVzya7BKnMjAbjFGa8x38mIp/WSsJdgwVvRPmMh74huGyMLW85oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763722006; c=relaxed/simple;
	bh=IoKeewMqEqvP0bmflhtcozf0g3MwQaI4Yhft6Uthnrc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NqQiCBggaCMJkXPniDWtff5I94hT9zZ5qe2RLwPhn+0ezUnB20yoEkx2MfrYLnjnZNMVrbiRTp5rpU2kUb0NSzhv7jQz6fDczGyRDcxlOtG1CUCodCjWYfdvFLaYu0KRRdqyoLvT8N4dk0PGxgVOIhzQlpwm7H9p5HNuznLA380=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RVgGAT7i; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RVgGAT7i"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29558061c68so24977645ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2025 02:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763722004; x=1764326804; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t+jQtIi6R3/Xo/ufxKPC6qm0gUE57Dr6R3PpZg3G3bk=;
        b=RVgGAT7iLzj3srBr+nD5PD4aI9xsojU8H3Cx0g3u5hZdTRg/gTe1Z101goefp+zX5k
         OxIFMMrTiQJ1XBBzrUdXLX7JFkGFFzQRohVU4hqBASR07evWXUqSW4Q5vnG0doX3XbWq
         yxODvYbiP9JrutAAoHAuWO4iyxpT3lsI3llQp7j9YOwjgWbEtFzqHBBtXhTV87WCVb+7
         U3EJNYRCRnvGy9ZnyBYz2TcxLJ31nvnMleQf3IVTC5JpnXasJDFwPpRkIoKV8VpZz2uR
         oPKMhfAqBvOd/UJTi5qiXgBL8W3jhi3KpgV1KSlrlYAw56TaYH3A4x0ZTwd9u0GdL8FA
         wQ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763722004; x=1764326804;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t+jQtIi6R3/Xo/ufxKPC6qm0gUE57Dr6R3PpZg3G3bk=;
        b=Sa7cbJ8miqb+i4Anai8YHYfVS/FQmGFp38vZgCuDXFioHjCUjWvNoGRQKDps1Mcpia
         2OUGotIcJmDqtI00sIgPpgkerMHggtBHi+0YclYGnLlPD8ZO/V+tzWnY//KAFA1YG70X
         umylOvTTjIXG3FaHjqVSCr+ZD1UKNvkFErCtWXfqw5DEnSpNJD9WeWez55DJalNg9olm
         YfNsef4FzgYfvx9orInOncJHSPUgCJLgokJ1K0A8shQztREnR/e3KBnWLpd+zDlshe0F
         +5ueDHHXuhucnkmWizdRFSX5lxzP2lJ7hwQs9fK8RG0GAFZkV+x9RXkIWl5JZC7wdk9i
         rEDg==
X-Forwarded-Encrypted: i=1; AJvYcCWKCuCa1NbkNrLAaoV2wiVs2fmXlbONgf1mS4EjNP3KrNx0sZS9N7t+ucxx4+R30rm6VlAizK9vykByXZjUFYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfliGMnJcJXeaWJ7efHfLXKwrlXtyOz3nagoQPItknZ/j1JpD1
	y9b5c6Umjz/pAf+8TPgZkLVGoG/it9LMg7zBo71eRbcq7eTyZG2g72Fh
X-Gm-Gg: ASbGncsrBbn22J9yMIn5fiaui2ERflSeTTs7yS2URsMoCv+Tu8NgK35ChuUq2eMdQ2G
	nAFpDhO482OzpVz73TxUXOmRm+53UKxiXkMgpYF4zqSelbv6duoFVY2cFsZdHcR1Utrw231PBXH
	oAPmJnVFvMFrYyZGTq6uHjh+JQz0qLd6yMHi8HJa5QJjxAj52REm+MpL2Bn8xjuGNJ0WVExz9I1
	pUoaTAaKzXad8V56BVUoLaxnyLIRARhIqTNZqKBGl9Umk+Xx64lBXfN98/5ErNdZ9yQLfxNIujb
	XggLakv6IHU6MPq8639q8A1VLhQL9rRlZUhBRYCLTY8cECrp+L7pAVkRZKZqYARGI8RBgQVgiku
	wvvpKugpJza4Mq5pgtVM671I0d4lmhZrZxndxdy8dZRO6o1O550Jz82YQ4NnzacvcGBNsmTIqSJ
	SkYTrTSCTa
X-Google-Smtp-Source: AGHT+IGM3Tnv0hnwaOvrFZQ0FP2TxVRH4LEdBvIs6xlX50jwt+kcq2E8pZwNoQWT5TAY6OTUuyyJfQ==
X-Received: by 2002:a17:902:d511:b0:297:d4a5:6500 with SMTP id d9443c01a7336-29b6bec9822mr29067905ad.26.1763722003892;
        Fri, 21 Nov 2025 02:46:43 -0800 (PST)
Received: from fedora ([122.173.25.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b138bfdsm52398575ad.22.2025.11.21.02.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 02:46:43 -0800 (PST)
From: Shi Hao <i.shihao.999@gmail.com>
To: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	ncardwell@google.com,
	kuniyu@google.com,
	linux-kernel@vger.kernel.org,
	Shi Hao <i.shihao.999@gmail.com>
Subject: [PATCH v2] net: ipv4: fix spelling typos in comments
Date: Fri, 21 Nov 2025 16:14:25 +0530
Message-ID: <20251121104425.44527-1-i.shihao.999@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct spelling typos in several code comments.

- alignement -> alignment
- wont -> won't
- orignal -> original
- substract -> subtract
- Segement -> Segment
- splitted -> split

Signed-off-by: Shi Hao <i.shihao.999@gmail.com>

---

changes v2:
- Update subject message
- Add additional spelling typo fixes
- Combined all typo fixes into single patch as requested
---
 net/ipv4/ip_fragment.c          | 2 +-
 net/ipv4/netfilter/arp_tables.c | 2 +-
 net/ipv4/syncookies.c           | 2 +-
 net/ipv4/tcp.c                  | 2 +-
 net/ipv4/tcp_input.c            | 4 ++--
 net/ipv4/tcp_output.c           | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index f7012479713b..116ebdd1ec86 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -335,7 +335,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb, int *refs)

 	/* Note : skb->rbnode and skb->dev share the same location. */
 	dev = skb->dev;
-	/* Makes sure compiler wont do silly aliasing games */
+	/* Makes sure compiler won't do silly aliasing games */
 	barrier();

 	prev_tail = qp->q.fragments_tail;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 1cdd9c28ab2d..f4a339921a8d 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -59,7 +59,7 @@ static inline int arp_devaddr_compare(const struct arpt_devaddr_info *ap,
 /*
  * Unfortunately, _b and _mask are not aligned to an int (or long int)
  * Some arches dont care, unrolling the loop is a win on them.
- * For other arches, we only have a 16bit alignement.
+ * For other arches, we only have a 16bit alignment.
  */
 static unsigned long ifname_compare(const char *_a, const char *_b, const char *_mask)
 {
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 569befcf021b..7d0d34329259 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -131,7 +131,7 @@ static __u32 check_tcp_syn_cookie(__u32 cookie, __be32 saddr, __be32 daddr,

 /*
  * MSS Values are chosen based on the 2011 paper
- * 'An Analysis of TCP Maximum Segement Sizes' by S. Alcock and R. Nelson.
+ * 'An Analysis of TCP Maximum Segment Sizes' by S. Alcock and R. Nelson.
  * Values ..
  *  .. lower than 536 are rare (< 0.2%)
  *  .. between 537 and 1299 account for less than < 1.5% of observed values
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8a18aeca7ab0..0d1c8e805d24 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1600,7 +1600,7 @@ struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
 			return skb;
 		}
 		/* This looks weird, but this can happen if TCP collapsing
-		 * splitted a fat GRO packet, while we released socket lock
+		 * split a fat GRO packet, while we released socket lock
 		 * in skb_splice_bits()
 		 */
 		tcp_eat_recv_skb(sk, skb);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e4a979b75cc6..6c09018b3900 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1129,7 +1129,7 @@ static void tcp_update_pacing_rate(struct sock *sk)
 		do_div(rate, tp->srtt_us);

 	/* WRITE_ONCE() is needed because sch_fq fetches sk_pacing_rate
-	 * without any lock. We want to make sure compiler wont store
+	 * without any lock. We want to make sure compiler won't store
 	 * intermediate values in this location.
 	 */
 	WRITE_ONCE(sk->sk_pacing_rate,
@@ -4868,7 +4868,7 @@ void tcp_sack_compress_send_ack(struct sock *sk)
 		__sock_put(sk);

 	/* Since we have to send one ack finally,
-	 * substract one from tp->compressed_ack to keep
+	 * subtract one from tp->compressed_ack to keep
 	 * LINUX_MIB_TCPACKCOMPRESSED accurate.
 	 */
 	NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPACKCOMPRESSED,
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index b94efb3050d2..483d6b578503 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2629,7 +2629,7 @@ static int tcp_mtu_probe(struct sock *sk)
 	interval = icsk->icsk_mtup.search_high - icsk->icsk_mtup.search_low;
 	/* When misfortune happens, we are reprobing actively,
 	 * and then reprobe timer has expired. We stick with current
-	 * probing process by not resetting search range to its orignal.
+	 * probing process by not resetting search range to its original.
 	 */
 	if (probe_size > tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_high) ||
 	    interval < READ_ONCE(net->ipv4.sysctl_tcp_probe_threshold)) {
--
2.51.0

