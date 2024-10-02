Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D88C12CD88
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 19:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727896797; cv=none; b=mvUs42aisZ6cOJTS/st5XQlgL5glyCmgrrZSlp+b8cX36a3PhC9C3MFsoo2tgO3KfrXHXc1R4clPwlJHqloAEKBMCZLm101/SvndKr/quapAi+lLeED50ydrTLGyjpcjk/FBGstn+HpCVC3IHuPzu9bavpB1oDsxwbL1JpV0bpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727896797; c=relaxed/simple;
	bh=kZP5CKAWBAGYVBdW2aEOzX1flzTaeYWhH/eN7r+lu7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfG4xKbxhiLukXLMda+0WC4RgBEjDif2Aj33ORaGkOIv8W3ttaq5fpe9FrAplVMjARQhUi+3nP+b+wailcauV/N9k2uJIFG4a51TaXyCNQR6NgcUz1eqwC5ayuJ0EQf0BAslCNG+TL86ckvB4dCqhqkrtXlolvPcq5tktG3YKiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=goHH625I; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="goHH625I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cWpxR1TSIQlQKJoBU8vKgP6/4Qt4DfPbB3p3yGOMHtQ=; b=goHH625I7cXt5GspEsMJAdo3bl
	GkIBmoaA1Y57NPZt9Re/ytNpEz++ZstN5MQ6Qm0+I9oC2lzkgMlUFG1PjqUTadbLNuVvPs4mHOBQZ
	y3CGULDTRmYVOHw54IMSfyNhMyG2AG5oUYAs7WkK16F59WLDWeFAfep8RyMKIn8avV5AA324tolKq
	7VcFMkCIZruQ5A2pnFZUJMa2zuTgCrau1h2oEdeaQzbr08r2Z3iYYduSr3dI7ErAg9OLlVXrVMyWY
	t3Dzy5r2YgST4g9Sd1yD01JB2Xs7a4Ubc22fBL7Guyftm+z/Rx33nXYz+PJX0wHrw0Pvf17/sG98X
	6mquUNfg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sw4t0-000000002lK-2Hs8;
	Wed, 02 Oct 2024 21:19:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 1/4] include: utils.h needs errno.h
Date: Wed,  2 Oct 2024 21:19:38 +0200
Message-ID: <20241002191941.8410-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241002191941.8410-1-phil@nwl.cc>
References: <20241002191941.8410-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise includers may face 'errno' undeclared errors.

Fixes: 26c945057d742 ("src: split internal.h is smaller files")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/utils.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/utils.h b/include/utils.h
index eed61277595e2..247d99d19dd7f 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -1,6 +1,7 @@
 #ifndef LIBNFTNL_UTILS_H
 #define LIBNFTNL_UTILS_H 1
 
+#include <errno.h>
 #include <stdio.h>
 #include <stdint.h>
 #include <string.h>
-- 
2.43.0

