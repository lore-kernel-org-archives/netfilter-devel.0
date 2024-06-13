Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6EF143C6D;
	Thu, 13 Jun 2024 11:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279139; cv=none; b=WuLPEKkm0XpcipVDM0wkRT/j/9FHQuUYBnDDfR3/o1SvumVIQzLgkFTVvxsiJL3TPDCZZBu6oV52O5UMKMPff69cH1aqSm9MjBArL8DR9s2JyLHmr63xpBRK3NEfsZ+WqqnqbJgeBRjJfPhACSpPJ4zF+MmuqU1WtQb3eA8AZ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279139; c=relaxed/simple;
	bh=7u6ABA55JaGctoDzT1Q7whu7FJbMsJ+IFU5trrLuBuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdh54VdLHPCbEjwkTgSvf4sADaJM8oBiWjWaTWG0O2gtJwuNUuiqOvOICyvxG4kNKZ9oblSCw9MIh952FlylDjycY73Eaw9MHWYtyd68Y0/mkgMuQSvJ4EN9UCzdy6JM5vWxJFwl2alDyuAB4RGlcNheRMQjQ2s2QYP9WXQ7j80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8j0uiOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8j0uiOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265AAC2BBFC;
	Thu, 13 Jun 2024 11:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279139;
	bh=7u6ABA55JaGctoDzT1Q7whu7FJbMsJ+IFU5trrLuBuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8j0uiOlSZWA82NwenZQ0MBiovHS5IXXw74/1SxS/VoyesExyEAf+C+jIJAMwKEyr
	 nI0ND4BjRm6RzRTzYllCBtm3nw6b3MFrmtQhRcBYqrinm9xn6VpmzTgxApYrSoy9Qm
	 ZHP0lJbEEtkZ+V/NI3mr8duqMmcsolvXhKnh67aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 189/213] netfilter: nf_tables: mark newset as dead on transaction abort
Date: Thu, 13 Jun 2024 13:33:57 +0200
Message-ID: <20240613113235.268891052@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 08e4c8c5919fd405a4d709b4ba43d836894a26eb ]

If a transaction is aborted, we should mark the to-be-released NEWSET dead,
just like commit path does for DEL and DESTROYSET commands.

In both cases all remaining elements will be released via
set->ops->destroy().

The existing abort code does NOT post the actual release to the work queue.
Also the entire __nf_tables_abort() function is wrapped in gc_seq
begin/end pair.

Therefore, async gc worker will never try to release the pending set
elements, as gc sequence is always stale.

It might be possible to speed up transaction aborts via work queue too,
this would result in a race and a possible use-after-free.

So fix this before it becomes an issue.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7254,6 +7254,7 @@ static int __nf_tables_abort(struct net
 				nft_trans_destroy(trans);
 				break;
 			}
+			nft_trans_set(trans)->dead = 1;
 			list_del_rcu(&nft_trans_set(trans)->list);
 			break;
 		case NFT_MSG_DELSET:


