Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E105979DDD
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Feb 2024 10:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709203516; cv=none; b=fB4NALHVdTBJrjB6icq04myev3H4HEcU3xmKYZA5yMekHHSMP98Dqx2dIm8FgW+mjlcPdNmwJnwToN1CfzURiVQLZNUu2yv0n6x6AxCgiwLJW92xuvzPshi3xmcVdwH6gK63r+wNis/Qr7r3Z/leD6Spzy8HFRmS6j+RyZygd6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709203516; c=relaxed/simple;
	bh=DY+eaAeI4bEq6K1rArlwUrnUKl+tITtXI+I+Eci8QoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCooLmFdOg4SVMf2lphYLNxYO5HBJ/oGTAJl0f2Zemq262gHYniKU+LpDIgLRnaD7dwhMr28rKd7AK3bQNATYJfR7IpGJcYm1LkR8/USy9xcOY+c3qhKPzOnwKPW3JiNQoT9Umx6Fi5v7c97lJ9o6Yvb7w/9DXXcQAxcBpAd5+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rfdub-0007dU-2O; Thu, 29 Feb 2024 11:45:13 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] netlink: allow typeof keywords with objref maps during listing
Date: Thu, 29 Feb 2024 11:41:24 +0100
Message-ID: <20240229104347.5156-3-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240229104347.5156-1-fw@strlen.de>
References: <20240229104347.5156-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Without this,

  typeof meta l4proto . ip saddr . tcp sport : limit

... is shown as

  type inet_proto . ipv4_addr . inet_service : limit

The "data" element is a value (the object type number).
It doesn't support userinfo data.

There is no reason to add it, the value is the object type
number that the object-reference map stores.

So, if we have an objref map, DO NOT discard the key part,
as we do for normal maps.

For normal maps, we support either typeof notation, i.e.:

  typeof meta l4proto . ip saddr . tcp sport : ip saddr

or the data type version:
  type inet_proto . ipv4_addr . inet_service : ipv4_addr

... but not a mix, a hyptothetical

  typeof meta l4proto . ip saddr . tcp sport : ipv4_addr

... does not work.

If nft finds no udata attached to the data element, for normal
map case, it has to fall back to the "type" form.

But for objref maps this is expected, udata for key but not for data.
Hence, for objref case, keep the typeof part if its valid.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index 3d685b575e64..0088b742d573 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1044,6 +1044,8 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	}
 	list_splice_tail(&set_parse_ctx.stmt_list, &set->stmt_list);
 
+	set->flags = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
+
 	if (datatype) {
 		uint32_t dlen;
 
@@ -1056,6 +1058,11 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 			typeof_expr_data->len = klen;
 			set->data = typeof_expr_data;
 			typeof_expr_data = NULL;
+		} else if (set->flags & NFT_SET_OBJECT) {
+			set->data = constant_expr_alloc(&netlink_location,
+							dtype2,
+							databyteorder, klen,
+							NULL);
 		} else {
 			set->data = constant_expr_alloc(&netlink_location,
 							dtype2,
@@ -1084,7 +1091,6 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 					       NULL);
 	}
 
-	set->flags   = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
 	set->handle.handle.id = nftnl_set_get_u64(nls, NFTNL_SET_HANDLE);
 
 	set->objtype = objtype;
-- 
2.43.0

