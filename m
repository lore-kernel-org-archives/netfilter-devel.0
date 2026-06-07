Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB892580E1
	for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2026 16:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780850705; cv=none; b=TZXS7FsfpULpJS65EjnCU9Msk3RTF7ByHMTq1ywvIvWc1ap29nkyGmADfSP3fcQigB9zkv0XMR6TpznlYb6xwHQJ1udTaynt3YyoMWs9nQgUC1yKtAd/gJ9Ldep6sJUgHqW5bchrcEep+2s5U071STvlyaq4Fl8CWVP7LsFt8vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780850705; c=relaxed/simple;
	bh=kcY0A0ZCZkSIBoy0QINHGFg4/K+Rysr1zHdY+wr2gYc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fDAhJz6Nzw+iXm0zIgC1lwgYjoPsGIaZEJKg0Jt5Nt1Z5f753cC/B1kpXgPOSeHgEf9QnIJBc5xXnHdBx58jTg1Z0LJ8Oic1aERA+bL8wPw62GwsXb2py6Ap+VDWdHKNXXfDwR1OzEbU9YU9ZTatkX9Kyksp2VUpmqhD140exwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bvIYkBYy; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bvIYkBYy"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2c0c1e0b0faso23959955ad.0
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jun 2026 09:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780850702; x=1781455502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1Uu7Azb1TRudnvaVj8+H6IwLowhewkHpcM86CR0fcYo=;
        b=bvIYkBYyUDc5GFIE55mv4LvDio7I1p1cwi53yRGr3oK9iXc/hafLFIo2OECjbOtw88
         169c0HQDYRaDncmKikez8rZvsHZHpllxtupGJMHu+N4KIwFlASKqtFmM98BOJzMrnMOL
         1Wmu6LEc5oGWhq/j+nKzrQ7RoypFzbJ2ywlEp9W4qnBbe3cpkuxCH6dotUdY3BhlCGsn
         rmYyqiZKvOvBg8w4Z1TMjpQGjIGvDE7dFKtgSQtlpvAR2q3kcwxZx+9m47YblY72Vomn
         BRcOZGxJGdj7u2bPDo8paSzWf+WXtuWf/BJLKE5FeHxZIZUZG8OZ4opcqsVq840ic2mu
         20dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780850702; x=1781455502;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Uu7Azb1TRudnvaVj8+H6IwLowhewkHpcM86CR0fcYo=;
        b=NsfpjP8NNeW3Y68Iudv/TWU+XuvHPDaU+G2WtInOiBLRSpOguo7t8Njc8AkwY+ATkC
         8Tz+2VES/LAfOXrceQV1PWLogvgqmM6QA6jxqOmEQDglXOGEQdLz4DjzLogGm5/6MmtJ
         nKE2dVbXRp26kNliiN+9Br+GVOBFI9vloPEbv4BbZNYfrJGQYqXhwsp5uQRmL6cXW0p5
         BmzYzMmlxluBgpw6ws3aytZMBaZH3q34lTQYfgfQE47jivf5TViHEetDBDWcxuzY17Cj
         4TlGIR7z246Z1Z+8zAvhlE1FqoEcEQCbYEIQMzscojTv0lCU27buZRt4BPTXMhIOSjGQ
         rs8A==
X-Gm-Message-State: AOJu0YzkA2Ue8esFtqhaldXvAKEIyIkrTMeFl7+2ysPNX1P4HqbGVQxL
	qtkRpWqiIs37mf3zguq5gyxIYbvXySmkpqpptzVUt41oZ7fNGKfdZdMuMFmcng==
X-Gm-Gg: Acq92OFULvvITltc2M7Ht3eBPKlydWCflMM8Gi5DJoQfINOq9uhepAZdc8apw5d4FGH
	rMmKcW1fNFs4tRvuOoUAoMtE4x2Jr7kRD3dlwaTTlJKA52CJe7hGgsgmBWN0yaMDyOfJW9RTiWk
	0EQnOHXsN90snF0qlCGfSJR6z8bgrssT02A+Eufq2lKAEW7HjFK0WktX+sOxdoDOeJI1K8fSJKI
	/a/6tr8Y7hJ5dl02GnCGSnpUXqgSwIQIS0t/06Re5Uo3pTGhig9MOc61aSwcHbge/knvGHMxoti
	qAa/UbyOmiAqP7DzOcthJ+w7wdddVj0ezI5tALGoxgcu4aoSGCn9sVVYY4hlQIWOdoMZlJZj9z2
	yLcW7c2VQ0hBdc8W05RcHxnmOqc3hY3EVfwqQFRoZ8pU+krDtsEvp/UqJ+kPlZdN4mb7G6NKdDZ
	nWB8nAg6oUbZdYvsVynW9XHpLAm2YBfNgCB2Wy4Y1rL+124e991FKjw8uKX1T3PGi6VRBE2j0I7
	ALZtpExtJu7HBuXtvgx6AfCAGivM+Uqg3wp3u4YUhKoww==
X-Received: by 2002:a17:903:28e:b0:2c2:5446:30e8 with SMTP id d9443c01a7336-2c254463524mr28709825ad.18.1780850702257;
        Sun, 07 Jun 2026 09:45:02 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f9f358sm152466765ad.30.2026.06.07.09.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 09:45:01 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	coreteam@netfilter.org (open list:NETFILTER),
	netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] netfilter: synproxy: fix unaligned access to TCP timestamp option
Date: Sun,  7 Jun 2026 09:44:47 -0700
Message-ID: <20260607164447.39700-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

synproxy_tstamp_adjust() reads and writes the TSval and TSecr fields of
the TCP Timestamp option via direct __be32 pointer dereferences. These
fields are at byte offsets 2 and 6 within the option, which are only
2-byte aligned — not 4-byte aligned for __be32 access.

Replace with get_unaligned_be32() / put_unaligned_be32() to safely
handle the unaligned access on strict-alignment architectures.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 net/netfilter/nf_synproxy_core.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index ed00114f65f3..0a038b9b5169 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -191,7 +191,7 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 		       const struct nf_conn_synproxy *synproxy)
 {
 	unsigned int optoff, optend;
-	__be32 *ptr, old;
+	__be32 old;
 
 	if (synproxy->tsoff == 0)
 		return 1;
@@ -221,18 +221,22 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 			if (op[0] == TCPOPT_TIMESTAMP &&
 			    op[1] == TCPOLEN_TIMESTAMP) {
 				if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
-					ptr = (__be32 *)&op[2];
-					old = *ptr;
-					*ptr = htonl(ntohl(*ptr) -
-						     synproxy->tsoff);
+					u32 tsval = get_unaligned_be32(&op[2]);
+					u32 new_tsval = tsval - synproxy->tsoff;
+
+					old = cpu_to_be32(tsval);
+					put_unaligned_be32(new_tsval, &op[2]);
+					inet_proto_csum_replace4(&th->check, skb,
+								 old, cpu_to_be32(new_tsval), false);
 				} else {
-					ptr = (__be32 *)&op[6];
-					old = *ptr;
-					*ptr = htonl(ntohl(*ptr) +
-						     synproxy->tsoff);
+					u32 tsecr = get_unaligned_be32(&op[6]);
+					u32 new_tsecr = tsecr + synproxy->tsoff;
+
+					old = cpu_to_be32(tsecr);
+					put_unaligned_be32(new_tsecr, &op[6]);
+					inet_proto_csum_replace4(&th->check, skb,
+								 old, cpu_to_be32(new_tsecr), false);
 				}
-				inet_proto_csum_replace4(&th->check, skb,
-							 old, *ptr, false);
 				return 1;
 			}
 			optoff += op[1];
-- 
2.54.0

