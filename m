Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F38D20409F;
	Sun, 23 Mar 2025 10:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742724577; cv=none; b=fV0SZx0SEwnzxFxUyUCHf0QJs7aTl4NqNbG+dxlIRSbiS6U1bgKBeqtZY8cinyjVxEFd2B80QxSdLB8zulAYC6L+yF3M0VdBdbDLP8/mTPL9td2E2bwpYHWMvtWEjy35Ir+bKGfMBxIFfyPo9/px3pS2Q4Bu3CDUZoULvzrgfVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742724577; c=relaxed/simple;
	bh=fSowlrrngOwsDNZt8FbmBBamwAyDsrQjSR6Ir/QH+vc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YKquVBMurXR2omn9euG3wpWqRA01deMGZQqPFGZqCV0yFEarLmuWRszUXHDpcDCzPZZ4RG2Xcz2F9ijbuBF8XAcvC8sEkoJNNz/TR80/6CvPmYo/ozddqXEvtXTrAMr8CExhqXerQZI66Btg/A31bNf1hYpr9Y4dDVn8otrAKqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kbig0TpY; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mk2T0NuB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kbig0TpY";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mk2T0NuB"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B950D60395; Sun, 23 Mar 2025 11:09:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724572;
	bh=vHknCH8VVQ63SXtgAfiqydpIO92QyJPlZQQnn20OiWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbig0TpY0/OoGjMRDyiOk3G8foYtiG72AGc9Q5eVICUesAm1BhSsjBsH9XFmyAOc0
	 G7OGuIqMLYfuEFbo9YTlY71lxhN0qR6vCGcAHQpqXBdawijfyeFZjTAXtRutBlYaq2
	 2BmBvMUiZ3DcQ+ignzXhEZhzicsuzclVTubUyByMifaMOHqEh3JNR3ObMrGKVo6791
	 STU3aARrsg2EvfCPPoh+huwNSnROH6AyF0yx0TtO94D6WutZGmgQNQcfMuwkLVeOC0
	 lMj5TzQvnc31dqoMOax6PsxVsqEY0BLfB16GVVvEt3a9xekNkTSAnxcRBsB9LlIjQY
	 LTx85iPYU4SGQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1AB8E6038C;
	Sun, 23 Mar 2025 11:09:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724568;
	bh=vHknCH8VVQ63SXtgAfiqydpIO92QyJPlZQQnn20OiWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mk2T0NuBt1lP1n5PlxAdCm5EGr61xw9LAwjcfdrYN1WFttl9VM3HmZA9ZK0SGu+tg
	 zA2VGS2uD5oT/fewiXhfuLjtkAoT0YotYB3i2ODlPIKhZjZ1+NzscR75sUNtVKrhcB
	 7rWoBNH6QnQFBq0OkEBLNDXcPOW122TYp96neDYZhI1K9XqNW1jIhVobnyjYnUcH29
	 rpwg8uRpFm2Hj58u/KifEEj13MVtwUcFKVAQHXXbSP6/na++FpeqrMU+a6Upo9G7xR
	 VwxC6JDXntA64AKjSrpUg8MVAzAve7LJsjVYxUYzwKggxPYa3ZNWekegT6/6SzABb3
	 mBWTvbsgzeWMg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 2/7] netfilter: conntrack: Bound nf_conntrack sysctl writes
Date: Sun, 23 Mar 2025 11:09:17 +0100
Message-Id: <20250323100922.59983-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250323100922.59983-1-pablo@netfilter.org>
References: <20250323100922.59983-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>

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
---
 net/netfilter/nf_conntrack_standalone.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 502cf10aab41..2f666751c7e7 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -618,7 +618,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
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
@@ -654,7 +656,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
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
@@ -947,7 +951,9 @@ static struct ctl_table nf_ct_netfilter_table[] = {
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
2.30.2

