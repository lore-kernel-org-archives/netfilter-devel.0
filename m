Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1339D143C67;
	Thu, 13 Jun 2024 11:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279228; cv=none; b=sgPIwac9E7Hm88uYOpxLoR101i0aXKA77AL817UfLSiDuBDP5wT9NXsjgO4lFzaDok2MsODYZXppNgeikGNvpyNozqfVBSaeCO3EssxXbxGmF9YVePGidir/bKWhk8vZot0FoyCBdbgjmHXAmBxc3CIRu+KlWuHWPE01HMfpWCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279228; c=relaxed/simple;
	bh=vr44zOlXYtubGPMqGfz7urh3/foqnyqGv429utas4/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOpBEOIItlLOtdAayT9hsgQFdinyG5yez/Ow6xxoagST8Lq35UwgKIEJwLm4dpSiN3hZb7+h1V5WE6TbCNTLrrDEtFwMQCKaKnJRr6qetiyxktnUTPsnbKVJCOnKzAsI/wQMl2Riht4e+Zc+YPODCjSAraaLXULDPuozVShywKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYBfnIdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYBfnIdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDC2C2BBFC;
	Thu, 13 Jun 2024 11:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279228;
	bh=vr44zOlXYtubGPMqGfz7urh3/foqnyqGv429utas4/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYBfnIdKhLWA4hXSWppIvcrLXihg/FuPRf3vu35LJ1BRmPWSkf1wb/HWwM9aGbqE2
	 oyxx8k8DmzgyokNr/XW4n7VgZTGrvF06jSAkRHxQPxG2L4W8szWHuy1BhKmZvKb4Nq
	 sdE+OzMJtcO/xP1XErB+W6gd/xSsd1E+RCkO9Kos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 187/213] netfilter: nft_dynset: report EOPNOTSUPP on missing set feature
Date: Thu, 13 Jun 2024 13:33:55 +0200
Message-ID: <20240613113235.194194841@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 95cd4bca7b1f4a25810f3ddfc5e767fb46931789 upstream.

If userspace requests a feature which is not available the original set
definition, then bail out with EOPNOTSUPP. If userspace sends
unsupported dynset flags (new feature not supported by this kernel),
then report EOPNOTSUPP to userspace. EINVAL should be only used to
report malformed netlink messages from userspace.

Fixes: 22fe54d5fefc ("netfilter: nf_tables: add support for dynamic set updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_dynset.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -133,7 +133,7 @@ static int nft_dynset_init(const struct
 		u32 flags = ntohl(nla_get_be32(tb[NFTA_DYNSET_FLAGS]));
 
 		if (flags & ~NFT_DYNSET_F_INV)
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		if (flags & NFT_DYNSET_F_INV)
 			priv->invert = true;
 	}
@@ -168,7 +168,7 @@ static int nft_dynset_init(const struct
 	timeout = 0;
 	if (tb[NFTA_DYNSET_TIMEOUT] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
-			return -EINVAL;
+			return -EOPNOTSUPP;
 
 		err = nf_msecs_to_jiffies64(tb[NFTA_DYNSET_TIMEOUT], &timeout);
 		if (err)
@@ -182,7 +182,7 @@ static int nft_dynset_init(const struct
 
 	if (tb[NFTA_DYNSET_SREG_DATA] != NULL) {
 		if (!(set->flags & NFT_SET_MAP))
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		if (set->dtype == NFT_DATA_VERDICT)
 			return -EOPNOTSUPP;
 


