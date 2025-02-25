Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAED213E68;
	Tue, 25 Feb 2025 20:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514597; cv=none; b=lyYlpev+u7jmiPxh2GF0lCgbzh/9e2yrCMyqqflAucYP9qhRiY1diZ/aDtR50/kBTqtGM5bZaKUuRLPgzQ5Tgx2GgngOv8+TtjZQN/poIP2+B7VnhMN25QONZCbi9lYist92l7Oa+TAAG1q2m8Hce3PH3r9Bw61lFNgvhGgOfu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514597; c=relaxed/simple;
	bh=p1IsKiAxwq12F2MM7ABxyO6mLj6RlYFe8Yg33MCLfXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+KLBfgMtpf2fKO0Jcu8xISHC0BZTF5M4LovO6i7i2sSX0MkS8ubrTOv/hh8p+OxMC0X5yB2vO/gJPZ6phHyClv+1dyEBwIWCEc6R+rSv4iAzvzMwGbS0F4ikDj9q7P0QGQzwtemeHEKh/nXJxi4YHQTF5YhroXnH+QUvamId24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hNxuQPhT; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hNxuQPhT"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aaf0f1adef8so365536966b.3;
        Tue, 25 Feb 2025 12:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740514594; x=1741119394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAJ1+kbz8lZ4YwPg+OV3VOfAm0Jd01XhEIX1QeYwh3U=;
        b=hNxuQPhTriJvA6L3DNkP/R366SqsUBBakZc26kJzoAqDPhqP4iaV/PRQbm2+OrEM60
         tWwZ2sf9wGW3hLboM24/fakDotXaqjZplR7KX8Y8rrLHGsaBzqo4wmP+29p3KoKbgI/l
         jOALh1gQNEWpXc/Vb9rsqkY+IDd7pl9JGBrDH+opgHpSjyMnvplGpChLTrsX44M0jgx1
         M1ZJ0hj2nB7uc4O4bMTJLuD9s4OGlMHQEC4Y673IM4iAfDo+sjn4I1ELV5PC6VGojZ2l
         LxmEbeugOMMdXlibjXZeEFj3io7CMk7oIdiiaAhAApLONuqGjfbNr2MxLv0v1J2z3r8/
         hXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740514594; x=1741119394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MAJ1+kbz8lZ4YwPg+OV3VOfAm0Jd01XhEIX1QeYwh3U=;
        b=I+Hde2Wml+2j65AM88IIinalyrTDwuvWrYqPscL4vfCNkC65CwqVu+AUe/FymdSCVH
         v843EJnADkVnj13IURMzDsw8ZjQ/pqmgadBDA4Fmd92QZ+GJJgxBHdRbJ4MCj/TtC/iM
         uKmpprj/jEDgCxvUsSwoS2f3iDT1iWVW4tUkrtNaotUzy61ilaMrurWB9etxavsHTnvb
         h2yUpNrTNTYDbiKztT1gsAc564GwFVnBzZuRKTa2B00Ij39MaxsnzfdJUpxRh3/sUy/g
         ENX8rCsZJG39iStI1nZNcvcH2GLNUIdJav7LICyVg3ZcQ5gFoIJE2Stxx1++JtuIDKCn
         wt6w==
X-Forwarded-Encrypted: i=1; AJvYcCWIbfZeztauBN7xqf8Blu+HODKhLXjXkLx2fNe1l4hZSYNKk8GTOl0HC/uFbmVZx+WVIsqd+myW9AE4z9lCChYU@vger.kernel.org, AJvYcCX1ypRzkQYuzJU2GnrOQH7ZeEpyBKrg0LsROnA+jhkAbh1fVExGPImDs4rNwCh7v5N3QlgFSQLtkQoRNfc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGsSbIUtKXmPCr/P1uDq4hEqwjhKcT/rKShWFSiaj/qkJmBWFm
	Zsj9JXqraOb9HClm7jIwl87M3JqTKawYW+wA2ugC6dHUthuQL0/d
X-Gm-Gg: ASbGncu3SrckbpBw3nC/BsRrlmP/rFQkwwyF81TJwdibdk2KB26AJo4/notTtVWfyxq
	mji253q6gTdCJh2nUw55Vfe44m/gNyP1Ot378Az9C7fMl3tKifm/5uPDK+wrgKL6aE8SSL9vTh4
	PqwXj8CGZExusTtCVjUzDNfsPqKxHU1JSNtr5nkPc4inn2VgSKmr5eJz1jQ/ujsfwJ1him19vJP
	SpnmaeMBONh7v2VbDQ5Q92rAj/KtIc7jPSlMbzN1WNueq1OzjXMn6xYexEAkzCJ3M50QRmW+Pqz
	3gZj6x4DXN68m/SpYFYt2MyPeUmLe/N/wc2AUg93xNsTcmALxeIzU8E2i14ZkHax+/FKa67KbwV
	wmKYP5EZ2aLnCjbdy9jNvfRkVy6eo8pYVCoQLOcA5T/8=
X-Google-Smtp-Source: AGHT+IEwV1DfGXJRPjYjfUai9IFb7gVR/sM912MZVVj4qwykjTK4A5haj0vlM9CKbuHOZqsSxaDDSQ==
X-Received: by 2002:a17:906:3181:b0:abe:ea93:2ca3 with SMTP id a640c23a62f3a-abeeedfd836mr54526066b.29.1740514593664;
        Tue, 25 Feb 2025 12:16:33 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed201218fsm194319666b.104.2025.02.25.12.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 12:16:33 -0800 (PST)
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
Subject: [PATCH v7 net-next 07/14] netfilter :nf_flow_table_offload: Add nf_flow_rule_bridge()
Date: Tue, 25 Feb 2025 21:16:09 +0100
Message-ID: <20250225201616.21114-8-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250225201616.21114-1-ericwouds@gmail.com>
References: <20250225201616.21114-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add nf_flow_rule_bridge().

It only calls the common rule and adds the redirect.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
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

