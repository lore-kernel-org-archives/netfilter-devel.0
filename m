Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F852143739;
	Thu, 13 Jun 2024 11:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279142; cv=none; b=rufA+jbtNuZAzmE1fHrKg/SpJp5FGivbhoSnWxAVamYw2E22V1xGe0Bk8sx5dwnK9n4Yk32sxrt6jmldrBGAOFZzGIQ10fGeKNlwn71D8DY338VMiM5a26QE4K0FeXWKSNgw60VoQ+6hfkxQrnEdO4FwziC+BS0gB/8clr6/SMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279142; c=relaxed/simple;
	bh=esNmr7O7Ox5oK4COzcNwqQspADfbzlqiYy9Vo5Qenk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxLYXCHBVifiLj5rmVawcjhpeJvSBQ0/J2BDKs7CRZfmuDMBi8sko3ANEQ+26WT67FasNAeReRw4TOLT+4v59JTEJW6g1I3y4z2ynZagJSMp24doaEhR7u3PfhEx2IQR5Y2uI8WDhHDeYIWctcL1y+b5iOYYK57P1tt/qXotWj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVsFm/X4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVsFm/X4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA75C2BBFC;
	Thu, 13 Jun 2024 11:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279142;
	bh=esNmr7O7Ox5oK4COzcNwqQspADfbzlqiYy9Vo5Qenk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVsFm/X4FUJinMk7rCXvviDo6NYC80ywkvhWdCXiSYL6pTn/CTFbbh+Avm/q8hTwq
	 bKmRfhs1rqK4MkFtneTZqOadDCD3y9j+OmXD1YACmhqLS7hXZ4ebMZcVgrvTm8NmSe
	 THF7D54JFpfleA1gzxwRLAMFsAgmeDhdq48KPMNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 190/213] netfilter: nf_tables: skip dead set elements in netlink dump
Date: Thu, 13 Jun 2024 13:33:58 +0200
Message-ID: <20240613113235.306182239@linuxfoundation.org>
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

[ Upstream commit 6b1ca88e4bb63673dc9f9c7f23c899f22c3cb17a ]

Delete from packet path relies on the garbage collector to purge
elements with NFT_SET_ELEM_DEAD_BIT on.

Skip these dead elements from nf_tables_dump_setelem() path, I very
rarely see tests/shell/testcases/maps/typeof_maps_add_delete reports
[DUMP FAILED] showing a mismatch in the expected output with an element
that should not be there.

If the netlink dump happens before GC worker run, it might show dead
elements in the ruleset listing.

nft_rhash_get() already skips dead elements in nft_rhash_cmp(),
therefore, it already does not show the element when getting a single
element via netlink control plane.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4200,7 +4200,7 @@ static int nf_tables_dump_setelem(const
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	struct nft_set_dump_args *args;
 
-	if (nft_set_elem_expired(ext))
+	if (nft_set_elem_expired(ext) || nft_set_elem_is_dead(ext))
 		return 0;
 
 	args = container_of(iter, struct nft_set_dump_args, iter);


