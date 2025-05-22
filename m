Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528812BCF40;
	Thu, 22 May 2025 16:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932818; cv=none; b=rhTevhcUNOBJVHxPpME4qCgLEE0Zc1fxvLEGK1Z8tPNAp0m4W96q5hnLGbHT1CUlF0MuLY2hgt6YFmh3gsdJhI6Psvd48rPQDsCNdsOahx3+g2bOQhBXQJ0S/lMD6kckrSpBrcdiXh1oI/fW2y2R6YLNuYkC/S8l9EIaPTceyS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932818; c=relaxed/simple;
	bh=YTQkkBdSYR0sLvFJmz+slPCpEG8Olu/hJDlShWzuMzM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=csfbQxAWPiAAzNlc2vBJEvQD6X5692t/xOdaBlINBsuHHDlePw82xjTUF3/EhmFMAbvaFvBQ+4h53flVZgqOZ4hl2B0LMOoyuAkBzgeH5UyBBIFa8J1TWNAqVkx4zKiw4Om1clky49Ds2xwpoaPdxpJhKf02wDASk3wTL2i2S/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LaMJAPw5; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jE1tQsHm; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LaMJAPw5";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jE1tQsHm"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D542A6070A; Thu, 22 May 2025 18:53:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932815;
	bh=M10CYrYELJAAawWtKW96cgRgBk5ZbCjGsSXLf/LHIPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LaMJAPw5FcLPOYrRtaX9uBq5XbnhdQqmvYR3ULk4ooqDyyJktVCo5tLRXVF+aCxrE
	 tbq8J/3MJX38OWYFOwLR47gHM/hhbt4B6RiuK6dtTdgCGjOIH5reoSA0fQtk1vsuPN
	 zMb9V1zUstd0ZFiL13hV63Biby1UUOqh61KVE3wk8qcTjLEj4ckRhkp1HNuXONQJT+
	 6sg5meliJf0s1PurFr+2gmmpaENWxQrdvFVNPMzI+DUxYeYJYFMrsIyU/nSMFPbz8T
	 zIUrYsi8wg8h9FabWktd+N90XHoQZk7VqVL+GkYXb830zLeP84KZG96xPM+w8wJ9gF
	 aZYWVZ5nZUNHg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5904E6074A;
	Thu, 22 May 2025 18:53:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932782;
	bh=M10CYrYELJAAawWtKW96cgRgBk5ZbCjGsSXLf/LHIPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jE1tQsHmHNUVr/VlheHnROXfOjtkZHNa+JM+h7De3dS4+7FTF9uDAglPy2jD3vzZn
	 wyhRC+J3c42zqA/hAX+jeBR2RkkTsliebIH+eLq75X2hdJa1hYLU8DEYEmGkH76V9n
	 hRQTUAyEUuRlkpkcrNph+AbjRmQx73z5XlmQwT9ILW6s7y7l91NXl0i/MANPJ9XFZ1
	 ArjbNkMLK6h6jazCJvL2mCxqLPdEdMrhkK/x3atfKcPlMBsAXoTQY1qo34Czoxws8n
	 btMOu1zZHzXmLFSNDzZlXdXdeT/8Gh9YuNaXHBdRDneDLS9qBqBbYAclad972nVSsj
	 TrbWmi/LElLdg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 23/26] netfilter: nf_tables: Sort labels in nft_netdev_hook_alloc()
Date: Thu, 22 May 2025 18:52:35 +0200
Message-Id: <20250522165238.378456-24-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

No point in having err_hook_alloc, just call return directly. Also
rename err_hook_dev - it's not about the hook's device but freeing the
hook itself.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 452f8a42d5e6..fabc82c98871 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2315,15 +2315,14 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	int err;
 
 	hook = kzalloc(sizeof(struct nft_hook), GFP_KERNEL_ACCOUNT);
-	if (!hook) {
-		err = -ENOMEM;
-		goto err_hook_alloc;
-	}
+	if (!hook)
+		return ERR_PTR(-ENOMEM);
+
 	INIT_LIST_HEAD(&hook->ops_list);
 
 	err = nla_strscpy(hook->ifname, attr, IFNAMSIZ);
 	if (err < 0)
-		goto err_hook_dev;
+		goto err_hook_free;
 
 	hook->ifnamelen = nla_len(attr);
 
@@ -2334,22 +2333,21 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	dev = __dev_get_by_name(net, hook->ifname);
 	if (!dev) {
 		err = -ENOENT;
-		goto err_hook_dev;
+		goto err_hook_free;
 	}
 
 	ops = kzalloc(sizeof(struct nf_hook_ops), GFP_KERNEL_ACCOUNT);
 	if (!ops) {
 		err = -ENOMEM;
-		goto err_hook_dev;
+		goto err_hook_free;
 	}
 	ops->dev = dev;
 	list_add_tail(&ops->list, &hook->ops_list);
 
 	return hook;
 
-err_hook_dev:
+err_hook_free:
 	kfree(hook);
-err_hook_alloc:
 	return ERR_PTR(err);
 }
 
-- 
2.30.2

