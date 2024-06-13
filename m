Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8514A142E9D;
	Thu, 13 Jun 2024 11:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279104; cv=none; b=gWqWByEE90+0JEzXviRy1s35MwKbIFhkSqj8eXufjEKaFbNEXwkXfQxCusi8sYDmlCvyrBmNJVRpG8wu78AZXpZsjL0AkPTE003XgkeRY+fStzhK9287ipR2OWtDtctaBQc2upzfZqkfzo6a2sJFf4XwLSx1sFKCYvYoSuoc9qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279104; c=relaxed/simple;
	bh=+uZ6l5o+t/qHWl1p02kpj55lgJvVKMwlKB+c6NqaTAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUDpIIgFtZlJewPA9CpkzPYjSgLjTcx6tba/SPtrjOF/M6f2ZmE/DvcTDRYHAlWTDi9m2ZHQMqIxNkkDRy2eEsmxoJL7YbVL1aQOcH1WnmuvFzdX2Q/2BILV2jOTtr5CXBQCKjKIAgTrb4GggEv+pd3P33ZraiHpHjoTK4ocltk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X59eJAPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X59eJAPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D951C2BBFC;
	Thu, 13 Jun 2024 11:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279104;
	bh=+uZ6l5o+t/qHWl1p02kpj55lgJvVKMwlKB+c6NqaTAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X59eJAPEvVtWGswya2vOxD4VOl8BbWOZO5WTSQGmHBh9udiLpCv1ZkFnRk9uuJ00i
	 bujWDasVbEPvtLoyzhs3PNJcDhqKP61V86Eq9E59Gi4A/nvla2cxQ44I0CVS/lPVAg
	 E8hd09MHjkc9uxtVy59wbB6hdBWMb0ehJFMpLULY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 4.19 175/213] netfilter: nft_set_rbtree: skip sync GC for new elements in this transaction
Date: Thu, 13 Jun 2024 13:33:43 +0200
Message-ID: <20240613113234.732818386@linuxfoundation.org>
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

commit 2ee52ae94baabf7ee09cf2a8d854b990dac5d0e4 upstream.

New elements in this transaction might expired before such transaction
ends. Skip sync GC for such elements otherwise commit path might walk
over an already released object. Once transaction is finished, async GC
will collect such expired element.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_rbtree.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -317,6 +317,7 @@ static int __nft_rbtree_insert(const str
 	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
 	struct rb_node *node, *next, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
+	u8 cur_genmask = nft_genmask_cur(net);
 	u8 genmask = nft_genmask_next(net);
 	int d, err;
 
@@ -362,8 +363,11 @@ static int __nft_rbtree_insert(const str
 		if (!nft_set_elem_active(&rbe->ext, genmask))
 			continue;
 
-		/* perform garbage collection to avoid bogus overlap reports. */
-		if (nft_set_elem_expired(&rbe->ext)) {
+		/* perform garbage collection to avoid bogus overlap reports
+		 * but skip new elements in this transaction.
+		 */
+		if (nft_set_elem_expired(&rbe->ext) &&
+		    nft_set_elem_active(&rbe->ext, cur_genmask)) {
 			err = nft_rbtree_gc_elem(set, priv, rbe, genmask);
 			if (err < 0)
 				return err;


