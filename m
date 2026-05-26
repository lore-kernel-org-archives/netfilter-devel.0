Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A373B38AB
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 16:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779813657; cv=none; b=g+2y+V4+Rg+GJduInAT0a71ippAyf5Gw0Kjx2BGDEB9yTDgk3HSY+lGVkZ2W0g016Duw8n3HhGqlETUfjhAWIQQSL5gVAKIybXCEOufvl3PytaMb/j39H8IWuhjKB2GF9/1ZgMipcjkOnJ+igBybvOpWcasHHkokXODYVYfKBrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779813657; c=relaxed/simple;
	bh=siU26rmEBLgDqcJGBl99JDiuh1ptxfNNJvToFFG4uXo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dwrEXmxShgjEdD6+1dsUSBjlC9ivBaui7R8klZYJhnhNHMZOpDjpKageA/Hm10v/TH7Cs/e7+4pwIisl3aeErzVaoPZxfRpuHHb8DhkclVn7pMwWSFlt3vR9OHYTkdq0pLSRHhiJxzguyM2uQM7vRQah4LWabHkUTkD6yq24Cmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FwQj01AD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FwQj01AD"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4AF3E604FC;
	Tue, 26 May 2026 18:40:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779813652;
	bh=yufVplPZQREc8lfOr+hxyRDxeccTemOKdnhhZ9Nhn3E=;
	h=From:To:Cc:Subject:Date:From;
	b=FwQj01ADSzoCi7fixqxOy7kCyWS5CEgiProOg7SHA9MLBJvKAI0w84q/pcYNXKvRF
	 XCoOgQiwaXm8NrwG2FgUBhNi7aPfn7uKoQFY0AwlssiJ/DIh7zxwQptAeQ5CEQyoOC
	 fY47NbFhdGSeXO6bSCOU2tzckFArELLZ/DcLTQEob6VKtY2GFrl3Fvqu9iETXxqPzp
	 q4K/3hoTyVWF5mGKquLL2UGG+drOTkB2eA9UqcUrOHroEcsC+gwux+PiPa5lPVF0N7
	 4u1xUpdqHemIC0kHS7bkQvMnYc1FNUU+ftiWCGxO7xx00f57sAXK8yyolLNPbFNGsf
	 gMxWsrYVpNJaQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next 0/6] add refcount to ct timeout/helper
Date: Tue, 26 May 2026 18:40:43 +0200
Message-ID: <20260526164049.148218-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is change in the direction of the original series..

This series reworks the ct timeout/helper infrastructure to add a
refcount for tracking the use of these objects from the ct extension
area.

This is to address the existing races with unconfirmed conntracks that
could sit in the nfqueue (or elsewhere) leading to access to stale
pointer on reinject if ct timeout/helper goes away. Also module removal
could lead to issues.

The idea in this series is to dynamically allocation the ct helper and
timeout so the memory areas are released when the last use on them is
dropped via refcounting.

Patch #1 adds the {READ,WRITE}_ONCE notation to nfnetlink_cthelper.
Patch #2 adds refcounting to the ct timeout policy.
Patch #3 is a preparation patch which moves the ct helper from BSS
         to slab.
Patch #4 move GRE PPTP destroy so removal of .destroy so this stays
         around on removal.
Patch #5 add the refcounting to the ct helper datapath.
Patch #6 revert the ct extension genid and the nf_ct_iterate_destroy()
         now that refcounting tracks use of these ct extensions.

Comments welcome.

Thanks.

Pablo Neira Ayuso (6):
  netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for accessing helper flags
  netfilter: cttimeout: detach dataplane timeout policy and add refcount
  netfilter: nf_conntrack_helper: dynamically allocate struct nf_conntrack_helper
  netfilter: nf_conntrack_pptp: move GRE specific cleanup to GRE tracker
  netfilter: nf_conntrack_helper: add refcounting from datapath
  netfilter: conntrack: revert ct extension genid infrastructure

 .../net/netfilter/ipv4/nf_conntrack_ipv4.h    |   4 +
 include/net/netfilter/nf_conntrack.h          |   6 +-
 include/net/netfilter/nf_conntrack_extend.h   |  12 --
 include/net/netfilter/nf_conntrack_helper.h   |  41 ++++--
 include/net/netfilter/nf_conntrack_timeout.h  |  21 +++
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c   |  19 ++-
 net/netfilter/nf_conntrack_amanda.c           |  39 ++----
 net/netfilter/nf_conntrack_core.c             | 130 ++----------------
 net/netfilter/nf_conntrack_extend.c           |  32 +----
 net/netfilter/nf_conntrack_ftp.c              |   5 +-
 net/netfilter/nf_conntrack_h323_main.c        |  91 +++++-------
 net/netfilter/nf_conntrack_helper.c           |  97 ++++++++-----
 net/netfilter/nf_conntrack_irc.c              |   5 +-
 net/netfilter/nf_conntrack_netbios_ns.c       |  18 ++-
 net/netfilter/nf_conntrack_netlink.c          |  12 +-
 net/netfilter/nf_conntrack_ovs.c              |  14 +-
 net/netfilter/nf_conntrack_pptp.c             |  87 ++----------
 net/netfilter/nf_conntrack_proto.c            |  15 +-
 net/netfilter/nf_conntrack_proto_gre.c        |  61 ++++++++
 net/netfilter/nf_conntrack_sane.c             |   5 +-
 net/netfilter/nf_conntrack_sip.c              |   5 +-
 net/netfilter/nf_conntrack_snmp.c             |  21 ++-
 net/netfilter/nf_conntrack_tftp.c             |   5 +-
 net/netfilter/nf_conntrack_timeout.c          |  20 ++-
 net/netfilter/nf_nat_core.c                   |  15 +-
 net/netfilter/nfnetlink_cthelper.c            |  40 +++---
 net/netfilter/nfnetlink_cttimeout.c           |  75 +++++-----
 net/netfilter/nft_ct.c                        |   7 +-
 net/netfilter/xt_CT.c                         |   7 +-
 29 files changed, 418 insertions(+), 491 deletions(-)

-- 
2.47.3

