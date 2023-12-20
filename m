Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D346482C1
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="BoKYE1sS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=U6Ceg9FhHPrHCKrVDt/NwsNRIFJB8Ugi6rUumgDOQ6M=; b=BoKYE1sSM4DaVcPMSKTZ1aui80
	3JCURbo1TW1XV6FOsUr6HNo9woko50GU7rM4iRRvYoD31H5XajP4m77WHmUkuU1zKq1qlVDxQF7al
	FmhR/DugcD44capF53Yh4xO8xVYGLZeSkZEA/Z+JBwXp0d9QDaekDGlo+iJOIrarc32eP22G7ajvz
	E+ChHG/QWUKAxA5sRtPpiHe141/2W3CScQHjwwfe1x5RGD1q7ZErUWGz2NyYsNeRuqF+k5nIEupTB
	f9B9TV7zaXcBEb7eYrYE33k0eAbm97mN9yrxqIjOlmFr+g0BDWXualvZc0Q60K2me+uFFm/kAEKgm
	p4XqeJ6Q==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5m-0004Kn-HD
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:42 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 23/23] extensions: libxt_HMARK: Review HMARK_parse()
Date: Wed, 20 Dec 2023 17:06:36 +0100
Message-ID: <20231220160636.11778-24-phil@nwl.cc>
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

* With XTOPT_NBO support in UINT types, the manual byteorder conversion
  calls are no longer needed
* Setting bits in cb->xflags is done by xtables_option_parse() already
* Since O_HMARK_* values match XT_HMARK_* ones, all but the O_HMARK_TYPE
  case fold together into a single default one

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_HMARK.c | 60 ++++++----------------------------------
 1 file changed, 9 insertions(+), 51 deletions(-)

diff --git a/extensions/libxt_HMARK.c b/extensions/libxt_HMARK.c
index 94aebe9af8353..83ce5003a1886 100644
--- a/extensions/libxt_HMARK.c
+++ b/extensions/libxt_HMARK.c
@@ -41,6 +41,7 @@ static void HMARK_help(void)
 
 #define hi struct xt_hmark_info
 
+/* values must match XT_HMARK_* ones (apart from O_HMARK_TYPE) */
 enum {
 	O_HMARK_SADDR_MASK,
 	O_HMARK_DADDR_MASK,
@@ -88,32 +89,32 @@ static const struct xt_option_entry HMARK_opts[] = {
 	{ .name  = "hmark-sport-mask",
 	  .type  = XTTYPE_UINT16,
 	  .id	 = O_HMARK_SPORT_MASK,
-	  .flags = XTOPT_PUT, XTOPT_POINTER(hi, port_mask.p16.src)
+	  .flags = XTOPT_PUT | XTOPT_NBO, XTOPT_POINTER(hi, port_mask.p16.src)
 	},
 	{ .name  = "hmark-dport-mask",
 	  .type  = XTTYPE_UINT16,
 	  .id	 = O_HMARK_DPORT_MASK,
-	  .flags = XTOPT_PUT, XTOPT_POINTER(hi, port_mask.p16.dst)
+	  .flags = XTOPT_PUT | XTOPT_NBO, XTOPT_POINTER(hi, port_mask.p16.dst)
 	},
 	{ .name  = "hmark-spi-mask",
 	  .type  = XTTYPE_UINT32,
 	  .id	 = O_HMARK_SPI_MASK,
-	  .flags = XTOPT_PUT, XTOPT_POINTER(hi, port_mask.v32)
+	  .flags = XTOPT_PUT | XTOPT_NBO, XTOPT_POINTER(hi, port_mask.v32)
 	},
 	{ .name  = "hmark-sport",
 	  .type  = XTTYPE_UINT16,
 	  .id	 = O_HMARK_SPORT,
-	  .flags = XTOPT_PUT, XTOPT_POINTER(hi, port_set.p16.src)
+	  .flags = XTOPT_PUT | XTOPT_NBO, XTOPT_POINTER(hi, port_set.p16.src)
 	},
 	{ .name  = "hmark-dport",
 	  .type  = XTTYPE_UINT16,
 	  .id	 = O_HMARK_DPORT,
-	  .flags = XTOPT_PUT, XTOPT_POINTER(hi, port_set.p16.dst)
+	  .flags = XTOPT_PUT | XTOPT_NBO, XTOPT_POINTER(hi, port_set.p16.dst)
 	},
 	{ .name  = "hmark-spi",
 	  .type  = XTTYPE_UINT32,
 	  .id	 = O_HMARK_SPI,
-	  .flags = XTOPT_PUT, XTOPT_POINTER(hi, port_set.v32)
+	  .flags = XTOPT_PUT | XTOPT_NBO, XTOPT_POINTER(hi, port_set.v32)
 	},
 	{ .name  = "hmark-proto-mask",
 	  .type  = XTTYPE_UINT16,
@@ -211,53 +212,10 @@ static void HMARK_parse(struct xt_option_call *cb, int plen)
 	case O_HMARK_TYPE:
 		hmark_parse_type(cb);
 		break;
-	case O_HMARK_SADDR_MASK:
-		info->flags |= XT_HMARK_FLAG(XT_HMARK_SADDR_MASK);
-		break;
-	case O_HMARK_DADDR_MASK:
-		info->flags |= XT_HMARK_FLAG(XT_HMARK_DADDR_MASK);
-		break;
-	case O_HMARK_SPI:
-		info->port_set.v32 = htonl(cb->val.u32);
-		info->flags |= XT_HMARK_FLAG(XT_HMARK_SPI);
-		break;
-	case O_HMARK_SPORT:
-		info->port_set.p16.src = htons(cb->val.u16);
-		info->flags |= XT_HMARK_FLAG(XT_HMARK_SPORT);
-		break;
-	case O_HMARK_DPORT:
-		info->port_set.p16.dst = htons(cb->val.u16);
-		info->flags |= XT_HMARK_FLAG(XT_HMARK_DPORT);
-		break;
-	case O_HMARK_SPORT_MASK:
-		info->port_mask.p16.src = htons(cb->val.u16);
-		info->flags |= XT_HMARK_FLAG(XT_HMARK_SPORT_MASK);
-		break;
-	case O_HMARK_DPORT_MASK:
-		info->port_mask.p16.dst = htons(cb->val.u16);
-		info->flags |= XT_HMARK_FLAG(XT_HMARK_DPORT_MASK);
-		break;
-	case O_HMARK_SPI_MASK:
-		info->port_mask.v32 = htonl(cb->val.u32);
-		info->flags |= XT_HMARK_FLAG(XT_HMARK_SPI_MASK);
-		break;
-	case O_HMARK_PROTO_MASK:
-		info->flags |= XT_HMARK_FLAG(XT_HMARK_PROTO_MASK);
-		break;
-	case O_HMARK_RND:
-		info->flags |= XT_HMARK_FLAG(XT_HMARK_RND);
-		break;
-	case O_HMARK_MODULUS:
-		info->flags |= XT_HMARK_FLAG(XT_HMARK_MODULUS);
-		break;
-	case O_HMARK_OFFSET:
-		info->flags |= XT_HMARK_FLAG(XT_HMARK_OFFSET);
-		break;
-	case O_HMARK_CT:
-		info->flags |= XT_HMARK_FLAG(XT_HMARK_CT);
+	default:
+		info->flags |= XT_HMARK_FLAG(cb->entry->id);
 		break;
 	}
-	cb->xflags |= (1 << cb->entry->id);
 }
 
 static void HMARK_ip4_parse(struct xt_option_call *cb)
-- 
2.43.0

