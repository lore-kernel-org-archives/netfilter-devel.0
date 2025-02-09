Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885771B87E8;
	Sun,  9 Feb 2025 11:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739099458; cv=none; b=cOeoqe7mE/jNWA6kRR9Vupgw2ZCqk9qEkx+8d2Wa5r9I4J8Oq3oslOVxD2dY7NJ/ZLVGLOioMDQHHxmauTxyi9RnTY2y5HEIJCqFQ5lIBcnQpOqgKKOl0wEnw+xsnze+sQnZ5Ibcom1N1ZeoFCgqcpR+vooZNQVoeGDE+deMUgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739099458; c=relaxed/simple;
	bh=p1IsKiAxwq12F2MM7ABxyO6mLj6RlYFe8Yg33MCLfXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2Ldh9JpzRaz0rzfTt3GgrnA4K2elyvU9Xpm4dySUc9UyPmwKwLT6UMWJg299gVjKNO3ZhKtX9f5mT3U7JdWgLwi2GafFZX1hTjtwBpcNy92g5aYUNFkDdxC4ICbOuYcDTLKnw+B9MPxhlyqtHyb3Xved0ejU3Mp52VGFz9eGYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LPWJ5sPY; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LPWJ5sPY"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ab795eba976so272539066b.0;
        Sun, 09 Feb 2025 03:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739099455; x=1739704255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAJ1+kbz8lZ4YwPg+OV3VOfAm0Jd01XhEIX1QeYwh3U=;
        b=LPWJ5sPYeTE81tJtU0twoWqbA9tUcDLHeNd+JAIeaSt/FHzrKKFXj0Gi3YmMYlWhkq
         AliTo3QySQh37SlYhTKAOf9/2gKRlF1PsCXKl0UTlkL8qezyzQc6afRiTqidaF2UCYRQ
         XJzjqwHOnWzMQTpVqttugnv08b1n78paoUE6AeuSglcF8vfTITM5iUXCe7nQHHieYYkv
         mDDBxhme2mTeWmXRmYGRvDJqxfN3jqPmaJMJv83taM1xMtJxe2zXpjMiedxJU5rv1Pz/
         pRuCUybn+Ufii3JOATfmqnXamQh0A4bbd+RFWtqTfuDJmkxn15rk2XgmLVaPI6c1VIv/
         zeQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739099455; x=1739704255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MAJ1+kbz8lZ4YwPg+OV3VOfAm0Jd01XhEIX1QeYwh3U=;
        b=VQxhLv7Lk0TUm+fflT1Adny6IQbK7hejPY6MrscBXVQsBdamSo5ff+PWAfppzl0yAD
         SDNKjVW0gTmHB2brVdVbwarXvrnAB/DkhaLES64cabY0fEWOLSQcYOrl+C4osSWdKQN0
         GAyJWDRMgc7OgvV9NM38mH+A1PVX9LW2LkJLmoO75LvwgP8f8xxlDoDFBmhHdNfoNk26
         uKwi4uYPFOg1BPca+r+op0M/3p++2n+igKMVBp8Mrm4wZdGHc/BAonytz4X219oPYk5h
         EjAu+RpfN1t33HGwClIlkbwljZ+4PmHOhUCJGlyPpfbfjrpSmzSChh9Lrgv/WcYpSc4t
         NNCA==
X-Forwarded-Encrypted: i=1; AJvYcCV6Gabm0yaG5MPYgZBZwUegMg7M4pqy7JQxoqIZZLSqEE4PwGAYx3b+a+vlZyHuqWXSkNblw/0t1waZhvc=@vger.kernel.org, AJvYcCWFRSciFVX0aTI2Yi08HDzok0/CMn7JceIWN0Ku8g5U5SoApvB2mwhfICNPxv5Fem1wxTfF5MBpsVx1hmp4BEbO@vger.kernel.org
X-Gm-Message-State: AOJu0YxS2FW1dI4xg1CZl5i8v/hcgFVH0hR52XGsZbmUx+UR1Qz1ACwX
	nTJwnI3KT1DLRSkcHAbf3ee3veCqUqcubZmY+moopF7bJCo92HUsOlxzY/SA
X-Gm-Gg: ASbGnctMeF1sZOuBlvP8rL76f2DXrWvp90QUiviKubw+hRedK1L1BUfTuYTg+1uaMmM
	5pQ7EDKjFcECnn2066WMNSuT4Hc7e5JbZHkcpBbNzU0QxwnGtjtvSWL1YfDNRD2frWmV1V7YQIe
	gpGwF709yc8uFoNy3wEICAz3uEKBVtYkwbaUH2H2WALRxV+EIuDd4r63S6X5NoVP+6WHr55SRD+
	LIlQnD3zQEafqW133oxko3R7vXGGmlZ9/waLR9QTdhLgu/SYJea0UhkDGpe/sXIp7T3neRi2Azo
	P4Agi794T1bOciYo2IhexXacc1IaPnnKzfhXJzgytr6Mw0IxR+rXPUFVMXQh5XbjZlF7JabC73O
	wxUtHaFrYXldogzEDPAHugc0WfycTqUTO
X-Google-Smtp-Source: AGHT+IETHQR7T52RBo2+4AcJP5+zLkS5jFUxhqgYRmiNsDGC4K0ZODmmfPCzwNhYWr95O8KmQOhA2A==
X-Received: by 2002:a17:907:ca0a:b0:ab7:a318:611e with SMTP id a640c23a62f3a-ab7a3186356mr452158166b.18.1739099454708;
        Sun, 09 Feb 2025 03:10:54 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab79afc7452sm357516366b.163.2025.02.09.03.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 03:10:53 -0800 (PST)
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
Subject: [PATCH v6 net-next 07/14] netfilter :nf_flow_table_offload: Add nf_flow_rule_bridge()
Date: Sun,  9 Feb 2025 12:10:27 +0100
Message-ID: <20250209111034.241571-8-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250209111034.241571-1-ericwouds@gmail.com>
References: <20250209111034.241571-1-ericwouds@gmail.com>
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

