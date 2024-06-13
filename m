Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA5413541B;
	Thu, 13 Jun 2024 11:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279107; cv=none; b=a8x02ocRZE1m+RbtnruRKCLlhLKTEWEZrd8mzoRhhpRmJKxuWaRxOiD3Uj4Z+A0xxIbnBeAmBf2kGi/sq3zLS4zyBUH2CXbzu2m6WzjSu/QrJfgwsGwTsauXR9NHVPI5Bz1VPEQUsGSJM3LxN+n80Xqqf9e6ltZsZEib19/UDvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279107; c=relaxed/simple;
	bh=Hm0JQkloxGWBkVlLc175kiihDz2+M8z4y5K1OG9vsB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkubO41T7iwQOPCv/GiwCH5c3EDBIkUFpN915QuvcrebU7Ktl8mPiAbYphzPU58onwfh7LX+ZzlbfDxBGQ/g+8NvkwjLRHWaokDyz/evbdfh/XH2sy943zmpdfdYNcLSgeOUzc3t909OkZkEMsABywpbAhVqC5q4VPSB5UzNk4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsnyJdIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsnyJdIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E05C2BBFC;
	Thu, 13 Jun 2024 11:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279107;
	bh=Hm0JQkloxGWBkVlLc175kiihDz2+M8z4y5K1OG9vsB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsnyJdIKZvjAtItiXse8/raIbKv4ReiBKs/yqBgmE/qND0AG17pQH2gxLVwQ23j++
	 Qc8OqaFRmkU7nK1+m8/g88yZ+58lrRvWLMSq5exKyNs9X6B0QqGd22XugfIQQgeuWW
	 Fmg3+8Ko+rOb2ITHkbWspKsE4qAPAPVWiAySdYjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 176/213] netfilter: nft_set_rbtree: use read spinlock to avoid datapath contention
Date: Thu, 13 Jun 2024 13:33:44 +0200
Message-ID: <20240613113234.770708190@linuxfoundation.org>
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

commit 96b33300fba880ec0eafcf3d82486f3463b4b6da upstream.

rbtree GC does not modify the datastructure, instead it collects expired
elements and it enqueues a GC transaction. Use a read spinlock instead
to avoid data contention while GC worker is running.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_rbtree.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -629,8 +629,7 @@ static void nft_rbtree_gc(struct work_st
 	if (!gc)
 		goto done;
 
-	write_lock_bh(&priv->lock);
-	write_seqcount_begin(&priv->count);
+	read_lock_bh(&priv->lock);
 	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
 
 		/* Ruleset has been updated, try later. */
@@ -679,8 +678,7 @@ dead_elem:
 	}
 
 try_later:
-	write_seqcount_end(&priv->count);
-	write_unlock_bh(&priv->lock);
+	read_unlock_bh(&priv->lock);
 
 	if (gc)
 		nft_trans_gc_queue_async_done(gc);


