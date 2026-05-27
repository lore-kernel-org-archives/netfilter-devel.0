Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AAE37C90B
	for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 17:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779903888; cv=none; b=nXr6ixYr1JtDWR1cTQF3MkFXLJeQb2NoWxcCMRLb/cok0WKVx70HbSrffocnMg+RhwwUI32hNdM2QGcxfUd+IKky/0NNPGDI0GgfeIXGQB4OrAKZGjWcNeLu67VpGEUlsw5Hcp8JpZJ3VnufSlqAHpJiGo4Csxhpru6ozInMC4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779903888; c=relaxed/simple;
	bh=+nvfFuU1jgS8Z1oXNN72X3yP+O51WHqmuYNbkyGSHtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wnk5TVurxRoUD//OEavg6Ka+CjFz96jmb3egz78q40C/oMllye9M3nauLmQ9uVq9efceTvGVMWTdCDvwn8N+Q4DZD9WCly8c2zPzj7lLXBUjjFNYWUYs1n1d2V7dqhUKAb8TdwuDop0Py5OfaYX6hcpbd6/0iA+THq4JWP3hZPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gJHc/G3f; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gJHc/G3f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=x+xlai38jZE/fyRqZXjXRHFxAqYg8+veTpYpnOndyzE=; b=gJHc/G3fZxBxXbl6mBuW8uw1HP
	UDanma+Ejwnni9ndbZ4X2CuxP+nv9GAF33GB/23EW31Cu1nM9g1YoCPy1RCq41p/so9kqrWkl8kTn
	Aqdv8MVvgCjH8jcXUGS7nhodZ6AF5BP2DFUhlyD1IfAD8HLRD2jOLfsdiPSjIzl0AhDT2qZpEOmU8
	PDGVZjKhAzW3c1H7URMKL/A9k2LKzuEHtiCcENQEKYvlrrAmWWpRr23lAFbEpngAHL8L3yXVvvd0p
	2mCycA+79bLBWgWetpiBJ5+7XhnvuiwbBclWjJGAkaaK/KVk/igPbbmFEdw+mMnKkDi2gVa5Mmo71
	KqplazKA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wSIDf-000000006oy-2EIT;
	Wed, 27 May 2026 19:39:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [conntrack-tools] conntrack.8: Document --stats counters
Date: Wed, 27 May 2026 19:37:13 +0200
Message-ID: <20260527173858.2546091-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Provide at least a brief description of each counter's meaning based on
code-analysis in kernel's nf_conntrack_core.c.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
While most values are pretty obvious, I am not entirely sure I got the
insert_failed and drop reasons right.
---
 conntrack.8 | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/conntrack.8 b/conntrack.8
index 2bfd80e5d6aa4..b562e16839a32 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -108,7 +108,42 @@ Flush the whole given table
 Show the table counter.
 .TP
 .BI "-S, --stats "
-Show the in-kernel connection tracking system statistics.
+Show the in-kernel connection tracking system statistics. The returned values
+for each CPU are:
+.RS
+.TP
+.B found
+Number of successful conntrack table lookups
+.TP
+.B invalid
+Number of invalid packets encountered
+.TP
+.B insert
+Number of entries inserted into conntrack table
+.TP
+.B insert_failed
+Number of failed inserts (clash resolution failure, conntrack extensions in
+inconsistent state, entry in dying state, oversized hash bucket encountered)
+.TP
+.B drop
+Number of packets dropped (clash resolution failure, removed conntrack helper,
+stress, TCP connection aborted)
+.TP
+.B early_drop
+Number of packets dropped up front due to full table
+.TP
+.B error
+Number of invalid ICMP/ICMPv6 packets received
+.TP
+.B search_restart
+Number of times a table lookup had to be restarted due to table reorg
+.TP
+.B clash_resolve
+Number of entry insert clashes resolved
+.TP
+.B chaintoolong
+Number of oversized hash bucket encounters
+.RE
 .TP
 .BI "-R, --load-file "
 Load entries from a given file. To read from stdin, "\-" should be specified.
-- 
2.54.0

