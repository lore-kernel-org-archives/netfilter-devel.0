Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346BA13541C
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2024 13:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706882000; cv=none; b=nL4ODb7zR+X/U6TNJdACvLDUk5dxuiwDA+zmORP6gkt9zJ03oJVhLNerG18MRrrapuXFkMPH55EnyKtpYjjibhqbfHK8iWapfW+Ur6wG83BuSb00YBQ+6Fz3rKfXmOfg8PViJixWFE29AefTaiX8LF6hqxcNFoMsMV0HiJ6zlMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706882000; c=relaxed/simple;
	bh=eB3AsazPsiSUe1jf/8mWUrKsBQIY6Ce+kRkH65LZoHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oz0yfD+lWkXtHiTKMFpfZV+xNvpOCxp4ZCgqh+0Xt5RMVlnfejlJn8sIUzoaW3ME+setFT4q9qMugWgKolRxJ3LGmurVb2LC1KXLanbXORHrbkoYo8zGp2T8l9kzgTBqdDUcOKUsVR7hkR2e1rdn18T7NoDHA+PjH0lsDNAMUWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UmZtvXNk; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UmZtvXNk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lYC9MnOqhuPdDSeFq9CNPyYcz+EY09sUSMmnseUX1Uc=; b=UmZtvXNk/yEObnW2GnQcJzZeKB
	sLbKlY+81fMNoPi/LK2v4CpsgHTV71pHQnXhDbFGTi/6gUNcgNL+770a2QFME+uMnUHg9IVZ7CrCB
	Ra3QoS6gft8jzv9mr8Vd7nhq7bGdzf2gOf43VwtxKGR3Y4u+XPgKOXweKmEB2OXlsv4C2VJ+1iWVG
	AWATLCaqhlKktSNR7ye0L1eSHw30TCNw9f2Aqy3JqCbsORQsRXQlkd33hfEKrMUy0ANA2fGthAyY7
	cQ56zK+bsrs5Ckp7lfP8Dhx4yS68eBnC38x1iZxIb6x+JybbXMZVRR+YBeVElq2MqTUN2KCLaIeMe
	/vFsCwdA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVtyi-000000003Bq-1fP4;
	Fri, 02 Feb 2024 14:53:12 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 10/12] nft: Do not omit full ranges if inverted
Date: Fri,  2 Feb 2024 14:53:05 +0100
Message-ID: <20240202135307.25331-11-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202135307.25331-1-phil@nwl.cc>
References: <20240202135307.25331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise this turns a never matching rule into an always matching one.

Fixes: c034cf31dd1a9 ("nft: prefer native expressions instead of udp match")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_tcp.t | 4 ++--
 extensions/libxt_udp.t | 4 ++--
 iptables/nft.c         | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/extensions/libxt_tcp.t b/extensions/libxt_tcp.t
index baa41615b11a6..911c51113cf2a 100644
--- a/extensions/libxt_tcp.t
+++ b/extensions/libxt_tcp.t
@@ -7,13 +7,13 @@
 -p tcp -m tcp --sport 1024:65535;=;OK
 -p tcp -m tcp --sport 1024:;-p tcp -m tcp --sport 1024:65535;OK
 -p tcp -m tcp --sport :;-p tcp -m tcp;OK
--p tcp -m tcp ! --sport :;-p tcp -m tcp;OK;LEGACY;-p tcp
+-p tcp -m tcp ! --sport :;-p tcp -m tcp;OK
 -p tcp -m tcp --sport :4;-p tcp -m tcp --sport 0:4;OK
 -p tcp -m tcp --sport 4:;-p tcp -m tcp --sport 4:65535;OK
 -p tcp -m tcp --sport 4:4;-p tcp -m tcp --sport 4;OK
 -p tcp -m tcp --sport 4:3;;FAIL
 -p tcp -m tcp --dport :;-p tcp -m tcp;OK
--p tcp -m tcp ! --dport :;-p tcp -m tcp;OK;LEGACY;-p tcp
+-p tcp -m tcp ! --dport :;-p tcp -m tcp;OK
 -p tcp -m tcp --dport :4;-p tcp -m tcp --dport 0:4;OK
 -p tcp -m tcp --dport 4:;-p tcp -m tcp --dport 4:65535;OK
 -p tcp -m tcp --dport 4:4;-p tcp -m tcp --dport 4;OK
diff --git a/extensions/libxt_udp.t b/extensions/libxt_udp.t
index 09dff363fc21a..3c85b09f871da 100644
--- a/extensions/libxt_udp.t
+++ b/extensions/libxt_udp.t
@@ -7,13 +7,13 @@
 -p udp -m udp --sport 1024:65535;=;OK
 -p udp -m udp --sport 1024:;-p udp -m udp --sport 1024:65535;OK
 -p udp -m udp --sport :;-p udp -m udp;OK
--p udp -m udp ! --sport :;-p udp -m udp;OK;LEGACY;-p udp
+-p udp -m udp ! --sport :;-p udp -m udp;OK
 -p udp -m udp --sport :4;-p udp -m udp --sport 0:4;OK
 -p udp -m udp --sport 4:;-p udp -m udp --sport 4:65535;OK
 -p udp -m udp --sport 4:4;-p udp -m udp --sport 4;OK
 -p udp -m udp --sport 4:3;;FAIL
 -p udp -m udp --dport :;-p udp -m udp;OK
--p udp -m udp ! --dport :;-p udp -m udp;OK;LEGACY;-p udp
+-p udp -m udp ! --dport :;-p udp -m udp;OK
 -p udp -m udp --dport :4;-p udp -m udp --dport 0:4;OK
 -p udp -m udp --dport 4:;-p udp -m udp --dport 4:65535;OK
 -p udp -m udp --dport 4:4;-p udp -m udp --dport 4;OK
diff --git a/iptables/nft.c b/iptables/nft.c
index c2cbc9d72ef0c..dae6698d3234a 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1324,7 +1324,7 @@ static int add_nft_tcpudp(struct nft_handle *h,struct nftnl_rule *r,
 		return 0;
 	}
 
-	if (src[0] || src[1] < 0xffff) {
+	if (src[0] || src[1] < UINT16_MAX || invert_src) {
 		expr = gen_payload(h, NFT_PAYLOAD_TRANSPORT_HEADER, 0, 2, &reg);
 		if (!expr)
 			return -ENOMEM;
@@ -1335,7 +1335,7 @@ static int add_nft_tcpudp(struct nft_handle *h,struct nftnl_rule *r,
 			return ret;
 	}
 
-	if (dst[0] || dst[1] < 0xffff) {
+	if (dst[0] || dst[1] < UINT16_MAX || invert_dst) {
 		expr = gen_payload(h, NFT_PAYLOAD_TRANSPORT_HEADER, 2, 2, &reg);
 		if (!expr)
 			return -ENOMEM;
-- 
2.43.0

