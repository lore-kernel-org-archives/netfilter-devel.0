Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351D829290A;
	Fri, 23 May 2025 13:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006899; cv=none; b=IM0O0ttRL8FMEMz53m1rZ9U6IyyD9IA9340ZQ9czVuAoGrobnflQVSa99yKSkOTjDOyTDHJNR76Ct3xZHD5u+MKwd/Yn521DFrd6Ip/B7hAWBEngS2cGPso4T5vaPfuhrWZwZA3LdkdrW1J4I9HY1KxscreY2A9g+cV8brfXsSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006899; c=relaxed/simple;
	bh=YTQkkBdSYR0sLvFJmz+slPCpEG8Olu/hJDlShWzuMzM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pmzOc4O4NIYl7e15GEGrPD0ayHI5YlvyUkOGBWU9LIwx4Tp4zDbxLvsZ3JhB6NXvBl2NSl5+6LwUrWNXsLWdRePjhSMJoIDdxl1Jgn4nI1/+j2XkOsnszbcT3sfM5rbiDJSMtoeO88XnaaGGM9USxW7usfBc1HiU/Z0TyIA4KcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Gohqs6Zw; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pWbszll6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Gohqs6Zw";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pWbszll6"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1B414606EE; Fri, 23 May 2025 15:28:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006897;
	bh=M10CYrYELJAAawWtKW96cgRgBk5ZbCjGsSXLf/LHIPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gohqs6Zw0Ca9sX3dZ5qfB5iMcss9ABPDeghEinb/BkG6vwjGrK/B7JtviGO49qh32
	 Ee1GJdwL1+2RBUJ5NlYPacBIqch4vBRN/GFLjHSbqKU/R+zrSgsxOSwnJaj9+ZiNA+
	 z4T+LJsXx77VDUVFqcro2EEF3/sjk8Zkzw84IdfwDqKPup4pdvo7mSJup1W9rIr2mF
	 1cTmWKHSVSzszzIB8QRBTqUNklM85l2qkR8ouqt433AknibdDzyMfkeo9Fh1LMbbRR
	 m87lhAULSn0Dciqkky1R/UbGYZPvuJwZDBcqdZsU9/GhhyfLs16MBHMtgcJFqte1aJ
	 tRCsIUT2XmROA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4C8446077B;
	Fri, 23 May 2025 15:27:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006855;
	bh=M10CYrYELJAAawWtKW96cgRgBk5ZbCjGsSXLf/LHIPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWbszll6+t11oRLS6Z+VBALbmp5EEABhua2fna06X7UH0Y8HqpRQ7gh7AmZyTaIbu
	 HTf3PjXEeYtNw04BdbyKN5SPWdNQ+L4H/sKYnniWb0WtB2AcTsbSCEEieUzVJUQZog
	 K+9gMGqEtUWal8kbBoTEvFxPPCx3+VH3AOPuHSjtAC6Z5KZwGmnW4N06JA7K6Nimfw
	 bhjFWXIr7eYfdDv8qX0QEzYdWeig+Ml9ap5JC+VjWGWbzugo7MFCrgAKjxFrwzPDP0
	 Gh8I3yBqUxEj3Zen5mhXaxLKzulkKLfM1Eb9xnRxJtLewx4zTDEOkQic78CuO2JGI4
	 iWdxj9PdOzZYQ==
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
Date: Fri, 23 May 2025 15:27:09 +0200
Message-Id: <20250523132712.458507-24-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250523132712.458507-1-pablo@netfilter.org>
References: <20250523132712.458507-1-pablo@netfilter.org>
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

