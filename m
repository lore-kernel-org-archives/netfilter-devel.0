Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99246AFAE;
	Thu, 13 Jun 2024 11:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279062; cv=none; b=WyjLLqxk4jcQRH30b7N72rdg8XlCIOAFSFdVo9t+6AY4Bo/aW8j13YxGQ762GXT9cFnOq23vzuxH2W66kcmHLTD5zmDR8NxDckd8VGNmOg4bpV0wkE1+DZ1CYBwE0PEkxKNC08tDO+X+lzFr5yVwPa2yBf9l2tK6wAj9WbCifRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279062; c=relaxed/simple;
	bh=/UkPdgpfkdvOwIP0sy7KZN5od/70P2NWz7uth69vi6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaeGV3OiQ0TZBQ9W/jAM0zWyLxBW4O3bG6KhC5g+LOstqOhttu7mMMDp5wups6SM/DrMfab6T5xmRI35uJyeZeUwkbo6wg314ilEpbwGnLia4FQ8VbX9xjtxnJtkMdJLU7CLmJK7mhJK1dNkSQvGeOdh0ykSUJndaqQ23hOJu8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDYCbVA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDYCbVA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E399C2BBFC;
	Thu, 13 Jun 2024 11:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279061;
	bh=/UkPdgpfkdvOwIP0sy7KZN5od/70P2NWz7uth69vi6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDYCbVA0bZRE4fNJDLAMT9fmQoX2cMsL5hqQPkGUptFEnQXBVHlQQxdz3RIBS3mMF
	 xtnlWqZoN5b8fmixnxMRIJByMyNGJ74d61J6IeVtDZteN47hhLCV2/x5i0Iv3L23Xd
	 nKesiZLN9SOj1yz02QfD+TYSydyAVeZIH6IkdDK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 163/213] netfilter: nft_set_rbtree: Add missing expired checks
Date: Thu, 13 Jun 2024 13:33:31 +0200
Message-ID: <20240613113234.273495970@linuxfoundation.org>
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

From: Phil Sutter <phil@nwl.cc>

commit 340eaff651160234bdbce07ef34b92a8e45cd540 upstream.

Expired intervals would still match and be dumped to user space until
garbage collection wiped them out. Make sure they stop matching and
disappear (from users' perspective) as soon as they expire.

Fixes: 8d8540c4f5e03 ("netfilter: nft_set_rbtree: add timeout support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_rbtree.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -82,6 +82,10 @@ static bool __nft_rbtree_lookup(const st
 				parent = rcu_dereference_raw(parent->rb_left);
 				continue;
 			}
+
+			if (nft_set_elem_expired(&rbe->ext))
+				return false;
+
 			if (nft_rbtree_interval_end(rbe)) {
 				if (nft_set_is_anonymous(set))
 					return false;
@@ -97,6 +101,7 @@ static bool __nft_rbtree_lookup(const st
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
+	    !nft_set_elem_expired(&interval->ext) &&
 	    nft_rbtree_interval_start(interval)) {
 		*ext = &interval->ext;
 		return true;
@@ -157,6 +162,9 @@ static bool __nft_rbtree_get(const struc
 				continue;
 			}
 
+			if (nft_set_elem_expired(&rbe->ext))
+				return false;
+
 			if (!nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) ||
 			    (*nft_set_ext_flags(&rbe->ext) & NFT_SET_ELEM_INTERVAL_END) ==
 			    (flags & NFT_SET_ELEM_INTERVAL_END)) {
@@ -173,6 +181,7 @@ static bool __nft_rbtree_get(const struc
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
+	    !nft_set_elem_expired(&interval->ext) &&
 	    ((!nft_rbtree_interval_end(interval) &&
 	      !(flags & NFT_SET_ELEM_INTERVAL_END)) ||
 	     (nft_rbtree_interval_end(interval) &&
@@ -360,6 +369,8 @@ static void nft_rbtree_walk(const struct
 
 		if (iter->count < iter->skip)
 			goto cont;
+		if (nft_set_elem_expired(&rbe->ext))
+			goto cont;
 		if (!nft_set_elem_active(&rbe->ext, iter->genmask))
 			goto cont;
 


