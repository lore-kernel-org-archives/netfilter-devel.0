From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH] nft: Header inclusion missing
Date: Thu,  3 Oct 2013 14:39:22 +0300
Message-ID: <1380800362-11290-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2603 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab3JCLj0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:39:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46ixes:
nft-shared.c: In function =E2=80=98nft_ipv46_rule_find=E2=80=99:
nft-shared.c:725:2: warning: implicit declaration of function =E2=80=98=
nft_rule_print_save=E2=80=99 [-Wimplicit-function-declaration]
nft-shared.c:725:32: error: =E2=80=98NFT_RULE_APPEND=E2=80=99 undeclare=
d (first use in this function)
nft-shared.c:725:32: note: each undeclared identifier is reported only =
once for each function it appears in

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft-shared.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 5c09fe1..c9bde90 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -27,6 +27,7 @@
=20
 #include "nft-shared.h"
 #include "xshared.h"
+#include "nft.h"
=20
 extern struct nft_family_ops nft_family_ops_ipv4;
 extern struct nft_family_ops nft_family_ops_ipv6;
--=20
1.8.3.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
