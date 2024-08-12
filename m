Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4C1187842;
	Mon, 12 Aug 2024 16:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479143; cv=none; b=K4qqZQbHQck/k/n6qGzvrQWEnJXCekhH1GrhgDkZdC6FvkanAR55rsd4xqWsxWlbzTp2u4lzStI+cKtjLJ8IvO4/t9W8yu/I274J9v8wCENK0yXDFf3T7BfGJcIlpL8JV/4kqHAvks8NkYnSEXZ8uW+a/J24gE1s/Sc5dw+IyoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479143; c=relaxed/simple;
	bh=ZKvY26kTqp46Ior3yBZ83oEflzrZJY3TrNMsjV55jIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2DTHx3uW9dijw03KAPCOw7L0z7ua18GfFLlBxyFPJrrocrDAYiV47aLCIdcMFbAWKw/HWGDZCB3kcO20ADfAeNjbDLtkM8fSXilFNqeYxyiIXUm1HqjcXXK1/CHOVuLHze0jKyBYKTG4potHMCFks9limHzJUm1TCgGcQ7onA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6NsuJs7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6NsuJs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F17C4AF0F;
	Mon, 12 Aug 2024 16:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479143;
	bh=ZKvY26kTqp46Ior3yBZ83oEflzrZJY3TrNMsjV55jIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6NsuJs7qgT+7UwSnN5q3Kn67u2Cm5KhIGHAp9/X136oxU0/FiaeYUqcZzR0t3BNa
	 gXt6PiXtaWTHijYSNR88QCO0ZB4GN54TupJeSEDY6OrfCxk1i5q7PaoYsachzjLrGW
	 cXC7fESRC0zvYrX2+MsM+x5b7358BxZ10sTLUsbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 146/150] netfilter: nf_tables: bail out if stateful expression provides no .clone
Date: Mon, 12 Aug 2024 18:03:47 +0200
Message-ID: <20240812160130.804906372@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3123,14 +3123,13 @@ int nft_expr_clone(struct nft_expr *dst,
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
 


