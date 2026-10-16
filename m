Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40005246784
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 09:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792142206; cv=none; b=J9ycbgOlxvxcCLDTWUHLmqz4CckvEF6ut85k8Up08GKyAxxLdm1ZNfskVYpTj9+xEaIveUjbRkobuPQQN4UHFLV6YB2l2znyhSd3ysXl9if19iKaPZOc/rGQTtwBhNlapocZXrQQh0MVwwU8PiBY/q56QHGP+NqJVrjilulcWb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792142206; c=relaxed/simple;
	bh=b4dWQl7hMad9YzCHfPfItzDS0jwKGW8idn009o631kE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=D+rZLlC97R80k5OhGmeiFy5j04pZ/uXcVp+xK3Q+OJHOl61FO0Ddxs/HI3N9jBv9yLDepFOH3L8eDJd20B1Y2GUT7y4lrIXNU2hdZYwFDg/NbVf/AeFFKCSAF2JLK/ZLCMw1330z8xQkvVVqWB7Vqld/Nk+EWwhutodWObTmiLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FUVcHRie; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FUVcHRie"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792142200;
	bh=yN4iWlZdNKAaDNtr97y2ZSI3l6ddN08KpvKJpEbt9xM=;
	h=From:To:Subject:Date:From;
	b=FUVcHRie3v+OHR1wLBEprM0Avf63xyWHP2wskHPU3UZqjH/isoR4E+GHPplxCWQCM
	 o01Q6VGmhVtbUmO57HR9bn2Bx3wgE9icwL5QvhXEHW7DZrY9U+Gjaex2OJCY9uLxZj
	 DdlM3hHQHPSh3Ki+ahGOHyk5VhyhNPgn9EUBaA7TdrrNa8cjRGsK0cbaBWmAr6JHk6
	 cDMk3JDAQG147nYqTPw6LzN4BKsy8m/CUIAOwzfEY0tZwG03xmD4/S1n1Z/d+euzQW
	 0s9FRrfVRt8VvklpPKSpC2vfTikvyIvXbiXcTEoTEjVbYWkGDIPpMX1jZ8vIvnlPpQ
	 9ebvaz53IlXrg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 390B460058
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 11:16:40 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2] netfilter: flowtable: do not hw offload flows in teardown state
Date: Fri, 16 Oct 2026 11:16:37 +0200
Message-ID: <20261016091637.1675459-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko reports that refreshing hw offload from packet path is racy
since the flow might be already going away. Refresh the flow instead via
GC worker to address this, ie. if hardware offload fails, next GC run
will give this flow a chance to offload it to hardware.

Since commit 7c549fb7eecd ("netfilter: flowtable: generalize pending
status bit"), GC skips flow entries that are still pending to be
offloaded. Let's just check for the teardown status bit after the
pending bit is set on to address this race.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: restrict this only for add/refresh.

 net/netfilter/nf_flow_table_offload.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 5aed013d6468..2b9446207cc0 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1123,6 +1123,12 @@ void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
 	if (!offload)
 		return;
 
+	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
+		clear_bit(NF_FLOW_PENDING, &flow->flags);
+		kfree(offload);
+		return;
+	}
+
 	flow_offload_queue_work(offload);
 }
 
-- 
2.47.3

