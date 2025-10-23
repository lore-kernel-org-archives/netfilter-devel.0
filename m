Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E9E28507E
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236090; cv=none; b=Tjgk4jQfNAmUTGSTTG5MjQfoCQxWGxYh6I3xQD66awYKWSsR1716ZnJoFT6ojJed0WKOmLb2eXW6O7T9FsF3X9XjK7xaVQWGP8Cg9Ax84pZeYmBMrd5Em+wwT04YJ5eM1tkHBCgsJ2Ehv/A/HXJI12l4Ry2NPxESWi6UoNNDgmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236090; c=relaxed/simple;
	bh=2XM8pkCRvsDLehfPfeL5A9Evi4iHTBuy491qCWQoFHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSMOnmrhDRL4sxratj1yM6v9OwprNSC5VtQsgOLQuyDa48QTaOsgjnw/43brnIou/51eBh3kBHTnFY5YdX7ZD7wxiAGgDfTKz2I6Nr3HlBGL1T1hUQ5rmtSC4SgvJXSUBOPXd9QmYM+HvtKmCOdCjRQrg0ng1/yjoWwopDf5nFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bMpVvqQ/; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bMpVvqQ/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hlfHy6uiaN6hv0aAUOFo0EalQjvdDQtjDyIERhiUglo=; b=bMpVvqQ/HYbWN7BSrKQDw9BZ6c
	0yBoYegkitOndQ+yQ6Qk0GgLOJQC1/QMYMQaGSuJm9iGOxf0vuN218XRCDgelMkeROAHsCihjISAY
	4+Hkem4LpsedAZPyvIutvtv5NCret4m3p1cHIq5qUPX4eI4uduJCDxKpi68I/HpHhAOl5kpZBO8dL
	EUgtjGgraYDJ1yNDsS4lKwMU0GjqKngnCb2h1t7Y+QCqhcJXDdf6HjyADqTo/UVtWcgUJP4FtVbkn
	hLk9CgA4c5ywBZWVWkKpkRrTfUnmaprOXjACtJZ542F66J8UGN/pETaLU1sUHXCJ1X1zZj0Qhv4Z5
	ozOiRD2w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxd-0000000006q-2oiC;
	Thu, 23 Oct 2025 18:14:45 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 26/28] utils: Introduce expr_print_debug()
Date: Thu, 23 Oct 2025 18:14:15 +0200
Message-ID: <20251023161417.13228-27-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A simple function to call in random places when debugging
expression-related code.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/utils.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/utils.h b/include/utils.h
index e18fabec56ba3..0db0cf20e493c 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -26,6 +26,15 @@
 #define pr_gmp_debug(fmt, arg...) ({ if (false) {}; 0; })
 #endif
 
+#define expr_print_debug(expr)					\
+{								\
+	struct output_ctx octx = { .output_fp = stdout };	\
+	printf("%s:%d: ", __FILE__, __LINE__);			\
+	printf("'" #expr "' type %s: ", expr_name(expr));	\
+	expr_print((expr), &octx);				\
+	printf("\n");						\
+}
+
 #define __fmtstring(x, y)	__attribute__((format(printf, x, y)))
 #if 0
 #define __gmp_fmtstring(x, y)	__fmtstring(x, y)
-- 
2.51.0

