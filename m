Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83C4143C57;
	Thu, 13 Jun 2024 11:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279059; cv=none; b=bD7jPFx/c6lZZ49121vZkzykYl9Zzs1jM827d4HrBOhZaUix5nRx8YcX+hqBe7JAhmo/T4jOKOI68aKv9ZinuXYlgYKsGhjjvek2Sc6VaCkjcas7Q+4+Hlw6+U/TgSvFHMY0P7bgcqikgzNVF2BMNyLOj7SRvDATddmw5EXJSgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279059; c=relaxed/simple;
	bh=s60ISix6Vsi7GCOGz3FVq7HUKg6z0F/gwrw8e07tYvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USAjY4mIFGhr3QU/d+TWclfpHMFd5v00DXIgVwYp4UAvlbgdgYxnhpvaSrJxlpjIj5/KGq3A7u/D8gi8Zr8VgnRP8Ii+n65qPVK6dm7opzp9sExfl8Ru+mikX7voz+J8UoemC6meBnAdKDU5FgHSBVJK2r3k08xwseCnVnD5YFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtiswgsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtiswgsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A98AC2BBFC;
	Thu, 13 Jun 2024 11:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279058;
	bh=s60ISix6Vsi7GCOGz3FVq7HUKg6z0F/gwrw8e07tYvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtiswgsFUowo6A0qO3ghaFH1njREdAtp3aKCsPS0s+nWcrQjRpWix38alRgPdoeKM
	 N12TDizQ06Ul3jVWEZjQ9vt4iqKYYjVHfCsb2sP0+CdznzafrahZvj6+k00sbLzUMd
	 pi5jQcuTEDtaZHPy9qCOYkNJwurTQwvJ4TZO2YyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 162/213] netfilter: nft_set_rbtree: allow loose matching of closing element in interval
Date: Thu, 13 Jun 2024 13:33:30 +0200
Message-ID: <20240613113234.235313330@linuxfoundation.org>
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

commit 3b18d5eba491b2328b31efa4235724a2354af010 upstream.

Allow to find closest matching for the right side of an interval (end
flag set on) so we allow lookups in inner ranges, eg. 10-20 in 5-25.

Fixes: ba0e4d9917b4 ("netfilter: nf_tables: get set elements via netlink")
Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_rbtree.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -145,9 +145,12 @@ static bool __nft_rbtree_get(const struc
 		d = memcmp(this, key, set->klen);
 		if (d < 0) {
 			parent = rcu_dereference_raw(parent->rb_left);
-			interval = rbe;
+			if (!(flags & NFT_SET_ELEM_INTERVAL_END))
+				interval = rbe;
 		} else if (d > 0) {
 			parent = rcu_dereference_raw(parent->rb_right);
+			if (flags & NFT_SET_ELEM_INTERVAL_END)
+				interval = rbe;
 		} else {
 			if (!nft_set_elem_active(&rbe->ext, genmask)) {
 				parent = rcu_dereference_raw(parent->rb_left);
@@ -170,7 +173,10 @@ static bool __nft_rbtree_get(const struc
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
-	    !nft_rbtree_interval_end(interval)) {
+	    ((!nft_rbtree_interval_end(interval) &&
+	      !(flags & NFT_SET_ELEM_INTERVAL_END)) ||
+	     (nft_rbtree_interval_end(interval) &&
+	      (flags & NFT_SET_ELEM_INTERVAL_END)))) {
 		*elem = interval;
 		return true;
 	}


