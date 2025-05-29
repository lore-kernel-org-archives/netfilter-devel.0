Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA1222DFAA
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 20:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748550744; cv=none; b=IHX+V9FR377MDMj/LRK4aA1zj8Rh0QoRY1i/nPvMvrDva7ABS20OE8EEONwz4WNa2Ik72Xd6dNiYdVyJGeihvjNVanfDdxhEpb1BbPnXKP8JhOGHFdUIeZgq9+btqFkny8DCA/ynwmDdTbQYh4iJf5/WaExJZM2u7SZdImDRCFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748550744; c=relaxed/simple;
	bh=mC8MS7W22ADeV3QlXz0MYTQfKYGC55hRmUGc3UYT3os=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JzcQzGdg/G20yP9ogDadVO+nJVK5xpoUllcM1BYsfEoRGfTgvxjWOd/QHNf3teHD9MsNM9bflGto/pfpMRKchZHVUqXaT/wQUNMJxUFmkYwKgKsxXRKNJcM8GIHbibanFLuWq7ZvZr9m6FHts8yZqzg6FG8pzS+qxPXiuDtthck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=nX6/Tfke; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="nX6/Tfke"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uGesod/RWb0y7pn8h0t+8s9tx1mrmKwq43ll1WgMByk=; b=nX6/Tfker2HYVD3u2FZsgDKqVt
	CZE3x9C07PgWCQT0Pj7MCh+i4YLV7SEu/9cmOCQmDfep0ze2XB7hrks2633RqN5EE1GLHiXTzd5hl
	8u7BKVu1Sew+yvrX6SIPaapToYcDadVaj/oGLUO5jfEeR7NcUnffPZO5IduQtDa5wZcqiqODFud74
	BKgrJSt6x2Wep74aUsP4KsxepDbaxZF6uIMz6ZlZWh2KE7KLIqd1xK87urXhL4EopwHWV/30XEiQU
	6UAtOAiyKaaJp0kbxbudDHi2W/R7RnZknqq3iJHHRiZ/Od5kmUENLhg/AMYz8yTxuX/NDtw5DKqk4
	sEW3jEfg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1uKjvA-003Dw5-0v;
	Thu, 29 May 2025 21:32:12 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 0/3] Some fixes for v6.15
Date: Thu, 29 May 2025 21:31:43 +0100
Message-ID: <20250529203146.2415429-1-jeremy@azazel.net>
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

Replace a couple of deprecated things that were removed in v6.15 and bump the
maximum supported version.

Jeremy Sowden (3):
  build: replace obsolete `EXTRA_CFLAGS`
  xt_pknock: replace obsolete `del_timer`
  build: bump max. supported version to 6.15

 configure.ac                  | 2 +-
 extensions/ACCOUNT/Kbuild     | 2 +-
 extensions/pknock/Kbuild      | 2 +-
 extensions/pknock/xt_pknock.c | 8 ++++++--
 4 files changed, 9 insertions(+), 5 deletions(-)

-- 
2.47.2

