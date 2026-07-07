Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1D93B1018
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 19:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783453946; cv=pass; b=hwrgzdZEqqEp+0G0RSLjnNzZ9coBQ34+Eg5AYDgfKUWUZX3hwUVlYO9GscoWsuUwilYM8gYg5PexEQizfT4FBBPzPQOvN8XBUIY7MXyS+wdgj3gdwMn+nICy7QKuF0NJlbXzkvFXC3pHQH2OrEsYJ0GAl5cFNEHQp3cFG9jEPSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783453946; c=relaxed/simple;
	bh=hIUhxqvD5KAcWm5ULJwwbd7QY2tbk2VLc5laVSZFOR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oyh/+sfz+IcsD8uJu3WjCgagrSrLI+qE+Di0K5TjH2yoGjNSg9NCg7uB+sS1aLXeXZWPxxTAj/S4/AEDfXodyMZAgIkOzpxwo98dNIAWL2RfvrwkybNxQZ+kRr5irJKV4jJtvwGbT+uStiO9rfEqsSxLubwJFRcizFVJBriNe+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=Jzwiacpb; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="Jzwiacpb"
ARC-Seal: i=1; a=rsa-sha256; t=1783453890; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=ifeKEUcbTo5QicAMOpJfVHP0L1SposUaPgHWX5qk2YwgnfctMD7A/MpfN/piYARk3cvOrVB90YtDNAKhdikQH9bDVrxZDPeL0s/JHT3T8/d2EtFBUzxE//BNwOkAds22Ek4kOqvKmV+en/SLp8R3idDVvaszOJWfFB7L+RNE+7k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1783453890; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=vwFghchW1RZsPbctAAtf2crj3IxI3Kf75GQ4nhH/zG4=; 
	b=Sdqp4C9Iu4KroaT/coCUrU+8hb+bu/RE5vFQ9YaeIENn2y+jezGedv/fflhwfZ1/tlaN7XM9DF4XDYTgNB5xuPZ1hQPdIOV9pUW0IG4NxGiVrku7gUEYDXaHs3RkrIuOEgL4ObeXd9HN0/ZJGVWQb1whRh0/xS2HBORGnIG/+7k=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783453890;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=vwFghchW1RZsPbctAAtf2crj3IxI3Kf75GQ4nhH/zG4=;
	b=JzwiacpbwnrbjJozLjEbGVHeT0LV+nUpXTAIqYEi89EmQOrHQ3d8AV9kwMOdWaGH
	x+A9pWlIM/WbQdFEPJpDVrMXRzlyaKeEmCAR9xc5kd21nh6qbG6XsWaHx5Uzn6qmqdI
	+NaY2jWlvJ+OBMQIb99z8iURjxVFV4TcZLy74B3o=
Received: by mx.zoho.eu with SMTPS id 1783453888627257.411650092272;
	Tue, 7 Jul 2026 21:51:28 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next 2/4] netfilter: nf_conntrack_sip: replace u_int16_t with u16
Date: Tue,  7 Jul 2026 21:51:07 +0200
Message-ID: <20260707195111.34899-3-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260707195111.34899-1-carlos@carlosgrillet.me>
References: <20260707195111.34899-1-carlos@carlosgrillet.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Use preferred kernel integer type u16 instead of the POSIX u_int16_t
variant.

No functional change.

Signed-off-by: Carlos Grillet <carlos@carlosgrillet.me>
---
 net/netfilter/nf_conntrack_sip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 0ff089e03891..87c9c6b92a6d 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -935,7 +935,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 	union nf_inet_addr *saddr;
 	struct nf_conntrack_tuple tuple;
 	int direct_rtp = 0, skip_expect = 0, ret = NF_DROP;
-	u_int16_t base_port;
+	u16 base_port;
 	__be16 rtp_port, rtcp_port;
 	const struct nf_nat_sip_hooks *hooks;
 	struct nf_conn_help *help;
-- 
2.55.0

