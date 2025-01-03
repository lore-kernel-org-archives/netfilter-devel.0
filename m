Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 112891FBE9B
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jan 2025 17:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735925741; cv=none; b=FflGO7IOWN+yYWQYEBAl12S0+w2n31busKL45LCK4Twqywtm2T4eLjHyrzu2U469BsyJVeYgGRA+VofYZy3Vz9lf/JgjcRDFiR/Tjq1mNGynb6B2sbEBCM45DgEo+byoPh9s/VbRbdD+LOuvBGq//jNdyd5VcCKTND02tNU/YHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735925741; c=relaxed/simple;
	bh=j+bU1OmWNNHWGJFKo3Ft5GggVvf9GYT2R5AAVrN7nDc=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EtgBCC94hdu2osZud/4GTjH2wdMk/Bw6K2A/SUPizfN2H6p9RZCEFy4kU2PwZBSG9EZyOToPleoH6jTpZRSJHSMpZtLRNUCCQ2SW2vhTgTcd2jKXAkre4yQodpNuJdL4jHA587py/pmifKITgrBj5USDO7+02bdUINxZTe5aFxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
X-Spam-Level: 
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 6/7] mnl: do not send set size when set is constant set
Date: Fri,  3 Jan 2025 18:35:21 +0100
Message-Id: <20250103173522.773063-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250103173522.773063-1-pablo@netfilter.org>
References: <20250103173522.773063-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When turning element range into the interval representation based on
singleton elements for the rbtree tree set backend, userspace adjusts
the size to the internal kernel implementation.

For constant sets, this is leaking an internal kernel implementation
detail that is fixed by kernel patch ("netfilter: nf_tables: fix set
size with rbtree backend"). For non-constant sets, set size is just
broken.

This patch is required by the follow up patch ("src: rework singleton
interval transformation to reduce memory consumption").

On top of this, constant sets cannot be updated once they are bound, set
size is not useful in this case. Remove this implicit set size for
constant sets.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new in this series.

 src/mnl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 52085d6d960a..5983fd468e56 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1265,8 +1265,6 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		if (set->desc.size != 0)
 			nftnl_set_set_u32(nls, NFTNL_SET_DESC_SIZE,
 					  set->desc.size);
-	} else if (set->init) {
-		nftnl_set_set_u32(nls, NFTNL_SET_DESC_SIZE, set->init->size);
 	}
 
 	udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
-- 
2.30.2

