Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B107B3E1
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Sep 2025 16:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757694710; cv=none; b=a+AdgqNxuWjkG7gdWIu4oBV4ZRcNBVqKrTZu2mN8OV8pbwYTtZFSt7KFCcEt2LSZb3jxNEXJTo1HXV21bHfPXoAlS5tSMAdTUu4y9s0rj4xMFTkHDkHl2x8S8BnuHnxlAdSOKDQiPZm6vo4/qkZdMrEEOIrEQC6KRXJEHQoAvTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757694710; c=relaxed/simple;
	bh=9ihUSfzSFkwLShWje0yO2srPckLAAToJdNnr5Y0SusM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JqyAlOmfKnM+q6DkFa3cM8W1FmFj0RTpWUNCytGU6tsT4ksN/teKZTCMparDONpWnebtARhD5aSE+a3potFA43OZDKO7x2QnYoUDlNi0aF8MnFpIsWJ3isp5zSNAl4PuGSNb0Jt5BewSg1fBWcJLUI0ZIzqNXuo+5SVV4s8qDRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H9eqaYZs; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H9eqaYZs"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45decc9e83eso20128835e9.3
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Sep 2025 09:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757694707; x=1758299507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UtKuOJb160u4mrJLBMsiqKEZV9s8rb8J9qjSnxTlACY=;
        b=H9eqaYZsV/SEKfw+wGD3shjT9uPhaD2GpRZrWX1FwxMVksRLBVvueSGYixtC5Gv+gZ
         6mDOIsNVcLpxmVn+zeq3rlg5od84xJXerX5EMTUr2IoA+h3HndRWVmVzjg1MwF0nd9/1
         on+ah4fk8mgjyPYqRtDabi2KUdgeVgkcvssgPH4kdemXfanXM9R6ORipFx3k6M8oQzA5
         f6W66NWpef6en3LosJMPvUVpfTQh5fIZNE4n36Y8p6wb9fPRpnDhuwt0V8BpyImLH5Cb
         kv1W/db8YIsQnwHGr7T2BVDXmAsFGPCQi5X1UdDbqGU32467ctLx8GF8YpT//AnJzJyF
         ASxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757694707; x=1758299507;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UtKuOJb160u4mrJLBMsiqKEZV9s8rb8J9qjSnxTlACY=;
        b=SA8WL3vQNBtrCYIJ1Yfi96q5PJaevq1DyQlVrapa67wantocp71f34lMerqRURt4fr
         48LgFhcmnn/OjOhGla5VsLID3DhJidJ+FqwUZlyzk3buWHKQ2N0ChXdNNfy+Is0QwHCj
         KPkN9lHYh8o8LJAqop1B5D1tTKpuY9M0ynPu0ZoeIA2YcE2aNE9jjpsZVNIbSBb5GhZw
         ASh52hYcz0PAonx01VaL3/RSxH2B9NrH5sm4npX+bIcwH2dyT3ynsp45AiCyQNm61KFO
         aSUuKEVI0agbNJ+TRP5NHYiLoosJBlJxmtEXvTuum4OxEweKrtcx8EZynJUU5oMOIz+m
         RqVg==
X-Forwarded-Encrypted: i=1; AJvYcCXDx8/Dh6699tcYLtXiVf46J5wvbVMGAsWsjz15Dug9D2wlMR7x0KrYJKsNTkdqyPoA5aw8cg8KsHrM601PqMs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY1JvT2gousHeHfhNnPmLYo6AufZkKf2bdmvnEa3mqsnRl7u2p
	C5IdnEgyozxlZAaZplYVFYS6PBsVK+mMF8yIirL4ZUDLMaYAoDQMjQ4D
X-Gm-Gg: ASbGncuZRHRdAmOkx/pLemWB9rqShZANY2AvWhQjyp/dm3UOYsRpJAsUE9lOngvU6tb
	BwI62qRAgYVA+EC38W2jo3VnMwNbYyS9rLzSCWHGolgMQB4PbDnwMKzqbgvcT7xXWQyqBmeqKRS
	LjHxk4RLUPjs1Yz6Oj3tVCnvQTd5fev/k+xRTP7k/V4j1z+a6awIzxy0+5gZLzgXy5EKNCO+Yd9
	fYQ9VOsiELTcYJsTSCiHGLMdU+IbU+xrWGs8Sl2uSAvx5wj1yrNzkPxJdP9nfQh1DkLPspnDppi
	j2ePU9VWtqAcNzCgyRy09ei3nW36x6V76yo1IqtjNpJO/DQgdl2AJ+rE68z64Qbb7ZOqz72ZOL8
	94AYqhkvUoBTWG3HqJodhXG9zUw3jaQLRUihaKcKvsRaKIuG69otEOdOoL4bdSd8h
X-Google-Smtp-Source: AGHT+IHIRSdEBgoLi0Q0DuZdQBqEeXcgKeXdgViwtka9Vqo2HBpKPmSlfWNGtBJ9utLxGObmeSXi0A==
X-Received: by 2002:a05:6000:3101:b0:3ca:3206:29f with SMTP id ffacd0b85a97d-3e765a2d9f1mr3941616f8f.40.1757694707074;
        Fri, 12 Sep 2025 09:31:47 -0700 (PDT)
Received: from elad-pc.lan ([2a0d:6fc2:68d0:5700:2165:4513:68b5:3f5b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037d638dsm64844795e9.22.2025.09.12.09.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 09:31:46 -0700 (PDT)
From: Elad Yifee <eladwf@gmail.com>
To: 
Cc: eladwf@gmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next RFC] netfilter: flowtable: add CT metadata action for nft flowtables
Date: Fri, 12 Sep 2025 19:30:35 +0300
Message-ID: <20250912163043.329233-1-eladwf@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When offloading a flow via the default nft flowtable path,
append a FLOW_ACTION_CT_METADATA action if the flow is associated with a conntrack entry.
We do this in both IPv4 and IPv6 route action builders, after NAT mangles and before redirect.
This mirrors net/sched/act_ct.c’s tcf_ct_flow_table_add_action_meta() so drivers that already
parse FLOW_ACTION_CT_METADATA from TC offloads can reuse the same logic for nft flowtables.

Signed-off-by: Elad Yifee <eladwf@gmail.com>
---
 net/netfilter/nf_flow_table_offload.c | 38 +++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index e06bc36f49fe..bccae4052319 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -12,6 +12,7 @@
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/netfilter/nf_conntrack_labels.h>
 
 static struct workqueue_struct *nf_flow_offload_add_wq;
 static struct workqueue_struct *nf_flow_offload_del_wq;
@@ -679,6 +680,41 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 	return 0;
 }
 
+static void flow_offload_add_ct_metadata(const struct flow_offload *flow,
+					 enum flow_offload_tuple_dir dir,
+					 struct nf_flow_rule *flow_rule)
+{
+	struct nf_conn *ct = flow->ct;
+	struct flow_action_entry *entry;
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS)
+	u32 *dst_labels;
+	struct nf_conn_labels *labels;
+#endif
+
+	if (!ct)
+		return;
+
+	entry = flow_action_entry_next(flow_rule);
+	entry->id = FLOW_ACTION_CT_METADATA;
+
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
+	entry->ct_metadata.mark = READ_ONCE(ct->mark);
+#endif
+
+	entry->ct_metadata.orig_dir = (dir == FLOW_OFFLOAD_DIR_ORIGINAL);
+
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS)
+	dst_labels = entry->ct_metadata.labels;
+	labels = nf_ct_labels_find(ct);
+	if (labels)
+		memcpy(dst_labels, labels->bits, NF_CT_LABELS_MAX_SIZE);
+	else
+		memset(dst_labels, 0, NF_CT_LABELS_MAX_SIZE);
+#else
+	memset(entry->ct_metadata.labels, 0, NF_CT_LABELS_MAX_SIZE);
+#endif
+}
+
 int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule)
@@ -698,6 +734,7 @@ int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 	    test_bit(NF_FLOW_DNAT, &flow->flags))
 		flow_offload_ipv4_checksum(net, flow, flow_rule);
 
+	flow_offload_add_ct_metadata(flow, dir, flow_rule);
 	flow_offload_redirect(net, flow, dir, flow_rule);
 
 	return 0;
@@ -720,6 +757,7 @@ int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
 		flow_offload_port_dnat(net, flow, dir, flow_rule);
 	}
 
+	flow_offload_add_ct_metadata(flow, dir, flow_rule);
 	flow_offload_redirect(net, flow, dir, flow_rule);
 
 	return 0;
-- 
2.48.1

