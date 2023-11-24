Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0B928DBB;
	Fri, 24 Nov 2023 19:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ei4kC60V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE23AC433C8;
	Fri, 24 Nov 2023 19:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700854094;
	bh=mgxJFFTi3bhwE/ceZbNm3sJQMpiMtBvZTLWTrk7by/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ei4kC60VIzh6kruzSc25+06xEeiwSS6x2EL9ydewDinHvtnUEZ5il4Z2JoZAIlSoj
	 +pxYn/a7OxLh5pF3zsSx4EJ9hZRbI7E42GpJ44gtTMeFYg1vVxjiDTUFe44Wf3m7mc
	 WxzGFEO+Gs6ItsmO1BO2asd9f30OfM+ONeNj1gIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.4 146/159] netfilter: nf_tables: GC transaction race with netns dismantle
Date: Fri, 24 Nov 2023 17:56:03 +0000
Message-ID: <20231124171947.874417474@linuxfoundation.org>
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

commit 02c6c24402bf1c1e986899c14ba22a10b510916b upstream.

Use maybe_get_net() since GC workqueue might race with netns exit path.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7052,9 +7052,14 @@ struct nft_trans_gc *nft_trans_gc_alloc(
 	if (!trans)
 		return NULL;
 
+	trans->net = maybe_get_net(net);
+	if (!trans->net) {
+		kfree(trans);
+		return NULL;
+	}
+
 	refcount_inc(&set->refs);
 	trans->set = set;
-	trans->net = get_net(net);
 	trans->seq = gc_seq;
 
 	return trans;


