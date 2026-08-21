Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C61A23D7FF;
	Fri, 21 Aug 2026 15:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326728; cv=none; b=CPjGHLSw3hAVje86FBJxYfIXfujadmJQ7dsrXkFmPaPHl6/sGNAiv+ZDwwawWUmxqisOckMI0JDgblUeOoYWRHCVZB0DXlgzUdpfgvaO+ePhQ8konMllPGmWq9d/4kaT+AhdpWrSunabq8mh8FzW82T9dbFw0Nc7MPVILnmzzdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326728; c=relaxed/simple;
	bh=GCdHbK2qhkiSMDUfaXboDYSPAByGX7GadFYWVX3B0U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDJvTJMDVQWkCdm5tdL/JnPFi510a4oVrCsqPQfH8oy7F53gzYCf6Rkil8TnHQQvLzM4/I2UNvyMa36tu8TCyoVz79NGMvYoDiTSg8bVZpBhGk30jnokosOI5H7oBLjUIScO5q0FSubexUiqVhsPHMce28afnolnnOUI39oJegY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MTDpW7lH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MTDpW7lH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787326724;
	bh=gZAcy+EPQjh1VZ2W+In51qQLIwSHVDOj7dvL2VDXns0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTDpW7lHsGDIfvt9JeSdeKPq8FK/dhg/xp+IewjaqLoUFCVJ0WdABO2mY6mJalrW3
	 WHJd8DtFLQA2/R6iquIN9XCwelejJ7G1HTh+4RK0mPXJnHPuwxkCNAS6PX5k34LTIC
	 XIxM8mIVuLv3EO/erSWxM0UKZVD4wG/0nP/701EpmajFR2ZbH2DaoFj8pwug0iY53P
	 M6TfVXsZzE62RxdcdbyEcuBuHkgM8OqnjKJiBeedxZUxCPsRMYx8ybsBiLCxjfNrSq
	 fWQnFBHfGk2AgcEYLeBLXF28wU63rkhFL1uVGKlQEiTYpcGg3LB6w5DjId/dERcd/p
	 363VteKx7HDGg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E043E6008B;
	Fri, 21 Aug 2026 17:38:43 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 01/10] netfilter: tproxy: use DEBUG_NET_WARN_ON_ONCE for protocol fallbacks
Date: Fri, 21 Aug 2026 17:38:24 +0200
Message-ID: <20260821153833.245589-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821153833.245589-1-pablo@netfilter.org>
References: <20260821153833.245589-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

Replace WARN_ON calls with DEBUG_NET_WARN_ON_ONCE in the default switch
blocks of nf_tproxy_get_sock_v4 and v6. Unsupported transport protocols
are already safely handled by returning a NULL socket pointer. This
prevents unnecessary system panics when panic_on_warn=1 is enabled in
production systems.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_tproxy_ipv4.c | 2 +-
 net/ipv6/netfilter/nf_tproxy_ipv6.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
index 041c3f37f237..5eab7a2dc8ef 100644
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -137,7 +137,7 @@ nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 		}
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		sk = NULL;
 	}
 
diff --git a/net/ipv6/netfilter/nf_tproxy_ipv6.c b/net/ipv6/netfilter/nf_tproxy_ipv6.c
index b2f59ed9d7cc..12ec36a6be2e 100644
--- a/net/ipv6/netfilter/nf_tproxy_ipv6.c
+++ b/net/ipv6/netfilter/nf_tproxy_ipv6.c
@@ -136,7 +136,7 @@ nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 		}
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		sk = NULL;
 	}
 
-- 
2.47.3

