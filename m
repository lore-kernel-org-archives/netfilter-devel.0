Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442097;
	b=ALU1W5zuhYemX8EnFlgWGdDn50WQw2st5NCYHxRWZutRzmRyMfYxTr59hy+0FffOZ3To
	 mOwdmhkQL0nh8HZPyjmkwLMcwDnHk0SY9t7ZjGcmnC3y60JYsAcLTAC9cLIJZZnSYg7YX
	 jZBJQ4HqSS9yNO1UjJQLCa9oPurCVF9ZoXjFbbadWkflBNQzd8Y/DXyWXUebfLlLmMMz4
	 Ng/BaU4QOQ2corm9m3IkFo0GlMHtLsMl6P3eRK4UEM+GDlvkDegbbZEHvTOnnPkJhu+jD
	 DBvt5WO+nkcIUTC8aw59e0chYsAF14MLK2r0HRJQ/LRvs7JxfB7Ilb4cHsuxQEX+vww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442097;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=7l6ujBlvopYz8h/a09FCsFReMdf0JytvichTI5tBd2g=;
	b=LeB2PFydwjoaUU8UcX5SLGzPighZSaVDNf4Y9A8cSvd70PFDTRhCK1YVUv3aIHOetRr5
	 ybP4l0KAarEjzeiHEmAguPoPoXds4KYu5gSlFopMkIduXJQISXVhi/I0U+GB6WoQWgSjR
	 y/2Wv7iCBxNRWuyGevGhsGT5tPzsSr1UbhxfBA4x1qI4ypCG02mBGNRORA6zkGqHiBvbM
	 E2qHsUCMvigi7xAbnsbWV86lr8sSNe6qJ3850mQLf01uFnR9RXjo788qBgm/odn0tNEd7
	 ZH2LoK9ZlBdkEZraskcUvZGplBosyqtKJLkSqbd2NfiFsoROX2jPAoe1AtajOc929bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Cxa8ViT5;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5577A606A32C;
	Mon, 23 Nov 2026 13:54:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5577A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Cxa8ViT5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442089;
	bh=7l6ujBlvopYz8h/a09FCsFReMdf0JytvichTI5tBd2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cxa8ViT5O9yCaOTgvmCxfyWpTNyX/y3v0h4qqQpyWlzIzAROiPIDBd9wlSbEiLen1
	 8CdrDeZK9WdS4n9PNWiv4ptcvZcs5ROZBBtych2fwaNEcCRm2xoeyacTwVVMmdXhQy
	 OQhbP/W3+hkcJM7fOLhM4WBzk58JKzsKaVsrkXG/GLmKjxBOi84ibINOJiYd7Z6oli
	 ortHu901hIfGra6ShbYyHloPre4ZeoAp1b6kPzqxPlFbn/yFr4eSzzJ0gxmWzpPAx2
	 y/Oe+L0I+4OmjaUGEg71d4FrskpxbEMSqzS1CZ3m7ZeNVlJqeUb2FvF9pb0/5aW81U
	 noXoKkH97TWIQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 97D3D602BA;
	Mon, 23 Nov 2026 14:54:48 +0100 (CET)
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
Date: Mon, 23 Nov 2026 14:54:28 +0100
Message-ID: <20261123135442.3940372-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123135442.3940372-1-pablo@netfilter.org>
References: <20261123135442.3940372-1-pablo@netfilter.org>
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

