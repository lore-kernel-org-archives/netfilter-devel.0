Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA60D520
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2024 18:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727287288; cv=none; b=Wd2RCFcP+3Sdspm8KlYHRT2wKrY5PdnAgnw6PBnc6T/rmp5JXCucS3UenHM9d/ivJH+Cxik891rrsMpPRC1PWPuch+G3lR2tLBfDNFhD1aBunbX2LDotvE/W0irpTUo1BqJp15qs3O+jHzLgXMVaJnXaa1h2aPpXaRZcYs0Y+OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727287288; c=relaxed/simple;
	bh=23kDi/SdvynH4/j79A33yP+uVi6J4yE0mX6MQOZz5Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NPo//L3pImPd2nHgJ6ztNPRDC3u0P9FMwKAHd8XBGsTUw3h6OdqT9GjaFfNXVNPqyglklHLeiWcfNIYqr9yyjd1O2EAYn/R2AbU8t9bJc/tL1ICPARSz3R/LAnx19/B7vAmpx7AYGnfgfL/T6VB3RNXK4rGSMs7WV039GEYys5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Qj8JyY6F; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Qj8JyY6F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=C/QnPistGTYeO6pAg1acBxB/g94PnwwZD/RjWJXX+CM=; b=Qj8JyY6FXOESi7hbBBd4LVlvO9
	jd6VWZcotgJgiOhDnJL390lh8d1dkDiJMEP3d5EekG5SBFyMqMpULFZrOs6e3crkPDyVQgM+xB9eF
	AbR38+6ykb4k/2a15G9XxeLZwD70idFCcF91sxSS6+D1jRUyEC1VKuPtql97eZ7j9JBcv+tDQOB/H
	/iuysBNe1gby7qMQk4Kk5YRXIBdt8fNpWuyVOmhPiTYuNz+ZO8gxc2Cva0K3M9PaJ9ZTL6bC/nHjW
	quMjufv+3W/obSHaRAscUL7tqLLeXQ2HBHsRnjWwSOfPp75rIv/rx2FrV4O/PGsD+rqdjYbCDgc8L
	JCP09Qkg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stWKK-000000000Ci-2Lp1;
	Wed, 25 Sep 2024 20:01:24 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf PATCH] netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED
Date: Wed, 25 Sep 2024 20:01:20 +0200
Message-ID: <20240925180120.4759-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix the comment which incorrectly defines it as NLA_U32.

Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index d705f30ac2b3..cb92375b77b0 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1696,7 +1696,7 @@ enum nft_flowtable_flags {
  *
  * @NFTA_FLOWTABLE_TABLE: name of the table containing the expression (NLA_STRING)
  * @NFTA_FLOWTABLE_NAME: name of this flow table (NLA_STRING)
- * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
+ * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration (NLA_NESTED)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
  * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
  * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
-- 
2.43.0

