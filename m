Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDB613D512;
	Thu, 13 Jun 2024 11:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279110; cv=none; b=M6f/lD/OGzCc9lzGNlq6rpwS7BrZAjYW7qwbiDTa7B7397aYQvo0GamT7JlRLnGDmVck91h+EmWb1cFNrlyzlFX0UeU5zDS214M2jLqMTRXa84/ES5HM2cSo4H9C8b3RkwFsh0DMbGvWKr8uyLrXmvVKjFbUeeLlKkv4Cu8upy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279110; c=relaxed/simple;
	bh=HBBs5CoGwVFGRESJ9yRfVe11uKHJr0Nm66fr8CJ6GJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8HiZ78cg80VoC6KydO0bkYHKaKiv0ZXuKnw3s8o0PFF9ERFXJghZy+6phvDnyXlchXN16CFZPV/uAWtFHClKSkG0ojUhqKMQUkcMkHfTajBGPmwEEH8zNVt1ZPF5Bwya1xBeShOJT8smumq4t4ffMooM+nGDYCNJYvr+a2o5IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYUepyai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYUepyai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C19C2BBFC;
	Thu, 13 Jun 2024 11:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279110;
	bh=HBBs5CoGwVFGRESJ9yRfVe11uKHJr0Nm66fr8CJ6GJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYUepyai/uFWuA83OnwvJajLy2FdlS+mTSos9ZunRHl3uWGrTteVdeaY/4FXQ8yu1
	 D6pSC/GbcdwdcFhk3zVVdCIGgOw8mgPIvVjDkuxE3127dtkGc2msIK+vrzdkWFMRuv
	 xJLwxPNt+TBidnz7M2STPP3uCUgB5BY1X8EoAjbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 177/213] netfilter: nft_set_hash: try later when GC hits EAGAIN on iteration
Date: Thu, 13 Jun 2024 13:33:45 +0200
Message-ID: <20240613113234.809174208@linuxfoundation.org>
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

commit b079155faae94e9b3ab9337e82100a914ebb4e8d upstream.

Skip GC run if iterator rewinds to the beginning with EAGAIN, otherwise GC
might collect the same element more than once.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_hash.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -321,12 +321,9 @@ static void nft_rhash_gc(struct work_str
 
 	while ((he = rhashtable_walk_next(&hti))) {
 		if (IS_ERR(he)) {
-			if (PTR_ERR(he) != -EAGAIN) {
-				nft_trans_gc_destroy(gc);
-				gc = NULL;
-				goto try_later;
-			}
-			continue;
+			nft_trans_gc_destroy(gc);
+			gc = NULL;
+			goto try_later;
 		}
 
 		/* Ruleset has been updated, try later. */


