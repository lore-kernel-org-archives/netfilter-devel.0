Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Qzvx6+IJ"
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27B211A
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 08:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2t0e+IQFzHkiT46I+zwxwNceQ7/AQ16DNL2CzaCCDD4=; b=Qzvx6+IJ4zb7BePfyKHxFa0oH4
	aQJJfTW+rS7rIaVCQv2vkGSyLZM9mfWkKj1wXHdUMDYzvQgo6hM1GhzyhopaT0552pps3lDQ920Hm
	WkCtl5nizBxOAKHmW12Vx4Ofgh3rxK1QUnQ99z1tXVBXIXPRv32OmH4pb/ZJRq7CAKC6f1mskRcgC
	8Nm8SbDUy3WHecHkfjydR/QHfZCxVoYR2lbz4uqZIyA6hHBqcq/wFf0ATm9iHOaURDk1UhxjSDZUf
	Z/rz8GSF2JeU+Q0vf0PE2TBbN7eRMRXC2ekO0chyzsfi9oAjT5dPNMjD813rPQXyTXapjQOozBDuU
	4Tu+0fbw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rDoor-0038UN-23
	for netfilter-devel@vger.kernel.org;
	Thu, 14 Dec 2023 16:44:17 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables v2 3/6] build: remove unused `AM_VERBOSE_CXX*` variables
Date: Thu, 14 Dec 2023 16:44:02 +0000
Message-ID: <20231214164408.1001721-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231214164408.1001721-1-jeremy@azazel.net>
References: <20231214164408.1001721-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

There is no C++, so these variables are not required.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/GNUmakefile.in | 2 --
 1 file changed, 2 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 53011fc8c2bb..51b18a59a580 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -37,8 +37,6 @@ AM_LDFLAGS      = @noundef_LDFLAGS@ @regular_LDFLAGS@
 ifeq (${V},)
 AM_VERBOSE_CC     = @echo "  CC      " $@;
 AM_VERBOSE_CCLD   = @echo "  CCLD    " $@;
-AM_VERBOSE_CXX    = @echo "  CXX     " $@;
-AM_VERBOSE_CXXLD  = @echo "  CXXLD   " $@;
 AM_VERBOSE_AR     = @echo "  AR      " $@;
 AM_VERBOSE_GEN    = @echo "  GEN     " $@;
 endif
-- 
2.43.0

