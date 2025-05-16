Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE4827990E
	for <netfilter-devel@vger.kernel.org>; Fri, 16 May 2025 18:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747419943; cv=none; b=KDtJVIq74Esu5a1EVOUEXDgHb0Je0yODGuSt3WrP0WxVByKok9qUr7xjucL3PTcWDfPprgXGJuNWsMYs374lIZ9mdpT67m3BCHcIS/1JK5f3/H/xXPnoaYHkg8YUmK+qk26aL6xI630ljGm+OAxjG7i06+39T/i5qkRrq/+RHLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747419943; c=relaxed/simple;
	bh=fAQvvI/EyGAKBDIkL04WMl17lq2Uf91oNEEQrjqPg/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Axb682ipQ4CAvNTyFyvPe4afLr5HS5azuIvWleiR8V84Zu/5/nNVqOcbtAIe+Se1qIzB/aIYd1LqPytP8N0V2DubC2LZGue053CY1AzxsC+vAItNs08NLn8AxYbliImX5n2sz8Oe/jtPHb58ayB0ryyLwBzgxCbtlmgQvtMlJMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=S3fdlMhE; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="S3fdlMhE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yjAl5tjpFtHSvbtZazbGzcMRwaFvyLUyZIkBkHhdBD8=; b=S3fdlMhEBg0UZf7QSIuD8QWp8V
	PoJpXg3xORVx+cCNzaduZ+ZrLkOOZPqkFTe20vGunvEXiAEG4pqJle9Vl5DC1AY8mCZJuhzIOO1J8
	TDxljRrKTdZhilGUxXThefQb4mXpRrrQwAH5SEWDie8fj3n2kgfEvWvVa3rTT1O5mMS5pDSRT+Wpe
	V3rJirjHikfUWJtL28QBWsSuBNk1YcsoO6htuBL9nDNOEnlchnGSicGcqZqlSBhIvf5plO30x6z4j
	otDeB18oy+r/wNLH9ScD2yttweECiOqqqfexpmP8aBhGJlLU9ZW3zaBKsRyvRtARemQl9oNGiZmvN
	TTcBKYYQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uFzkZ-000000005jI-2IvG;
	Fri, 16 May 2025 20:25:39 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/2] netlink: Catch unknown types when deserializing objects
Date: Fri, 16 May 2025 20:25:33 +0200
Message-ID: <20250516182533.2739-3-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250516182533.2739-1-phil@nwl.cc>
References: <20250516182533.2739-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Print an error message and discard the object instead of returning it to
the caller. At least when trying to print it, we would hit an assert()
in obj_type_name() anyway.

Fixes: 4756d92e517ae ("src: listing of stateful objects")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/netlink.c b/src/netlink.c
index 0724190a25d6f..52010c74d4f30 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1802,6 +1802,10 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 		obj->synproxy.flags =
 			nftnl_obj_get_u32(nlo, NFTNL_OBJ_SYNPROXY_FLAGS);
 		break;
+	default:
+		netlink_io_error(ctx, NULL, "Unknown object type %u", type);
+		obj_free(obj);
+		return NULL;
 	}
 	obj->type = type;
 
-- 
2.49.0

