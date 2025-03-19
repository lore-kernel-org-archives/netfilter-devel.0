Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0701DF73E;
	Wed, 19 Mar 2025 14:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395278; cv=none; b=X52i9+EtOqcuA9Gdgddd40eyWi77J+ngw05BM4F9vJ4VRGEVYX+FvZNdA/uJidl3euIeC92lhABp1P8H9SVfPLQ7LvHKhT8BLLT9QwJRMT6cCel9JlPjG53fJTavEs5yr3c0lLMWt+UI2+kcFEBOT+czIt8gGKXLRDtBKcrOwo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395278; c=relaxed/simple;
	bh=GoY5hPkeGwRCyspoZAxfm0Suw8bPfsdDXl9JAND+GrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B86PFXW6Z/8RweM70zjGe91rXW+IEPemT6hL9WU9p1PkhF1ZsZr2oZSdMOKbHj38DjyEp67lozm+61u37iza51gCYSBC9Xsz1d9eZz0Qwj0VcQK1tbv2qJZBN1NygKG8h7nCMPkRr9/YyrS9Qoe43lA0cG/DBGCq2cmH5Jp35QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnPw76lQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnPw76lQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFE6C4CEE4;
	Wed, 19 Mar 2025 14:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395278;
	bh=GoY5hPkeGwRCyspoZAxfm0Suw8bPfsdDXl9JAND+GrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnPw76lQAgGJCKCNnzGNg5aNKFBtODgtHEtyCTu/Whfr2mGfXQTwopNIxnxOQg0Jw
	 aE4XoYP63bedEdAe8kRcYQN5KM0xDIjLLnaUVRpHyWmYFIAfYn++W99qy2p1fIvuX3
	 5qEdFl0rg+jYeyEG9iNC/bMKNcPE0V63AcU1uqP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 165/166] netfilter: nf_tables: bail out if stateful expression provides no .clone
Date: Wed, 19 Mar 2025 07:32:16 -0700
Message-ID: <20250319143024.496402846@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 3c13725f43dcf43ad8a9bcd6a9f12add19a8f93e upstream.

All existing NFT_EXPR_STATEFUL provide a .clone interface, remove
fallback to copy content of stateful expression since this is never
exercised and bail out if .clone interface is not defined.

Stable-dep-of: fa23e0d4b756 ("netfilter: nf_tables: allow clone callbacks to sleep")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3336,14 +3336,13 @@ int nft_expr_clone(struct nft_expr *dst,
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
 


