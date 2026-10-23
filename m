Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792763920;
	b=I9AONLhiTBNnuFWnuGp5MlVeAFHmAST6Lo/syBrjqYES1r4phWX2kXO0jhGQ2JOX7WYb
	 l3PZmK24MrJA64Dx7DaaqXBIbcrTyWauk9a6dKymB+Iqdtl0pnlOayRErYLOebPxY/sDP
	 V/wYaTK5aJpT7F5nv8WCBQsvpd2Qw59JKJXD3ioFS2tQDAPrIzDRDLG+bn5P+zr8n7AwT
	 /Pj1kA4UeCNJqQfYBIWQ5pe3tFUUqrYxvRs1NCgE+32VDPXxebFULNhGi8zoIqyhegGhj
	 Xm/e6t5X9jutoeuormQiXBdAtZ3U5P797hT36p42wsfxRRDwbirPk6hh84QeM4MSH5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792763920;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=e+iKjHvNXYpZtpUHAR1vquw3k47JpM3ZOTtvT8nDIzM=;
	b=Ag4XPgZo+dskVF4L6sd8KprCyIHXefqaW/QHocSOZpGGoAQTZLb6xq96xjT8s1wUdh43
	 jx5rkDEPSPwSzU2tsRXKbuPqYdz6D1u+Ldt8x5RofCtklOCGUIheTFnkwQS2BdBXovB0n
	 SCQTubVxDlxXW+F35MUv2yqhHA0Ddr7ALo5AXkK5Bs78vZTSdRg57vpfM9Rc1w+J7X3wP
	 b/RgfNNBWTLXgDQUHoexchYNcp5ViWFtMJEN3b6vQdzi3QOdd3YFcEWb95Dy2NivW8UlO
	 gZTjeUiPEHjJASlxC85HkPCGUDEg0y40V6Smx5u52rbWpQBZlaRwzAsYB8oG+R0O2dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1211606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 13:58:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1211606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 577B860796; Fri, 23 Oct 2026 15:58:38 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 5/7] src: flowtable: allow to unset NFTNL_FLOWTABLE_SIZE
Date: Fri, 23 Oct 2026 15:58:04 +0200
Message-ID: <20261023135806.7259-6-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261023135806.7259-1-fw@strlen.de>
References: <20261023135806.7259-1-fw@strlen.de>
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

LLM finding: NFTNL_FLOWTABLE_SIZE was missing, so we fall through
and do not withdraw the flag.

This is a native uint32_t, so no memory leak occurs here.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/flowtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/flowtable.c b/src/flowtable.c
index 27af51c68874..2adb478ee94a 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -72,6 +72,7 @@ void nftnl_flowtable_unset(struct nftnl_flowtable *c, uint16_t attr)
 		break;
 	case NFTNL_FLOWTABLE_HOOKNUM:
 	case NFTNL_FLOWTABLE_PRIO:
+	case NFTNL_FLOWTABLE_SIZE:
 	case NFTNL_FLOWTABLE_USE:
 	case NFTNL_FLOWTABLE_FAMILY:
 	case NFTNL_FLOWTABLE_FLAGS:
-- 
2.55.0

