Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AB72EA73D
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 02:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779760956; cv=none; b=BgdT8tRKqjpD2sAfZqyjL9qp/7eMu7As8QLQe5tHfNx50ST9oi3Hl9KHQ0KZU5jl8SoSHSwF/b9tkrQNwS464vv3EzLgItHbAhh+8Z6/3OpGyA7DNac/SpBn/RCxMRGBJzBvwto4/3rfd8wCoxaanH9Z/4T/gw4JymVq1XFeQ+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779760956; c=relaxed/simple;
	bh=9SSGgAKoAw3Ql2lZ4mxtyVQTNzFNPVrK8C19984UgHs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kpO/vheJjJRhtScoppn3MqKbSHYeINpVev0csHhHA0hRSJC5Ik6k2wE1dfvpKIBzmmOFW6apGh6O92v4sWFEXM5idIgDsehaXy4OHaDwTKF71jTLgftnnOJogW5FfJwb0yQz2eI+BfmEnm+26WZgHyG5UqRtCg3r6TMqkOxWRAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VPzHZvwO; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VPzHZvwO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779760952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nlkUVQnxlsBn5Da8pELezcA3yclHp0l8rDUMAFVEJUs=;
	b=VPzHZvwOFhr5EEhsSsOoP/9BnzMJR5n7vtkezfADa/5lkV7PJio5ccVzfEseBGZNth3tLO
	A1rdgryVPRo8mF5Tf9VtgxW/EwT3/5rOzCMjWWosXHIDyaxiSEPGPsWsqfpSMvrGmarYRM
	r1bOHz8Zxz45lyDMZe6pVv3rkGA/13k=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: netfilter-devel@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_fib_ipv6: bail out of sibling walk if rt got unlinked
Date: Tue, 26 May 2026 10:02:27 +0800
Message-ID: <20260526020227.4857-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This was reported by Sashiko [1].

The RCU walk over rt->fib6_siblings can spin forever if rt is unlinked
mid-iteration: rt->fib6_siblings.next still points into the old ring,
so the loop never meets &rt->fib6_siblings as its terminator.

fib6_purge_rt() always does WRITE_ONCE(rt->fib6_nsiblings, 0) before
list_del_rcu(), so readers can use rt->fib6_nsiblings == 0 as the
detach signal. The same pattern is used in fib6_info_uses_dev() and
rt6_nlmsg_size().

[1]: https://sashiko.dev/#/patchset/20260520023411.391233-1-jiayuan.chen%40linux.dev
Suggested-by: Florian Westphal <fw@strlen.de>
Fixes: 1c32b24c234b ("netfilter: nft_fib_ipv6: switch to fib6_lookup")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 net/ipv6/netfilter/nft_fib_ipv6.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index c0a0075e2590..2dbe44715df3 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -191,6 +191,9 @@ static bool nft_fib6_info_nh_uses_dev(struct fib6_info *rt,
 
 		if (nft_fib6_info_nh_dev_match(nh_dev, dev))
 			return true;
+
+		if (!READ_ONCE(rt->fib6_nsiblings))
+			return false;
 	}
 
 	return false;
-- 
2.43.0

