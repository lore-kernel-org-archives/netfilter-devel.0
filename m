Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887692F5302;
	Mon, 22 Sep 2025 19:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570655; cv=none; b=H5jWK7gMv7WsB41KGRNbiIW6yXsd4cP5oljPbFShgga5Dyc02miV39s1nRvsvRNvAWzuJnUPHYIeDcaUtrsbjo5vcxgm3QozKSKLlu5+AWKBIZmf6vgK5tahPGCY53avKkalLEgRX8XXYPS/Q+KuTWLUFvBKVerph+4N9vGrd2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570655; c=relaxed/simple;
	bh=yqlA7vId+ku0OBurzmpSjN8elYoe+QUjP5XjIjEne1s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dDwJ3Tgr+A5rlbUYqf+TxqyWtKzDtcpDXyzj1CegS/KTWeXIjWErQMSXdxIQbFcEsljSKHPMHB1/B0O1hha5t+hD30Pf3cXJ3fKBeQsVx8yj0eS0CAQ9xHQwhin1btiUPWdB62PUzlcvtpzqFQLEftgI59nPnXxC7dOc2J/qhfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=VOEC33sv; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="VOEC33sv"
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:1621:0:640:12d9:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 91AF788577;
	Mon, 22 Sep 2025 22:48:48 +0300 (MSK)
Received: from d-tatianin-lin.yandex-team.ru (unknown [2a02:6bf:8080:c27::1:3a])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id TmcMU33Goa60-762HOt5G;
	Mon, 22 Sep 2025 22:48:47 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1758570527;
	bh=2QbQZ3xXww2zGM5XlqT0lRHZgoIfQAqx/2r0Ht+KoMI=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=VOEC33svWQgdO8JChu4rQmiwTOFSqRlqqXQkt5qrJTQtx9ILIHk6SFhOBLi73VlsH
	 9TP2DzEvdLj+5pVaIe1xnz8VXrbXxpNneJe62CZArbIhbHPWrIhFHoxDyO/j6Mu9qp
	 2qRLbM81vH9NWtxRmlB17dNYGJjEj609HaayXuPc=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Daniil Tatianin <d-tatianin@yandex-team.ru>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 2/3] netfilter/x_tables: introduce a helper for freeing entry offsets
Date: Mon, 22 Sep 2025 22:48:18 +0300
Message-Id: <20250922194819.182809-3-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250922194819.182809-1-d-tatianin@yandex-team.ru>
References: <20250922194819.182809-1-d-tatianin@yandex-team.ru>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Analogous to xt_free_table_info, add a helper so that the users of
xt_alloc_entry_offsets don't have to assume the way the array was
allocated. This also allows us to cleanly change how the array is
allocated internally in the following commit.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 include/linux/netfilter/x_tables.h | 1 +
 net/ipv4/netfilter/arp_tables.c    | 4 ++--
 net/ipv4/netfilter/ip_tables.c     | 4 ++--
 net/ipv6/netfilter/ip6_tables.c    | 4 ++--
 net/netfilter/x_tables.c           | 6 ++++++
 5 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 77c778d84d4c..f695230eb89c 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -274,6 +274,7 @@ int xt_check_entry_offsets(const void *base, const char *elems,
 int xt_check_table_hooks(const struct xt_table_info *info, unsigned int valid_hooks);
 
 unsigned int *xt_alloc_entry_offsets(unsigned int size);
+void xt_free_entry_offsets(unsigned int *offsets);
 bool xt_find_jump_offset(const unsigned int *offsets,
 			 unsigned int target, unsigned int size);
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 1cdd9c28ab2d..bc164c2e22b0 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -570,7 +570,7 @@ static int translate_table(struct net *net,
 		ret = -ELOOP;
 		goto out_free;
 	}
-	kvfree(offsets);
+	xt_free_entry_offsets(offsets);
 
 	/* Finally, each sanity check must pass */
 	i = 0;
@@ -593,7 +593,7 @@ static int translate_table(struct net *net,
 
 	return ret;
  out_free:
-	kvfree(offsets);
+	xt_free_entry_offsets(offsets);
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 23c8deff8095..1ffd871456e1 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -708,7 +708,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 		ret = -ELOOP;
 		goto out_free;
 	}
-	kvfree(offsets);
+	xt_free_entry_offsets(offsets);
 
 	/* Finally, each sanity check must pass */
 	i = 0;
@@ -731,7 +731,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 
 	return ret;
  out_free:
-	kvfree(offsets);
+	xt_free_entry_offsets(offsets);
 	return ret;
 }
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d585ac3c1113..0f2999155bde 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -725,7 +725,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 		ret = -ELOOP;
 		goto out_free;
 	}
-	kvfree(offsets);
+	xt_free_entry_offsets(offsets);
 
 	/* Finally, each sanity check must pass */
 	i = 0;
@@ -748,7 +748,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 
 	return ret;
  out_free:
-	kvfree(offsets);
+	xt_free_entry_offsets(offsets);
 	return ret;
 }
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index c98f4b05d79d..5ea95c56f3a0 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -970,6 +970,12 @@ unsigned int *xt_alloc_entry_offsets(unsigned int size)
 }
 EXPORT_SYMBOL(xt_alloc_entry_offsets);
 
+void xt_free_entry_offsets(unsigned int *offsets)
+{
+	kvfree(offsets);
+}
+EXPORT_SYMBOL(xt_free_entry_offsets);
+
 /**
  * xt_find_jump_offset - check if target is a valid jump offset
  *
-- 
2.34.1

