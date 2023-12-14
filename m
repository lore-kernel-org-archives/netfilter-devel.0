Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="DBthfKTT"
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7760A116
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 04:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=upReZHkA5rxf9OVI1F0LW/69k6j+8yjL8deHHMN3N1w=; b=DBthfKTTcLsjIbqEH+DizNd/wP
	vRd4k0hkEx0yM6GX4EbMBec3B7Y6SCybSPV32JydtCwHoXKqWyC77l6mu5GygFP2QsmOphZtHYy43
	davQGwxgGXX0UhCxhKxm9cfDz2iJm/zfnBjZOZ5tFD9CNXikuyEIj9OrRVvYa92LAyiYA1k9O1KaM
	N0xam+V3jQKX03PUmhlYv07rq8WQM8LeoCIMf8D+bW6xseLc6m7bx3rUoePv+PFZqC8zfMOCpRLQ6
	Dh1zDR08Y6FWZ21HgarIU2QVd7x3pUUCgWhviQMT/QebZ4uRxcSydsEdk34Rd6Olh3fxuyXHgzCF9
	kq8mTr8Q==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rDlJN-0032wj-1w
	for netfilter-devel@vger.kernel.org;
	Thu, 14 Dec 2023 12:59:33 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables 2/7] build: remove obsolete `AM_LIBTOOL_SILENT` variable
Date: Thu, 14 Dec 2023 12:59:17 +0000
Message-ID: <20231214125927.925993-3-jeremy@azazel.net>
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

It doesn't do anything, so get rid of it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/GNUmakefile.in | 1 -
 1 file changed, 1 deletion(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 40bcec7999ae..53011fc8c2bb 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -35,7 +35,6 @@ AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 AM_LDFLAGS      = @noundef_LDFLAGS@ @regular_LDFLAGS@
 
 ifeq (${V},)
-AM_LIBTOOL_SILENT = --silent
 AM_VERBOSE_CC     = @echo "  CC      " $@;
 AM_VERBOSE_CCLD   = @echo "  CCLD    " $@;
 AM_VERBOSE_CXX    = @echo "  CXX     " $@;
-- 
2.43.0

