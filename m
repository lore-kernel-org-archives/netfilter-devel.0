Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="SWNH/0r0"
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776EE11B
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 04:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oBkoWERwtOak9pa8jZ7dwPOwmsjB8eSDe5Kf2KXTmac=; b=SWNH/0r0oh7esvASkRs3UE59pL
	5gWTx4ofBS6NSlNnPInznbM/VRMlJPjv2oNWqzx4UbRzISBOjkUKmn2B9Qa9/tNp82X8u1VsCeU/q
	5kLBmZX4GNB5CMIe1b/PEGDTpIYyUJ5dOEetz7iveK/8nnrvTPrf1vMLOTl5Sa5rEfJioPwM2aYwB
	Hc7Otfw9pLiqYsaRra6cgW3YQP7rkbEiwdrmj/QwNDlS083QQyxbjOfpRccOT1Qe4UW2//GQcbgJZ
	ZU7NaCQ44sRRMPx9PrhsUF24hxAa16R9M12tGidceA/wBzbis8LcyF8/vLqnKeW2v6tG+uTxtBcJW
	3MIybW9g==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rDlJN-0032wj-2X
	for netfilter-devel@vger.kernel.org;
	Thu, 14 Dec 2023 12:59:33 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables 6/7] build: replace `echo -e` with `printf`
Date: Thu, 14 Dec 2023 12:59:21 +0000
Message-ID: <20231214125927.925993-7-jeremy@azazel.net>
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

`echo -e` is not portable and we can end up with:

      GEN      matches.man
    -e      + ./libxt_addrtype.man
    -e      + ./libip6t_ah.man
    -e      + ./libipt_ah.man
    -e      + ./libxt_bpf.man
    -e      + ./libxt_cgroup.man
    -e      + ./libxt_cluster.man
    -e      + ./libxt_comment.man
    -e      + ./libxt_connbytes.man
    -e      + ./libxt_connlabel.man
    -e      + ./libxt_connlimit.man
    -e      + ./libxt_connmark.man
    -e      + ./libxt_conntrack.man
    [...]

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/GNUmakefile.in | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index dfa58c3b9e8b..f41af7c1420d 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -228,19 +228,19 @@ man_run    = \
 	for ext in $(sort ${1}); do \
 		f="${srcdir}/libxt_$$ext.man"; \
 		if [ -f "$$f" ]; then \
-			echo -e "\t+ $$f" >&2; \
+			printf "\t+ $$f" >&2; \
 			echo ".SS $$ext"; \
 			cat "$$f" || exit $$?; \
 		fi; \
 		f="${srcdir}/libip6t_$$ext.man"; \
 		if [ -f "$$f" ]; then \
-			echo -e "\t+ $$f" >&2; \
+			printf "\t+ $$f" >&2; \
 			echo ".SS $$ext (IPv6-specific)"; \
 			cat "$$f" || exit $$?; \
 		fi; \
 		f="${srcdir}/libipt_$$ext.man"; \
 		if [ -f "$$f" ]; then \
-			echo -e "\t+ $$f" >&2; \
+			printf "\t+ $$f" >&2; \
 			echo ".SS $$ext (IPv4-specific)"; \
 			cat "$$f" || exit $$?; \
 		fi; \
-- 
2.43.0

