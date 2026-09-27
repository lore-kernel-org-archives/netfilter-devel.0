Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB4D3EC2D1;
	Sun, 27 Sep 2026 22:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790548492; cv=none; b=t4AFe/NsWHYvWxGmrbwrlnwDeHT65JdbS03TH+DGFs9h6dEkbUW3MAanIF5bszEGxBCEOaCg7KtOG7Nu+qrBs3WAGlifeJwgAj9ROth1TWN2S1sBvt9zJHkbxCZ1KO84p5M51/OC7NSArLiJSbpDs7Qx63WI1KGbfCQlWZMHofQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790548492; c=relaxed/simple;
	bh=4ilh5JCTCH3Vgjk27o5M6erAbz/k0VzrKwABW/YOJNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDJsKF5DLtPot9n6lnTGUNcX4c29AFMGPTJJVC+xBvx/FVD9ZeGGOT/ATCPm+s1PfGC2d3PsCpUG7uqgmBfYYMPz+Sr36mWPY1kH0CU2dfQEADPWj0OAv9BoDgPVrXQJMlkwO/pQrnjsLW4voFiJoTMfivnlm3M6XK7fH694uHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Subf2ChA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Subf2ChA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790548489;
	bh=xw0ty/tA0ysJjI3JvqGU7W8bH9AWPjkybz/iZn1MPhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Subf2ChA3rDaRUdok9Gs9bRppMNzPY1VuMG0n/2UUrtHn2BlIZ0zmymhQ15wkUb9G
	 MJfX01aaVfav+d0+bwY1S9D8wg0vW3qpAdijum65EPloLa5MNTovfiHdC3EMjT2KhA
	 /DqelDL5P2qwux4wE/91Md8n+1i+6Zx2B9Jm0IAn4W4L8NzLVcc0usyvhdD5Gjd2rb
	 OB8gNf0/jxhNS5JGAE14Q5bxRQGf/zhtVu9ZSxRaCwXl8f2hSvRlF2Y7feN93JBSgh
	 PyuwphR7HHJrq12lgIkFnjTl/LXu87zqZvxLfP48H1ViYbVHzCapixRIDC8PkZ1jBg
	 pWrkL+5kaDpug==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A56566008F;
	Mon, 28 Sep 2026 00:34:48 +0200 (CEST)
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
Subject: [PATCH net-next 07/11] net/sched: act_ct: set net pointer before publishing flowtable
Date: Mon, 28 Sep 2026 00:34:32 +0200
Message-ID: <20260927223436.269024-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927223436.269024-1-pablo@netfilter.org>
References: <20260927223436.269024-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qingfang Deng <qingfang.deng@linux.dev>

nf_flow_table_init() adds the flowtable to the global flowtables list.
However, tcf_ct_flow_table_get() sets the table's network namespace only
after that call, leaving a window where the published table has a NULL
namespace pointer.

Set the namespace before calling nf_flow_table_init() so that flowtable
list walkers can rely on it being initialized.

This is required by:
"netfilter: flowtable: check namespace before iterating flows"

Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Reviewed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/sched/act_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 411e3dd92d07..e26c0d5b2176 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -349,10 +349,10 @@ static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
 	ct_ft->nf_ft.type = &flowtable_ct;
 	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD |
 			      NF_FLOWTABLE_COUNTER;
+	write_pnet(&ct_ft->nf_ft.net, net);
 	err = nf_flow_table_init(&ct_ft->nf_ft);
 	if (err)
 		goto err_init;
-	write_pnet(&ct_ft->nf_ft.net, net);
 
 	__module_get(THIS_MODULE);
 out_unlock:
-- 
2.47.3

