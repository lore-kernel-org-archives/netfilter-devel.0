Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4805A4718E1
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134199; cv=none; b=SjDsCgRLqssLkjfDVZEEoMs5kiMVw5AMoeTrZxCM40yImD3yKGsSKB2H+pbI3aueDQAx/aM9r/yLqTmlmG106isoCyqHsSC25sf6JtmWLNYa4149Qy7CzuxHFX6X9gAY9aMhEp59cnclFg8TzbDDF3bffXJnpG3CfvfEBJwZY7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134199; c=relaxed/simple;
	bh=N2fEn5naZVynWAREy9aYIddLfbC9cTCqMP6evTuQQrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcVbdtlcu/HjonsPVD+g+tKFtpLNmOpusZAjer79/V4V6oPKtlSiKbIDXbb8TzonglwBpYLqQzS5LlV5BBk2chLPy3Q+/jLR+BfkMOb9LhGkSSvy/6+6CoK7902uTABMqixAiYJmTKEHNypFYwasfOXhyFgDicwZTQRRSc44th4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=gImvn9C/; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="gImvn9C/"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c2dc8cb0decso110975766b.2
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 10:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791134191; x=1791738991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7pciMmt6xvkKxAILLtPxurNk5XIP3aiXY2Q8mmcn43k=;
        b=gImvn9C/gR68omXOgmOhHwB+3WO9azBAH1Vach+nKQaIJvVRbIYvjOarZ4WLaT7S6Y
         TzIVwG6JwBYrb3MV5N4pb8MQxzeLsJASfqKYwOlbmRHjnmoXsVIqFujn1pa7eKo7ZaAb
         m/fVlaQwrJT5hncJVqNrYVw1yc3gSpqdks04MW2Mp/RD80UABCaGODDtnzKxdrVe5dZ2
         iEVIoXDKWuH+8HPnkYIGuk9Jsf5mhWLoAmDvFySxvE5OocbHZ6xLboBMxPZpzFIwuuWP
         /kmUn4bPKsMsX+A3kVAUK/5+B9bYgdnfOwK5VIZaf1HzvBze2UJfi+RvhQDFQuC/E1NF
         toxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134191; x=1791738991;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7pciMmt6xvkKxAILLtPxurNk5XIP3aiXY2Q8mmcn43k=;
        b=Q1KtZqsb6BokQ9ONlsLkrqq6W4GrPDeOXooNh7qFcSOPCMaRN74whXODBHoPcKfc5N
         4EaFjiB9exL4Od5OUCOWcBr23+ZLw458wxocCtAVlfPUTNCfTprqj19cafywGwCAURCw
         elgAXhyj4Wrh91r0E9i6E7HrJ0LxnVEKYNVk84b4dCP98ihwiGJllgqFQtnlNRkvfxJ0
         2OLJ9QdhdkpkoOxtoq7u0AuJl1oq0SxPDY2/vwPnzg9csfEKfOConQC/JYB6msEySNWl
         TW6V0vG0o64F4Hdlb3iZozpRQ+PGm7Bv4Q5jXMezyW6VJohgM9BzfeN1lkKiOjGvK92i
         GWhA==
X-Forwarded-Encrypted: i=1; AKwUvBygEa7gHwRFC4DbOZHmeizvm5aEFeAGvZ1qCebTDkEe/NN20zsuid0MhMlbys04tJ7JW+FsU1qkgIBlwby+/x0=@vger.kernel.org
X-Gm-Message-State: AFuF++n2ng4HOjcoPc8g0Ukx/akl4WLu5K6hdO17UgkCUe0Kzop07xQp
	RY8KfibkXLN4SFd0N2sW8TbkoNGzMl+KeXZk1LtZRgMZntDhraNeV9QFpX3Ofy5SSQ==
X-Gm-Gg: AYBFou3Q1Ow7FiOdaEri3VvjkDxXVdOku8C3EcxrvKyl3I/K3gqeZAyMegf3TFDjxof
	eKFFq+YbYJka4I+PECRajJo/i1XRrlYhXwUPwJ+3QPsYohXsUNZaWExPsaeuA4RKMybig8vVZEC
	9Qt7QW+SaWJAV0LVJwAmDXndBKQ0ED5LYxfmlGdVLOEcyKDun1lA7D8h2E5CEolrRVhQtbZzS4g
	NInWfKu7QVevFV6eZnM1n7pZ6yoJaJ/M+ier2NMNpLNrEqkf74GHlY/iqvfSC5NF0vS8hedbmNr
	Ezd8wN8hcIfCny/miSu6qFE2fy/9O+FG8SMIgcHq/twXqDIQQdCHGLzLaSg7k1gUjrt7ap0ebDD
	BDhAqHH3bS3xvwUc7DPtN8oFFF+LeWV8aaV2O52QTLhFlNCHQ1wM/UOv0Mp1ETaBTlJSRrN6Z3P
	lwrLq5njM6n/KcIjdqWkDSsxuGxRVcnNf2E/ZnuF5OU6D3qqGT5dTq8ncwz6v2eiz7DSmELIFrg
	Av8psMI7yK8Uj+e/WaO97potlmrqW7ydrNbqzwW26r/M1V3PTYfJeA3/itOd1sMUdTqRJdoACCP
	B90IMrxv/WWDMBjFq749DMxxb/xoyX1S1pl/4lfNOGL0bajR+CccROUDOOWKagrFTVnCbMxRsUZ
	iYKt8WLVpl74xsLL2S8r3/hD28aK41yVIFulyNb6yoUOdNhr5iXoVlS+AHCP/gJFGqPQH8LUzAs
	79jSQVTLV+8iLbSKNzXJ+PuHw=
X-Received: by 2002:a17:907:3f1f:b0:c2e:317e:d711 with SMTP id a640c23a62f3a-c2e6edf32b9mr428205766b.27.1791134191269;
        Sun, 04 Oct 2026 10:16:31 -0700 (PDT)
Received: from Desktop (pd9513667.dip0.t-ipconnect.de. [217.81.54.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e4cf9ddbesm317345166b.69.2026.10.04.10.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:16:30 -0700 (PDT)
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
Subject: [PATCH nf-next v2 2/4] netfilter: flowtable: promote a flow offloaded in one direction only
Date: Sun,  4 Oct 2026 19:16:26 +0200
Message-ID: <20261004171628.3544978-3-julius@bairaktaris.de>
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

The next patch offloads TCP flows without a reply in the original
direction only. Keep the reply direction of such a flow on the classic
path until the connection is assured, then offload it too, as act_ct
does for UDP. The XDP flowtable lookup does not return that reply tuple
either.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 net/netfilter/nf_flow_table_bpf.c |  4 ++++
 net/netfilter/nf_flow_table_ip.c  | 26 ++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/net/netfilter/nf_flow_table_bpf.c b/net/netfilter/nf_flow_table_bpf.c
index cbd5b97a6329..7070bc600db1 100644
--- a/net/netfilter/nf_flow_table_bpf.c
+++ b/net/netfilter/nf_flow_table_bpf.c
@@ -50,6 +50,10 @@ bpf_xdp_flow_tuple_lookup(struct net_device *dev,
 
 	nf_flow = container_of(tuplehash, struct flow_offload,
 			       tuplehash[tuplehash->tuple.dir]);
+	if (tuplehash->tuple.dir == FLOW_OFFLOAD_DIR_REPLY &&
+	    !test_bit(NF_FLOW_HW_BIDIRECTIONAL, &nf_flow->flags))
+		return ERR_PTR(-ENOENT);
+
 	flow_offload_refresh(nf_flow_table, nf_flow, false);
 
 	return tuplehash;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index c8c29a9a1684..289fe6c9e4f5 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -465,6 +465,26 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 	return flow_offload_lookup(flow_table, &tuple);
 }
 
+/* The reply direction of a flow offloaded in one direction only stays on the
+ * classic path so that conntrack sees it. Once the connection is assured, that
+ * direction is offloaded too.
+ */
+static bool nf_flow_reply_unoffloaded(struct nf_flowtable *flow_table,
+				      struct flow_offload *flow,
+				      enum flow_offload_tuple_dir dir)
+{
+	if (dir != FLOW_OFFLOAD_DIR_REPLY ||
+	    test_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags))
+		return false;
+
+	if (test_bit(IPS_ASSURED_BIT, &flow->ct->status)) {
+		set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
+		flow_offload_refresh(flow_table, flow, true);
+	}
+
+	return true;
+}
+
 static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 				   struct nf_flowtable *flow_table,
 				   struct flow_offload_tuple_rhash *tuplehash,
@@ -478,6 +498,9 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
+	if (nf_flow_reply_unoffloaded(flow_table, flow, dir))
+		return 0;
+
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
 	if (flow->tuplehash[!dir].tuple.tun_num)
 		mtu -= sizeof(*iph);
@@ -1074,6 +1097,9 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
+	if (nf_flow_reply_unoffloaded(flow_table, flow, dir))
+		return 0;
+
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
 	if (flow->tuplehash[!dir].tuple.tun_num)
 		mtu -= sizeof(*ip6h);
-- 
2.53.0

