Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD21296BC3
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236093; cv=none; b=MDhHZGe9EAennGizhwi9Eu7yxc/QiFcELVQ01XUAfaRQGSiyM8H4e0szxDInpLVHDjGIfHPEzwZFg81hyGX4evfk9ABXnC4NT2RsqKKUIeoeMaPVsmGFEUIMa+h6OPq+jQm25oP1RP13eO2v5CMf+6cPNkZ/4L0MibtCFGU35YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236093; c=relaxed/simple;
	bh=9MdkPrvPodyIObMgTK9sIxbxDKg+Pwh1xELH5fZ4mOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFQOZEqn0KzpKewcIr09WTq4M34832x1z16FLEE5aqd1ATAVUoas8tTxSgYF+4tAjndCDJQMNpI5h9H15D+jc7x2oQDcUEw4IF3hEYEOqhvJ877ELPHx9hruvj4HgE/I2vvmkpIq4P6owbA8vSq2iJjMgkKk7pPJAD2eIxjdv4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kW1nSyEj; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kW1nSyEj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=y+uXsxofPPrss6HwiUgDLj53uOGZ0KVP99smq0AUSfE=; b=kW1nSyEj/7wSMnDtFHIoimH1I9
	wDBM3whtzct0gCPutclLVfR9zAMReoXsWlns4psfkUzXtWkeHMAxyLx0af+XiBZ99attsCq6pKWuM
	Zv/f57/CM5csLI50yQ7QLecN2KZtXRDASQ/Yk4z1v2eX1pcU6/UsjyK6pHC4BEsMTp+jcYf2uJHTt
	LXSy1wKHQL0Lw01HdjZ/ORefS84DTeigRUT6uaccZ4CeUJThyPmsaNA/4N7t2kV1+//Z07mq7MSio
	QjB+Y5mrMz61XIT55qQxMT4y0vP+jveYKYdzzfC9ue+Wx770uFVMISk/dlPKJIcaERSdbaq+prpBm
	Qdbr/NZA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxi-0000000007N-1KXN;
	Thu, 23 Oct 2025 18:14:50 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 01/28] datatype: Fix boolean type on Big Endian
Date: Thu, 23 Oct 2025 18:13:50 +0200
Message-ID: <20251023161417.13228-2-phil@nwl.cc>
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

Pass a reference to a variable with correct size when creating the
expression, otherwise mpz_import_data() will read only the always zero
upper byte on Big Endian hosts.

Fixes: afb6a8e66a111 ("datatype: clamp boolean value to 0 and 1")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/datatype.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index f347010f4a1af..7104ae8119ec6 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1559,7 +1559,7 @@ static struct error_record *boolean_type_parse(struct parse_ctx *ctx,
 					       struct expr **res)
 {
 	struct error_record *erec;
-	int num;
+	uint8_t num;
 
 	erec = integer_type_parse(ctx, sym, res);
 	if (erec)
-- 
2.51.0

