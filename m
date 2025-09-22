Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7806F1F91E3;
	Mon, 22 Sep 2025 19:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570539; cv=none; b=Gl9CrNv6bG6y9/2OyZSdA3gv/BYTPAZn70bnAdte7iJ5nHE1Ur3alASIS3daj3hwiPa8ehAjVfWCLk7zHYwRi9kziVFUD9pwQ+VrPQIhrYbH55jtt054/LP7DuTtf939Lipd/GZND8T4788fFbEGctN3QxYOlyJhSlZuX5O8btc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570539; c=relaxed/simple;
	bh=PU/XANUrK9hEk6kA9sjjUVfSRU1bJZRYU/1EfwVatis=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=plCUCsmgPS6/4dXBAaRYTPxbEY7hxrUhJLRu5P4eoueWVDzSUPZvwUin+LdNNFkil2djxf7NaIgXRCHx27A707GHvJPWae4sfnSoi2R2Y7+mOZ5WtcaGMWqf0x7yzT96NVSG4cwsJdZMgsCOAypPN3xfSPZN+8Riq40yDt6T2jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=CcO0io4Z; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="CcO0io4Z"
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:1621:0:640:12d9:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 16CC681063;
	Mon, 22 Sep 2025 22:48:46 +0300 (MSK)
Received: from d-tatianin-lin.yandex-team.ru (unknown [2a02:6bf:8080:c27::1:3a])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id TmcMU33Goa60-MnWz3v3K;
	Mon, 22 Sep 2025 22:48:45 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1758570525;
	bh=8znYj7PjmcES13vpMIwZBkpiyRK8HzACSb8RD6m3aD4=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=CcO0io4Zc9m2ZHccdeCYz6KJ0EhiS4maKBRJJMVHSWljMajloRT8N5R/ClHaiV4AV
	 1+V1EeV0OER9kNTiJlhOPDOk/2zvvlbi2RxgjJS0Y8AcMVLdgG9m6NmqcR+RGmozLi
	 wMQk8BLKLUWJN289u6aYC0asOmMxWaFq06hNubw0=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Daniil Tatianin <d-tatianin@yandex-team.ru>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 1/3] netfilter/x_tables: go back to using vmalloc for xt_table_info
Date: Mon, 22 Sep 2025 22:48:17 +0300
Message-Id: <20250922194819.182809-2-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250922194819.182809-1-d-tatianin@yandex-team.ru>
References: <20250922194819.182809-1-d-tatianin@yandex-team.ru>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This code previously always used vmalloc for anything above
PAGE_ALLOC_COSTLY_ORDER, but this logic was changed in
commit eacd86ca3b036 ("net/netfilter/x_tables.c: use kvmalloc() in xt_alloc_table_info()").

The commit that changed it did so because "xt_alloc_table_info()
basically opencodes kvmalloc()", which is not actually what it was
doing. kvmalloc() does not attempt to go directly to vmalloc if the
order the caller is trying to allocate is "expensive", instead it only
uses vmalloc as a fallback in case the buddy allocator is not able to
fullfill the request.

The difference between the two is actually huge in case the system is
under memory pressure and has no free pages of a large order. Before the
change to kvmalloc we wouldn't even try going to the buddy allocator for
large orders, but now we would force it to try to find a page of the
required order by waking up kswapd/kcompactd and dropping reclaimable memory
for no reason at all to satisfy our huge order allocation that could easily
exist within vmalloc'ed memory instead.

Revert the change to always call vmalloc, since this code doesn't really
benefit from contiguous physical memory, and the size it allocates is
directly dictated by the userspace-passed table buffer thus allowing it to
torture the buddy allocator by carefully crafting a huge table that fits
right at the maximum available memory order on the system.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 net/netfilter/x_tables.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 90b7630421c4..c98f4b05d79d 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1190,7 +1190,7 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
 	if (sz < sizeof(*info) || sz >= XT_MAX_TABLE_SIZE)
 		return NULL;
 
-	info = kvmalloc(sz, GFP_KERNEL_ACCOUNT);
+	info = __vmalloc(sz, GFP_KERNEL_ACCOUNT);
 	if (!info)
 		return NULL;
 
@@ -1210,7 +1210,7 @@ void xt_free_table_info(struct xt_table_info *info)
 		kvfree(info->jumpstack);
 	}
 
-	kvfree(info);
+	vfree(info);
 }
 EXPORT_SYMBOL(xt_free_table_info);
 
-- 
2.34.1

