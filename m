Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D17B1A01C6;
	Thu, 15 Aug 2024 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730693; cv=none; b=Gqegw3bc9bAWrN7O/Nw8A1oBAXPGptmE69BPHktxU3x5hyxNRbOREOJO996QCnsJZil6wCwcFLucEdD4918CIlmpubBfU/9b6XP0dirp68D+063gAfafrZWdI22CxovO240opUzch7DqekgQ5VxMXil8mSyuccv7tIQwQefitsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730693; c=relaxed/simple;
	bh=mQlNjAP89H7QiKeAVN57UOGD+DGMOERv6op8tx9Hkw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxpRJoNxhERmyvAAs16/mIHKEEtVCaZTbUgPIZoL/+/nLHQSP4Q4gNfrmnc6NoUO9NASTGY1iGS6dmdLAukZr/veCIz7TX6RTe1mR4dqfxMKiph646FaTQ/eBc1l3KcZIP0lZSa+9VtgOiOSUcf5C4pKoYpAZYFX6MZR+0BzKtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1y58xVnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1y58xVnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FFBC32786;
	Thu, 15 Aug 2024 14:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730693;
	bh=mQlNjAP89H7QiKeAVN57UOGD+DGMOERv6op8tx9Hkw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1y58xVnGXH0jZENCe6W8oEJj9UuIuDgHID9MKZh/PL2EG1qv7An1ocY807I89a9Kj
	 cameXY3sRfFk632RYc3K94iPLWMCBqXjMW4ppYIu/GtuiEjZ4sRvoxFkKlMhfbMHLP
	 aKJRmLxlQw2NukwmKV8pYtzA0RoM6TAbS7RXnftQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 468/484] netfilter: nf_tables: bail out if stateful expression provides no .clone
Date: Thu, 15 Aug 2024 15:25:26 +0200
Message-ID: <20240815131959.554712392@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 3c13725f43dcf43ad8a9bcd6a9f12add19a8f93e upstream.

All existing NFT_EXPR_STATEFUL provide a .clone interface, remove
fallback to copy content of stateful expression since this is never
exercised and bail out if .clone interface is not defined.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3053,14 +3053,13 @@ int nft_expr_clone(struct nft_expr *dst,
 {
 	int err;
 
-	if (src->ops->clone) {
-		dst->ops = src->ops;
-		err = src->ops->clone(dst, src);
-		if (err < 0)
-			return err;
-	} else {
-		memcpy(dst, src, src->ops->size);
-	}
+	if (WARN_ON_ONCE(!src->ops->clone))
+		return -EINVAL;
+
+	dst->ops = src->ops;
+	err = src->ops->clone(dst, src);
+	if (err < 0)
+		return err;
 
 	__module_get(src->ops->type->owner);
 


