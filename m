Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98A919938D
	for <netfilter-devel@vger.kernel.org>; Fri, 16 May 2025 18:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747419943; cv=none; b=OsMuE+KfaZPCR+DhdY8epA5+S4GfQdx1T6EdgXVCNufbzhtgDFqfeqKraMOvQP+eNk5ZIQX224FxAj3Rau/I/+T0TR2Aj1HMSz+BJqWPrkOOVWBcspNdkkoExJ2mvDRN8m0fnYFUmANBPeBEcbvkDSLz/h8omXm0yderu9XHSqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747419943; c=relaxed/simple;
	bh=ZMiRhfIzWROeBZH1i11zLQabzZzEqdxCrqcBUebgx+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUJmMOx28VLsjqe2/sAbktZUSF/kvnT9vfPYA/GYnPwMlDJyVAqwA8uwnHIZCpX9ttueKIs8SP3Swo1lQZzUl7caWdMj4otjqOf4BFkJ9Mvzez4gA3/cnHcQXEqBPAgsCweCZRSEuLtlJ/YtxyHxzxObNGGc+6fNlUUJIyTl0LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MQLky2y1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MQLky2y1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YWAI6611ZTRCqnN3/BjUq0qkpViOZsgdXfk27s89TA8=; b=MQLky2y1l16fGtbIa8d8L9uVBS
	97oLo0bnnzb42EAS4AC/jSYOAlmtD1dmmuQdXbyJuPmDswv6di1C850jU8p7cmMTyS2dgoTicorzM
	t8T9zESV3ATtC4ZGfEDoiugW0YMqCAmLyz0PdOar3ni5i9VLoP1bOoGOqSkGWoM5LAZd8o1hgTqH8
	VsDO99E/T+uFfK/cPf3mdsAVw7cLlp14nNg6rut5iV9Mahy3s4IvuEI1ypkff35uKwPLDLe0Ql5/+
	K6QlP7CheDtnJWlWkuUh6DgcdAgDhKyQywyH/kz7cEGxOY4tZyKPjNMbVlD2wrfCEaCZUSERs+GwI
	WU5aNJeQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uFzkY-000000005j6-2E7K;
	Fri, 16 May 2025 20:25:38 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/2] netlink: Avoid potential NULL-ptr deref parsing set elem expressions
Date: Fri, 16 May 2025 20:25:32 +0200
Message-ID: <20250516182533.2739-2-phil@nwl.cc>
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

Since netlink_parse_set_expr() may return NULL, the following deref must
be guarded.

Fixes: e6d1d0d611958 ("src: add set element multi-statement support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index d88912457c591..0724190a25d6f 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -969,7 +969,8 @@ static int set_elem_parse_expressions(struct nftnl_expr *e, void *data)
 	struct stmt *stmt;
 
 	stmt = netlink_parse_set_expr(set, cache, e);
-	list_add_tail(&stmt->list, &setelem_parse_ctx->stmt_list);
+	if (stmt)
+		list_add_tail(&stmt->list, &setelem_parse_ctx->stmt_list);
 
 	return 0;
 }
-- 
2.49.0

