Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83D720C02F
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Apr 2025 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745169648; cv=none; b=dcJb/rqopsrvk5gdgA9X6WieWo62ldbo3MlQnMvSz60j+19LdvD7KtIyIkerajq87UbasYLnBLgMSkZ01+EGg4MuMR/Jd7dbRD8ypyjNJEgqNckEv/hb6Yp8Fk8dlH1zK3SDepyhwFV2Oos0cH+ca8ep6n3lJOu6T3tV9pJrJ6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745169648; c=relaxed/simple;
	bh=q2yCle7Ue+YAZsDQwkHxQ3t/Gv+rLZA0MFqn8V+S8os=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=owOLoZsLmyhEWdF8WY4pYAYtEOCSFINYMEc3yHFjJrq1yXrvdlGWk+Ly8d//fRGv7734pD4yGT++hva5bb0ppfG8Gp4uqFEJ9yiy4v+GOKdGDuY8Y/zOrZ3X7j4P5inTUM7iXLqS6Dfk2wpgUrjR6PJqCzC3vVflEVKzIHUmKbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=bc8qXTpO; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="bc8qXTpO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=T7zm/ZzhZ+jeOfAkfj5+sX7jHesx7WY4ceJoQqm8rJc=; b=bc8qXTpObPFPjaDn0s/eixJMfC
	3QnBuFoEYlMntdnPPI2AHgWqGBT14gx4QEDeaOR4HZs5PB4dPVduZUGeZpyLRPpS4DhZ0zyAOFu+k
	P7+asPpCrA9h2pmDW+F1leAuK7ts8xuHTt15FdKaiKk+r93tHW0Te4Jp5+kZD8FuEZagGqWushrud
	amnGwX1Z/0JjTKEsb2iN721YM/BYsrx0M8l1eZpLrmNcUmeeBXeYtMYBBqRZw4QAGGiG/0ZIbg0r8
	2bGKG9MYSFXbLFv3k25Or+Qc6qhM4p4fhdqzTPS3IZzD+/dPRGM7ByJ7z2fW9EEPSejGJrLuoxvXl
	wcStDiNA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1u6YLO-005Uip-02;
	Sun, 20 Apr 2025 18:20:38 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc: Slavko <linux@slavino.sk>
Subject: [PATCH ulogd2 0/6] Add support for logging ARP packets
Date: Sun, 20 Apr 2025 18:20:19 +0100
Message-ID: <20250420172025.1994494-1-jeremy@azazel.net>
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

* Patches 1-3 contain fixes for some minor problems that I spotted while
  working on this.
* Patch 4 refactors the IP2* filters to be a bit more efficient.
* Patches 5 & 6 add support for logging ARP packets.

Jeremy Sowden (6):
  IP2STR: correct address buffer size
  db, IP2BIN: correct `format_ipv6()` output buffer sizes
  IP2HBIN, IP2STR: correct typo's
  IP2BIN, IP2HBIN, IP2STR: refactor `interp` call-backs
  Use `NFPROTO_*` constants for protocol families
  Add support for logging ARP packets

 filter/raw2packet/ulogd_raw2packet_BASE.c |  11 +-
 filter/ulogd_filter_IP2BIN.c              | 121 +++++++++++++---------
 filter/ulogd_filter_IP2HBIN.c             |  90 ++++++++++------
 filter/ulogd_filter_IP2STR.c              |  94 +++++++++--------
 include/ulogd/ulogd.h                     |  13 ++-
 input/flow/ulogd_inpflow_NFCT.c           |  23 ++--
 input/packet/ulogd_inppkt_UNIXSOCK.c      |   7 +-
 util/db.c                                 |   2 +-
 util/printpkt.c                           |  10 +-
 9 files changed, 221 insertions(+), 150 deletions(-)

-- 
2.47.2

