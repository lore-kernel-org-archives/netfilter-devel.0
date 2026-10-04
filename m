Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA0347125A
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 17:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134201; cv=none; b=heKyUZtKgcwvWimjLs+lvONTkkkKiBH4vVG8/74cjfUUU+UZ3mnLuUd+2bJW/J/8cRQ8ZGz88DV9NBq9UBAMHTPbewKtS8f3+j0mVbOrCyT7QeUe1U3DGc/mFRuib+6R7UNx8jGMWeCId/+CpYBw9J5sMiHALps3laFwuOYW4q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134201; c=relaxed/simple;
	bh=o+JP6AFkjXqu+xgn0kPky3tJsPD7UpyZPMamq+tPVVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXqIGWDWQmSFQ2xnmYSn1pEp9y5/GtxX0OMZiwAAm9cA8HoS7JXHcNzhy4XO7MJDe7brMXu4A2MW6oJWDvIXvalaIo6J/G/rWlDNjVNhbJX/q832mWfQnTuRL18FgQRLvZOhTkbRd1c5bGo79WvwqSygLCzGx9qOvfCTM8Rlft4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=DpEDTgQR; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="DpEDTgQR"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2e43f3d1fdso143421866b.3
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 10:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791134192; x=1791738992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TJNhbzdzUtweI2bWLQScQsYVxoKpUAcTekhWP7Abrus=;
        b=DpEDTgQRauCXnYOV7ZoTK/2porP1x5M+2Q1zQnBHLxTxA5kzM3O8BNIB+gZRTYk9i1
         HWH6yFPxWqqyfZeB/BdutxpmlPELsvOZE6i8mzJHs8gqmjTjovkFkoqaiNJStCgNhcAk
         VB8K51s6ji3q7/0ReSrPFOgVJ6AaBRiBsxN78Qdk3nEQngYOVyFIGiY3Hf8HphHLy5mz
         r/e/jjiDEq5lyADdqqAGeAv3Tsmw5MKr1DFb8LZpKKivVbn2YpuRl72Li5Vw8kmG+HAG
         p7OU6p4cVIfR4eVpZ1xP4JJgBHa/pm6S9njFzFYggZmv9ckdRRATZCfxdRlIJTmAS6q6
         nomw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134192; x=1791738992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TJNhbzdzUtweI2bWLQScQsYVxoKpUAcTekhWP7Abrus=;
        b=ukbByhXqAS9KchrDfa+Ht523J42lFu2vxQ+BBVrecTmQPwPYLdEsx0bO56+xw6fgxo
         p2JErk+pQiTpK/qPB7v75ceHHGhcq4XQH7Blo0otFxR7CqpBASjcA0OoazZalLjtAhcA
         C6fhSOK/HwmtFZlT36Ms+15uk62DErNcI+fv3324tXMyOxk5JyO+zN+OadNZ4/jVqjxY
         r97UfO2Xg8gh8aGcq+AsE0ce2S0TGlsbgvGNOfYUsW76rgfNJ1o8aa7MVo96FQLh8crK
         H17FZA7kk0/tV/N8ZQiyV+Ac0jIgEJgtjaAr/UqLFKTX5IxVmCJm55wdYV1OqndzhLFK
         GcGg==
X-Forwarded-Encrypted: i=1; AKwUvByrYEGw8IZSAjjLvMsSW0mwdAFUZxDf6E2T0mWV4cRNYRZuheNtoHAb19Cwun0UNR4ZBY3xNxbDh+hS6pYoqok=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ1lxRkyoNq7JwWBZbBYzVW/M93Ixh9XBzwqmm7L/3wZC/n+8UU
	KlVKG5jNP6w5vSXyyWdWCbxYLC+wBNm5BoLc9iRng7Qs+u0YEKbs/Dg6u9g2l0EFdw==
X-Gm-Gg: AYBFou1ItPsbzV9Rl/lcDbeXC0ZFimuBZsCE2Ll4w/F6KR5LrPk/4KTToLr2ufcceUT
	WmffpXkVBKa6t04sKsQFGwI8awCmcOiJn7i7xRIkWWA9nyrAe9VTeGn/agq7xXzpCJR9wkPYy+6
	WzuerLWZjNQ2tCVtz1FRjeKyGpDJf2Un16RKAvmsGgwiM4V3gUjmNdCH684/7Al+WTWo9/FtcLt
	HgeuEA7AOIDX+ypv0LobfYQ+LY1oGrJCg04QKeuTcvymKfd1ij+2tccFMBPCq2AaFpNDcHcNot8
	HqbPHQsb5awtyVKACt9nq1FPI4zItNO3KzV3d9NmrgAGJV8gXlG/vj5Rd4dLwWPRe/niNY8Y+VO
	ewECCHWLDbCrNiJEruD9P9XPjstfdGtv9ssMKdOPSiS7ozQ9Z5Prxmprf6A2S7EzaNG6QAPuEBS
	7LYvcJ6cfM8XA4MTNIQtnP3htSR9GzdAOZdRSlm/rYz6LvJprwyjvzCKbtabQkzuz7YmoamphwO
	VpJK+h7BMG3NzoKNRm5gP7tK5KU1MzjL5w6mwsEClZksnHfSAmygLftLBzKMS4h0uGYOdWR+7pR
	oTq3O/JzMHlCHpIokmP5SAILFlt62N3c7aIcqwSF+pfoGPEcfWksy23Q9S33Z0zppK14KX/IdGr
	i6+a32aUtkcW93ZnXDbW87qDWw8359mnmwlgp/KpUWAKCWaGtUkcGdOxZ4IaLKgJfhVSOJWSuOn
	RuP+9burJF2T2P5uBOtnbBEFrkxQSn30DPuA==
X-Received: by 2002:a17:906:f586:b0:c2d:c8be:4e71 with SMTP id a640c23a62f3a-c2e6ed46571mr421857166b.19.1791134192089;
        Sun, 04 Oct 2026 10:16:32 -0700 (PDT)
Received: from Desktop (pd9513667.dip0.t-ipconnect.de. [217.81.54.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e4cf9ddbesm317345166b.69.2026.10.04.10.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:16:31 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: kadlec@netfilter.org,
	fw@strlen.de,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	geldot@protonmail.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH nf-next v2 3/4] netfilter: nft_flow_offload: offload a TCP flow that has no reply
Date: Sun,  4 Oct 2026 19:16:27 +0200
Message-ID: <20261004171628.3544978-4-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261004171628.3544978-1-julius@bairaktaris.de>
References: <20261004171628.3544978-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gary Dotzler <geldot@protonmail.com>

A TCP connection picked up without a reply is not assured, so it is not
offloaded. Offload it in the original direction; if a reply arrives and
the connection becomes assured, the reply direction follows.

When such a flow leaves the flowtable, cap the conntrack timeout at
UNACK, as nf_conntrack_tcp_packet() does without a reply.

Signed-off-by: Gary Dotzler <geldot@protonmail.com>
Assisted-by: Claude:claude-opus-5
Co-developed-by: Julius Bairaktaris <julius@bairaktaris.de>
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
With nf_conntrack_tcp_timeout_established=7440, an idle unreplied flow
that aged out of the flowtable had 7390 s left without the cap and
250 s with it (3 runs each, virtme-ng).

 include/net/netfilter/nf_conntrack_l4proto.h | 9 +++++++++
 net/netfilter/nf_flow_table_core.c           | 5 +++++
 net/netfilter/nft_flow_offload.c             | 6 ++++--
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index fde2427ceb8f..c251ee862bb6 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -208,6 +208,15 @@ static inline bool nf_conntrack_tcp_established(const struct nf_conn *ct)
 	return ct->proto.tcp.state == TCP_CONNTRACK_ESTABLISHED &&
 	       test_bit(IPS_ASSURED_BIT, &ct->status);
 }
+
+/* Picked up mid-stream, no reply seen yet. Caller must check
+ * nf_ct_protonum(ct) is IPPROTO_TCP.
+ */
+static inline bool nf_conntrack_tcp_unreplied(const struct nf_conn *ct)
+{
+	return ct->proto.tcp.state == TCP_CONNTRACK_ESTABLISHED &&
+	       !test_bit(IPS_SEEN_REPLY_BIT, &ct->status);
+}
 #endif
 
 #ifdef CONFIG_NF_CT_PROTO_SCTP
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 03241d4bfd5e..2f2a6ecc9195 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -224,6 +224,11 @@ static void flow_offload_fixup_ct(struct flow_offload *flow)
 			tcp_state = READ_ONCE(ct->proto.tcp.state);
 			flow_offload_fixup_tcp(ct, tcp_state);
 			timeout = READ_ONCE(tn->timeouts[tcp_state]);
+			if (nf_conntrack_tcp_unreplied(ct)) {
+				u32 unack = READ_ONCE(tn->timeouts[TCP_CONNTRACK_UNACK]);
+
+				timeout = min_t(s32, timeout, unack);
+			}
 			expired = nf_flow_has_expired(flow);
 		}
 		offload_timeout = READ_ONCE(tn->offload_timeout);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 32b4281038dd..b37590c3dac0 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -73,7 +73,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
 					  sizeof(_tcph), &_tcph);
 		if (unlikely(!tcph || tcph->fin || tcph->rst ||
-			     !nf_conntrack_tcp_established(ct)))
+			     (!nf_conntrack_tcp_established(ct) &&
+			      !nf_conntrack_tcp_unreplied(ct))))
 			goto out;
 		break;
 	case IPPROTO_UDP:
@@ -117,7 +118,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (tcph)
 		flow_offload_ct_tcp(ct);
 
-	__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
+	if (!tcph || test_bit(IPS_ASSURED_BIT, &ct->status))
+		__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
 	ret = flow_offload_add(flowtable, flow);
 	if (ret < 0)
 		goto err_flow_add;
-- 
2.53.0

