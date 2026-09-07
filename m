Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E0F3BB690
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 18:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788807365; cv=none; b=OIzF1nt/SKVyT688D+brepQLdVI8AGfJYUEG8W/pVdGgBW/lsPYJqndkySitgDAErH0dRZJ3fuX8Wlt3eEKW5zDan3xSZrRARA/igtmnr6quzOVNXXEN31ocMLdOxjq8Pwuuzay+XBd0URk9Q0qi5+g7o4zqYZyHzCNOS+z/OOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788807365; c=relaxed/simple;
	bh=PJub26XM+j+cusRcVIn0baATPwidZC3GOg/jR2f/6Xc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQBA1ZNK67etiEGbZECZiE78YHSDDg64kpRUuRR7ZqQmYFhdOYZ0QJ5LBmoWGjCusg8CYwcwb7GkOzGcuaK4e76CfWl/uE7Z8RmgdGzcwmr2k85FqYOMo6tQNHNpEG5DDqOesJyw+yXDFA0TaaAgex5VmmOjY6B/kGIoD6YVGBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sAQgM2Hi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sAQgM2Hi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788807362;
	bh=l0w3eAQt4C2+YIQwjaCiRdeSRRB6b+qqoUIFEjDQ9uw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=sAQgM2HiOIWeP0oGVCkI9kd2Qxiu3Zp8b5cRnUK9LA0FH7PQFdspofBiQDcmNz3kE
	 HUbaEiD5Ju9V3B0rrAzZ4vOMbvFblMShdL7r8wYdEF7nql7VSmp/lxd8VMNZ4m/gP5
	 b3uOKsgcFHGGrD1LH6kMLJr4IyUeUtrmTPlZQ2hlDUBNNc6Txiufj3psSiLrabXzCS
	 9t8taYAX62Or2JKaAMcXGiytFGN4T6sT4TyHxOna+a1+WfKNXnelmB9BKAnezSQRHW
	 CIm1zgYNrCydiFmNHqISjmUlKmmuttGtQ5yvyGRtwhdFjr5NW1iGJFlvuSbUi/75Tw
	 /jhD8GKCVPs4Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E78FD60792
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 20:56:01 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 6/8] netfilter: nat: use GFP_KERNEL_ACCOUNT
Date: Mon,  7 Sep 2026 20:55:50 +0200
Message-ID: <20260907185552.1422008-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907185552.1422008-1-pablo@netfilter.org>
References: <20260907185552.1422008-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace
GFP_KERNEL by GFP_KERNEL_ACCOUNT.

Allocate the internal nat hook via GFP_KERNEL_ACCOUNT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: no changes

 net/netfilter/nf_nat_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 8ac326e1eb5b..09cc5b8fd6af 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1204,14 +1204,15 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 	if (!nat_proto_net->nat_hook_ops) {
 		WARN_ON(nat_proto_net->users != 0);
 
-		nat_ops = kmemdup_array(orig_nat_ops, ops_count, sizeof(*orig_nat_ops), GFP_KERNEL);
+		nat_ops = kmemdup_array(orig_nat_ops, ops_count, sizeof(*orig_nat_ops),
+					GFP_KERNEL_ACCOUNT);
 		if (!nat_ops) {
 			mutex_unlock(&nf_nat_proto_mutex);
 			return -ENOMEM;
 		}
 
 		for (i = 0; i < ops_count; i++) {
-			priv = kzalloc_obj(*priv);
+			priv = kzalloc_obj(*priv, GFP_KERNEL_ACCOUNT);
 			if (priv) {
 				nat_ops[i].priv = priv;
 				continue;
-- 
2.47.3

