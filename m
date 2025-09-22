Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CD32F3613;
	Mon, 22 Sep 2025 19:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570654; cv=none; b=Swe9YzyF9Cbrg38irtk+c6u8mMddjCfytgIn1IwAM71gHq94042/VMQcuVj2NvKSAGI8uxJOPOo9MN+mGcSzGcTbCfxQJlTagg6kHvMYwugkCBzjGbeEC8aHBHMO227JDEUnhQzuRRCVcviNOn65SLT1elGs7xgJphJ6Z5o4C9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570654; c=relaxed/simple;
	bh=IIuaOrz0FC8chHu7ILOxwOJmM63B00UIluxC+65xLfE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hBSLZ8JW3CFbZKON2lv4mC1JhyQGf4aXyo6ncq9VVgBQl9OxKLAvcK1QtzpeBbB7WRy8LSNw7ty4+ZRpF4cwezSg5dMEh5vY5/BFu6raQxhMqY6i3SNgV+iCS3MCqGGpSIIZy3cSjwZlxCkjhB5rWC25dMsOGJ5jIClfjJPOTTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=WCMIMWJL; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="WCMIMWJL"
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:1621:0:640:12d9:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 3AEF38857E;
	Mon, 22 Sep 2025 22:48:50 +0300 (MSK)
Received: from d-tatianin-lin.yandex-team.ru (unknown [2a02:6bf:8080:c27::1:3a])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id TmcMU33Goa60-srwXviqN;
	Mon, 22 Sep 2025 22:48:49 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1758570529;
	bh=ERVn3lgtdd/+G0FxLqF0rVkFcod05w/PTMcT604L6DQ=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=WCMIMWJLK29lv+34fERZqiPcN8jMoaVD5duMuwNGl67OsGtHqshss3ZBAX6zH/05o
	 nRe81/EuqTq7c+j8DEpkwW72OoodgboTm5Q79VMTViL2V6JsDOIo+Wghy99L2Uz6AQ
	 /oOlDd+uouw26fNMQcOI1i6imguTvqZWRKzrSD0o=
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
Subject: [PATCH 3/3] netfilter/x_tables: allocate entry_offsets with vcalloc
Date: Mon, 22 Sep 2025 22:48:19 +0300
Message-Id: <20250922194819.182809-4-d-tatianin@yandex-team.ru>
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

This allocation does not benefit from contiguous physical memory, and
its size depends on userspace input.

No reason to stress the buddy allocator and thus the entire system for
allocations that can exist in vmalloc'ed memory just fine.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 net/netfilter/x_tables.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 5ea95c56f3a0..06a86648b931 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -965,14 +965,14 @@ unsigned int *xt_alloc_entry_offsets(unsigned int size)
 	if (size > XT_MAX_TABLE_SIZE / sizeof(unsigned int))
 		return NULL;
 
-	return kvcalloc(size, sizeof(unsigned int), GFP_KERNEL);
+	return __vcalloc(size, sizeof(unsigned int), GFP_KERNEL);
 
 }
 EXPORT_SYMBOL(xt_alloc_entry_offsets);
 
 void xt_free_entry_offsets(unsigned int *offsets)
 {
-	kvfree(offsets);
+	vfree(offsets);
 }
 EXPORT_SYMBOL(xt_free_entry_offsets);
 
-- 
2.34.1

