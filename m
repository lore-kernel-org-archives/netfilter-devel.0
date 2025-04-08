Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7BE1E1A3F;
	Tue,  8 Apr 2025 14:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122549; cv=none; b=fyIep0Q9qD7ppa5oAy5WK/hfY2PHVT/JKgU7DYZ0N2op3AhI1TsPauyZKlNV7II4FOQQc/eql/9t8H3HpxqPGqerWzCYfMK46UAPqVGn7GNhqshEMIlixxXAvJiMYBdNaE0n8I45VZIDq1qwsrzlaJDxytcr6uHEQJHP7uLAiTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122549; c=relaxed/simple;
	bh=EZJG11e4pWpqrTF5AUNg7CFYWOk3WqLPNIo7rSIH9ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJZ+JCfZRNVbJNEhAk8xghqXeeSf98Cz9f+wBhWuUwbEqdFozsL0MFpoItQyWH7Zyc/ih3fSq2QrsaEEm+iA2Pw4L73a1MV6548HYp65p+Xhuh7MeX4bC/K4/CSyE0zxykM5TuOC2CbINIMJFtaGcdOcGx8zaqzPOtJ/QATE/Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cHSHiPdd; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cHSHiPdd"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5ed43460d6bso8737987a12.0;
        Tue, 08 Apr 2025 07:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122546; x=1744727346; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SMox0MpwPKygAR/vnpy2GVz1YAIGJ060oJ50J1k9QBo=;
        b=cHSHiPdd6W8uREM69DzrDthQ+1aEQExgPJIjTIoAfL9shX7O4t7K6nMmW1VbWSBO66
         GwqzsT1RQo7LaY7GWqIrqJe7fqc1ecFAfnMPaYRYM/ubDvv9QMt6LAaqPeKgZcCfqT2b
         HbDcWTXGmuCKctodo7QXjPfc+1YpuimkbckZmhPWKs+keaadwXN+2eGO+UQ6RdtqxSQw
         eXHCHso5csaFwS1PTRgB0Q61/UGxTI2KIqvo+n4BszACuKkPZBD9uZ3Lb7VnbCIDPYKO
         BWfnEXPk3+QkzLx0T9t0Cqt6YO9us9p0/r7f32I5CJY7K1B/40LviMZQvwBVfa0sLPBh
         /1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122546; x=1744727346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SMox0MpwPKygAR/vnpy2GVz1YAIGJ060oJ50J1k9QBo=;
        b=IlptyyJpG0VEVOmS/kTxHdj6Ib+npiAo3myR8uuJLJR9HWaZrlmznVNMhkHGptB0aR
         FK4HvJ3F2bANKlTnR1EkhrxJnDfVOSAo0AmI1NVuN89RoxCBUqHi+FP0oXl7coiEzWQq
         m3enNi/RDYE9BZMjr7YT5d/zWUNjihJm0dhhT7vMSbj8PF4wnaP4sNaDapC8x3ReBP+q
         Kf9EnUnzXU0CIoyG3YOZiyL1GBnrpcqjudGAT8cO3W8tV/Jp4LPTrlHoAEl9iLFCsQ3V
         4rMskNR8dDfwr+5hlbQ7WIwhrUuK9qyy8Q3j1jl6ESX1s4SmAg9JhroTZobQARlqHdUD
         EiEA==
X-Forwarded-Encrypted: i=1; AJvYcCWPE4QCGoaFZsLBsBlrgf+tRYqW5xMfCBwlXO9HNudPl5hzjmCbd9uS+3mHVKmTtqHEToHC3VY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnmQQWVYNnJQoi3nF+eWw+kxbPNTD3CrlQj4qPYDt0qaqGydp4
	ER5lKLlavU/vaTyVMAdGMbqvb0zRZe2LwOuIsYa3oTxQZNQYc7mM
X-Gm-Gg: ASbGncsc0vQHS9ReuZ4+h42al7GRkJz8jsXpBIUo19KlqnuHSRoeFyHBkylqUAnrBwz
	5ASdc3UK3aP5meUhzpIuPpjDEvvm6raWs+kMKOioy5YxfiqzpKhmuKRDyBNWiMAlTLNAGYoV/YH
	n0J/GpnLB5wKb2a99Cp02big0K62V65HojdHGxb4b4hg8DqX0Kkq3aF51HpDb8dhHL/MS4C8n+r
	lQ244iSnFibqWguRdU7hPoCK9UkgwKj4Gjrc7q1TIkB0ftxYeUM7IBdhadzmsWEKruRvLwK1qOQ
	0KDsXXyjM9MA49C8vISvN5MqdzUG0A6PdOmzlTn+R6pzbUpm7LfaOnFC5awQzyyfTAHq3v+g3YU
	fgxZpai6E1pB/JRZDaZ9yw9/40sYllcA6+6hsQR6x7o30DyQ/oOy0lLzt7Q3hx1o=
X-Google-Smtp-Source: AGHT+IFiFXOEqtgluqyzIi/WCknfqKS4o7jSNlmNKIOd8sHqcoYOQXUTzezC2L6Lby3z0XIO3JmYpw==
X-Received: by 2002:a17:907:3e0f:b0:ac7:b621:7635 with SMTP id a640c23a62f3a-ac7d6d8f3d7mr1635065966b.36.1744122545582;
        Tue, 08 Apr 2025 07:29:05 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c01c2c13sm910586466b.182.2025.04.08.07.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:29:04 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v2 nf-next 3/3] netfilter: nf_flow_table_ip: don't follow fastpath when marked teardown
Date: Tue,  8 Apr 2025 16:28:48 +0200
Message-ID: <20250408142848.96281-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250408142848.96281-1-ericwouds@gmail.com>
References: <20250408142848.96281-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a flow is marked for teardown, because the destination is not valid
any more, the software fastpath may still be in effect and traffic is
still send to the wrong destination. Change the ip/ipv6 hooks to not use
the software fastpath for a flow that is marked to be teared down and let
the packet continue along the normal path.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nf_flow_table_ip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 64a12b9668e7..f9bf2b466ca8 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -542,6 +542,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
+	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags))
+		return NF_ACCEPT;
+
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
@@ -838,6 +841,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
+	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags))
+		return NF_ACCEPT;
+
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
-- 
2.47.1

