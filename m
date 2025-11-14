Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDD235959
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2025 00:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079953; cv=none; b=HaCfFUKkjFLAeU1G4D5v6BAG4j+lteMxWaqB117aKqsPuo2p1/HS66mxgMqb1FdzHA1ggFrdLu0ZgkooV/3mdevRNBN0YpprGFD1CNIZqLFJ8ifK2Dap/382DUSSUhDeYpoRiuGEQcnR+E2AmacO7aQ25dBPfUzqKRJHoLf9Pf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079953; c=relaxed/simple;
	bh=bfVkIuzc8Fz48e5Hs2DX8oTuamulRCXaSZreMTtn1eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDmP+31CxelEVDv26dCAPzfq7mv1Bc2Awm8+zsT3TF15/d3rmSxXL/E/jZXLdWzjYCEK+ka64zQHq3WRn//dIIqO5yCQ21DQDjjVTjhDB70zZCeON8HgpH+9Qi+czx4FrydUdZ5IYqeae/5XhefZSLDCyBvaNGtW1FdmEf9S2+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=QulE2kLC; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="QulE2kLC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jT7p9Fp4e5nyB793mf8l6vgt0+aZ+7kJ7EHs39OWbao=; b=QulE2kLCDlQp9I4pxF/uLUKAQk
	GhrOTxSXQyp/Fa4MQqXQo6EFJxpdpQK7px5ySCK319f+udDoyBpCuZKa+ZEruAWpSHFKTmkjqgz9H
	tz7etQUMo0d4Dm3slsvn1BVBxkxBwIwbjaz70DHbaYZkJex3DyRzubF10wrq0dgVjTXL1ckimmH6n
	/1H1e/J396nQuGzxx4mKvvlqcjDDUb2qZTXV8BHm6M9HIN0d8cXh7TpPmcGXB+JK7uhPL67LJdHke
	cm/Jxu7qo6MiufH+UMxkn0vamvFm5KPlLIzm85C2r2p59UIqwkjPf9ah+PmhHqtOSqLioD6TnYoit
	U5MJsI5A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vJhdM-000000005jo-2fnL;
	Fri, 14 Nov 2025 01:25:48 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 11/11] utils: Introduce expr_print_debug()
Date: Fri, 14 Nov 2025 01:25:42 +0100
Message-ID: <20251114002542.22667-12-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251114002542.22667-1-phil@nwl.cc>
References: <20251114002542.22667-1-phil@nwl.cc>
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
index 6a0e494607c93..1c227f6849a22 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -27,6 +27,15 @@
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
 
 #define __must_check		__attribute__((warn_unused_result))
-- 
2.51.0

