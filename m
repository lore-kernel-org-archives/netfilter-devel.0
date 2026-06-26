Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AE925B08C
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2026 12:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782477105; cv=none; b=iX92SVeGoqfq+KjAwKYf1dqZRwpHHyCJNmthDvBJvDl6T9N4OTZSAR7YduKIrQ/8WzKvgSy9I+/IFUtiHraVhRc5hkUa2O1gujzeyyU3/us1GXbccBv15MVn/ryTMKvNpKuLS2pF+KKIQcMsKGExXSB0alhCn+qgKn8oga6hqEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782477105; c=relaxed/simple;
	bh=Kif0EMg7VDB8uLMvyEDgRLoaifq+Ali9xExMJVQfe5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AMTimTdCz/1qzrKMUx/+PBUqh+09eNDi8SrPP7//gvGsflRfrnb/+TvIBdeiro0nDJMPHhwgKKpLPfuGdxHCHq28lvrdfKHdXm7N6gz/3jNW7wCgHaPHjwHiVML3SsRN6xChP3TGap9x2Va6i/szo3nbijHGEwgF8qEPUyTf/yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A9098602A3; Fri, 26 Jun 2026 14:31:41 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: conntrack: remove obsolete module parameters
Date: Fri, 26 Jun 2026 14:31:28 +0200
Message-ID: <20260626123131.23096-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

1) Switch nf_conntrack_helper hashing from full tuple to name and L4
   protocol. Prepares for tuple removal.

2) Remove tuple from conntrack helper definitions and eliminate redundant
   protocol registrations. Add netlink policy validation to prevent protocol
   number truncation.

3) Remove obsolete conntrack module parameters.

Florian Westphal (3):
 netfilter: nf_conntrack_helper: do not hash by tuple
 netfilter: conntrack: get rid of tuple in helper definitions
 netfilter: conntrack: remove obsolete module parameters

 include/linux/netfilter/nf_conntrack_h323.h |  2 -
 include/linux/netfilter/nf_conntrack_pptp.h |  2 -
 include/linux/netfilter/nf_conntrack_sane.h |  2 -
 include/linux/netfilter/nf_conntrack_tftp.h |  2 -
 include/net/netfilter/nf_conntrack_helper.h | 10 ++-
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c |  2 +-
 net/netfilter/nf_conntrack_amanda.c         |  4 +-
 net/netfilter/nf_conntrack_broadcast.c      |  2 -
 net/netfilter/nf_conntrack_ftp.c            | 32 +++------
 net/netfilter/nf_conntrack_h323_main.c      | 10 +--
 net/netfilter/nf_conntrack_helper.c         | 77 +++++++++------------
 net/netfilter/nf_conntrack_irc.c            | 27 +++-----
 net/netfilter/nf_conntrack_netbios_ns.c     |  2 -
 net/netfilter/nf_conntrack_ovs.c            |  6 +-
 net/netfilter/nf_conntrack_pptp.c           |  2 +-
 net/netfilter/nf_conntrack_sane.c           | 34 +++------
 net/netfilter/nf_conntrack_sip.c            | 45 ++++--------
 net/netfilter/nf_conntrack_snmp.c           |  4 +-
 net/netfilter/nf_conntrack_tftp.c           | 33 +++------
 net/netfilter/nfnetlink_cthelper.c          | 21 +++---
 20 files changed, 108 insertions(+), 211 deletions(-)
-- 
2.53.0

