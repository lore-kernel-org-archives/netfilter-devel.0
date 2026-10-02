Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92423233936
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2026 12:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790945373; cv=none; b=hj+sHPbkdjB08G6GHkvfDw+lMm64dfF1h8RQO8Jc41Gjsib0ihXHA6FWoVVLrCOCX6MH8rAa6hPbiQHr3NmlTSM5YsTP4YJ84NucGo75tmxGCUBfVtd8uifsEzk4FN1RQ/qGa0E0I3Su1finFWHaXDFXX9i5Xt77Co/3PZfRrlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790945373; c=relaxed/simple;
	bh=Gzip/4DOkVDdoi1jdhkD6u8Rve6PysIjpV0cnu57gQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1l5F8hllu+dvkqAgOXUu8C9uzySUOfoqO1WOJ+lqBRusRkxyq2a4xATPW5/52WahY5E7eTnBvyV1utPR7dQEaLfLZ4NLOxod8NBcR3pULSuv4a/tyQuCw6O8SthK7nKJ5y6JwXv+Eu/iZ2MuelS75Xv7x8JR7Yw29jkfsIjabU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Jc+fL8Ke; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Jc+fL8Ke"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=x02Yrdr5syvwLmH/yXPFy+bWpz9qDbZG/K+2roKWlY4=; b=Jc+fL8Ke9TbnAzTppnkM2QV8lA
	D7/MxujSC5p0We2FzFpLDWh9CSsoPbrbx9LKdpVkv/OhZ/ff8IqIW265gSdh+2ugLXgMZyZiN4BIy
	cZ0AphrLT/UvjmjOPEat+JvYY6VAy9nQRDFd3jiT1pwY1u2woCjxMoCrQnMsL3OEhYIl5kORwViE7
	0bBB+JZhl7zI3GqOa8D3XHyfcIzd/wGga1NmApOnh9yDiEl7C0Z3FVd6zZw0jF4HSEGDVYJhd8pWK
	JUOF/BZBgOkaZ7cCb81Q56RKbJ0uNxmCzuqpIQEpbBZZkwBSTj4KZXwSV6nQvEsPVSmitYunK1T5c
	WFkoGP6A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xCchW-000000007iK-1O64;
	Fri, 02 Oct 2026 14:49:22 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Balazs Gulacsi <m2gulbal@gmail.com>
Subject: [iptables PATCH 2/3] extensions: libxt_conntrack: Fix for ignored ctstates in translation
Date: Fri,  2 Oct 2026 14:49:15 +0200
Message-ID: <20261002124916.2264622-2-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261002124916.2264622-1-phil@nwl.cc>
References: <20261002124916.2264622-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Balazs writes:
> iptables-translate ignores the RELATED,ESTABLISHED states, when DNAT
> is also present:
> # iptables-translate -A SOMECHAIN -m conntrack \
>                      --ctstate RELATED,ESTABLISHED,DNAT -j DROP
> nft 'add rule ip filter SOMECHAIN ct status dnat counter drop'
> # iptables-translate -A SOMECHAIN -m conntrack \
>                      --ctstate RELATED,ESTABLISHED -j DROP
> nft 'add rule ip filter SOMECHAIN ct state related,established counter drop'

Reported-by: Balazs Gulacsi <m2gulbal@gmail.com>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1827
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_conntrack.c      |  4 +++-
 extensions/libxt_conntrack.txlate | 14 ++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 2b41213edb0e4..4ac4fba00c9c5 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1233,7 +1233,9 @@ static int _conntrack3_mt_xlate(struct xt_xlate *xl,
 				     sinfo->invert_flags & XT_CONNTRACK_STATE ? "!= " : "",
 				     sinfo->state_mask & XT_CONNTRACK_STATE_SNAT ? "snat" : "dnat");
 			space = " ";
-		} else {
+		}
+		if (sinfo->state_mask & ~(XT_CONNTRACK_STATE_SNAT |
+					  XT_CONNTRACK_STATE_DNAT)) {
 			xt_xlate_add(xl, "%sct state ", space);
 			state_xlate_print(xl, sinfo->state_mask,
 					  sinfo->invert_flags & XT_CONNTRACK_STATE);
diff --git a/extensions/libxt_conntrack.txlate b/extensions/libxt_conntrack.txlate
index 79b34df9e3586..e7255e2a516fd 100644
--- a/extensions/libxt_conntrack.txlate
+++ b/extensions/libxt_conntrack.txlate
@@ -64,3 +64,17 @@ nft 'add rule ip filter INPUT ct status dnat counter accept'
 iptables-translate -t filter -A INPUT -m conntrack ! --ctstate DNAT -j ACCEPT
 nft 'add rule ip filter INPUT ct status != dnat counter accept'
 
+iptables-translate -t filter -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED,DNAT -j ACCEPT
+nft 'add rule ip filter INPUT ct status dnat ct state related,established counter accept'
+
+iptables-translate -t filter -A INPUT -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT -j ACCEPT
+nft 'add rule ip filter INPUT ct status != dnat ct state ! related,established counter accept'
+
+iptables-translate -t filter -A INPUT -m conntrack --ctstate ESTABLISHED,DNAT --ctstatus CONFIRMED -j ACCEPT
+nft 'add rule ip filter INPUT ct status dnat ct state established ct status confirmed counter accept'
+
+iptables-translate -t filter -A INPUT -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT --ctstatus CONFIRMED -j ACCEPT
+nft 'add rule ip filter INPUT ct status != dnat ct state ! related,established ct status confirmed counter accept'
+
+iptables-translate -t filter -A INPUT -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT ! --ctstatus CONFIRMED -j ACCEPT
+nft 'add rule ip filter INPUT ct status != dnat ct state ! related,established ct status ! confirmed counter accept'
-- 
2.54.0

