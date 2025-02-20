Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612742F852
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Feb 2025 17:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740072036; cv=none; b=dVoRps1Hg3ZPCnL6DdzyBfXmEKcxWJOImthTXe/MO6BPN3jaWYfj/Wx7K97xfCaEnbyNV+M0wJDCXdhLg2+OEKj91emCh8/Znp65panw/yeZoDtqwg6uif8/ITMRopQyeriS1sIlSVhFe3Rajuf7DU09WRgr3UhXvJdZ8+ZDhrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740072036; c=relaxed/simple;
	bh=Ormfdj+I5kMReFgYKRngEDP72+BOfrJXpkIfM6Gn92I=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=JOaTqCjEZcxvitiG2wSSOQDYwYb15iaKD38fCmwiW1DsSu4hCuXKmALhuOVEQW6krjfKp3eQiYDLixZW6ylxtvpJBKIND0nFnR0VnqUtIhkah3ggr+DSw5bomHYxc31b+wD8tfWPk0MMS0VRG+whEh5aXsyfc1DRic4l7Z5OxnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Bzs1KQmD; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Bzs1KQmD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Bzs1KQmD";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Bzs1KQmD"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 79248602F6; Thu, 20 Feb 2025 18:20:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740072032;
	bh=18Kokfm6Elft0mPFKyuXWzYo7J4010jlDRXibIuYrRs=;
	h=From:To:Subject:Date:From;
	b=Bzs1KQmD48qrNhaIXIY0XguYZJIqvDiBFHiEHj7yyIIcdQHMDv+fgB3Hccp6t6Exp
	 YjuAq/rvRaMh/dmFh9liFVnBIHL055uYe9ZwGHyi/MgDqIHTEJYdxlxYN2vs2Y3S/+
	 gRZEuBLev1Tp97EA3HPoBWWjsORmsG4ppLxP2+vhBWIj6xFi8apcH3FX1NWpAvkRDD
	 LHPJcbYXEt173sWB5qDSUuKk0fFfazbQFp4IRCT8KYPFuMk+PI+0X5eseEip/bZlpI
	 vuIMFo1jsVikSwE4/HRHyRsxxgDn1tAvQRw/spmEbGdumboJHoRKSDycdyrFIkWlAt
	 y/GaXrWIb3SOQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 279F4602F4
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Feb 2025 18:20:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740072032;
	bh=18Kokfm6Elft0mPFKyuXWzYo7J4010jlDRXibIuYrRs=;
	h=From:To:Subject:Date:From;
	b=Bzs1KQmD48qrNhaIXIY0XguYZJIqvDiBFHiEHj7yyIIcdQHMDv+fgB3Hccp6t6Exp
	 YjuAq/rvRaMh/dmFh9liFVnBIHL055uYe9ZwGHyi/MgDqIHTEJYdxlxYN2vs2Y3S/+
	 gRZEuBLev1Tp97EA3HPoBWWjsORmsG4ppLxP2+vhBWIj6xFi8apcH3FX1NWpAvkRDD
	 LHPJcbYXEt173sWB5qDSUuKk0fFfazbQFp4IRCT8KYPFuMk+PI+0X5eseEip/bZlpI
	 vuIMFo1jsVikSwE4/HRHyRsxxgDn1tAvQRw/spmEbGdumboJHoRKSDycdyrFIkWlAt
	 y/GaXrWIb3SOQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] evaluate: auto-merge is only available for singleton interval sets
Date: Thu, 20 Feb 2025 18:20:29 +0100
Message-Id: <20250220172029.869691-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

auto-merge is only available to interval sets with one value only,
untoggle this flag. Later, this can be hardened to reject it.

Fixes: 30f667920601 ("src: add 'auto-merge' option to sets")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 812505868dd1..f5838df650b5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5041,6 +5041,9 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		       sizeof(set->desc.field_len));
 		set->desc.field_count = set->key->field_count;
 		set->flags |= NFT_SET_CONCAT;
+
+		if (set->automerge)
+			set->automerge = false;
 	}
 
 	if (set_is_anonymous(set->flags) && set->key->etype == EXPR_CONCAT) {
-- 
2.30.2

