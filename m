Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9DC286430
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236071; cv=none; b=KsLpWllaEAqSVYNd45B2+1w+Q9fyIc1EHWcDJIXhfpIVA3hjVVNrFD2cVJCO/1TMvQUUANP3+avOz1Uq6nJx2zvTH6k93EO2b4VRji7OgeKbl9jiyaxDBmyPOWU0O59Rce9+aig0H9b5Y9Mi/zdlNCWnjAEDlvR11UlOTi2iIgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236071; c=relaxed/simple;
	bh=sBbdU3X2Wx+xT9o70S8s5xR9MCOVJz8m78G9eaC3DW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rN2klW1REcOsWov9pbjL6yUzZWvWn+5G8vloKPCumeMPC3f6Hs23nDaL8hXzlXTKiR5to2Q+iFS4Rr6zbZdlgPip7ZxPPa1guGG3XmxK/CdZ7WthBaDwLbllnFk2QuO+VrHeulXYbm6A6a9yiUqIjxRFYy950/FOhWIOe79O38s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=l1UBRB0S; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="l1UBRB0S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lWF1czO5YgSVJcwgVgX4ooAklmcFel/JMdMc7kvvVEM=; b=l1UBRB0SxhQm8Dcob3RhJ7DCqH
	oZpduUd0e3jvwHQ1+LFLllE60GJj+MrqLqTFu2mjG6I9JAcT2gVbmw4f9vUE8Xy0JPAGt5B9zcUEF
	bLpXLEpbaMZXMNkerk+mwGI9GU3PvJrp3qvGEH3j39cmxNuehsWI4gXG7R/qxnqhNiaV0XllRV06v
	hSI2EvmEzb6+xCxw9kHTM4MCyd4IRmWmfhYiQZ62LKKWe4nkXMGnVPbHG0pf33SgLBVq8h5gWUovm
	pv4hyPMj4l/dP4hB0ZJJX9VW9xKO3AMKiapeISVe/V7swm3hNkq+k0oXuxA+L+WXcvfsk2IWMe4su
	STp8nRMA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxL-0000000005G-2pc6;
	Thu, 23 Oct 2025 18:14:27 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 12/28] netlink: Zero nft_data_linearize objects when populating
Date: Thu, 23 Oct 2025 18:14:01 +0200
Message-ID: <20251023161417.13228-13-phil@nwl.cc>
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

Callers of netlink_gen_{key,data}() pass an uninitialized auto-variable,
avoid misinterpreting garbage in fields "left blank".

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/netlink.c b/src/netlink.c
index 7882381ebd389..3258f9ab9056e 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -563,6 +563,8 @@ static void netlink_gen_prefix(const struct expr *expr,
 static void netlink_gen_key(const struct expr *expr,
 			    struct nft_data_linearize *data)
 {
+	memset(data, 0, sizeof(*data));
+
 	switch (expr->etype) {
 	case EXPR_VALUE:
 		return netlink_gen_constant_data(expr, data);
@@ -580,6 +582,8 @@ static void netlink_gen_key(const struct expr *expr,
 static void __netlink_gen_data(const struct expr *expr,
 			       struct nft_data_linearize *data, bool expand)
 {
+	memset(data, 0, sizeof(*data));
+
 	switch (expr->etype) {
 	case EXPR_VALUE:
 		return netlink_gen_constant_data(expr, data);
-- 
2.51.0

