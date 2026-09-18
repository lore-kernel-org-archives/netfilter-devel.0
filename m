Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E004E322E;
	Fri, 18 Sep 2026 11:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730935; cv=none; b=p0PTa45iCwM1C3cwqAtHhS3Uxf4aD4jPTgT59eQmRf0K1xfxThvBvY10MV6EN3JUS1w8zmiULv+4whOpxXu8ES20hvW9uODXcxneUw8l9o+cbwh5x1DFbk3+zYKqM3Dg7UaoKDuRN/sccLiMs+z+Zwhzwb+uxWEQLL6HqL+zQk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730935; c=relaxed/simple;
	bh=4HfuHVWBDeEsxxv8e0VT7aodI1+OuVHGTWmLKRxxxvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AC6mam4GXgp5GzgVUB6Zv+34i17I4D2R2H32eQ5A+Bpo+1O58xVx4cxeE9K1gvyhfPqdFIvzAsKniTHuVJd/IXlUeI4cORBNSGpGOFb4jljhg9EuOs5FvqBPMzIyZ/zd5RfGAUFcNHoSZnjggDKcRshsZuHHj4d9iTuAjy9umgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=N1+xcMZP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="N1+xcMZP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789730931;
	bh=2X8mObAesaPVjweNT9/lS2qSkKHcZ69bb7cf/OianZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1+xcMZP6ovkRNvRtamWh8248zAvywTZ/jaOYvJld5ScawyEFkl1NpATNL6cuZzoO
	 PTuco7GwlEF6oWd0XX0W0E6yRqF3Mhra88i9MawBrTuQHG1CNYLRqiudDZosQBLiHu
	 caay8bZS/xlR5Dc3eko/Iadiq89/Z85pJyJQz/G1aM9R0gb1TvYggTeBLSft/pUaz/
	 mXAgwqh8MjLB1wNlZiaaFr8Y8yioORpuC7lQz4TdQBG+iBLYIb9VZAVVAnlux+3mpT
	 cjGCQHs73WeAIKd3hCrRkNu1XfgORUgV7sqrFn8iVXTXtmrUunISoM8rBJ4CYqHs4W
	 ubU0scIvinOiA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A540460060;
	Fri, 18 Sep 2026 13:28:50 +0200 (CEST)
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
Subject: [PATCH net 1/8] netfilter: flowtable: publish HW_DEAD after worker is done
Date: Fri, 18 Sep 2026 13:28:37 +0200
Message-ID: <20260918112844.194503-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918112844.194503-1-pablo@netfilter.org>
References: <20260918112844.194503-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

flow_offload_work_del() sets NF_FLOW_HW_DEAD before the work handler
clears NF_FLOW_HW_PENDING. Once a flow is both HW_DYING and HW_DEAD, a
concurrent garbage collection pass can remove it and schedule it for RCU
freeing.

The offload worker holds neither an RCU read lock nor a reference to the
flow. If it is preempted after publishing HW_DEAD, the RCU callback can
free the flow before the worker resumes and clears HW_PENDING, resulting
in a use-after-free.

Move HW_DEAD publication to the common worker epilogue after the pending
bit is cleared, making it the final flow access by destroy work. Order all
preceding flow accesses before publishing the bit that allows garbage
collection to free the object.

Fixes: 2c8897953f3b ("netfilter: flowtable: Add pending bit for offload work")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 801a3dd9ceea..6757fd89c1f1 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -995,7 +995,6 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
 	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
 		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
-	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
 static void flow_offload_tuple_stats(struct flow_offload_work *offload,
@@ -1059,6 +1058,12 @@ static void flow_offload_work_handler(struct work_struct *work)
 	}
 
 	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
+	if (offload->cmd == FLOW_CLS_DESTROY) {
+		/* Publish after the worker's last flow access. */
+		smp_mb__before_atomic();
+		set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
+	}
+
 	kfree(offload);
 }
 
-- 
2.47.3

