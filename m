Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B0248CD78
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 14:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323127; cv=none; b=DrWiekXmoGu4/2FRTCE6IxZfnZCWBAnmhR61RV/m+QeGdHYR80DzwSlCD683b9TjBYAH9DkmuuY9wuixuRUq7Yn5xyVlPKixDoFvifLgpHoU5qUc79/Gzf9tfGLbPGb5kGm80rrGk2PciDUwSDZZokwDa7ZQevtWt3qywe/echs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323127; c=relaxed/simple;
	bh=lJGdSJpYMEWHEBjLUzg4XcOH6hwykiKsdLb5V1sOosI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyKKjXTrp8YEWr/9KB2L68uHVd4Egm+VCqQedkudVZ+lRgqN+5//8Gx7zZuL7U2f7FVzZJSm9hWGc+2U6jk/D5Zk/2Edad98eolNURWeqcm/G3OmVqbPzxBdz66RhDp+LBpnl1SeWGvHsGehDs2Y6gHUy89C5Rd03NKMGqJplh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Fx3+FiPP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Fx3+FiPP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787323123;
	bh=we6OGxGKgYleqpanFTJclfTyqvtbb+Elrj1TlXrHDD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fx3+FiPP1UnaH6wFLEJbBUKfDBqd1I7XEQc8R0qRuF0tAe3ziAoTKjf4hvBzFmBJ5
	 pgam2pv9Ri0GBYKRdm90xtpxCANOEJyfocD7WvXVCLe936K1GetmshqaMi0jufeO9P
	 6YMU+nN5SeLHE0mO+9s9fYJm1vrOo+XocEpfhohWBTU37IpdDXcHJmtoZq818mgyoi
	 7QAgyJHVPETFqaf0pAdQSb5sMB2Rw8S8P85m06d/Zo7jw8AIHyjAsOuqKkm3Li5e3v
	 0n26HxSNv9qquuAUAT8sfaExel59R/KzdigD2wS8CdfYLodN9Czs/BIUirh+UOWBMV
	 9tNXJJTqWgdXA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B910C6008B;
	Fri, 21 Aug 2026 16:38:42 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next 09/10] netfilter: ebtables: use GFP_KERNEL_ACCOUNT
Date: Fri, 21 Aug 2026 16:38:26 +0200
Message-ID: <20260821143827.183963-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821143827.183963-1-pablo@netfilter.org>
References: <20260821143827.183963-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace
GFP_KERNEL by GFP_KERNEL_ACCOUNT.

Use GFP_KERNEL_ACCOUNT to allocate ebtables template hooks.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 0bf541936f60..64b8f6f98211 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1304,7 +1304,7 @@ int ebt_register_template(const struct ebt_table *t, int (*table_init)(struct ne
 		}
 	}
 
-	tmpl = kzalloc_obj(*tmpl);
+	tmpl = kzalloc_obj(*tmpl, GFP_KERNEL_ACCOUNT);
 	if (!tmpl) {
 		mutex_unlock(&ebt_mutex);
 		return -ENOMEM;
-- 
2.47.3

