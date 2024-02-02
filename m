Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411E64779F
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2024 13:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706882000; cv=none; b=S0wtr+vjUbgiEvm6Khzhm39I496cL04ZtxbN9uNmDGxaGuk/ANgCtf/4MxzMLYornPv31kgRtJZDPMjQC0cRmiT/1WaPb4qyw9agLh9bB4hZQeqIvreRJK8/VMXju1J+e+ExvL/gWx7zoJJor9B2+4dmIhtPKnS1kOYiHB5YulE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706882000; c=relaxed/simple;
	bh=YBE6wGRJwqoGP0AR+qvnoAff289up1fTbI+VPv71ZsA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ActQXpZV3PlJz48MIyRVxZQjOVDj8pg/mYf2lqG7Nu/rTtB5tdOxBVBtG+ahgoLeEfs4fAircAWj+rIN7w5oCONAOxUg20SWhtn7Kw7ez6/LFMQIUtA6rkjALCpTY4DMciBkQviRYvidTJiY6mecNvbpOtPzZ29oOapCUNfasAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cjuDl9RN; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cjuDl9RN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7oLg3NA4MRayOgvhXWoqm7VQqKCUT385cOLjvAsT4RA=; b=cjuDl9RNd3CvEVnCrTmiw1E2KH
	0IM08NghOPbvtSDu2s7JU2yPOJuETU9C0bN6kldO/EBNKGdOtaNdeLwtA9ejWtNkDgSaBXFkx4smd
	8LwPltZUt/vwPsrOQtze/BOu3nSe0v0L0mYHCSxsG9U/U1dRcaeqkF6gJcEr1jbDu/KJllVV91Tdu
	6QVbmAOu2ymP/GBJdwxg/iuKCE8lJnZiJFpM6G9b1eBvcxj0g3pRVJRyVKKH5CBm6qL00yr31SvPS
	jfI8IyAoapcMzJXikwsD0FYJ4AZo4LFxiqbzCNQS19mZwvTOL5XVx9fmNEoULiSZdk6Kkku1m7gIe
	vYQBPGMA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVtyl-000000003CK-3gIZ;
	Fri, 02 Feb 2024 14:53:15 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 00/12] Range value related fixes/improvements
Date: Fri,  2 Feb 2024 14:52:55 +0100
Message-ID: <20240202135307.25331-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Discussion of commit ee87ad419e9a0 ("extensions: libebt_stp: fix range
checking") motivated me to check parser behaviour with ranges, including
some corner cases:

* Negative ranges (e.g. 4:3) are supposed to be rejected
* Ranges may be (half) open, e.g. ":10", "5:" or just ":"
* Ranges may be single element size (e.g. "4:4")
* Full ranges are NOPs aside from the constraints implied by invoking
  the match itself
* Inverted full ranges never match and therefore must at least remain in
  place (code sometimes treated them like non-inverted ones)

First patch in this series bulk-adds test cases to record the status
quo, following patches fix behaviour either by implementing checks into
libxtables (in patches 2, 3 and 12) or fixing up extensions. Patch 10 is
an exception, it fixes for inverted full ranges when generating native
payload matches for tcp/udp extensions.

Phil Sutter (12):
  extensions: *.t/*.txlate: Test range corner-cases
  libxtables: xtoptions: Assert ranges are monotonic increasing
  libxtables: Reject negative port ranges
  extensions: ah: Save/xlate inverted full ranges
  extensions: frag: Save/xlate inverted full ranges
  extensions: mh: Save/xlate inverted full ranges
  extensions: rt: Save/xlate inverted full ranges
  extensions: esp: Save/xlate inverted full ranges
  extensions: ipcomp: Save inverted full ranges
  nft: Do not omit full ranges if inverted
  extensions: tcp/udp: Save/xlate inverted full ranges
  libxtables: xtoptions: Respect min/max values when completing ranges

 extensions/libebt_ip.t         | 12 +++++++++
 extensions/libebt_ip6.t        | 12 +++++++++
 extensions/libebt_stp.c        | 21 +++++++--------
 extensions/libebt_stp.t        | 45 +++++++++++++++++++++++++++++++
 extensions/libip6t_ah.c        | 22 +++++++++-------
 extensions/libip6t_ah.t        |  6 +++++
 extensions/libip6t_ah.txlate   |  6 +++++
 extensions/libip6t_frag.c      | 27 ++++++++++++-------
 extensions/libip6t_frag.t      |  6 +++++
 extensions/libip6t_frag.txlate |  6 +++++
 extensions/libip6t_mh.c        | 20 +++++++++++---
 extensions/libip6t_mh.t        |  6 +++++
 extensions/libip6t_mh.txlate   |  9 +++++++
 extensions/libip6t_rt.c        | 28 ++++++++++++++------
 extensions/libip6t_rt.t        |  6 +++++
 extensions/libip6t_rt.txlate   |  9 +++++++
 extensions/libipt_ah.c         | 22 ++++++++++------
 extensions/libipt_ah.t         |  6 +++++
 extensions/libipt_ah.txlate    |  6 +++++
 extensions/libxt_NFQUEUE.t     |  7 +++++
 extensions/libxt_connbytes.c   |  4 ---
 extensions/libxt_connbytes.t   |  6 +++++
 extensions/libxt_conntrack.t   | 26 ++++++++++++++++++
 extensions/libxt_dccp.t        | 10 +++++++
 extensions/libxt_esp.c         | 26 ++++++++++++------
 extensions/libxt_esp.t         |  7 +++++
 extensions/libxt_esp.txlate    | 12 +++++++++
 extensions/libxt_ipcomp.c      |  7 ++---
 extensions/libxt_ipcomp.t      |  7 +++++
 extensions/libxt_length.t      |  3 +++
 extensions/libxt_tcp.c         | 48 +++++++++++++++++++++-------------
 extensions/libxt_tcp.t         | 12 +++++++++
 extensions/libxt_tcp.txlate    |  6 +++++
 extensions/libxt_tcpmss.t      |  4 +++
 extensions/libxt_udp.c         | 43 ++++++++++++++++++------------
 extensions/libxt_udp.t         | 12 +++++++++
 extensions/libxt_udp.txlate    |  6 +++++
 iptables/nft.c                 |  4 +--
 libxtables/xtoptions.c         | 23 +++++++++++-----
 39 files changed, 439 insertions(+), 109 deletions(-)

-- 
2.43.0

