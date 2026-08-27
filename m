Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD952477E31;
	Thu, 27 Aug 2026 14:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787840270; cv=none; b=WreZndsDLCfVNWkK2mYkD0lLA9bU+dkdy5WtUFTpGgAML0eXhaVMnazrAOBBBWrQg5bbGGzO7kBaPSLgTgk7dLp1kUAHqd4c6i+aOLR17RU6163KT7NKuqLrpVnl1i2Bv8vtgHI0xQlfQyCh6AVj2xu8ccisSaBHzfZCUsmvwLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787840270; c=relaxed/simple;
	bh=Tdydl1wAVGNkFkK4yZWIRGDhCXrMID511+i7Z0gDchw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhzvLZcRbKEGxKQUIhUEzB8m9RF4Xim47VfdIoKc0P6ezltFqanYcExVp9P9b+BGlV5ET6YaTEvwJAiy5g0AWYd5TwFTMKpUsDk9dQKTPad4rckg2T9Pa/7e2ZnHUyVcaHbWPhKYulYO36DKS6JtnFbdC9AQ6ab+640u09iEaXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SItCFM5c; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SItCFM5c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787840260;
	bh=YA4OG8D7OVkBiUj+AgPhn6jmP4tLCBg+Vk3Poht+K4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SItCFM5cAhl6bUB/rKhL47B9spF7tZulUFor+/OwJEtErIS62Zqg0cegoHCGWWdUM
	 ja/c4zTBfCHAlND3yeabem+gSZztJOgLzToscoiAvlD06xEVqeIZBWF4khRW6fqVmq
	 OQ2PVyix57u9igiPYDaaycl8J3TdxgzTFcIrzJBeUerud/6JpStYCwzCFl3uB0t1MR
	 sMgGYW9Cl095YUi/xLhrBLRZbAMN2Dy9dScBAyAhBXgdHEjRq16NBJ0j2RTj6bg1fE
	 9sPIbDwvQLBfdC40syunxX4jkvRCOqF5LfGZ5v7LsJ0SD6+uk3X1sKGuB42V/lcEtd
	 RQdmhPDARRC1A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 08DF460078;
	Thu, 27 Aug 2026 16:17:39 +0200 (CEST)
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
Subject: [PATCH net 1/9] netfilter: tproxy: use DEBUG_NET_WARN_ON_ONCE for protocol fallbacks
Date: Thu, 27 Aug 2026 16:17:25 +0200
Message-ID: <20260827141733.423453-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827141733.423453-1-pablo@netfilter.org>
References: <20260827141733.423453-1-pablo@netfilter.org>
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

Link: https://patch.msgid.link/cover.1786968834.git.zhilinz@nebusec.ai/
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

