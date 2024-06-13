Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EDE142911;
	Thu, 13 Jun 2024 11:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279092; cv=none; b=nFoZjDbUPE3lpwLMeWAV0NI5BWaMu59/3BszJETB2wBz0cjExjAaFxB7u9hqqLLUWrJvCGfJ9zFH1XCjGX8ebKP0Yv3MKZofAXYQC0nVIR5nYWxc1u/ufPCZcSAyTCQarg1CARH0u8bQIVgw3wyCGZ1RXDBg19s/Cn41c4ZUNHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279092; c=relaxed/simple;
	bh=sBKCQEQsP5lG/xFwUvDdfD6fwVLB9WnsQFdCwTPa1dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmhKkmuNtVgMwZgkTjZCojpPrv+o4lzL6SrLkuS6O9GkL2ZN30M/H7MLvtELr7kteKh0P+QIjFrtq2WVfEnnSKJ0V4DzerOHyNagisDEAcVRU8pTFsP4+5XCIqWW50RqmxH9JoEKDrsVQa+b62nlb9Yby0SDk5V6XUCe23biAlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOQHmA+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOQHmA+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D78C2BBFC;
	Thu, 13 Jun 2024 11:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279092;
	bh=sBKCQEQsP5lG/xFwUvDdfD6fwVLB9WnsQFdCwTPa1dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOQHmA+LxyF99v+JoU3r/+hWUk0KaN8I7xkFEDo2q+h10lK5h4kWt2/i6PF9h1TFS
	 9PPs01mboTWHMdFZqJ4xFwZysLVLLvSBj1Y37b6DEVTmN/mzUPd2BjGRPzRREsBe+l
	 A2P7PDYUkN4rU2NEv5vWRqjMFepPxcz2VEIJ12Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 4.19 172/213] netfilter: nf_tables: GC transaction race with netns dismantle
Date: Thu, 13 Jun 2024 13:33:40 +0200
Message-ID: <20240613113234.618721313@linuxfoundation.org>
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
@@ -6820,9 +6820,14 @@ struct nft_trans_gc *nft_trans_gc_alloc(
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


