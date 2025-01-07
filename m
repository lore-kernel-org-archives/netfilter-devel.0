Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C49D1E493F;
	Tue,  7 Jan 2025 09:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736240773; cv=none; b=P0NXeIiRYsZ3r3txgVhNcKV/kANSt8/LqRVrYwSIrtY2VgOOinHMWsq4tWiiW/KDahVgDjQVSHg/cEufjCtKSF4JkgE+WqMkBU8FQTZ4kZZDPgJA1PtlibijB7uwC4qI2fujJIG/UGuxF4zOwzcXgmtiB8FNH1+7udw5wl3OkQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736240773; c=relaxed/simple;
	bh=BvqBAh9vpYpaQZe3zOQxhCXX2RDxLCUEfBQIamImBGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4y6EfGNST7EP+SC1qk8iBs2j5EeOjHz2kxye/8ZwXulPXtoH+JJsTtZ5ZpvRK4UAvAtSRMseJq+WvJAaJ1OHnhMEipR6OhgOsFKId5PtOmMn+1TeDiB2IHPukpfFY6Cfy0DPMQiO9s4PymMsbnXEpeR0TrUFy9EsAGyB0Eekqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HVnxlqHu; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HVnxlqHu"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d3dce16a3dso27117885a12.1;
        Tue, 07 Jan 2025 01:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736240770; x=1736845570; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0IPV+/btLneRoSo5HiyXyxa4AsB3fEttv56AKWcCbic=;
        b=HVnxlqHuYatQR2U8JSU66TbGh250Wo3H4JJI0BnjKKVC7yWKR38rwNW6Mc8NqOso3+
         hKs0CzEGfcwL7nLV9z1PGO6rJpBAmgEtQA/R05IL1BG3Rve0SNQRXpLlkw4js8REFa3T
         5ol2kfuLGg3m0ci1cH3B8c9CWIAUTR0tir08F1GFWMby6TZp751M0O+UsdReGR8zet8V
         fxtmM+INviAwGzWFxleNT4uvRb6MGo9w0++ibQPqzFEyW2HPyLD0TmBI2e9TmcKXvaGS
         gm2WfoezaFMkjG6dtTm3zkaICbfWLZQc51KC2GPgPr9YY8oyhzcLNhYUxeDRf78F8O2b
         ZKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736240770; x=1736845570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0IPV+/btLneRoSo5HiyXyxa4AsB3fEttv56AKWcCbic=;
        b=pHROv9CDe+bzBjzplW9UmOzLgxMdgnmYt2FAwPgR+zo/3sTNd9bkmm1F3dX2suEWZu
         CGtDs+EQurOYe8YeN2fo2BgsbOW/PWTs+7IXTIS0BBFIywNtqZjS9yScKV2J8Vy0IOB/
         FcnS1CBazX/Rd/whsJk+eGtppbQhIIMiTCD9yDG+FK/Z9eM+pSmr/bJxzzqP5s/hujW3
         c0pNmIN3ssFNvRabnU/HfQwLvQoEvOAWK9nQl72p5Qg76jM5y4ucYXHJ/xefn1IESD2l
         xZxvQTQsSRMYXucz2IQC4UoI8AY776TGIZMJSH4bxnBeoQ/aRtoVQBWn/0ftg5hMeGlK
         Sw+A==
X-Forwarded-Encrypted: i=1; AJvYcCU/902lzqKhFxTR7/CB5QJmQ8nKFIiKrq3tGJ9Z06CeOATsgQFltrwT4i4g7T3XO8dHxFv5ujdLjWa67En1y/9+@vger.kernel.org, AJvYcCW59c5xM40XVKQflqWzCZS/9eu19vQLrtV/tnnBqt6rGv7e5Cxmi74acuh4oHQnxDhfx0wXT0sZKBKbJC4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZbQuXfVJ3Y1y+lCy4k67FH+OLs4QK3u5cUVbQQKxkIKPgH/7I
	Ct6hbDSBEnEtcAG7rDWoCpxtx7c/hP4gHL91EOjDRw33cd1kJ5H6
X-Gm-Gg: ASbGncsoHbKw7sazdyvGnzqCsoxUGRWLtyD5YHYLR1CUrAxaPaDSsecni2mvgyetpJC
	++wdNIrlczhLIRUpeyaC3RHmbiumS6nkf009xVcHi0ID7ps5tRFlXj8obL6wxpN++GfA0PTM6bI
	beg/Wu9i/0kt12Ckk/TjVvZTs1Kf1tSxpVk2+yGPYkszw5KZEJqwoZeDHKFwb7vLtgwLzviVWSc
	nyYl4AOzxT0ZQhXt3awjZdjH63Cs60rrOhnUVumOMlPP85Wwb5nNlOQkf3twPnwo58RbzgC2DYx
	/mtAsinDiz8jLTgVpuKZJZyEeWELui8zjgfhR/wn1xBid10U/u4EVMcqoF+a19jRlj19VM80Lg=
	=
X-Google-Smtp-Source: AGHT+IGuwqZCeoYTDAlGotcMA4hMjnDwkRNwCsaQvYcPeOTdVvTuTBvdK5LwWWAVBu+HrkBFOHXWUg==
X-Received: by 2002:a05:6402:26d1:b0:5d3:e9fd:9a16 with SMTP id 4fb4d7f45d1cf-5d95e916b32mr1930324a12.12.1736240769741;
        Tue, 07 Jan 2025 01:06:09 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80676f3f9sm24005333a12.23.2025.01.07.01.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 01:06:09 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	David Ahern <dsahern@kernel.org>,
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
Subject: [PATCH v4 net-next 06/13] netfilter :nf_flow_table_offload: Add nf_flow_rule_bridge()
Date: Tue,  7 Jan 2025 10:05:23 +0100
Message-ID: <20250107090530.5035-7-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250107090530.5035-1-ericwouds@gmail.com>
References: <20250107090530.5035-1-ericwouds@gmail.com>
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
index b63d53bb9dd6..568019a3898a 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -341,6 +341,9 @@ void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
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
index e06bc36f49fe..5543ce03a196 100644
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

