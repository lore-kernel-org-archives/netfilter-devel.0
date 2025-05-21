Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C98F253B58
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 13:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747833178; cv=none; b=Ssjr/YbLP/e8vG49jITmGcnk64nwuXaExNPMeU3ZLLxorEvMPny2+HXEE225+yu0pFE3KyTwhmG32qIRCd/E8TlcwPW21nGJag2kTOhQfTLjwRiPsreDKsuTxUNcf/CHBhbdr0P/ojDRpyZY/yWy4XBGUvKAcbgN0TcqWFXGYAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747833178; c=relaxed/simple;
	bh=+oSNlCXX6dELXpFPcQFmdLm3J8V3P+h6wBSG/A3bBck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFNaypgjWMGYHrqGu/w0g3CdoYh03ayCiQwwaQzFhn4k563h9JVYuZpQyfSGfIgt7wy+sfrIhqIQe5xu5t5tW5+a9KDv8qRiORrgUDTo6BCaD5Z723dq9MpLZKOCNc84PTfXq7LDF6LmTMTyYLVi7CtU6upAKjPTIUZ2wtttbxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Bz8TEaoe; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Bz8TEaoe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2ksKdx2KKxowwo+XsEJYI0+2Jm2ploUSJv+qzqra5OY=; b=Bz8TEaoeKpHtn6+OfOkHzRHaM4
	WpSCH87B1k/ccQa3C0KP8h8r57SS5HgVVQUo+5aWMaX4xr+4RLJQWHQy621sW4gzKQUgicDR0FqH1
	IezRIxwRDitNk9muS0v67WJiZELZ/mYMos4xsR2zkCnAmOjWxdY+EViRvq4gjEKO5ksV0zf/JL+61
	aE9AojoDF71MlqEPuiix+yUcbbf97dgpvQE6zp+pneRfY64bwFqmw0VFwLdxKm6D0yFeAGWfRNT0J
	cnPbncTR/xuyUkPmRfG8Ss1MtiZmgpLmf2Kfh0zp95ErQr/R+/+Nb+ducOOVw1H22W9WC81KX1H85
	0y3xDrBw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHjFZ-0000000083k-03cZ;
	Wed, 21 May 2025 15:12:49 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/4] netlink: Keep going after set element parsing failures
Date: Wed, 21 May 2025 15:12:41 +0200
Message-ID: <20250521131242.2330-4-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521131242.2330-1-phil@nwl.cc>
References: <20250521131242.2330-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Print an error message and try to deserialize the remaining elements
instead of calling BUG().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index 1222919458bae..3221d9f8ffc93 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1475,7 +1475,9 @@ int netlink_delinearize_setelem(struct netlink_ctx *ctx,
 		key->byteorder = set->key->byteorder;
 		key->len = set->key->len;
 	} else {
-		BUG("Unexpected set element with no key\n");
+		netlink_io_error(ctx, NULL,
+			         "Unexpected set element with no key\n");
+		return 0;
 	}
 
 	expr = set_elem_expr_alloc(&netlink_location, key);
-- 
2.49.0

