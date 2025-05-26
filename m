Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F76C1D54FA
	for <netfilter-devel@vger.kernel.org>; Mon, 26 May 2025 17:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748279993; cv=none; b=iHR+R49OlZvWUhBK3BQc/mzRoR3x3AeJNDkYUtJWkqJeU8LrQMYuQrOH2X70Z++bcnZjoboL/706pwskPkjwjDTA9g2+ycp/Xft6xvi1po472LdkHVQOPgz6Im2wJu0LRoLPYJyDrIvd7dB16LH4sk+G+muupzHETpFLyqQfZfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748279993; c=relaxed/simple;
	bh=R0aDnk5DjRrkG5lIG7dVr1NTMbvg+kVWgLCHv3yfZGU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aE61zDdUo/vUSUkRKobnPH/ZZMh6BQx/cbKEBA9m5p82xsex4N83W/rL3A5bvq3d5XJz09z5x2xQdYOz10M2LU8bAlsoe0Q027opQpRHyO/RhTPg/Gvdr9fmObbmIRjvTQsOhZ52mN3KXN+6RcrmMDRl5LSTJje0eeVCfTtdFz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=PUS5xfah; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="PUS5xfah"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yx+OcpaxiiRQRQQ+64oDEJC3gIfFFPNNG7/f2DoNT4o=; b=PUS5xfah5by6OG2te1WdMtACXO
	MzpvwT+0jKaYGzn2aHfoZDa4xyFF9JOP/JqDw+NWzNHIy9YmMHc70VVr8RsYRUkopRCWfB+fg6yvL
	jpl4wR5QaL3b0RLjXiPCl23RSuanzjzmQ/93sGh1KjX6uub1fYulgC/1+2qgw1pxGGbammA0anS9H
	DQSscE+8TZCPAjTGwcZJg9h+/4fMgSYErXEcf2cytnMTUjKPkZWlYqQiFe7oe79+7S6Bg8W8+z8jO
	4mdlB8H71ckq7epP4YpeejNtrqId99NKI5Bee+fO1u+TmgWRXE1v33zjH8+eg4x8933yU+l2QVbu9
	+IqrWyRA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1uJbUK-000rKJ-1H;
	Mon, 26 May 2025 18:19:48 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc: Slavko <linux@slavino.sk>
Subject: [PATCH ulogd2 v2 0/4] Add support for logging ARP packets
Date: Mon, 26 May 2025 18:19:00 +0100
Message-ID: <20250526171904.1733009-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

Hithero, ulogd has only fully supported handling ARP headers that are present
in `AF_BRIDGE` packets.  This patch-set adds support for handling ARP packets
in their own right.

* Patch 1 contains a fixes for some minor problems that I spotted while
  working on this.
* Patch 2 refactors the IP2* filters to be a bit more efficient.
* Patches 3 & 4 add support for logging ARP packets.

Changes since v1

* Patches 1 & 3 from v1 have been merged.
* Patch 2 from v1 (now patch 1) has been reworked in light of Florian's
  feed-back to use the size of `struct in6_addr`, rather than `((struct
  in6_addr){}).s6_addr`.

Jeremy Sowden (4):
  db, IP2BIN: correct `format_ipv6()` output buffer sizes
  IP2BIN, IP2HBIN, IP2STR: refactor `interp` call-backs
  Use `NFPROTO_*` constants for protocol families
  Add support for logging ARP packets

 filter/raw2packet/ulogd_raw2packet_BASE.c |  11 +-
 filter/ulogd_filter_IP2BIN.c              | 121 +++++++++++++---------
 filter/ulogd_filter_IP2HBIN.c             |  86 +++++++++------
 filter/ulogd_filter_IP2STR.c              |  86 ++++++++-------
 include/ulogd/ulogd.h                     |  11 +-
 input/flow/ulogd_inpflow_NFCT.c           |  23 ++--
 input/packet/ulogd_inppkt_UNIXSOCK.c      |   7 +-
 util/db.c                                 |   2 +-
 util/printpkt.c                           |  10 +-
 9 files changed, 215 insertions(+), 142 deletions(-)

-- 
2.47.2

