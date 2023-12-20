Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57655487A2
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mlpF3S0f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=f0Fub8YgRDaLHMTYzNwaMNEbGk9V9wDGN4g7LpMgcsc=; b=mlpF3S0fOmZjg5ekaVG8ZkhsZn
	xxx4vOK3V2EhXm3YFEMNAEtfkm5oW4LNxxA01BkqX6Os+A32agBW+DjddUguW22ydZ31aKiSs8iih
	0iD/rBKogRuRBfGpkusYm6PzE3O/cMRHmEnJmngX70iQ79jpf6fHNb0Gqiofuf/Qzyr3hlUPaqMGn
	FrW5yzB8dJ0TmNdTVD6FcdzI5YsEuBYdz7q3Wine0bGIA71ZguetDhVl2YFH3H7YF467qhWcAhelW
	toABpt4Iwq2v88PMrte4B9A/oW0T4ztgq4y5zvHmxzFryvK3Wukr3dvwY4Pfg01GgMIofrk83I/1N
	TXKbFSlw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5t-0004M3-Tc
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:49 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 00/23] Guided option parser for ebtables
Date: Wed, 20 Dec 2023 17:06:13 +0100
Message-ID: <20231220160636.11778-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first part of this series deals with guided option parser itself,
fixing a bug in patch 1 and adding features in patches 2-4 in
preparation for ebtables' guided option parser support enabled in patch
5. The remaining patches then convert ebtables extensions apart from the
last one which significantly reduces parser code in libxt_HMARK.c using
the new parser features.

Phil Sutter (23):
  libxtables: xtoptions: Prevent XTOPT_PUT with XTTYPE_HOSTMASK
  libxtables: xtoptions: Support XTOPT_NBO with XTTYPE_UINT*
  libxtables: xtoptions: Implement XTTYPE_ETHERMACMASK
  libxtables: xtoptions: Treat NFPROTO_BRIDGE as IPv4
  ebtables: Support for guided option parser
  extensions: libebt_*: Drop some needless init callbacks
  extensions: libebt_stp: Use guided option parser
  extensions: libebt_arpreply: Use guided option parser
  extensions: libebt_dnat: Use guided option parser
  extensions: libebt_ip6: Use guided option parser
  extensions: libebt_ip: Use guided option parser
  extensions: libebt_log: Use guided option parser
  extensions: libebt_mark: Use guided option parser
  extensions: libebt_nflog: Use guided option parser
  extensions: libebt_snat: Use guided option parser
  extensions: libebt_redirect: Use guided option parser
  extensions: libebt_802_3: Use guided option parser
  extensions: libebt_vlan: Use guided option parser
  extensions: libebt_arp: Use guided option parser
  extensions: libxt_limit: Use guided option parser for NFPROTO_BRIDGE,
    too
  extensions: libebt_pkttype: Use guided option parser
  extensions: libebt_mark_m: Use guided option parser
  extensions: libxt_HMARK: Review HMARK_parse()

 extensions/libebt_802_3.c    |  83 +++---------
 extensions/libebt_802_3.t    |   2 +
 extensions/libebt_arp.c      | 201 ++++++++++-------------------
 extensions/libebt_arp.t      |   7 +
 extensions/libebt_arpreply.c |  52 +++-----
 extensions/libebt_arpreply.t |   4 +
 extensions/libebt_dnat.c     |  64 ++++-----
 extensions/libebt_ip.c       | 208 +++++++++++------------------
 extensions/libebt_ip.t       |   8 ++
 extensions/libebt_ip6.c      | 212 +++++++++++-------------------
 extensions/libebt_ip6.t      |   8 ++
 extensions/libebt_log.c      | 121 +++++------------
 extensions/libebt_mark.c     | 140 ++++++++------------
 extensions/libebt_mark_m.c   |  69 ++++------
 extensions/libebt_nflog.c    |  82 +++---------
 extensions/libebt_pkttype.c  |  45 +++----
 extensions/libebt_redirect.c |  40 +++---
 extensions/libebt_snat.c     |  74 +++++------
 extensions/libebt_snat.t     |   2 +
 extensions/libebt_stp.c      | 244 ++++++++++++-----------------------
 extensions/libebt_stp.t      |  16 +++
 extensions/libebt_vlan.c     | 102 +++++----------
 extensions/libxt_HMARK.c     |  60 ++-------
 extensions/libxt_limit.c     |  50 +------
 include/xtables.h            |   8 +-
 iptables/xtables-eb.c        | 108 ++++++++--------
 libxtables/xtoptions.c       |  52 ++++++--
 27 files changed, 757 insertions(+), 1305 deletions(-)

-- 
2.43.0

