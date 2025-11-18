Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC42F2C0266
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Nov 2025 23:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763509831; cv=none; b=Lr7tqbQTHreMg88xePqpy9J5Yn0Wn4xSOPPSYXRitEG9Y7w8ymNpL3CAGRELSkHhqSboNt+FbVnUWgbWb5dFDYh0heKo4B7KURUzro7hiI9sErpiVRvIhlDrImnSdElbyTH+FZfV/Oyv2zfdgy0EWOPoJr2Plb/l99HPOdUSpyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763509831; c=relaxed/simple;
	bh=4gmSRXZMzaAl/czxycXpo/eG6dcTCMzS3VtVt2YFoYM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZLODT9ZoGDcZX9rSbdHjBKRTx1IVOCvNR/uX+Av+WQsK+6jlTlqZlN1DLW1SSSiY4+6cz7VXA/VkKE34e+/rLTZe8kppXTyztD2QMoayzo7gylGz06mQo2nHdMms2dYl1y1Avs4FQjeCH19rV6J2fkZIa56BPRRZOifgh9ZDn2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YmKtwu4f; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YmKtwu4f"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 32BAC60272
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Nov 2025 00:50:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763509819;
	bh=v4t3r5tHthydrZAcd1JwPVeZY4eGPC0DbaniB7zuWaY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YmKtwu4fle8msIjd1/Hx9AJT2AVZMIUCsmyQu35eDNqYSsCKXMkq+92koGF8RoFjC
	 jmxy8uVfmNJN+q+z8yGQLir+IWQK7FSApFZq683vQ1bmTgR+2sShJfsitg5/PeoCzU
	 kr4L2ajoiNEnP6UmKahybULfWP7vKP/UBVijdJDHlT/z1X+54WOeuB48/t265Ikm57
	 dvyazi3CDOmsKZX8s1lAhmXXAu6n6b6qyiErVEohAO8uNN3OOk8t0bRagaw73YcJ9z
	 kfvgqqsHWvQRp6aeGHiXEiITUBuasfbuGEE3jlIcCIevZ+Yolciw69oh5nsKIvoA1Z
	 fog3xhCjHWNkA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/2] netfilter: nfnetlink: bail out batch processing with EMLINK
Date: Wed, 19 Nov 2025 00:50:09 +0100
Message-Id: <20251118235009.149562-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20251118235009.149562-1-pablo@netfilter.org>
References: <20251118235009.149562-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Stop batch evaluation on the first EMLINK error, ruleset validation is
expensive and it could take a while before user recovers control after
sending a batch with too many jump/goto chain.

Fixes: 0628b123c96d ("netfilter: nfnetlink: add batch support and use it from nf_tables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 811d02b4c4f7..315240b2368e 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -558,6 +558,10 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			 */
 			if (err)
 				status |= NFNL_BATCH_FAILURE;
+
+			/* EMLINK is fatal, stop processing batch. */
+			if (err == -EMLINK)
+				goto done;
 		}
 
 		msglen = NLMSG_ALIGN(nlh->nlmsg_len);
-- 
2.30.2

