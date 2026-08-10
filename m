Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020A743B496;
	Mon, 10 Aug 2026 19:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388814; cv=none; b=rWqDcgPyCQKtMcc0u+bYZ4xrllkghXyjpO1Dz7vXPZZZxXTDHNkYCTT4Y08FcPUA7pMVvfmHWR3Qa77Wh8iGmOu7LnnaE6UoMootRiyxEdj+gMtGWSTarnHcQY+H4j/JBV9+gSGO2fHd4nnmzgt8Pk69/dS3COavNEPdBQwF1Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388814; c=relaxed/simple;
	bh=CEC/6uhdTSQt09HjFKs9RNY3djlgHHHGjD9e1QoJJj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4oskNcVecfk6Z/1YCnkwJZEMm/wXmbq05oC8t2HKAz1Kax0MF+G/JrQuzcGuQst4tO5/Blv7fYozsSUMpCuALUvVv8f9iA8b68/0xqk1rCQt0W1xV3mWBbdOO5D3Xlo06yCCYybZOOljbc+XjaowxmDvkhQ0V/LgGS7vHto2tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZdqK8iWx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZdqK8iWx"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C0B226028D;
	Mon, 10 Aug 2026 21:06:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786388811;
	bh=fyUUPOm4yxC6o8qwyaz1vkA0qgAwls6ufWpW4e5Ss7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdqK8iWxCWzZ+WDOE4AH7VxJd2nQELwSK0p+vu0R1Z/wAiuZYFuRcrAtMZtI+L894
	 1Mtez0yZpc+V/I2YLoaYkfjQaMTiYop7V/MIPvsNojci29p4kKUrAa2ZcbMx2KleVn
	 kI/zQ13rXuJMnzfofFyhZWI/luFiZtkHBx/6YW/8Zm5fNP+YOD4DNqoDRZBMizNNAD
	 3gnTmWIAgsGP8lUyJFQlZ/RfE7eCdRwf2wI8QnFfPHKdpVbL1cIBRgIYtjPqsaysbm
	 zpgM197vGert0GQA9uO61mftv40Nm6M8tz14qIeB7CvCtCpYrv8S3CNqJsqwblI2Ik
	 19Y5X3tZFNGjQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 13/13] netfilter: ipset: let destroy callbacks adjust ext mem size
Date: Mon, 10 Aug 2026 21:06:21 +0200
Message-ID: <20260810190621.894119-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810190621.894119-1-pablo@netfilter.org>
References: <20260810190621.894119-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

For bitmap this change makes no difference, because destructors are
called synchronously.

List type however calls them via call_rcu() so accounting decrement can
happen after list_set_flush() set ext_size to 0.

'set->elements = 0' can be removed for the same reason in the list type
case, it calls 'set->elements--' for each element.

Fixes: 9e41f26a505c ("netfilter: ipset: Count non-static extension memory for userspace")
Suggested-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 2 +-
 net/netfilter/ipset/ip_set_list_set.c   | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 226fdf17b683..d6a7e6604542 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -77,7 +77,7 @@ mtype_flush(struct ip_set *set)
 		mtype_ext_cleanup(set);
 	bitmap_zero(map->members, map->elements);
 	set->elements = 0;
-	atomic64_set(&set->ext_size, 0);
+	DEBUG_NET_WARN_ON_ONCE(atomic64_read(&set->ext_size) > 0);
 }
 
 /* Calculate the actual memory size of the set data */
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 0bc2370773af..f070088742d6 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -423,8 +423,7 @@ list_set_flush(struct ip_set *set)
 
 	list_for_each_entry_safe(e, n, &map->members, list)
 		list_set_del(set, e);
-	set->elements = 0;
-	atomic64_set(&set->ext_size, 0);
+	DEBUG_NET_WARN_ON_ONCE(set->elements > 0);
 }
 
 static void
-- 
2.47.3

