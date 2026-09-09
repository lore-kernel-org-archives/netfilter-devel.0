Received: from mta1.migadu.com (out-29.mta1.migadu.com [95.215.58.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7AC45519D
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Sep 2026 07:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788940580; cv=none; b=RH0ejyA1NJ/OTBfmyfyWOw7Eq6Su4SgVWutXbar2Zni/ThNFZOskcbZUgT+pIdCw2aYHKR3sidkPm5jbGAdE7znoxrEdeEJ0WwYno8NB7Guj7lJWDiLpwgocLKEpvboRnKD3KyWzgc/vcJXtc+pKTPGrj/shDzy7U5VuZkpPp3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788940580; c=relaxed/simple;
	bh=NNu2AEdz7//rwAJPmsE49oyejxssnUM+nGFAvmkANE0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sWC/pYu6bL4QdY4+QCTC27U6kUEmNkE/ILm6q8SL+9TQCCORM3BoXIVi1KI52feaBNCfrjFO1Gt3o8mb827IHdCzn1QJjIT/KAtrtYh96jFY4xZwWXXPikbf2b230c6kf0sFRCHIZLRZ35V1a5zHgVFQsqXb6kpZUssvEK1KY6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hpH474kx; arc=none smtp.client-ip=95.215.58.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hpH474kx"
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NNu2AEdz7//rwAJPmsE49oyejxssnUM+nGFAvmkANE0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788940575; v=1; x=1789545375;
 b=hpH474kx/DPfAC+QG78HnSjXVeZNzizOAs326X6xbHWV9vOSfTTBouBHh2aub+TJ+kVvPxHx
 RxOrXR6D3b5Hf8eKjq5XluVFkrHaaSauN5GF7Mht26PhCc1SshwlE9D0sBJHpHkMbvcoqjq/owJ
 6Wao7A4bwKYOaVcfObijE0fI=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 590c92423473aef6;
	Wed, 09 Sep 2026 07:56:15 +0000
X-Mizu-Trace-ID: 590c92423473aef6
X-Migadu-Flow: FLOW_OUT
From: Qingfang Deng <qingfang.deng@linux.dev>
To: netfilter-devel@vger.kernel.org,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Oz Shlomo <ozsh@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Qingfang Deng <qingfang.deng@linux.dev>
Subject: [PATCH nf] net/sched: act_ct: set net pointer before publishing flowtable
Date: Wed,  9 Sep 2026 15:56:05 +0800
Message-ID: <20260909075606.1508155-1-qingfang.deng@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_flow_table_init() adds the flowtable to the global flowtables list.
However, tcf_ct_flow_table_get() sets the table's network namespace only
after that call, leaving a window where the published table has a NULL
namespace pointer.

Set the namespace before calling nf_flow_table_init() so that flowtable
list walkers can rely on it being initialized.

Fixes: fc54d9065f90 ("net/sched: act_ct: set 'net' pointer when creating new nf_flow_table")
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
---
 net/sched/act_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 9080cb386c16..6bd19db68d97 100644
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
2.43.0

