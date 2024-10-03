Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B78B6A8D2
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Oct 2024 18:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727980693; cv=none; b=P84zgxAMih8T6/SrbKqKNilPCHx2Z3rOT4uq6OphCqHtQAm1VQyFmAG5zl+AOYlvvafF4AabrhxLy8swz+bJne8Zh5NEMBrpHWpFsSW5wrDIBy0Qd/lkp20BswpJHLmy1ZWRy/UrM7jGUrsXbx0y8ds4PFgnGsUSOlVeK3E6FQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727980693; c=relaxed/simple;
	bh=ICcN1EBvAz51jrItT31p6P2w9MfqQ10cPI07baOXLIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qzz/b/qL7JlNtflRfsYAfrh5Xefk9F1Kj5Jo7PeGII8hnXCEfrMi0ee8XC3YtOBBO8uziE8msEbkfFQtUeVGU3q74id3/8/kW/FoEr/b0IH7Y1tgYr+dHPYKYIFlSPJlr6mpTFjtb0SKr2i8T2uJuSyCYOD06pc5xpr5gPRQfdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1swQiB-0005rH-SQ; Thu, 03 Oct 2024 20:38:03 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: syzkaller-bugs@googlegroups.com,
	Florian Westphal <fw@strlen.de>,
	syzbot+256c348558aa5cf611a9@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: xt_cluster: restrict to ip/ip6tables
Date: Thu,  3 Oct 2024 20:30:46 +0200
Message-ID: <20241003183053.8555-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Restrict this match to iptables/ip6tables.
syzbot managed to call it via ebtables:

 WARNING: CPU: 0 PID: 11 at net/netfilter/xt_cluster.c:72 xt_cluster_mt+0x196/0x780
 [..]
 ebt_do_table+0x174b/0x2a40

Module registers to NFPROTO_UNSPEC, but it assumes ipv4/ipv6 packet
processing.  As this is only useful to restrict locally terminating
TCP/UDP traffic, reject non-ip families at rule load time.

Reported-by: syzbot+256c348558aa5cf611a9@syzkaller.appspotmail.com
Tested-by: syzbot+256c348558aa5cf611a9@syzkaller.appspotmail.com
Fixes: 0269ea493734 ("netfilter: xtables: add cluster match")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_cluster.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index a047a545371e..fa45af1c48a9 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -124,6 +124,14 @@ static int xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
 	struct xt_cluster_match_info *info = par->matchinfo;
 	int ret;
 
+	switch (par->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		break;
+	default:
+		return -EAFNOSUPPORT;
+	}
+
 	if (info->total_nodes > XT_CLUSTER_NODES_MAX) {
 		pr_info_ratelimited("you have exceeded the maximum number of cluster nodes (%u > %u)\n",
 				    info->total_nodes, XT_CLUSTER_NODES_MAX);
-- 
2.45.2

