Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88DD4FD269
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2026 16:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790960180; cv=none; b=LNGt4bWEeTnux24M4bVN+gMbkc+3FhUHTLJc+wO7VNLyPTMB/azxidBcUPGIVT4Gji4OIUpZpYSsZdbuYN4dZm2lApaX0HHxCszeHi21J0WfhR6cWf+Z17whPr7Mzl2BkNwqpJUn20oCtvcYdnZ1OALxIFHmamRNGzllOR7bQsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790960180; c=relaxed/simple;
	bh=yvr4THWK+b359x9GAPgm8g4XYqFtpb7xUBVoOJlXZcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9D4asN+jmAGgE0+UCfHxRIXnDOj+Dic2Ca5TnB4+4439HzDE3Ocqn1zoMMS9hCnwqzq6Wft8P3Ni73HbdctUPo8dI2WMnUx9ihlFIYk2nAlgunOcJ1a1VULmEYFNqQVwqr1rvI1dEgiqTsRDqDF0LIr9E5RQgV6jUF0zyfT8yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QAiRgpaX; arc=none smtp.client-ip=74.125.227.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QAiRgpaX"
Received: by mail-pj2-f41.google.com with SMTP id 98e67ed59e1d1-3a6f8525bfbso169706a91.0
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Oct 2026 09:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790960174; x=1791564974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wizRrn3DJlyZ2Elw+HTCvVAyeo09ldgbQPuJfwoj4to=;
        b=QAiRgpaXlooI50Qgfb7L7k8wvT1o58ots5e26kFsGJHtcBBO4Bp0AiH7l1N9mOnHok
         U3W7y6egLMvh+WYyCamxLrFdfHxvGBz54QgGosN6Ej72OqptUXXcFaOOydMNs3joYSFN
         PFV/9Pc/a//sEhUxgGuH45dEeNhSOrDIi7jXy4eyXnrZbX3Orctgt8Na7pq+xe9enjws
         fRI6dxmj4wStTS0kotEzAx4vT9GKS+FpUbtVmSg8kLzD+kQIYAnroDA0lvKS147lVmXt
         w3P1m0X/nuPU8aIVx3NXv5Q3HzjmNBMf1GYgahyT5gRYCD9ZaAD/jvG4oiIrdV4y+hDa
         8eBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790960174; x=1791564974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wizRrn3DJlyZ2Elw+HTCvVAyeo09ldgbQPuJfwoj4to=;
        b=eJnKbsO1vQoJDj1ux2Z28BTW3nyRNLakdfkz08XN4ReTuzOiPMahP5Wl1Qh4DdxPcp
         RQZ3P+qV5nlbLAWAElIvwQ6u4Nl2JuFyFp2Xlt69uqqy5XAjcvUMk8XaOpI4yXTC6aBq
         b9tRBn44vH8Hq/A856tGEeKw0kC+3RjdYMxtYCxfvzNYipNOIBtc67z8d35e9vviPEwC
         qPQTndu9BCvdJvt/yXKNAUEvCF7IJGu3RJW0tjImlrv5POxoUtcXb/jx8pkr+Ol3dnMo
         8duQrGl3sv3edrew1jYGeM1WPvJn+s8BsXspfCynt9QrPwibPATCo1I+2NymD0MvkaUt
         5ydA==
X-Forwarded-Encrypted: i=1; AKwUvBwWIyUMeFMyf2P2Zx2GDDkd4abc07l8dE8O/7BAM0atCl2yxjUsllNmxccDgZfTa2W4lGuPqlga7muiIP4CkQw=@vger.kernel.org
X-Gm-Message-State: AFq9FYI1uCGlM6T5sJyMkUgzFesQSzLQVNa4ttgO6wVXBTx5OC46wWw5
	4Ub4GiyDTX+TGRMgrwXPCuj1tqeouStMTG3dvfjUAE4f/zE26y2XGxu0nqsY0Vul
X-Gm-Gg: AYBFou0yTsNTysw4IltnavdBBKLhuQJZv5JSG4D1C6Q5eTixb36hkVMeKcTmGMRmm4r
	4Jv0GdkYitQ+S7cfE1cB71TVROZWy1zD+3HH1/2BSSFJR2m7Ati/sMG4BX2gnRYOdE44c1FBUDN
	2cjLCW3QSR0UJPlQPLv4nh44hUY1Cc2Y9LNk3BLYNQdsNg5pMKNx91LLuiWenuywi+0/jOGuVUg
	e83D4VhYkug7C96IrhmA6jxSsQ4kFY/m+kyHj+9re9EZvdjnXM5IyOyGXh3MM5370A5jQyNmNHE
	YWCI/f7U9wqcl4nBAQ+MFkP/zGQ5hfE0qbC/zo/loiia5DmCYtwU1RXeZMDqY50mcJwkTGdsDvX
	7lXKmzcAqlOGbR4raLZHn2plnQqPEhlwMxtbV31HRmuiR0Gwkkmk6inm5+rpa0jczcIwynY8ZPr
	JhZh49twzqv9dmaSPsA0CL6b++tyg816oKLPWOynqlnuy3iIBHxKDN7cQEPKNclMB9vJ/ENwtHb
	6J7OBqGKfs=
X-Received: by 2002:a17:90b:3889:b0:3a7:eb0:119f with SMTP id 98e67ed59e1d1-3a70eb012e7mr335685a91.43.1790960174158;
        Fri, 02 Oct 2026 09:56:14 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a6f7f7482dsm2448670a91.11.2026.10.02.09.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 09:56:13 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	stable@vger.kernel.org,
	4ncienth@gmail.com
Subject: [PATCH v2 net] netfilter: conntrack: reject nested ctnetlink master chains
Date: Sat,  3 Oct 2026 01:56:01 +0900
Message-ID: <20261002165601.1754467-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261001180224.1018290-1-4ncienth@gmail.com>
References: <20261001180224.1018290-1-4ncienth@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Conntracks created through ctnetlink can reference another conntrack as
their master.  Userspace can repeat this to build an unbounded chain whose
recursive destruction exhausts the kernel stack.

Stop the repeatable userspace paths.  Reject a direct master that already
has a master, and reject NFQUEUE-attached expectations for such conntracks.
Keep regular ctnetlink and kernel helper expectations unchanged.

Fixes: 5faa1f4cb5a1 ("[NETFILTER]: nf_conntrack_netlink: add support to related connections")
Cc: stable@vger.kernel.org
Suggested-by: Florian Westphal <fw@strlen.de>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
Changes in v2:
- Replace iterative destruction with the maintainer-requested creation-time
  restrictions.
- Reject nested NFQUEUE-attached expectations while preserving regular
  ctnetlink and kernel helper expectations.

Tested on net 71a77ab76e74 and exact v6.12.105.  In both userns runs a
one-level master was accepted, 5,998 nested direct attempts returned
EOPNOTSUPP, and cleanup ended with nf_conntrack_count=0 without a crash.
A policy control also confirmed that terminal IPCTNL_MSG_EXP_NEW remains
accepted on a related master.  A real iptables NFQUEUE/NFQA_EXP control
created one expectation before the patch and none after it.  The related
object is W=1 warning-free.  The netdev allyesconfig and allmodconfig W=1
full builds were not run.

 net/netfilter/nf_conntrack_netlink.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4e5d7c70143683..c68e79d1ac87b9 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2359,6 +2359,11 @@ ctnetlink_create_conntrack(struct net *net,
 			goto err2;
 		}
 		master_ct = nf_ct_tuplehash_to_ctrack(master_h);
+		if (master_ct->master) {
+			nf_ct_put(master_ct);
+			err = -EOPNOTSUPP;
+			goto err2;
+		}
 		__set_bit(IPS_EXPECTED_BIT, &ct->status);
 		ct->master = master_ct;
 	}
@@ -2864,6 +2869,9 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 	struct nf_conntrack_expect *exp;
 	int err;
 
+	if (ct->master)
+		return -EOPNOTSUPP;
+
 	err = nla_parse_nested_deprecated(cda, CTA_EXPECT_MAX, attr,
 					  exp_nla_policy, NULL);
 	if (err < 0)
-- 
2.55.0
