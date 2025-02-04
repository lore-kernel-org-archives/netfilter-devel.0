Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC04521C18C;
	Tue,  4 Feb 2025 19:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698603; cv=none; b=bBfhDFr56RddUmdavRgNm+g3blSDPqCKieFA9qAngduBPChLFQys9pBxmVosyFsFgRj3Uast5tI0grfH/lSLaIw9XXhBfM+3+hva0XsvuStlElXAuZL2tNEAuP/uWMzfIl3XrD4b0xM3bgtLKsDreMGUCnO72RUK76QqamsNOAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698603; c=relaxed/simple;
	bh=o5uKTl7le41zF9aDebFQ5O7fq0HuDrigyuv2o5ox/jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crVL9NZwKeTHT+g0jQMtRcUpOHhMx2c5SuCeYdbBnb7bbBh11g8gwBXgRo9kmtUlFnVInOhRxwHEB34YtDlz7xEeFz/quRVPeJksn0FEC54/sLvgOpV2c4XGB0jCI9PdSJfOOs3GhvCTTeDFy+y4gDwMvzNiIJtAeIYNT3f9hpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DwIzHFrs; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DwIzHFrs"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aafc9d75f8bso1195056166b.2;
        Tue, 04 Feb 2025 11:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738698600; x=1739303400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8xE+ROyc/mcQ2fBT7crVscR/jU0rSEqZAJgDthtdCdc=;
        b=DwIzHFrsguT0XdoB8Rc+3eWY7IzqaacemW4Jk0cEPLnEQ0pWMfpXgT0AaQOOXR5X0w
         lJgFMe3qJwwTUvx/GeRpLontw5Sq/eemkbFizZq2DIJmfmp68VFLyYow/i3B35VzEiUx
         75u+34S+/KDUakgPSpNtb+ElSFViokpd9yTEeZXrxnnrdT+zAHhunUkME+zIm6T739nZ
         o72HiTc+iTZ3BH/YxWJnMdyl/ts2NUOLcuTHlhNMEzGx1OrPo91B/aykdD9Pgi6WcyGo
         uuBcmntLtAF5rJeojktKMcwsB6WL0O8QZpKDIW8/mM79f/M1ub9BpGS5pp3ANaH4ZmuW
         JEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698600; x=1739303400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8xE+ROyc/mcQ2fBT7crVscR/jU0rSEqZAJgDthtdCdc=;
        b=s1MkU2BK1l+ZmUEgKgzsbwrTUjirgng2lUJxEOyR97tsXGLlfOipqK6z3/tozEpFpZ
         pBh3iV1xuAMRloqWNrU70iILae7odJmUC42YNvacAf7mtHl4HsO9UbqlHPTGywBrBJZ3
         fIL8HI+KyHLAkL54cQT34Oi8wEjTsyN/Y0L3T0Q/Y2WFwxkTG5aTkTcXrfUvQzq1kk7k
         1x0qlfxLWhuj+C0+BgRx9ZS5Dzcl/RYSUk2OyrpPIV0e+i5iqQ0JzGpNl9LK3LpagY/g
         hVtQir9O4yDLSQdLIO2mgy2MS2s7V5MsKlvDPg7cq62JGtBOK+jn4PiPPKIj06PGESvI
         C0Xg==
X-Forwarded-Encrypted: i=1; AJvYcCUbghfPBmj5DyUu9uOtrtzQyQmiIOONd3/1OU16bojqANh5gXep3AIlKg73DJEQdy/MhmI3iu0/XwWRhgfDGuvU@vger.kernel.org, AJvYcCUozsNaYg+ytc/ni8KNzWWf+5pqO8pYU6c81wPy2gQqIwoIubjqOI2EqbLlj6h6E61c0fUbxzcRF4oFkU4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu1ag6uZaXXSZTxAYF47ZD38f+khTUDHz11reunJrLHHA25Eyj
	xcsnf7b4BHjeIlzWsYcoaWm/QDN9r8wWikZpzlM/D+OotuLQGwM+
X-Gm-Gg: ASbGnctdx8WKmIfZA1l+ykoz3Wpk/loyc/fUW4CbSw999A0kzX3aGvJXPP1BKV4UqXn
	9fRFM7KD98t4lUWJ+fz9jqnWObd1iNW5FqrYcSyNA1ckJhTrET5L7jOMFcTkvP5HJpTX4BfGxge
	n/soXvQXIM3HAPr0m2YDDSgFldUudyO7Dl2gjN1HTk4bx1TmBysA8YCDM+kH9e+KdCyC3urYjWV
	pOT+5X7iPX0eR+VYYRBghccrsyOEAgymC7Aa+1Tpe323pp19Q1vw6R6bfXFrzhxjzba3bbrmwQp
	60VQMjOZM9syXPauJXviHJjAwfRd7OkpgYfK6ELXNAvb1S80Z2nadSE6gz4nhSYlEh9GFgQkAsz
	v71OV8gNyzQdQ4cGLsTHA2w+t83bMM4sZ
X-Google-Smtp-Source: AGHT+IGHC1MVQan6DyAcHVPJFsYpMQ/lz7RSHxdEh7BdqhTUwrDVwvLIusKNv2NoZZcDS32oCD5V0A==
X-Received: by 2002:a17:907:3d8d:b0:aa6:9503:aa73 with SMTP id a640c23a62f3a-ab6cfdc5f5cmr3418392666b.51.1738698599948;
        Tue, 04 Feb 2025 11:49:59 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a5635bsm964684466b.164.2025.02.04.11.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:49:59 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v5 net-next 07/14] netfilter :nf_flow_table_offload: Add nf_flow_rule_bridge()
Date: Tue,  4 Feb 2025 20:49:14 +0100
Message-ID: <20250204194921.46692-8-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250204194921.46692-1-ericwouds@gmail.com>
References: <20250204194921.46692-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add nf_flow_rule_bridge().

It only calls the common rule and adds the redirect.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/net/netfilter/nf_flow_table.h |  3 +++
 net/netfilter/nf_flow_table_offload.c | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 4ab32fb61865..a7f5d6166088 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -340,6 +340,9 @@ void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
 				enum flow_block_command cmd);
+int nf_flow_rule_bridge(struct net *net, struct flow_offload *flow,
+			enum flow_offload_tuple_dir dir,
+			struct nf_flow_rule *flow_rule);
 int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index d8f7bfd60ac6..3cc30ebfa6ff 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -679,6 +679,19 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 	return 0;
 }
 
+int nf_flow_rule_bridge(struct net *net, struct flow_offload *flow,
+			enum flow_offload_tuple_dir dir,
+			struct nf_flow_rule *flow_rule)
+{
+	if (nf_flow_rule_route_common(net, flow, dir, flow_rule) < 0)
+		return -1;
+
+	flow_offload_redirect(net, flow, dir, flow_rule);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_flow_rule_bridge);
+
 int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule)
-- 
2.47.1

