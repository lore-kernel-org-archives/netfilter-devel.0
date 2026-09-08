Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72BA4EE847
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2026 10:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861787; cv=none; b=iOSmdgPL2HkGB6on7lCBPQCjVWX7KMY2oxv5R4ybzKElzYmXvCdn0jE8/8+kzcBcIw3EtdyTenwbmmT1FSljjqNbHKMdsJ5wlx2sM9AwIbXTJeUzpqSgGrqxAeRYw4498U2imQ/qK/Y0FAhe+nuISIjp9JEdUlYidWqNXesA8ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861787; c=relaxed/simple;
	bh=/vm75KDd2UZODwi9HM8GqqmF2ySzrv6jd4m1pyZUZKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWHezirezo5D9EkKYg/FBcc9sBqTO4Thf6phmRO8faa99uKisQ1gh511GT62Wn6GNQ2D1vGNgQ3bK8696sUEC3PJaQC59xi6Iy45sBjVa93Kv03faq/Q0J8CiIS1utgeCTIGz1ZdWoONDHAm/kZY7vBUMFz4iGWzHVrt4pPyzpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LQTaC8ME; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LQTaC8ME"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uhVBiifoD4HIc9bi/wPY92uYACDhT80YIfQshYq2hOM=; b=LQTaC8MEdhN0j8yRAiAbw2Co8d
	u8kq8nZIBgXOTqD5ZP6estCky5pIsQ18IL4pszV7QfF07Sz1pj8roj2ifXRIVaTso43QZWnHqocjB
	PP/7x7JshuHlxc0TVJqybTFg8tBMp+x6CwKTfLIu6/prbOHIwPsjz+4TAqixkW9GPgXRcQ9Tko02O
	XKrX+2Jb7cSEu4ruWeY8dp7UhMde6rUekDM69yIl8ov/FqzQ2gdiljFDnLIMIxSISk1BkcBFlyXvi
	G8hpzgIkzss+EfbZMtF8U/HVOtHYkLOcfVPuGMYfHWKeJbIrKwmKeTT8voGZSfCd4QD/+vHRF0YzQ
	vl72dyvA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x3sfP-000000005SR-3iW4;
	Tue, 08 Sep 2026 12:03:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 2/4] netfilter: conntrack: Untangle drop and invalid counters
Date: Tue,  8 Sep 2026 12:02:54 +0200
Message-ID: <20260908100256.2648175-3-phil@nwl.cc>
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

In nf_conntrack_in, 'drop' counter increments if
nf_conntrack_handle_packet returns NF_DROP. This is a special case with
TCP packets (added by commit 6b69fe0c73c0 ("netfilter: nf_conntrack_tcp:
fix endless loop") and not related to invalid packets which are
responsible for all the other <=0 returns. So don't increment 'invalid'
ounter in this case.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_conntrack_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 53401e21ad99..f9b8927327ba 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2065,9 +2065,10 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 		if (ret == -NF_REPEAT)
 			goto repeat;
 
-		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
 		if (ret == NF_DROP)
 			NF_CT_STAT_INC_ATOMIC(state->net, drop);
+		else
+			NF_CT_STAT_INC_ATOMIC(state->net, invalid);
 
 		ret = -ret;
 		goto out;
-- 
2.54.0

