Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0877039FE7;
	Fri, 24 Nov 2023 19:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gH3qva9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45435C433C8;
	Fri, 24 Nov 2023 19:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700854121;
	bh=+P4zY6DQ8jM+3G1ZpOgGgcu8mr1meQBIPDkkHfQKsII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gH3qva9AXzy0iE9PdqVWYnNPE/4wmMCK0qiRsM/8eZYoSnSv+HJznTFcS+SI1kJCd
	 aJnBLJzLYn+AUEE4bJHTfj3hpcA9CQMSZGUufG1sDt0OkWqcQVDso1zhTDPqZ03COS
	 eKqdbc/+AGLuNBTc/afCozfldVf9Yzd49KxxiJug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 152/159] netfilter: nft_set_hash: try later when GC hits EAGAIN on iteration
Date: Fri, 24 Nov 2023 17:56:09 +0000
Message-ID: <20231124171948.115541269@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -324,12 +324,9 @@ static void nft_rhash_gc(struct work_str
 
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


