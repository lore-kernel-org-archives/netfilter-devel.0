Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442254;
	b=W34qeQuI/jrdj7Y5dL2qomlriqcyZl0c1J0Kgzup1M3WW8TCFjWjaYF2SkJnVpoQnrzR
	 eYkk6yX48XvWEealY+mOJzpifp3K7uceMW1yl6qYcJ9PBUaefzrHDRfTMBG9gXwRz9d5X
	 UxRWYoAsrQTCdex/vZ1mvKiTR4aEqPnRIrUYFi86+uM7BWIT/b4TTNv49XJz34cKtB4nM
	 ZPzZUrB4Ys+PWRB/iuNdJfvxftSsUJtWRhePhVUYx3SzP/K2hHi/rZMlI7Jz/DD3QPTf/
	 FXH1/x+AV6iep8TcMefje+RDnS3wo5ciDtGOaPBkCa/NM9vz1slyJ65fkHMZEOR5tqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442254;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=7l6ujBlvopYz8h/a09FCsFReMdf0JytvichTI5tBd2g=;
	b=qBmnY8ronN2ILTis8rnWQor948pPm2AcwIlgbv5PI3j1EmCmk2Ou6LW9GkmAyDMQGSCH
	 jCPBFil4F/agoxoaXDFYmxpvafNdIxESNh7IeWCyOjcHHWE0X/LtVZG5GyCCTFwXoqDG7
	 O3vB4oLj+MJRj+OTGJrUVaWDt8YVwjFTEV/eB6jGmXxD0FN2NHjOgK8vWhBDgMx4rxKfB
	 HZJXyP2BGWhXcLA2zGm8hgayGTY3DNba8xMmgfVG5RrINoOsDn1wCsX3jAFCB86SUnJqb
	 VAPS2w4P+zW9DfUV1kSsC2xdCL9gmtwsrg4KVzb+pvSoTd7GpbH8G2muuMhL+/HGQQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=qha833XN;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B789606A33B;
	Mon, 23 Nov 2026 13:57:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B789606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=qha833XN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442252;
	bh=7l6ujBlvopYz8h/a09FCsFReMdf0JytvichTI5tBd2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qha833XNxJNZ3YSWZD0UkPLXJEw247TObNeQCekU4ZKw60iWO6ixXeRxbe8IqAjBj
	 5u/HRo94/mGo2ZHe/GXO3eXvBmG+VLLOqa84RKC4j+OHZh1FTzQvk6L5guKLcJnc6F
	 npnRbbQfUxwyAOh7qA2wipDqLw02PhgrQeYr2eKG3HuPloLhsbPMj77dZJW9YlS6XQ
	 c/Hr21jELXdW/LPouW2fQ5F4e3fbF2eul8iqRBDoBxYnaT6p9/6NF+1Lak+Kn4H/Vp
	 BWeL4+C+1CWu4u71FCpVKlnTvmdEO97dynsoEKPdBgO5ORsg5AjXL1T9w+XsH5zBW+
	 znhIspEc9Qskg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CEAEA602EB;
	Mon, 23 Nov 2026 14:57:31 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 01/15] netfilter: conntrack: prevent nf_conntrack_buckets race condition
Date: Mon, 23 Nov 2026 14:57:12 +0100
Message-ID: <20261123135726.3940688-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123135726.3940688-1-pablo@netfilter.org>
References: <20261123135726.3940688-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

There is a race condition in the nf_conntrack_buckets sysctl handler.
The implementation uses a single global variable as a temporary buffer
to parse user input. Because sysctl handlers are not locked, a
concurrent read or write can overwrite this shared variable after a
writer has parsed its input but before the actual resize occurs.

While this sysctl is only writable from the initial network namespace,
the race can trigger if a monitoring daemon reads the sysctl while an
administrator or orchestrator is writing to it.

Fix this by removing the unnecessary global state by using a local-stack
table instead and delegating the locking/serialization to
nf_conntrack_hash_resize() function.

Fixes: 3183ab8997a4 ("netfilter: conntrack: allow increasing bucket size via sysctl too")
Reported-by: VEGA <vega@nebusec.ai>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index d88a10230862..9775efe4e2c9 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -533,27 +533,22 @@ EXPORT_SYMBOL_GPL(nf_conntrack_count);
 /* Sysctl support */
 
 #ifdef CONFIG_SYSCTL
-/* size the user *wants to set */
-static unsigned int nf_conntrack_htable_size_user __read_mostly;
-
 static int
 nf_conntrack_hash_sysctl(const struct ctl_table *table, int write,
 			 void *buffer, size_t *lenp, loff_t *ppos)
 {
+	unsigned int htable_size = READ_ONCE(nf_conntrack_htable_size);
+	struct ctl_table tmp = *table;
 	int ret;
 
-	/* module_param hashsize could have changed value */
-	nf_conntrack_htable_size_user = nf_conntrack_htable_size;
+	tmp.data = &htable_size;
 
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	ret = proc_dointvec(&tmp, write, buffer, lenp, ppos);
 	if (ret < 0 || !write)
 		return ret;
 
 	/* update ret, we might not be able to satisfy request */
-	ret = nf_conntrack_hash_resize(nf_conntrack_htable_size_user);
-
-	/* update it to the actual value used by conntrack */
-	nf_conntrack_htable_size_user = nf_conntrack_htable_size;
+	ret = nf_conntrack_hash_resize(htable_size);
 	return ret;
 }
 
@@ -657,7 +652,6 @@ static const struct ctl_table nf_ct_sysctl_table[] = {
 	},
 	[NF_SYSCTL_CT_BUCKETS] = {
 		.procname       = "nf_conntrack_buckets",
-		.data           = &nf_conntrack_htable_size_user,
 		.maxlen         = sizeof(unsigned int),
 		.mode           = 0644,
 		.proc_handler   = nf_conntrack_hash_sysctl,
@@ -1153,8 +1147,6 @@ static int __init nf_conntrack_standalone_init(void)
 		ret = -ENOMEM;
 		goto out_sysctl;
 	}
-
-	nf_conntrack_htable_size_user = nf_conntrack_htable_size;
 #endif
 
 	nf_conntrack_init_end();
-- 
2.47.3

