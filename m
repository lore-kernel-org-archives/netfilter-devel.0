Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="VrZ+arIK"
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABF5114
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 08:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=upReZHkA5rxf9OVI1F0LW/69k6j+8yjL8deHHMN3N1w=; b=VrZ+arIKbYtobbYGLlKAyNlrx2
	vC55Nj12e661JZ8YtbFckqiQvoThY31fjU/4IW8QFtbRbgUpYVI490MAbd6bVwTwr3MWIQl3PRZ7G
	b4jBEr43CzvVbcGMREexG7ynZBIIzqws31ImcRfOD0YAcOdp9OOtuI4HxWOWTgN+w6phIdFOGpXjd
	sxHC6EKUHqbvT2LiOKWlEmxTnXvJEeyNQcn2Lj6EBS92PkdJsZwE+aNiwW/vG58ZO+FI9AYstmnUb
	ar8f4jwWzw0KC32xlYxWSkC+YH/Xj4nLB2PZbNr63mG4wHqyoawVLIEpa9VbH+eXlbc72xDEtmhTK
	YVx+qU1g==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rDoor-0038UN-1u
	for netfilter-devel@vger.kernel.org;
	Thu, 14 Dec 2023 16:44:17 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables v2 2/6] build: remove obsolete `AM_LIBTOOL_SILENT` variable
Date: Thu, 14 Dec 2023 16:44:01 +0000
Message-ID: <20231214164408.1001721-3-jeremy@azazel.net>
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

