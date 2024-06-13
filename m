Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48F5143870;
	Thu, 13 Jun 2024 11:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279148; cv=none; b=MRGqUm/poKWGaxtVKIK62TEtoeinV+QOMQmk9JDoMw73QM08sn29uRcMPjztEhSRkftC7FJt7YmCgepIVgC7ukOdo2FobYazB2uTGs2C/kO/vByizu7mOysDVPcwa0o+n6wP+sj5Hut5Mu5lKF2Sg4esziXZPpLGC8KKJjmgflQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279148; c=relaxed/simple;
	bh=lADNaDvuqA/mWyB9GkvLDo17Zn1ONPyao4aL3eUD5UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4UWTvNVQEXHHyjCXVGV1zdCbWpkpM/f0FQVLcUfCtt22gJ4pK9lcPQBm35vz19pz/1cZI8n2VCzi39upZtXu19UP8FkI5I2xgVhMgSXpLqvmFx4mW+PCEZjO3epGHVKCLkUczFOJkglg+pyLowxkQ/xXe1LKo6tmn93echRcpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+EdnTtz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+EdnTtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F82C2BBFC;
	Thu, 13 Jun 2024 11:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279148;
	bh=lADNaDvuqA/mWyB9GkvLDo17Zn1ONPyao4aL3eUD5UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+EdnTtzGI5dSi8OtQ23xtSeY+CkK4ccespDhSNOdv2aejIkpAzxmdjSrX+F3xOQL
	 vQQEcqm4rTQNZistoNDO4qRgl3gk4ZMRK+rE2B7LICAGcPCPw6sewr1P7GEcX4uDhS
	 uCoRTGlU4pUvqvrFSg1zomvk7ody5JHIDug+tGEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lonial con <kongln9170@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 192/213] netfilter: nft_set_rbtree: skip end interval element from gc
Date: Thu, 13 Jun 2024 13:34:00 +0200
Message-ID: <20240613113235.383057906@linuxfoundation.org>
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

commit 60c0c230c6f046da536d3df8b39a20b9a9fd6af0 upstream.

rbtree lazy gc on insert might collect an end interval element that has
been just added in this transactions, skip end interval elements that
are not yet active.

Fixes: f718863aca46 ("netfilter: nft_set_rbtree: fix overlap expiration walk")
Cc: stable@vger.kernel.org
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_rbtree.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -240,8 +240,7 @@ static void nft_rbtree_gc_remove(struct
 
 static int nft_rbtree_gc_elem(const struct nft_set *__set,
 			      struct nft_rbtree *priv,
-			      struct nft_rbtree_elem *rbe,
-			      u8 genmask)
+			      struct nft_rbtree_elem *rbe)
 {
 	struct nft_set *set = (struct nft_set *)__set;
 	struct rb_node *prev = rb_prev(&rbe->node);
@@ -260,7 +259,7 @@ static int nft_rbtree_gc_elem(const stru
 	while (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
 		if (nft_rbtree_interval_end(rbe_prev) &&
-		    nft_set_elem_active(&rbe_prev->ext, genmask))
+		    nft_set_elem_active(&rbe_prev->ext, NFT_GENMASK_ANY))
 			break;
 
 		prev = rb_prev(prev);
@@ -368,7 +367,7 @@ static int __nft_rbtree_insert(const str
 		 */
 		if (nft_set_elem_expired(&rbe->ext) &&
 		    nft_set_elem_active(&rbe->ext, cur_genmask)) {
-			err = nft_rbtree_gc_elem(set, priv, rbe, genmask);
+			err = nft_rbtree_gc_elem(set, priv, rbe);
 			if (err < 0)
 				return err;
 


