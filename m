Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE652116F7;
	Tue, 18 Mar 2025 16:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742314555; cv=none; b=eTQQ6ewwT2FgJCsI4Dnp9aZDa43eNuZ2HMOiKgbTMCHn4pdW5v5A3G3cizcIiTnF4dVgCYI92Pks4j4F327UvC2CutPOJzpTh1wg2LIHjO5yzy3zwqXQPspDQ1zhjzMRJYXRf5AUx0YyIeJzXzoGE5eLGc9R0IOp/X2Dw0LW3o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742314555; c=relaxed/simple;
	bh=LmffCKADIeIffqapPxsU9tOy+2YOtIGz9W0FFK7WHVE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mN/tirKq+cxbeomgxZgL0t0y8j65PXrrkOkVIVAcvxh+h7SRkXaVuX+if3+lvOl/NzCWcCklKDY6Wxe9bSXIXolh7956BwMrWC/uRzSznILYTILN9sR5xV4L0tuIDv7Tu8u2fh99LIBOebR5CJ8Nw1lJnCIk64bBxraCOqvZW1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DRbmqAs9; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DRbmqAs9"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5eb5ecf3217so798043a12.3;
        Tue, 18 Mar 2025 09:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742314552; x=1742919352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rgo+etfraKUMI0M5lQ2rgHXdFZ4sUNxuHXFwWg3ih84=;
        b=DRbmqAs94uoBRtltN2bbN6NhH4hsYJQH/T3faeu0v16vrkdANW2CVvB+bzo2kVywbL
         92jnGzrCoEls3nFe7XVb66gcOLDHV83XCJ/vZkJ/vKPMhWmq1QNs12Bc+diM14JPey18
         4NIlrt8NtKM2Qzs8RSDigpkB/tdIhGwvUxjmyLMHQyAGGAIbs5gCKuS6rH1J2edrduvx
         2My/NtmlBiS+CJEQ1UbPtttMBoL6mmhgD3iJ6qH1p0pSzGS010aD634cl6I4OMDuxl7E
         tHbG59qiNvG8Wp7oArmyA58wEk4KhQQ1o037WI2E7EM5KR+RulxRiep7+VLpt0+yV7pU
         AzJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742314552; x=1742919352;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rgo+etfraKUMI0M5lQ2rgHXdFZ4sUNxuHXFwWg3ih84=;
        b=qTOuX072EiOhvzuWQP0C/i1qsDda884Ssa1uR49olCcgnbXHHLbzEsEnnG5E1OrMq6
         abqRXPT3COZ0L9+VFcQYeUuQHjgDSXL2SudL17kClOD7QBobmjtjr71KEZnQyWulKEDQ
         NdnKgkuaCh9+iaGtfSpEC66eCjQP+MmNFpB0l2o9CAuauO6MCvCJNQ4t8VD+fHH6odJD
         65wSvwk6t0a38N7Du09DA0/xJv7eNNFBUOOiwaTs+8V00KzAvxHmaJdVNGtHNep70Ewf
         XUFb72uJgDsIbYbdFmdz9bwKkvS/yQSVPo+RmyLLrb0ELHXgxAM32y1m+nRRfP3TZtPK
         syPw==
X-Forwarded-Encrypted: i=1; AJvYcCXeorFRtfzsGLuCXfDLYrkBpm/BArg8PFSGuBmzQ/QZxnK07iwIfuVaxGgfMLHaenZAA36BB24HpPbtYXLr3Ejb@vger.kernel.org, AJvYcCXxZzqe5rFUKzng+4lS7V1umU0s4BC4IyiBlFZPqzNc0Fcq2iz/n0Pbo11LLE2GE2nY6rknnIA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrrX4Ie6Qv3hg9D71PYkNDzvIw0rDg3qUq/EjshE/fSwmvRpvo
	EEwL04iz3odwWI2B+Z+abFTHdhbNj42LLDe2uWRJVSgu3sx8B4ZT
X-Gm-Gg: ASbGncvVKK+d/uHlb1WzaU/BuaLVhK30bMCW2k2uM5yjOGqt/WTRTRGWRpvD/L3TA+8
	jyWAp/B1lD4CwbcyPgpyQKGWjHXYw6vrAx1ecdja4Et1bhPSFhaXRP41kBP+m60Wd0qGqnIL4Gf
	xF5qPToJOWIriVhe2/QLKF9CfT4iSI6+L3g/5tOp5JZ2mJz0r0BARUtdz2EXmsFbl+D1WQZrZQI
	e6UPeT+V5Uv/Ahip70ZoHacgXiXxSmnT4w4UKsIUxUg56QNvsMh7rnKHJzDO6qOfofRP5X1ev9A
	zvYlk2U6si9C0fH8OwC3vNLF/0GnOHsnRBfZDZ4j8+kDKeKw+hu3sbrmu1cnWmPGuaG04WJRKzl
	iQK25iA==
X-Google-Smtp-Source: AGHT+IGg53ur2jmSUxDXT3bKkey+aq++2T4faI8kMqp5GiJrYGOR8DsXKVvZLa/A4CTE5qj5lQ59XA==
X-Received: by 2002:a17:907:e88c:b0:ac3:8794:21c9 with SMTP id a640c23a62f3a-ac3879427camr557665466b.21.1742314551759;
        Tue, 18 Mar 2025 09:15:51 -0700 (PDT)
Received: from localhost ([185.220.101.65])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-ac3863146bbsm231819866b.146.2025.03.18.09.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 09:15:51 -0700 (PDT)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
X-Google-Original-From: Maxim Mikityanskiy <maxim@isovalent.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	KOVACS Krisztian <hidden@balabit.hu>,
	Balazs Scheidler <bazsi@balabit.hu>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Maxim Mikityanskiy <maxim@isovalent.com>
Subject: [PATCH net] netfilter: socket: Lookup orig tuple for IPv6 SNAT
Date: Tue, 18 Mar 2025 18:15:16 +0200
Message-ID: <20250318161516.3791383-1-maxim@isovalent.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_sk_lookup_slow_v4 does the conntrack lookup for IPv4 packets to
restore the original 5-tuple in case of SNAT, to be able to find the
right socket (if any). Then socket_match() can correctly check whether
the socket was transparent.

However, the IPv6 counterpart (nf_sk_lookup_slow_v6) lacks this
conntrack lookup, making xt_socket fail to match on the socket when the
packet was SNATed. Add the same logic to nf_sk_lookup_slow_v6.

IPv6 SNAT is used in Kubernetes clusters for pod-to-world packets, as
pods' addresses are in the fd00::/8 ULA subnet and need to be replaced
with the node's external address. Cilium leverages Envoy to enforce L7
policies, and Envoy uses transparent sockets. Cilium inserts an iptables
prerouting rule that matches on `-m socket --transparent` and redirects
the packets to localhost, but it fails to match SNATed IPv6 packets due
to that missing conntrack lookup.

Closes: https://github.com/cilium/cilium/issues/37932
Fixes: b64c9256a9b7 ("tproxy: added IPv6 support to the socket match")
Signed-off-by: Maxim Mikityanskiy <maxim@isovalent.com>
---
 net/ipv6/netfilter/nf_socket_ipv6.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/ipv6/netfilter/nf_socket_ipv6.c b/net/ipv6/netfilter/nf_socket_ipv6.c
index a7690ec62325..9ea5ef56cb27 100644
--- a/net/ipv6/netfilter/nf_socket_ipv6.c
+++ b/net/ipv6/netfilter/nf_socket_ipv6.c
@@ -103,6 +103,10 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 	struct sk_buff *data_skb = NULL;
 	int doff = 0;
 	int thoff = 0, tproto;
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn const *ct;
+#endif
 
 	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
 	if (tproto < 0) {
@@ -136,6 +140,25 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 		return NULL;
 	}
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	/* Do the lookup with the original socket address in
+	 * case this is a reply packet of an established
+	 * SNAT-ted connection.
+	 */
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct &&
+	    ((tproto != IPPROTO_ICMPV6 &&
+	      ctinfo == IP_CT_ESTABLISHED_REPLY) ||
+	     (tproto == IPPROTO_ICMPV6 &&
+	      ctinfo == IP_CT_RELATED_REPLY)) &&
+	    (ct->status & IPS_SRC_NAT_DONE)) {
+		daddr = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.in6;
+		dport = (tproto == IPPROTO_TCP) ?
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.tcp.port :
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
+	}
+#endif
+
 	return nf_socket_get_sock_v6(net, data_skb, doff, tproto, saddr, daddr,
 				     sport, dport, indev);
 }
-- 
2.48.1

