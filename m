Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F16219A7A;
	Wed,  7 May 2025 22:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746656412; cv=none; b=TLC8VXLLl+gsmcwrAGJy1auZNaCuRtuRxr3+SMoXguE4pyiO+S9LNJKVy5s++Zxo5UcjPi0KgRAAUTm3Mi1e6zT0KACPj1k17sJGXHQF2a3ZaUwCobO2yufHtGtEQDSzt2lcMi4lPaCl/58e2PYg1/jJV6hd+2CCYzD+2kj75Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746656412; c=relaxed/simple;
	bh=mmJ5t145tJaV9s3ylJVk3FjgHn4yLvW7aTBfw5C7Cxw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uGnzCNXxW43Nsa+u2tjaCGd+h1F7UeIsBFuYb/ObGgd9IoR2eAx+jw6jj2nXqu/iziRd3BO5dBopwkaXSuQqwliuRDMiZE+wcFsEPVNp3bRxf+dsR8JOLrMbgVPeIDxDjkjLZFx6+PhlhSO1NNSpFfzLgzk+gT9B5f1TcIPhrgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SVA75Dto; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=opSFgoIV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SVA75Dto";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="opSFgoIV"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C4BA3602CA; Thu,  8 May 2025 00:20:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746656401;
	bh=8Hj1IMT5EmqXg7gduO2i2Zz/xnAn3lxC4MQSTMVZrs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVA75DtoBfRhU+eGkZBnSUK7CeuGkykUChcBq+shGFZsTcuFBO5M4yxqP3H+hh+xi
	 CJbpZa+reP5/McQYdaH/LMg/0nuE8f3QbYOfPB4IkYI2o8Z65pgsl1mPqttY6Qb8wB
	 1bdQd+KcQIgqI0+LpLemezJK8JUMD4kKDAcLkiRqXHu1EYSonFBqQxVRfxri0o7sy8
	 CgvyKggry1QGI/dpXW/RxLchaK04rOSJG3TkrJgIo92ARPAxQwEj9lmL8wsJ3ClTWw
	 vNbmCPn5vK7YkrFYv2WBRdWbVaJyFNuAfr1TYbvdGBon7SUhgGwsoH7KMXJb6c06tb
	 mPpk3tG6vGKRA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EA537602C4;
	Thu,  8 May 2025 00:19:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746656400;
	bh=8Hj1IMT5EmqXg7gduO2i2Zz/xnAn3lxC4MQSTMVZrs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opSFgoIVs8mj9WAkl33y3TXrkE6N55vBtoQsYStOqHoq59OV1EF+JShM/j4anI25A
	 TmByDs6UCrjXcCNGdcrlk8THnTAUy5Si81c0Xklc3VNk/I29W4wSYjFTyuCyWAlQZa
	 0geYuAzZI9yhwSN3sDjO1HpH46XZhhFTYOHQHtpmxKKKrpmgRqooyDNB77ympqeN9U
	 OmHTyYVpYFusmgUz4n4HeUADQdb/37+CUdzSqJfEd/B9gw5RBD6BYZD2W27NbFeCZE
	 bTesyX7ykhgaPR8+S+Hlb8OUg3jnTveSrQovm0zyOi2/t1XlUS9dhlDJ4OqGraFrvt
	 mmkBei18CVWTg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 2/2] netfilter: ipset: fix region locking in hash types
Date: Thu,  8 May 2025 00:19:52 +0200
Message-Id: <20250507221952.86505-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250507221952.86505-1-pablo@netfilter.org>
References: <20250507221952.86505-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

Region locking introduced in v5.6-rc4 contained three macros to handle
the region locks: ahash_bucket_start(), ahash_bucket_end() which gave
back the start and end hash bucket values belonging to a given region
lock and ahash_region() which should give back the region lock belonging
to a given hash bucket. The latter was incorrect which can lead to a
race condition between the garbage collector and adding new elements
when a hash type of set is defined with timeouts.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Reported-by: Kota Toda <kota.toda@gmo-cybersecurity.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index cf3ce72c3de6..5251524b96af 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -64,7 +64,7 @@ struct hbucket {
 #define ahash_sizeof_regions(htable_bits)		\
 	(ahash_numof_locks(htable_bits) * sizeof(struct ip_set_region))
 #define ahash_region(n, htable_bits)		\
-	((n) % ahash_numof_locks(htable_bits))
+	((n) / jhash_size(HTABLE_REGION_BITS))
 #define ahash_bucket_start(h,  htable_bits)	\
 	((htable_bits) < HTABLE_REGION_BITS ? 0	\
 		: (h) * jhash_size(HTABLE_REGION_BITS))
-- 
2.30.2

