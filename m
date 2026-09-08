Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D612351FCBA
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2026 10:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861786; cv=none; b=aSdi76gwQwA3T/Z2X9F/3K/HQ0AcCXm/PzZrwuocJFgFRZqc7eMkVKWsosBPz+nrpUZi9IcRUlB5EjVEqSatgL1YVgVBFhxf6hIDY/fWg2WaXE/cc/yBxEqIDS3ipl/dc/7QuwepMkZyUGjMov+9OTuep5gbZJZi6CcYfVVZYBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861786; c=relaxed/simple;
	bh=7LxrUb+g1AgYbS1ZmWNkxf4rNj3ehXfen3Tpaiq9B1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIVe3DCpir1kJjkfsj0qO3RJAnvobJWS9OK27qcEBPsmTSNzgzlR7aUDdNX2r9BRg/8gbZTGsGX7UQg+lVr68N040dNlonavJkHD0Rjmq6Nrs8oRPo7EGKlY5AleQaZql8pffIWl43BEAN6IeGmozmE7W5a8J6yDd629HAoVrO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bOCUfGDm; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bOCUfGDm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XzBIkUH5KhTwC5NwOjnLNd8R8gGKb/o11Db31hNPxO8=; b=bOCUfGDmC6SbmE/SamVep8Yada
	oHDMD7r6ph/Hq15jKtOKOabwOb3Ywc9ehqcD8CEOIewiQ0Wi1a0yFfILWIX2JlZ+J/yz4YoeZwt39
	7581iuHbkGWHPHaDIBEYMbljJ3IsKhRaNYlqEsl/T9Lz7kGT8z84klTuVLt+ZBCE4GxmFqlcFc3/6
	gs2byfRuqzfRPuvbOOfD/SzGfX3DdblqQOSCrjvPBHYi1Giifdr48KTEGXF5W0M3OsNhDCjIJbVNs
	9B0UZ9giKW0VBHckreyyOzNnSd+odqkJFfiOV2Mc+ezqJtFnRQRklTrLo7o1OrD2BsxXcWSjYE8F7
	W6q0ToAg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x3sfP-000000005SM-1f0M;
	Tue, 08 Sep 2026 12:03:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 1/4] netfilter: conntrack: Untangle insert_failed counter from others
Date: Tue,  8 Sep 2026 12:02:53 +0200
Message-ID: <20260908100256.2648175-2-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260908100256.2648175-1-phil@nwl.cc>
References: <20260908100256.2648175-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is not much sense in incrementing multiple conntrack counters for
the same situation. Defining insert_failed as a situation where a valid
packet's conntrack can't be confirmed due to unresolvable clash sets it
apart from 'drop' (ENOMEM situation) and 'chaintoolong'.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_conntrack_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d0d9e5ea84a0..53401e21ad99 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1169,7 +1169,6 @@ nf_ct_resolve_clash(struct sk_buff *skb, struct nf_conntrack_tuple_hash *h,
 		return ret;
 
 drop:
-	NF_CT_STAT_INC(net, drop);
 	NF_CT_STAT_INC(net, insert_failed);
 	return NF_DROP;
 }
@@ -1259,7 +1258,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		if (chainlen++ > max_chainlen) {
 chaintoolong:
 			NF_CT_STAT_INC(net, chaintoolong);
-			NF_CT_STAT_INC(net, insert_failed);
 			ret = NF_DROP;
 			goto dying;
 		}
-- 
2.54.0

