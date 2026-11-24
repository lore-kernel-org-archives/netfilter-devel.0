Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795534034;
	b=u8ULmOEmHjo+tNHNoCsXR0E+HIOYbCh6r0YzA0/ScGgUyjKsntmXuPE4gZY38nJfIBox
	 28Tb+Qi6Ano3sqZEPTI8CpGp7NhSHalBKFu2sTCwaRqTq1vT9QYP+H04F9AtFMJKTv3YR
	 dw0K1JHok+zJgranZMmnmBDYBhPumtOpuLfpMau/z28IswHUMjNKuTjjdfr13YeMxRTc4
	 tL7+xoMaLwFsTSQBDwHypN39J/MIqwbo20qLO2l/ALd76Kwo6jd6Mz7PHPuAe4C1LgPeS
	 I25yaRwiBjiW0OMkOcOdcWTxVn57t2aY+rSPI9dMqOZK8ptv+9el566hzgTUseVsfvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795534034;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yoO1jhsIvGKw5Ng25N/Scqq24Hx+n7zlEavsSLqOe9M=;
	b=efUvW9qJzZtFgConQ+iLVZCzogdZONHR3iu7qloLaAWYuQ0b0wi/7fhgcqAwl6rUCucx
	 lhanLGF5V5Ey4rn/93jviFROBgCmoJhB6birMNGBUcMbS3QZw/Kti3QCVYeVfl55uuu1M
	 a/9hgsKuSdgcYWzJQyRAXNNa1DRR31tQt5c0BdMGxYnoYegI+bcwrHcRNAMKG7hKGZUUV
	 oFqgyVfsMqU0yCcAWBSeiF9TjvrgTGY3pkZmtvzR2COf7++RHX3RkF8TTwTz6iOK/s90b
	 2LPNVT1rX6UE9F0/acZw2HTeLGq0VNdpvALjt40LRILLzzAP07FelPlWVFTS2ut0FWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3305606A31E;
	Tue, 24 Nov 2026 15:27:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3305606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 630236024F; Tue, 24 Nov 2026 16:27:11 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net] MAINTAINERS: don't CC netdev on netfilter patches
Date: Tue, 24 Nov 2026 16:26:35 +0100
Message-ID: <20261124152635.26769-1-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Netfilter patches are handled by the netfilter maintainers and the
netfilter-devel list, yet scripts/get_maintainer.pl also suggests the
netdev maintainers and netdev@vger.kernel.org for them, because the
NETWORKING [GENERAL] entry matches net/ and include/net/ as a whole.

Add exclusion entries for every path already listed in the NETFILTER
entry.  This is done to reduce the mailing list load on netdev@,
which does not need to be Cc'd on netfilter changes. Patches merged
into either nf or nf-next tree will still be passed on to the net
maintainers.

Signed-off-by: Florian Westphal <fw@strlen.de>
---

 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7336600952c8..8348b298e40d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19170,21 +19170,31 @@ X:	Documentation/networking/batman-adv.rst
 X:	Documentation/networking/mac80211-injection.rst
 X:	Documentation/networking/mac80211_hwsim/
 X:	Documentation/networking/regulatory.rst
+X:	include/linux/netfilter*
+X:	include/linux/netfilter/
 X:	include/net/bluetooth/
 X:	include/net/cfg80211.h
 X:	include/net/ieee80211_radiotap.h
 X:	include/net/iw_handler.h
 X:	include/net/mac80211.h
+X:	include/net/netfilter/
 X:	include/net/wext.h
+X:	include/uapi/linux/netfilter*
+X:	include/uapi/linux/netfilter/
+X:	net/*/netfilter.c
+X:	net/*/netfilter/
 X:	net/9p/
 X:	net/batman-adv/
 X:	net/bluetooth/
+X:	net/bridge/br_netfilter*.c
 X:	net/can/
 X:	net/ceph/
 X:	net/mac80211/
+X:	net/netfilter/
 X:	net/rfkill/
 X:	net/wireless/
 X:	tools/testing/selftests/net/can/
+X:	tools/testing/selftests/net/netfilter/
 
 NETWORKING [IOAM]
 M:	Justin Iurman <justin.iurman@gmail.com>
-- 
2.56.1

