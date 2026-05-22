Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABB63C2E
	for <netfilter-devel@vger.kernel.org>; Fri, 22 May 2026 05:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779426111; cv=none; b=hAsmp7i9Zbz8S8C7lFktAniAwjveQszdgNL/M2NspZViWzB3ShCxLXlTGy27Psuhe9JNcg1/xk5mC20qVBK5So3Gvvv3rY5SMPhpwVjkuDUQGnwQgiAo0Us0Nn/ZqQYKj4cxQvKMBGdNe59akjdqWKDxJ8bIS3TMRqRSPLn2p8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779426111; c=relaxed/simple;
	bh=6JLlofDESk43bow59J7hdoH3yZVyZMtczLV9+pwKuNY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hJrPaoUKPU/E/x8m126q2YCHUWh4zgPeywXFduWKLUkkbW4FOM+jJMHTURzhLaxcnKDE3GebIN+v7hVBOT8quvfcSYuhTK1ZdpBs5WGc/6Tvt8br2r1Hbt/kY2ibFwI1tFVl5OJIjG5RQCs3+krvkPigmLjPMLVijrVd9muAsoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3E13A60345; Fri, 22 May 2026 07:01:47 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/5] netfilter: conntrack: remove some code
Date: Fri, 22 May 2026 07:01:29 +0200
Message-ID: <20260522050140.4838-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

1) Remove the full tuple from the nf_conntrack_helper hash. Switch to hashing
   based on the helper name and L4 protocol.

2) Remove tuple from netfilter conntrack helper definitions. Eliminate
   redundant IPv4 and IPv6 registration requests.

3) Switch nf_conntrack to static registration. Remove helper autoassign
   port module params.

4) Remove the obsolete nf_ct_helper_init API from netfilter.

5) Add deprecation warnings for IRC and PPTP conntrack trackers. Update IRC
   helper help text to clarify its use for DCC extension.

Florian Westphal (5):
  netfilter: nf_conntrack_helper: do not hash by tuple
  netfilter: conntrack: get rid of tuple in helper definitions
  netfilter: nf_conntrack: switch to static registration
  netfilter: remove obsolete nf_ct_helper_init api
  netfilter: conntrack: add deprecation warnings for irc and pptp trackers

 include/net/netfilter/nf_conntrack_helper.h | 20 ++---
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c |  5 +-
 net/netfilter/Kconfig                       | 11 +--
 net/netfilter/nf_conntrack_amanda.c         | 35 +++-----
 net/netfilter/nf_conntrack_broadcast.c      |  2 -
 net/netfilter/nf_conntrack_ftp.c            | 51 +++--------
 net/netfilter/nf_conntrack_h323_main.c      | 85 ++++++------------
 net/netfilter/nf_conntrack_helper.c         | 96 ++++++---------------
 net/netfilter/nf_conntrack_irc.c            | 40 ++++-----
 net/netfilter/nf_conntrack_netbios_ns.c     |  7 +-
 net/netfilter/nf_conntrack_pptp.c           |  7 +-
 net/netfilter/nf_conntrack_sane.c           | 50 +++--------
 net/netfilter/nf_conntrack_sip.c            | 61 +++++--------
 net/netfilter/nf_conntrack_snmp.c           |  7 +-
 net/netfilter/nf_conntrack_tftp.c           | 47 +++-------
 net/netfilter/nfnetlink_cthelper.c          | 20 ++---
 16 files changed, 177 insertions(+), 367 deletions(-)

-- 
2.53.0
