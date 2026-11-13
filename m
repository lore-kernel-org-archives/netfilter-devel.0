Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539587;
	b=k6Oxw9uneJNcShNmenOUEGdwtFCymaIdXSi+UHY6NDOzZmgtMxsp2+I/cFHR+f6eV6vI
	 y2wgxxgcugnjLQhwe3DnwGrYVrTTv2mbszRbK4w5DH5O9ReV57qfyQ2v68xGm5qM9M7gC
	 VMm5kN7+H/SbJZihMyBcesaylAESeHgRJ4bwqgweqY+1wGA+WZ11VYrlS95RbAX5Ihh7K
	 th3D/clRaOV0f3X8i72P+kFtt2RYNsWZ16QCFOrgxj25ShPI1Vc56HP7K/eJ6I2+LFpaT
	 m4gOtQOSfcHIAOfr7JQ3IIrWoXXPVTls6k0PVp8qj7upFmqJqSG2oIqtYK0DJdF0+ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539587;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=aL0i2bOb5Au0I6UYZUML79qPFqmooqvj+Q5kLNFoTH0=;
	b=d4XLF1CRZH54SHjo7QxA2D39fKdq4P3FXpT63M8lRhoNo47GSX0E3IjsDbUoKbS1PG2L
	 tL5DhwoWkpyxbBcsEHDlL8elf0V68G/rMjMzFHMgG3NLT6evonHXk1PRmpZXI2Rcut+a0
	 7BNKC5j/dvG+qvk1woz00ZBZ9o/YkpI7i6MDemMXzG8FWTTdvmogfq+o59F3BrL4Cqr9N
	 +0KHOG+v9CBzjXh4Db8CfAzA8cdseUsxZ0t1Y3VrS4acRaV5TlbL+P+WusRLdDKCwJN9Q
	 ZMuEsZICk6Grn5ocdGnAUPYp4Bp34krA0n2sTiYOZk6dlf1t9Ow1r51SFIy+plbReQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=k97wVshJ;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9F4606A336;
	Fri, 13 Nov 2026 03:13:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D9F4606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=k97wVshJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539585;
	bh=aL0i2bOb5Au0I6UYZUML79qPFqmooqvj+Q5kLNFoTH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k97wVshJ5U2NxhIuwy4+AGzxeyWvglvAEO9SP7limf1akzPt/BKNWuwH/nVpoyZa7
	 dJ+q5tPDLV51hCyi6wx1Bposy++xaY/G4CnJ2ysoXSp7DXyqzl4AOyYGiEkxJ7oePf
	 LdF57A7qLLq5iMAVlSs+IZF6aotpU0GWIpZLspdvyhmdbg2M/oMKDhJF8QYRKbac1v
	 jMF4nJC6oUTruTrmajuK5q+MKksEmeboxyeHpu/UpcX7C9wIeiutLBNcNAZJamjfxB
	 3GZEyy6GIFjB0X6J6+OmHIf+A9reY2o91lX96Z+nlybf1DFJp5lng8zjLN3V7XVord
	 Lv8ycqLctqyqQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3B394602A5;
	Fri, 13 Nov 2026 04:13:05 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 07/15] netfilter: nft_flow_offload: do not offload multicast
Date: Fri, 13 Nov 2026 04:12:43 +0100
Message-ID: <20261113031251.2437074-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113031251.2437074-1-pablo@netfilter.org>
References: <20261113031251.2437074-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Koral Ilgun <koral.ilgun@adtran.com>

A flow holds one output per direction, which it resolves when it is
added. The outputs of a multicast route change when listeners join
or leave. So a multicast flow in the flowtable continues to send to
the output that it resolved, also after the last listener left, and
the counters of the multicast routing stop.

A ruleset can keep multicast out with a match before the flow
offload statement. Without one, IPv4 multicast stays out of the
flowtable only because the reverse route lookup in nft_flow_route()
refuses a multicast source address. The IPv6 route lookup has no such
check, so IPv6 multicast that ip6mr forwards goes into the flowtable.

Skip a multicast destination for both families in the flow offload
expression itself, so that the result no longer depends on the
ruleset or on the route lookup.

Signed-off-by: Koral Ilgun <koral.ilgun@adtran.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index d3c5651dd699..530e20c7fd45 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -10,6 +10,7 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/ip.h>
+#include <net/ipv6.h>
 #include <net/flow.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
@@ -33,6 +34,10 @@ static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 
 		if (unlikely(opt->optlen))
 			return true;
+
+		return ipv4_is_multicast(ip_hdr(skb)->daddr);
+	} else if (family == NFPROTO_IPV6) {
+		return ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr);
 	}
 
 	return false;
-- 
2.47.3

