Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6C16D1C5
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Feb 2024 13:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707397748; cv=none; b=oJsv8OYmcMpxev97fgjhyNmDzG5wL/c326FdPy6dhG70AP6wUIgOYghk7Bqc5yhvpZl4QNJypR8tkUOEhMi7NHRiKAm5/5Itf70HMXk3ZJ1c7UJxSl9IekbNh7gYun2mBiDpsrt+v6nHNeTHQO3Mfr3bnWKYnQH3ZH70/bh12dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707397748; c=relaxed/simple;
	bh=rnNjpOSa6vfnPNFc05rgG/lDV7y19tBCUE+Vqg+wKZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lFRSUgXWTJzj/3cisPGdoRbkdNAt/0+SeZv04kFHXQ4olfGSjpOX1AnzOC1SRG/6Dyj+Huzi6PFAeXac0VZDxUB2EOavhRlIUxM9GmV40kq5ny9I0z1qA8cX2g+9Z5dv3/6pl1I75JEKwF1GHcSc8F9Gav3zXZ+MTdGMTK5yBN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=TeP1347T; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TeP1347T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Rlp8AwKhzUVWZloIUvM6lAWMG+zHFKag++bW2rXVVOI=; b=TeP1347T8PqP7ao66IokasOjZL
	EyesrsR1SrfkV4Se7C8u5TkgffTfg1OMT2DsWFcEj/yMM2gHh5XezUp2JLc8LteHQ0KxKoDm2ifgh
	J/3N0vuZHC4hQ/pn2IKWeFJP1L8nPwBLdYawy/cvSU8iMBGSKKoLuxVC8BjJtY5i7/QviVMNLIpH3
	VO1OdQkp68eIG9CUhyc0dtq2mZD+5Ek074G9/XTAaOZL2IAk3U+6KKMElIKdNOpEnuWU7mZ14M627
	Q6z9drTDokY8vzRVTbefy7NshJLTfwiKHYp+blUIMufGRp0bS75nHcREBWUzoG+MiCnghkc/mtp/J
	VrBX/4jA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rY49F-00000000271-1hJE;
	Thu, 08 Feb 2024 14:09:01 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	anton.khazan@gmail.com
Subject: [nft PATCH] cache: Always set NFT_CACHE_TERSE for list cmd with --terse
Date: Thu,  8 Feb 2024 14:08:59 +0100
Message-ID: <20240208130859.17970-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This fixes at least 'nft -t list table ...' and 'nft -t list set ...'.

Note how --terse handling for 'list sets/maps' remains in place since
setting NFT_CACHE_TERSE does not fully undo NFT_CACHE_SETELEM: setting
both enables fetching of anonymous sets which is pointless for that
command.

Reported-by: anton.khazan@gmail.com
Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1735
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/cache.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 97f50ccaf6ba1..c000e32c497fb 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -234,8 +234,6 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 		}
 		if (filter->list.table && filter->list.set)
 			flags |= NFT_CACHE_TABLE | NFT_CACHE_SET | NFT_CACHE_SETELEM;
-		else if (nft_output_terse(&nft->output))
-			flags |= NFT_CACHE_FULL | NFT_CACHE_TERSE;
 		else
 			flags |= NFT_CACHE_FULL;
 		break;
@@ -261,17 +259,15 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 		flags |= NFT_CACHE_TABLE | NFT_CACHE_FLOWTABLE;
 		break;
 	case CMD_OBJ_RULESET:
-		if (nft_output_terse(&nft->output))
-			flags |= NFT_CACHE_FULL | NFT_CACHE_TERSE;
-		else
-			flags |= NFT_CACHE_FULL;
-		break;
 	default:
 		flags |= NFT_CACHE_FULL;
 		break;
 	}
 	flags |= NFT_CACHE_REFRESH;
 
+	if (nft_output_terse(&nft->output))
+		flags |= NFT_CACHE_TERSE;
+
 	return flags;
 }
 
-- 
2.43.0

