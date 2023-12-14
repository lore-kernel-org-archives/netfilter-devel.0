Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ZhFe1Hci"
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD03120
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 08:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PW+L8Bt1onKMhcUk/GBl5hwPZR555HSH4eZvlLezlbw=; b=ZhFe1Hci/xqu4dddOrQ8OqNwvY
	CZqZxxYJUpllLArDzF5Lrww4shniVy7EHSLN3FHvizvK2uUqcHedA4FzH3VPlX1jCs4hq79eogz0Q
	1o9KWpLKvzaYfAQXh2DaS4jA1KQVZ60L+gLk/te7XL8LmRZ3A40711PRuZPavoetkb3AhylWq653n
	EdY/xkhf4pw7KRLHo1FJwOH8orAV59Tohaht3FFwLWNUoKCk8AigTeFgObXALcKHcZ3ncAD731yXv
	cWwcCxROI/rfKdAftBTxTyDNBnQslFam6aXGcSqbfHVp561TEyDaVEz8hnCkL78P7dnM15m+H3nrH
	9KotUqhQ==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rDoor-0038UN-2U
	for netfilter-devel@vger.kernel.org;
	Thu, 14 Dec 2023 16:44:17 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables v2 6/6] build: replace `echo -e` with `printf`
Date: Thu, 14 Dec 2023 16:44:05 +0000
Message-ID: <20231214164408.1001721-7-jeremy@azazel.net>
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
index dfa58c3b9e8b..20c2b7bc6293 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -228,19 +228,19 @@ man_run    = \
 	for ext in $(sort ${1}); do \
 		f="${srcdir}/libxt_$$ext.man"; \
 		if [ -f "$$f" ]; then \
-			echo -e "\t+ $$f" >&2; \
+			printf "\t+ $$f\n" >&2; \
 			echo ".SS $$ext"; \
 			cat "$$f" || exit $$?; \
 		fi; \
 		f="${srcdir}/libip6t_$$ext.man"; \
 		if [ -f "$$f" ]; then \
-			echo -e "\t+ $$f" >&2; \
+			printf "\t+ $$f\n" >&2; \
 			echo ".SS $$ext (IPv6-specific)"; \
 			cat "$$f" || exit $$?; \
 		fi; \
 		f="${srcdir}/libipt_$$ext.man"; \
 		if [ -f "$$f" ]; then \
-			echo -e "\t+ $$f" >&2; \
+			printf "\t+ $$f\n" >&2; \
 			echo ".SS $$ext (IPv4-specific)"; \
 			cat "$$f" || exit $$?; \
 		fi; \
-- 
2.43.0

