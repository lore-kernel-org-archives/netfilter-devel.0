Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F27F3BB681;
	Mon,  5 May 2025 23:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487355; cv=none; b=rFZqYBIk407A7dg5V9DlSKDOkC/TYlXBp/OLcEgINJe1bI++WkLQPXZ6RPMwdDjquw8kB925y3O+T/0EPzlXhE3gsRvt7aYGO923QJjh9+1fwW9TgI/hKxR9mGwMDAawQyRUlJLKFExBWIAeo8q8/MZvtZvRzkx4q+vmCPj2TMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487355; c=relaxed/simple;
	bh=33fKuR8xSXXrYYpGa+BSRpBI1AmNXITApsh+Wb6LxWI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HsSjveUZ32yspzLN5j2UN0xCxyjmsPqlwxsxPYayXcIn03XgBuUwamKcvn8yE3CS0CD87rxzUMu7EkM+VF4OZSMUzJab7N8fNhk2DXomtw4eE/I69KLXPjIqs9jYDeGlHIRhHnTWwqtvq9FDGwstA4dg3k2oTp3XIkM39IJTaI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CWib3jlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CWib3jlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B68C4CEF2;
	Mon,  5 May 2025 23:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746487354;
	bh=33fKuR8xSXXrYYpGa+BSRpBI1AmNXITApsh+Wb6LxWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWib3jlRTj8QtOwbPvpLNmL+yBmN+XTpLkFZNCP9nBMn2V0vNdso5e65bM3wEacrR
	 177ssZdoXLxDgXCtWuFrASIld4TFaRF9UmK8TRXj9otveIl1w5pE8dhvdXZLsGdvrG
	 4Lr6Rp8yZZwxVo66uLCebUrf9c81ahlDz/dYWRgkHW9RnSbs221yCNcMHD0vrZc80/
	 vsqhVNQXW5lin+WCHiaCYyV9UFGTlm16PuS057lLCuwcOOVO/t6yDBh4Iwt3keU/jz
	 3B5YLSBJorixAS9pF9UwraDbO0in76792tRvNbjXMff+OjJA0GBYFlzGdC5TVq7KIQ
	 usR2uXxV/hTJQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 25/79] netfilter: conntrack: Bound nf_conntrack sysctl writes
Date: Mon,  5 May 2025 19:20:57 -0400
Message-Id: <20250505232151.2698893-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505232151.2698893-1-sashal@kernel.org>
References: <20250505232151.2698893-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.293
Content-Transfer-Encoding: 8bit

From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>

[ Upstream commit 8b6861390ffee6b8ed78b9395e3776c16fec6579 ]

nf_conntrack_max and nf_conntrack_expect_max sysctls were authorized to
be written any negative value, which would then be stored in the
unsigned int variables nf_conntrack_max and nf_ct_expect_max variables.

While the do_proc_dointvec_conv function is supposed to limit writing
handled by proc_dointvec proc_handler to INT_MAX. Such a negative value
being written in an unsigned int leads to a very high value, exceeding
this limit.

Moreover, the nf_conntrack_expect_max sysctl documentation specifies the
minimum value is 1.

The proc_handlers have thus been updated to proc_dointvec_minmax in
order to specify the following write bounds :

* Bound nf_conntrack_max sysctl writings between SYSCTL_ZERO
  and SYSCTL_INT_MAX.

* Bound nf_conntrack_expect_max sysctl writings between SYSCTL_ONE
  and SYSCTL_INT_MAX as defined in the sysctl documentation.

With this patch applied, sysctl writes outside the defined in the bound
will thus lead to a write error :

```
sysctl -w net.netfilter.nf_conntrack_expect_max=-1
sysctl: setting key "net.netfilter.nf_conntrack_expect_max": Invalid argument
```

Signed-off-by: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_standalone.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 1e3dbed9d7840..de330dffa0a28 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -608,7 +608,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.data		= &nf_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	[NF_SYSCTL_CT_COUNT] = {
 		.procname	= "nf_conntrack_count",
@@ -647,7 +649,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.data		= &nf_ct_expect_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	[NF_SYSCTL_CT_ACCT] = {
 		.procname	= "nf_conntrack_acct",
@@ -926,7 +930,9 @@ static struct ctl_table nf_ct_netfilter_table[] = {
 		.data		= &nf_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{ }
 };
-- 
2.39.5

