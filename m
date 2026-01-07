Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027243596F1;
	Wed,  7 Jan 2026 15:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767799563; cv=none; b=ASvjJ2PBRCFCt5QJjkJija8GWB9I+Sco3MQpYX3dAXyyn1BkmJYGTMqxxudZXKzz444CDnNvXGBj663qm+ZnT4hZXGDp9A4UdSjReNjSw1kpcgCixta05TtP5R8wS3pkdf0vnq0MrSX+uOsYkBXOUG0N/giqUU+FghagyFZRvLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767799563; c=relaxed/simple;
	bh=883jdIi3G515fdDbZIDusQhNLICofB+V5dbl/fmOM90=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dw+PEdH7WtdUrjZLk/r/imWl6VvC9/bbPhDlVVeYDDqaQwc5yh3pv2+WKTAhdRJ5vApHb3sjT+cegnhO2oK/ZsizqTXBMMW9gaZj96MPYNPnBKmDbAiqQi3R2dQ16OkPXtfnvQOXl88PwaOuGsFw2gKpIyUtSN4jYCl5mNenKq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CAE5F602A9; Wed, 07 Jan 2026 16:25:58 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	audit@vger.kernel.org,
	bridge@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/2] net: netfilter: avoid implicit includes
Date: Wed,  7 Jan 2026 16:24:07 +0100
Message-ID: <20260107152548.31769-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are various headers/subsystems that include xtables or
nftables headers even though they are unrelated.

Also nf_conntrack relies on implicit includes, esp. for GRE
internals, which get pulled in via nf_conntrack.h even though only
nf_conntrack_proto_gre.c needs this.

Other locations should include pptp.h or gre.h as needed.
Start to remove some of these entanglements.

Florian Westphal (2):
  netfilter: nf_conntrack: don't rely on implicit includes
  netfilter: don't include xt and nftables.h in unrelated subsystems

 include/linux/audit.h                            | 1 -
 include/linux/netfilter/nf_conntrack_proto_gre.h | 3 ---
 include/net/netfilter/nf_conntrack.h             | 1 +
 include/net/netfilter/nf_conntrack_tuple.h       | 2 +-
 include/net/netfilter/nf_tables.h                | 1 -
 net/bridge/netfilter/nf_conntrack_bridge.c       | 3 +--
 net/netfilter/nf_conntrack_h323_main.c           | 1 +
 net/netfilter/nf_conntrack_netlink.c             | 1 +
 net/netfilter/nf_conntrack_proto_gre.c           | 2 ++
 net/netfilter/nf_flow_table_ip.c                 | 2 ++
 net/netfilter/nf_flow_table_offload.c            | 1 +
 net/netfilter/nf_flow_table_path.c               | 1 +
 net/netfilter/nf_nat_ovs.c                       | 3 +++
 net/netfilter/nf_nat_proto.c                     | 1 +
 net/netfilter/nf_synproxy_core.c                 | 1 +
 net/netfilter/nf_tables_api.c                    | 1 +
 net/netfilter/nft_flow_offload.c                 | 1 +
 net/netfilter/nft_synproxy.c                     | 1 +
 net/sched/act_ct.c                               | 2 ++
 net/sched/act_ctinfo.c                           | 1 +
 20 files changed, 22 insertions(+), 8 deletions(-)

-- 
2.52.0

