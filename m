Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F08143870;
	Thu, 13 Jun 2024 11:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279231; cv=none; b=jTr8q/qJXXeI+rKNK8XrBpNzNPX1KoZG1oIkpFurQJgOKbNFjYMNzv0+gQFQIjJqkCWPsjMyIfpAHFReNsnfuTRBTNIfFq25U0VD8q5BeLOAmsqAmB84NGIOTG317VC3DFDH+UwV7Qm3CyLlGvlNM3sB826tSfJHk09rOdTsQ1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279231; c=relaxed/simple;
	bh=lFCAKEuqpb11BDFcyqIcaPZ5wO2EnYH/YJAtRuurArU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8u+vfvbO7CrGW4yAMAGGLa0NQr4iUAbv+v52dTHL+wlvusziHa3zjeLaikylboI7zZaq7TgYkwImmpHyT0qlup/u8LlKFMUh2x8TdeJB58hCSh0jYRhikMYVZzi4PlLTUn7Haumng0cGzYAxP5o6MGGUW1My4ePA5GrOWR9chE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SEEn2ha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SEEn2ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF93C2BBFC;
	Thu, 13 Jun 2024 11:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279230;
	bh=lFCAKEuqpb11BDFcyqIcaPZ5wO2EnYH/YJAtRuurArU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SEEn2haVrwAXWgnl3FlMmkdd9nQn57qizXJYn/Ldnj4QVX5SaEEZQ2ZS/v26Wofs
	 ZDRydbkkadrYKvnmJaXF4vATCwnE/Pd5fDvKrCd8LTtkshVP8O96y9uTCeF8CtoCuf
	 rBdUmHwpFuOh6DAZSlWQ6Vlh7mkSh9gi4mz+g9pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 188/213] netfilter: nft_dynset: relax superfluous check on set updates
Date: Thu, 13 Jun 2024 13:33:56 +0200
Message-ID: <20240613113235.231585566@linuxfoundation.org>
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

commit 7b1394892de8d95748d05e3ee41e85edb4abbfa1 upstream.

Relax this condition to make add and update commands idempotent for sets
with no timeout. The eval function already checks if the set element
timeout is available and updates it if the update command is used.

Fixes: 22fe54d5fefc ("netfilter: nf_tables: add support for dynamic set updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_dynset.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -154,16 +154,8 @@ static int nft_dynset_init(const struct
 		return -EBUSY;
 
 	priv->op = ntohl(nla_get_be32(tb[NFTA_DYNSET_OP]));
-	switch (priv->op) {
-	case NFT_DYNSET_OP_ADD:
-		break;
-	case NFT_DYNSET_OP_UPDATE:
-		if (!(set->flags & NFT_SET_TIMEOUT))
-			return -EOPNOTSUPP;
-		break;
-	default:
+	if (priv->op > NFT_DYNSET_OP_UPDATE)
 		return -EOPNOTSUPP;
-	}
 
 	timeout = 0;
 	if (tb[NFTA_DYNSET_TIMEOUT] != NULL) {


