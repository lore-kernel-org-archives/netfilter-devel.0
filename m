Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51F53F54C5
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 09:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403149; cv=none; b=qZv+ydSBwT0s3TE5ZnmRXSSTsG73FSPLNxMk8cDx2g/vRtMvs/aZVywB5wlWtyS6OWdm59/TXCnR/7jZZntKMWv4MaOiwZJvl84cPQPNsMdRVWeYjKY0ePHJgekPu9sds7NJ86qeGcbZ9gY8TEIfNbJWQFF465qnPIZJbQWfibs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403149; c=relaxed/simple;
	bh=Tl02vchXIgWBbP/Gw6GTA6UvT0+m1BVvdteqrzZnxE8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HgdXwdtITxp9e+AdiMR7I2zQ9gAut8qikQntnybGI2nv5F9//4qzUppl+PoXfZUDkb0iXZUByoQPtVZk5fsIBsQHECpwhYTLP28TRC/7j0VvuzOmefmwhhA1tmc/kHZgJ3N+WT+Uqt3I36LZqd9TQQSj8SdWWOjazu++gat5B5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gAnAltFw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gAnAltFw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3Qj44x4EXKpidqCV/7i8pdclVSL4AZ7WS0Po8lDOGlo=; b=gAnAltFwxE8uJDBVt3i29VvscD
	2zrjxEqJDKxxBat8/akxIEUWeMSXDkbk/FpfS0HoQODdkcgMpJC/8iMNpwBTD8kE4SEiUZKw6iOpx
	lKrsYo/yHhD5hrIbEbzgNC12zWU/k7EvF+/AfR5+rUgZ1toTBSOlUiKM6N/2CjazXlOV18KT8OXVl
	NQQAnjC5DZyvcFoBDniz4W4doMY+xlqMbN63oQkGqYI/3S6z9UvL+xU7yBuBjyIc767zcYBsCzcvx
	yZpzPx/JgCdd3a8j3kNQCxZjzXnkd3+c4u2qEEt8BazZFaLdOcWqgtWfEUa2ML8NF2xkq1D9cXBGO
	jtJ9prgw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wpMut-000000003sK-3ezX;
	Thu, 30 Jul 2026 11:19:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH v2] conntrack.8: Document --stats counters
Date: Thu, 30 Jul 2026 11:18:24 +0200
Message-ID: <20260730091858.1982235-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Provide a brief description of each counter's meaning based on
code-analysis in kernel's nf_conntrack_core.c and feedback from
netfilter-devel list.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Update descriptions as per feedback from Florian
---
 conntrack.8 | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/conntrack.8 b/conntrack.8
index 2bfd80e5d6aa4..bc78c4823881c 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -108,7 +108,47 @@ Flush the whole given table
 Show the table counter.
 .TP
 .BI "-S, --stats "
-Show the in-kernel connection tracking system statistics.
+Show the in-kernel connection tracking system statistics. The returned values
+for each CPU are:
+.RS
+.TP
+.B found
+Number of times a tuple was already found and had to be adjusted  when setting
+up a new NAT mapping.
+.TP
+.B invalid
+Number of invalid (e.g., malformed or non-IP) packets encountered.
+.TP
+.B insert
+Number of conntrack entries manually inserted (via netlink or eBPF).
+.TP
+.B insert_failed
+Number of new connections dropped because of unresolvable clashes with existing
+entries.
+.TP
+.B drop
+Number of packets dropped due to memory pressure.
+.TP
+.B early_drop
+Number of connections dropped in an attempt to recover from a full conntrack
+table.
+.TP
+.B error
+Number of invalid ICMP/ICMPv6 packets received.
+.TP
+.B search_restart
+Number of table lookups which had to be restarted. In rare cases a lookup may
+encounter an already deleted entry which causes a search restart.
+.TP
+.B clash_resolve
+Number of entry insert clashes resolved. These happen frequently with DNS
+traffic and thus not neccessarily indicate a problem.
+.TP
+.B chaintoolong
+Number of oversized hash bucket encounters upon inserting a new conntrack
+entry. This is a fatal problem for conntrack and it will drop the packet as a
+consequence.
+.RE
 .TP
 .BI "-R, --load-file "
 Load entries from a given file. To read from stdin, "\-" should be specified.
-- 
2.54.0

