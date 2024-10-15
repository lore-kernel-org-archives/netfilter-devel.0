Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E483C1C07C3;
	Tue, 15 Oct 2024 12:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996947; cv=none; b=CG4TSR69dhMFQh+EHQ72tDhisx5fmCU17J0+BPHdpaJ3moY8Y+DZEZ1O7f/FnbvHMQJG6zkfSyAe88GV5SKA9rpNNAhFAq4wsPKeJY3Nb1sRiRBALIaEYLx1N4pYEWBRWIOxymwyqTxZ5AnkSc/vMMAXQhRaYXTRjVUbmmLfxyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996947; c=relaxed/simple;
	bh=3w6wGSORqcmCxn5P2LBtOD0Aoaq4hYnaNMJeLvKxJY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OA7U/TtEHF3F5vtrW4OjHfLhiuqUEkz0wtrSFO4CsGe9T6SYKq2AJ4G4/SB9osJwU3K/YMVo4fiHamkPLXSows2Bis0CDkboTfKksNLC21jB2Y+XLRlKEzu73ldEsrEFN28XJgX+lOcZasqpMI/xpsaYsPTwtJeSTMsBuW9yEFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oatGnKS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oatGnKS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53968C4CEC6;
	Tue, 15 Oct 2024 12:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996946;
	bh=3w6wGSORqcmCxn5P2LBtOD0Aoaq4hYnaNMJeLvKxJY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oatGnKS4cELKqXCYuVD1Wu1fq1Yf+xmW5k5TnPy83AtBakx7h8UpsBm7WrGSEBYTW
	 w/t7+1XZ3ecDYoQf5CnDgU611b96ZvDzv0zeckA/Bhfl9gM3U1mDio2nVyIasZyvq0
	 7/oN5nObCnxdY5vtawA041mJJahuKsoPDbG/lVkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 046/518] netfilter: nf_tables: missing iterator type in lookup walk
Date: Tue, 15 Oct 2024 14:39:10 +0200
Message-ID: <20241015123918.789171662@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit efefd4f00c967d00ad7abe092554ffbb70c1a793 upstream.

Add missing decorator type to lookup expression and tighten WARN_ON_ONCE
check in pipapo to spot earlier that this is unset.

Fixes: 29b359cf6d95 ("netfilter: nft_set_pipapo: walk over current view on netlink dump")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_lookup.c     |    1 +
 net/netfilter/nft_set_pipapo.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -207,6 +207,7 @@ static int nft_lookup_validate(const str
 		return 0;
 
 	iter.genmask	= nft_genmask_next(ctx->net);
+	iter.type	= NFT_ITER_UPDATE;
 	iter.skip	= 0;
 	iter.count	= 0;
 	iter.err	= 0;
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2030,7 +2030,8 @@ static void nft_pipapo_walk(const struct
 	struct nft_pipapo_field *f;
 	int i, r;
 
-	WARN_ON_ONCE(iter->type == NFT_ITER_UNSPEC);
+	WARN_ON_ONCE(iter->type != NFT_ITER_READ &&
+		     iter->type != NFT_ITER_UPDATE);
 
 	rcu_read_lock();
 	if (iter->type == NFT_ITER_READ)


