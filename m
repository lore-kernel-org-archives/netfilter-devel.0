Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="L5obAXNT"
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776A8118
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 04:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2t0e+IQFzHkiT46I+zwxwNceQ7/AQ16DNL2CzaCCDD4=; b=L5obAXNTSA0wZx2OCiFg6msV7s
	S0J2329vYQaJkCax7D5wC16K4u6jWPVy9piX0vs44nnAro//Fd4AMrOjxocGwAgTb9tihn415s1Ue
	zqdgHK2orAo3fM+OOZGNnXdw0zcdeCTQDsANvBFAdW9E/g9GqH2t735Pj+DWYIK930N7LL8MgAJWM
	wgLGc27EqvpChTlin6t0bBHWomcUhCGmjgThI0Imow9rzYfJrHz3h7qaIa/sC0olR+Qi22ImJDD40
	qJcyZSc1z7Aek9XlKWADwUhpyJY89AgO8VFK1AX5zOnCurv4SIX6xviBrH/OrWUwKxY20dQ/2/1w/
	fh+TNBUw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rDlJN-0032wj-26
	for netfilter-devel@vger.kernel.org;
	Thu, 14 Dec 2023 12:59:33 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables 3/7] build: remove unused `AM_VERBOSE_CXX*` variables
Date: Thu, 14 Dec 2023 12:59:18 +0000
Message-ID: <20231214125927.925993-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231214125927.925993-1-jeremy@azazel.net>
References: <20231214125927.925993-1-jeremy@azazel.net>
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

