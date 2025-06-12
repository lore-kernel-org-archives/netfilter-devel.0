Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F147223714
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 11:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749729153; cv=none; b=W7D6rUOPPfX+k6ZjALonQEB2X3zF3A2hFq4Tv8FwIAsSgJZzimlfCk5dow4WBQhvRxx738nl4Kr1gJAmABcCUQmW3CXTPolCK2TYpnyf4zxFk8eeC4On9Dgd3RlcM5IM4+QEtnyyAFaY2SRwbcF2fpGhGFQyJ/04hSj5voJSgZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749729153; c=relaxed/simple;
	bh=jL9Hm/RbrNxAB5iQDzX9PZHw7BiT/liHnsLB1RGHt68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hukpKcpI36UWw1EOSjr/EHPoBIy0kDsLaonFO1Pa82YT+CGp9RNhP6otnYQbJTVzzjsHbqKzP/Ienk9dP9EGwzCLRH+bGdqHv6x9ROJI0cdnWLQEAUmpCXvPI+CgEvMsDM6Bam9ig5jnhecdFrn5juvLSQXDIH8i6cCvtAGbsNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gIYyEmnd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gIYyEmnd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=o4G00vcwqUFO0dbbY+QCLl5avWjHKrfPvfQT/ZkVygE=; b=gIYyEmndNXWvtuNycid4g85zZs
	6F7SgAgWpH/g/YcFF60i4IkIuvtDB7BsUFRH1IB3oNcyR6KlAm18bwITfnk+/U7Sc5SYELPsGHUj1
	q3ffP7qrcWkFj+LNUMUdKtvvKn6rxG6AIjtUxPEBGQVz7iLdbkDD/HvQmgiMq9PkTy0OIwIbtaZyA
	pJ2/cG4kxK+gWfZW049bqrXOjolKnY1dN30DqB1ofNdsC8upuYWa5sRGfY/xkd+WUOKB7PjaG4o73
	hhRxEV3MSuq5e8jEhbiTr/1gKgM6GIjjwu+NGT3wuwNgWsmG8qyA5qMUQov0T9YVBqR9J/W0grOB/
	ejpU1Bfw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPgTs-000000006Fq-30fi;
	Thu, 12 Jun 2025 13:52:28 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/7] netlink: Fix for potential crash parsing a flowtable
Date: Thu, 12 Jun 2025 13:52:12 +0200
Message-ID: <20250612115218.4066-2-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250612115218.4066-1-phil@nwl.cc>
References: <20250612115218.4066-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kernel's flowtable message might not contain the
NFTA_FLOWTABLE_HOOK_DEVS attribute. In that case, nftnl_flowtable_get()
will return NULL for the respective nftnl attribute.

Fixes: db0697ce7f602 ("src: support for flowtable listing")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index bed816af3123d..0e0d32b846d6a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1847,7 +1847,7 @@ netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 	if (nftnl_flowtable_is_set(nlo, NFTNL_FLOWTABLE_FLAGS))
 		flowtable->flags = nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_FLAGS);
 	dev_array = nftnl_flowtable_get(nlo, NFTNL_FLOWTABLE_DEVICES);
-	while (dev_array[len])
+	while (dev_array && dev_array[len])
 		len++;
 
 	if (len)
-- 
2.49.0

