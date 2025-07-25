Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2642EE5F6;
	Fri, 25 Jul 2025 17:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463069; cv=none; b=UgIgotLcn3/2JcEJ9Rum4HxggqJhuNsnIuVccWi7X43Y9UvRK8eCwh2DWy3AIUdKHj6X8Jds8azMQz1KumSo/XO/+qvm7Enuiao2PG5zH1LEr7ABzci+ahQBYOoI0AQpKWFSAIcJmdpj/XPYEoUNV00hh65yhKYTEevhKhiBbxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463069; c=relaxed/simple;
	bh=ZhoNoHyUgV3GHucQx+0+Z9LqrvMJs4W9VLtkPHFke1k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L1XyNZofmoziOdBUiIRNI/rkeOgFU4CN6QtewZAr0Z3ITFs2wSLy/z8gnkNKiD95FI6tUD/idGgOielsq15Q4cvpvXykNcWIwcDIoG616SnB9brnAdOIT8YyB+Weia4scIaGWOr4fGmbiaHcWRdGRCShgZiI9o9numVFrRHF2cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=s/XOw/m2; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eUxAINk5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="s/XOw/m2";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eUxAINk5"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5F3306026E; Fri, 25 Jul 2025 19:04:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463066;
	bh=dVUWRuMfhGHxNyHtHyj+PtEuk3sfGozhXLH8NpTODwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/XOw/m2f2jzVzUkl5ybvPtmKGZ62WO4mxK2vYkXvJyOCMHJqiC7wJtp/zwMFqvdM
	 GNzBJFWQCv/d2lBNNsPZSFLu74cLl8SqWJnRZDVcqpvoljg241EiaQXZN/DY1nbAE4
	 kCu06nPaoXHQkvKvPRFBuu5EjwXUXFqFjQuffbOc0+fsJYRtDYrNAYyprjjhp1+KuN
	 xEmX7WRUIK50/ymxriXDiFcfb/enaJaFYXKo7W4DyXiSQLay2lk9UepsOXjaPKsr/N
	 oQmrEMZytr/9kXDzFbfoLUEN9q5K3/NGMbjHIx6y0hcKxF8XIruYvqgcyUo9zBNMPT
	 uSmbQtd1I8n5w==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 667616026E;
	Fri, 25 Jul 2025 19:04:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463059;
	bh=dVUWRuMfhGHxNyHtHyj+PtEuk3sfGozhXLH8NpTODwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUxAINk5JpA1gS3KW/crdroD+PCz6IXKhZN8C9/OPhxC4jvKu1dVg+C7JgQhZwCNc
	 Nmq0rpK2oO1imVq4pvYtuMGDCrw5VrauD+AFp7XTnVPqOD/i/r3fwjZAhi/kXN/zFG
	 c5lks+A92Io9CEHhE2dFu6crM/sSjMTnicpgVJIDgqdi4in4NICYNEnVkzs2UlrNzN
	 kMtXESK2OyzyUA8VBV56ImC3UEFZFqNiRBfcyppwIBToO3NRbrhhn9v86+BwBpMxN8
	 57rVh4jbAQbqynZ6YEITJDHYbFkxLXQMH9ARN6uu/yL0sLnyvL14BeaYy7dQPwhHaA
	 nBFCPUMpV0Lvw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 17/19] netfilter: xt_nfacct: don't assume acct name is null-terminated
Date: Fri, 25 Jul 2025 19:03:38 +0200
Message-Id: <20250725170340.21327-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

BUG: KASAN: slab-out-of-bounds in .. lib/vsprintf.c:721
Read of size 1 at addr ffff88801eac95c8 by task syz-executor183/5851
[..]
 string+0x231/0x2b0 lib/vsprintf.c:721
 vsnprintf+0x739/0xf00 lib/vsprintf.c:2874
 [..]
 nfacct_mt_checkentry+0xd2/0xe0 net/netfilter/xt_nfacct.c:41
 xt_check_match+0x3d1/0xab0 net/netfilter/x_tables.c:523

nfnl_acct_find_get() handles non-null input, but the error
printk relied on its presence.

Reported-by: syzbot+4ff165b9251e4d295690@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4ff165b9251e4d295690
Tested-by: syzbot+4ff165b9251e4d295690@syzkaller.appspotmail.com
Fixes: ceb98d03eac5 ("netfilter: xtables: add nfacct match to support extended accounting")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_nfacct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
index 7c6bf1c16813..0ca1cdfc4095 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -38,8 +38,8 @@ nfacct_mt_checkentry(const struct xt_mtchk_param *par)
 
 	nfacct = nfnl_acct_find_get(par->net, info->name);
 	if (nfacct == NULL) {
-		pr_info_ratelimited("accounting object `%s' does not exists\n",
-				    info->name);
+		pr_info_ratelimited("accounting object `%.*s' does not exist\n",
+				    NFACCT_NAME_MAX, info->name);
 		return -ENOENT;
 	}
 	info->nfacct = nfacct;
-- 
2.30.2

