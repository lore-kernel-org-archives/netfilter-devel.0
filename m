Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2074143870;
	Thu, 13 Jun 2024 11:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279151; cv=none; b=npCxeYQft/BBAfH1Hx82SbFcwu2rJ2DWdd8gaT0ZQfSQTRQH6frX0ZZRa4fb6IcwYC4XPh2zv5zEU31oTKdNi/h0gWT+ILdeD886WIJAKKZkAtb6oD3+57ShsnGOL0Cn1cJuxDV6NH2JmxJCI9+DrYuObtp3YBvkpgh1IfbBKcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279151; c=relaxed/simple;
	bh=DeUoA9VTQGrrA3I8puROcQdqb11qjEpmuvVxFbWNwAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thB4GlircA03u4DWPYDm7Lw7ry3DeoVjhIfrzj4lz+iQYgQaXc2+3eYHdvIaduQBlNaeWbqfZZI7SxQcoCnNveaBmb8GJ8Ca+nkJDq2rvHBl1p2DXj3hP8neE9RNHglMEPHeGMEA5gJ9+Lj1BNZt1lC2bUhRhDMY6R2n+LHv1Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQvDCpZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQvDCpZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E1CC2BBFC;
	Thu, 13 Jun 2024 11:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279151;
	bh=DeUoA9VTQGrrA3I8puROcQdqb11qjEpmuvVxFbWNwAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQvDCpZTVJ03eN4/jxBfhdmA9XHb0DytOI7dEO51z9dmYbLz9ImfuZuvHsLiwd++e
	 BHYzTzXdecjf7rKElKb4oTplYJCEsTdtVfDyCLy6FZb6CHrwZts0A0Iv+rh/rnur1W
	 3VFVZ8jdZnafMDPGaGAzzCz/og+yRFPJSLRzRCe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+de4025c006ec68ac56fc@syzkaller.appspotmail.com
Subject: [PATCH 4.19 193/213] netfilter: nf_tables: set dormant flag on hook register failure
Date: Thu, 13 Jun 2024 13:34:01 +0200
Message-ID: <20240613113235.422388419@linuxfoundation.org>
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

[ Upstream commit bccebf64701735533c8db37773eeacc6566cc8ec ]

We need to set the dormant flag again if we fail to register
the hooks.

During memory pressure hook registration can fail and we end up
with a table marked as active but no registered hooks.

On table/base chain deletion, nf_tables will attempt to unregister
the hook again which yields a warn splat from the nftables core.

Reported-and-tested-by: syzbot+de4025c006ec68ac56fc@syzkaller.appspotmail.com
Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -925,6 +925,7 @@ static int nf_tables_updtable(struct nft
 	return 0;
 
 err_register_hooks:
+	ctx->table->flags |= NFT_TABLE_F_DORMANT;
 	nft_trans_destroy(trans);
 	return ret;
 }


