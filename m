Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8087129A3E5;
	Mon,  5 May 2025 22:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485038; cv=none; b=hNcMAvyBfQZr7BcHclicSzHynP/2cPkwIyP5PVEsChJkpNqN4DNthoviHNFQVeI4MEdCPg9JbKVaALwfxSgxlrSmUytCg9u58XoKS7cuwv1kY+St/AjEV2kWFupH3C/Smm+KNShzYk/iXgJIOIY0ndYUOLvl0Mge+mUzRteXUQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485038; c=relaxed/simple;
	bh=BjLeZRjT7RgjsCwKpIEeIybZ8EIpiwyBzGS14AWFqV4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G6XLky2+kRWhSuZi144iCd3BjCNHUyVl8Bq2Q+COSTqxIuD8XqgDhIULUmRzgixdmnSJTTmFHRtUcqHOINXbr86rk58QhLYChqAGyI5VOKAPEuRk+8yjYjM7noR3/C//qwIh155LKzDwuRKukLfZMCvpi0TR4VD+Gjy9RAJm28E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m6ZdxZ1N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6ZdxZ1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0995FC4CEEF;
	Mon,  5 May 2025 22:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485038;
	bh=BjLeZRjT7RgjsCwKpIEeIybZ8EIpiwyBzGS14AWFqV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6ZdxZ1NfvVfb/rKkhzZJtwbjYtlPOEJZnbm5oy+AaVtVPF325LO/aib7YS44fjrg
	 RDe4v680iOX1CrrU46Xf99hkXPEJDzsaVu701NUp7xHTjHBrRQh/yecWGsY7pYjuUp
	 evKLWp8ueA/mRwH+1diPy+b00TJ9X8AuF3FFm3JCAuvHUX+fNeaszzAnwXcsMYWW3r
	 ZV1dK4HyIZusupuBsShK47YV1ITZ5WWP8hiinEd12aOWg/SQlifGvblfrPWTMVW3iL
	 f38Y0CXKCLbXl95kRDb3neT7UpnAzG9W/bmknNw+8VDc6gSoJ/w3WeKmuBR23xwW81
	 KcZ5UHuuLcYxQ==
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
Subject: [PATCH AUTOSEL 6.12 135/486] netfilter: conntrack: Bound nf_conntrack sysctl writes
Date: Mon,  5 May 2025 18:33:31 -0400
Message-Id: <20250505223922.2682012-135-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
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
index 7d4f0fa8b609d..3ea60ff7a6a49 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -619,7 +619,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
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
@@ -655,7 +657,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
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
@@ -948,7 +952,9 @@ static struct ctl_table nf_ct_netfilter_table[] = {
 		.data		= &nf_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 };
 
-- 
2.39.5

