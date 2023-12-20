Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1262482E3
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kaRfMdfz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KtYgZxlHs5cr7Jo+Hk4dnMzUOqna7/XJ+m7QSyWxsiE=; b=kaRfMdfzaLF152Ad54M0M+/PwF
	xIHjhwV9xUrC3SD3ZiNji6u/2ef0BP9rS3H71KiOmDU3rMeQtfZ3aps5YF2/fL0yUuJR6lX2zW9n0
	OuVD/RB7jKIahQ/c0u/wt4YpXnCIgEIew8CA17S7fNhRiZuBc2ydEPCVrskPHLTbIlOqOm5hr6NiW
	wzUBlyt8zGLzfadU88U1VkjnPHJaDFteCxHEnEwMVlkQzirO23+JAquBmj2xJXabrAvGNSn8sqRDB
	PM6+J8PyZ+8jlDDirJ+X//A+pZ3ucT48oMoQPU7EecVTPaqI/Zwxv+xTFNnGcONEQPasz4QLOkXY3
	nit24rwg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5r-0004LW-7X
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:47 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 03/23] libxtables: xtoptions: Implement XTTYPE_ETHERMACMASK
Date: Wed, 20 Dec 2023 17:06:16 +0100
Message-ID: <20231220160636.11778-4-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160636.11778-1-phil@nwl.cc>
References: <20231220160636.11778-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Accept an Ethernet MAC address with optional mask in the format
xtables_parse_mac_and_mask() expects it. Does not support XTOPT_PUT (for
now) due to the lack of defined data structure.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/xtables.h      |  7 ++++++-
 libxtables/xtoptions.c | 10 ++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/xtables.h b/include/xtables.h
index db7c492a9556e..ab856ebc426ac 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -12,6 +12,7 @@
 #include <stdbool.h>
 #include <stddef.h>
 #include <stdint.h>
+#include <netinet/ether.h>
 #include <netinet/in.h>
 #include <net/if.h>
 #include <linux/types.h>
@@ -68,6 +69,7 @@ struct in_addr;
  * %XTTYPE_PLEN:	prefix length
  * %XTTYPE_PLENMASK:	prefix length (ptr: union nf_inet_addr)
  * %XTTYPE_ETHERMAC:	Ethernet MAC address in hex form
+ * %XTTYPE_ETHERMACMASK: Ethernet MAC address in hex form with optional mask
  */
 enum xt_option_type {
 	XTTYPE_NONE,
@@ -92,6 +94,7 @@ enum xt_option_type {
 	XTTYPE_PLEN,
 	XTTYPE_PLENMASK,
 	XTTYPE_ETHERMAC,
+	XTTYPE_ETHERMACMASK,
 };
 
 /**
@@ -167,7 +170,9 @@ struct xt_option_call {
 		struct {
 			uint32_t mark, mask;
 		};
-		uint8_t ethermac[6];
+		struct {
+			uint8_t ethermac[ETH_ALEN], ethermacmask[ETH_ALEN];
+		};
 	} val;
 	/* Wished for a world where the ones below were gone: */
 	union {
diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 3973c807ded0e..9377e1641f28c 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -791,6 +791,15 @@ static void xtopt_parse_ethermac(struct xt_option_call *cb)
 	xt_params->exit_err(PARAMETER_PROBLEM, "Invalid MAC address specified.");
 }
 
+static void xtopt_parse_ethermacmask(struct xt_option_call *cb)
+{
+	memset(cb->val.ethermacmask, 0xff, ETH_ALEN);
+	if (xtables_parse_mac_and_mask(cb->arg, cb->val.ethermac,
+				       cb->val.ethermacmask))
+		xt_params->exit_err(PARAMETER_PROBLEM,
+				    "Invalid MAC/mask address specified.");
+}
+
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT16]      = xtopt_parse_int,
@@ -813,6 +822,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_PLEN]        = xtopt_parse_plen,
 	[XTTYPE_PLENMASK]    = xtopt_parse_plenmask,
 	[XTTYPE_ETHERMAC]    = xtopt_parse_ethermac,
+	[XTTYPE_ETHERMACMASK]= xtopt_parse_ethermacmask,
 };
 
 /**
-- 
2.43.0

