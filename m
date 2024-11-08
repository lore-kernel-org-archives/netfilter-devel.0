Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E582229EE
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Nov 2024 17:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731088022; cv=none; b=ocw1lFkVsrC3BeBqdTogIEhtCUagRK9bavz0q/vaMFNqFCghhQgH468lrHQhn8UWRbxuXdXn2ik1E/hILN8wjyM2oxuh2MZrvyC+n9sjgJ52XDhcJ0Az2210eX0tce0At10rbgqcIw91YUH21fvvY3WGAW0JtvmCNuqPpHPNZEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731088022; c=relaxed/simple;
	bh=xu8wob/3GLtII3I+2oafzoMnS1AE/4MQZgfmSwQMpic=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=OvtFiB4e1Jhb296Z0d+a4Da8GmZx7UvABsp3XVFLkvt+yn986tUYgLXbG2TfSgP8g1NizXnyXKcW3M1gHouV8O0hDlb7CuJMw7nbYarNJ8m0RQiPFMwm8W8j/0fcAimGH2t5gQcomAyVNZWYojLoK/6EzS9ulxGc30mt8EgKfGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=GbHTS5jH; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="GbHTS5jH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=liaORyl4vuP7xO7NsLXrblrXK6SN3GWg5PT8fR9ho1o=; b=GbHTS5jHRg8+XMcqY23j2cTDQp
	7jSKlGPixuNl2kJqQLuXixB5jr+HXRDSn1lBKUw2jmM7rPjm/8ZgR0dCQgfYSflUSIMRlwkr3APhj
	kTLK81LgzZBDkkWmBCDtf6zWZR6VbFlAwWJ7J5aH7/2VSh/U1EnAeGBSateTB7GmGsRolvQie/lFc
	su/uNvaDdyCFBCbgpAvwAGJdKpgq2ROvtFrP+pVHeTe5wUAlG3xE6ni02FuW5ZmpEQ90A1blcfitS
	vqWSLG7cnS/ixONvx4qjOt6F5Dq4JGwGSgnHaEN2rHrQ+b31eeuPaExV2YfgeMuEga7vsPP31UdQp
	a+wZ4nkQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1t9Ssm-006VY7-1d
	for netfilter-devel@vger.kernel.org;
	Fri, 08 Nov 2024 17:34:52 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables] ip[6]tables-translate: fix test failures when WESP is defined
Date: Fri,  8 Nov 2024 17:34:43 +0000
Message-ID: <20241108173443.4146022-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.45.2
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

Protocol number 141 is assigned to a real protocol: Wrapped Encapsulating
Security Payload.  This is listed in Debian's /etc/protocols, which leads to
test failures:

  ./extensions/generic.txlate: Fail
  src: iptables-translate -A FORWARD -p 141
  exp: nft 'add rule ip filter FORWARD ip protocol 141 counter'
  res: nft 'add rule ip filter FORWARD ip protocol wesp counter'

  ./extensions/generic.txlate: Fail
  src: ip6tables-translate -A FORWARD -p 141
  exp: nft 'add rule ip6 filter FORWARD meta l4proto 141 counter'
  res: nft 'add rule ip6 filter FORWARD meta l4proto wesp counter'

  ./extensions/generic.txlate: Fail
  src: iptables-translate -A FORWARD ! -p 141
  exp: nft 'add rule ip filter FORWARD ip protocol != 141 counter'
  res: nft 'add rule ip filter FORWARD ip protocol != wesp counter'

  ./extensions/generic.txlate: Fail
  src: ip6tables-translate -A FORWARD ! -p 141
  exp: nft 'add rule ip6 filter FORWARD meta l4proto != 141 counter'
  res: nft 'add rule ip6 filter FORWARD meta l4proto != wesp counter'

Replace it with 253, which IANA reserves for testing and experimentation.

Fixes: fcaa99ca9e3c ("xtables-translate: Leverage stored protocol names")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/generic.txlate | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/extensions/generic.txlate b/extensions/generic.txlate
index 9ad1266dc623..64bc59a8611e 100644
--- a/extensions/generic.txlate
+++ b/extensions/generic.txlate
@@ -76,17 +76,17 @@ nft 'add rule ip filter FORWARD ip protocol != sctp counter'
 ip6tables-translate -A FORWARD ! -p 132
 nft 'add rule ip6 filter FORWARD meta l4proto != sctp counter'
 
-iptables-translate -A FORWARD -p 141
-nft 'add rule ip filter FORWARD ip protocol 141 counter'
+iptables-translate -A FORWARD -p 253
+nft 'add rule ip filter FORWARD ip protocol 253 counter'
 
-ip6tables-translate -A FORWARD -p 141
-nft 'add rule ip6 filter FORWARD meta l4proto 141 counter'
+ip6tables-translate -A FORWARD -p 253
+nft 'add rule ip6 filter FORWARD meta l4proto 253 counter'
 
-iptables-translate -A FORWARD ! -p 141
-nft 'add rule ip filter FORWARD ip protocol != 141 counter'
+iptables-translate -A FORWARD ! -p 253
+nft 'add rule ip filter FORWARD ip protocol != 253 counter'
 
-ip6tables-translate -A FORWARD ! -p 141
-nft 'add rule ip6 filter FORWARD meta l4proto != 141 counter'
+ip6tables-translate -A FORWARD ! -p 253
+nft 'add rule ip6 filter FORWARD meta l4proto != 253 counter'
 
 iptables-translate -A FORWARD -m tcp --dport 22 -p tcp
 nft 'add rule ip filter FORWARD tcp dport 22 counter'
-- 
2.45.2

