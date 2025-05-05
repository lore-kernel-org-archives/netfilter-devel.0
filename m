Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD942ECFFF;
	Mon,  5 May 2025 23:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486509; cv=none; b=KWkzIij0tqO0c4cM8rN8FfrkvCNhNttrXEmdp2ssw7Is7xVtAYRIu0tTxoh/9eN1vps15ddmD2eTHRMb55IbOqEQ5b4rAY/LJrikqPhKcbuGA7QNNwGAFuJd4zO04/HfOGPqavhpiHKBkzLbKeOpPHW673MtzUZjN9r7Zs7Pq7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486509; c=relaxed/simple;
	bh=CvZy6PV0XzT2rBkLKJjXMgmKuMb0AlaAod2uUWCGLZI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GeLCtagydI2GajITCm4E427UBgpsfvbszclTvPzDZUAA2QAH4frKV+WUn9RT9aKr5m8grpa17i3ubglZQUN3jRQGIpXCvNeQY1WQCoBOnfSoXN2Zo+Tlv6SXZwR4Xi3UtHUFbMFcafAXkTV28WOInmve8n7kimjBFLNVickujEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1TNo7HE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1TNo7HE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D2DC4CEEE;
	Mon,  5 May 2025 23:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486509;
	bh=CvZy6PV0XzT2rBkLKJjXMgmKuMb0AlaAod2uUWCGLZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1TNo7HEpx+EQd9nq/aUfww8RrFxtayIvh17F7I6oPNG9PgMdI/YRIp+COhCdzY4u
	 ZDukmeE84BLKT7iYHZJMczwow/1t2B57QqSl3ZBGL9gF1Gg9Ab52FKPqugezeSX5Yk
	 aPdRi0cmbJkaZJtEM1FF7+eZi4+sgchmrlmohOjJ2QbyIMxAO7AIIqR7dqz8zYRF/o
	 scwUXhkG39R3GbfFBdmKSM2+rF9hU2AhjA2n+Ydbl5c67jSH54AcTei2UbOiA1euzC
	 L1EfLPwQ+QoES6viDPukLqk7Sl2Ae9uAibI32BMkC5ams56jcGlSyPbeM53Htwi+8B
	 kVput2ixomjBA==
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
Subject: [PATCH AUTOSEL 6.1 067/212] netfilter: conntrack: Bound nf_conntrack sysctl writes
Date: Mon,  5 May 2025 19:03:59 -0400
Message-Id: <20250505230624.2692522-67-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505230624.2692522-1-sashal@kernel.org>
References: <20250505230624.2692522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.136
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
index 52245dbfae311..c333132e20799 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -631,7 +631,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
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
@@ -667,7 +669,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
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
@@ -970,7 +974,9 @@ static struct ctl_table nf_ct_netfilter_table[] = {
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

