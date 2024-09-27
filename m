Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D1018C005;
	Fri, 27 Sep 2024 12:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439984; cv=none; b=UpX5p3rEil5fuZSMTx8y8s2dR3F20XADiUw6HuFLBJS7D5AR4lI1/jvOXwSZYi4EMR7qjdgnKqrGANlpLeT4ZVDJgZqrmv/KwGmKX/O6gybr5pFLCt9bFtPRg/zZminNb4AwUV+fjm3lWXeoiuKei1fOooyro0F62eCn8/UYQvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439984; c=relaxed/simple;
	bh=bJ5+0tITocmPGWOxVvYOTPwZA8Efx3Kyn//V2TOgmZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnOp+Ex8sQH81TEXo8wR1HCbj0x/YpQhCVzcI4EkW5zDXT92qNIaOuXPbZbakoLRlApP/Ik48webMsoaF1AAPi5VDIRnyBLN2wr0qIv3yCuiax6mz/0L7gjnG5yUDKXBgHuafYGbE8U5RKRx6IKIWa4uVLEJwyUjSqM6/Q5Qxdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0miKZGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0miKZGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E82C4CEC4;
	Fri, 27 Sep 2024 12:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439983;
	bh=bJ5+0tITocmPGWOxVvYOTPwZA8Efx3Kyn//V2TOgmZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0miKZGizmx+q5BI4R5spk+rdzlKE0yT08MSk510E7gUtjQKLKSCZi3eETRIduxzh
	 WizAZudioZJ5bofcM6LlkcrF8qYneoclcTISg9KCY0X+HU1nFx68PEVC+lrNRSeiSt
	 D/5MN8R2PnRwrsJFrymDlShFFiODCuiCTgHeeTIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 46/54] netfilter: nf_tables: missing iterator type in lookup walk
Date: Fri, 27 Sep 2024 14:23:38 +0200
Message-ID: <20240927121721.662047598@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -217,6 +217,7 @@ static int nft_lookup_validate(const str
 		return 0;
 
 	iter.genmask	= nft_genmask_next(ctx->net);
+	iter.type	= NFT_ITER_UPDATE;
 	iter.skip	= 0;
 	iter.count	= 0;
 	iter.err	= 0;
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2041,7 +2041,8 @@ static void nft_pipapo_walk(const struct
 	const struct nft_pipapo_field *f;
 	int i, r;
 
-	WARN_ON_ONCE(iter->type == NFT_ITER_UNSPEC);
+	WARN_ON_ONCE(iter->type != NFT_ITER_READ &&
+		     iter->type != NFT_ITER_UPDATE);
 
 	rcu_read_lock();
 	if (iter->type == NFT_ITER_READ)


