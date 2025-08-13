Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96013280CD3
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104760; cv=none; b=ASUHaL0jRk4afJacQz8Rs/agn7/5zOhuBrv7R/kRfsQlbgV67EXl/+nYP8k+1jl/fm6dXSLmyT6hT0UOoEUWVtG2m5a0rU0XFeY2LVAoyBQKZgoybKmRbvOXwY6xJ2HI8BzU95dk4qioR+PDQlr6ivZi4p7sXAa2aU7Y3qwdKVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104760; c=relaxed/simple;
	bh=YGsOrNena7PY8ogIb2J6M6bQuTrGGmO1z4bsbUIRp9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNKYOdatKmQAaOIepi6AMCJGCyTT2HiA89TP704Wr+DVjYarxFb6sHZOx49qbjb5J/bf+OcJ+r6ly7wcEPjand1bgZl8iiSwwAywf6+t21i0la3gikpisn2nSfscEBmBFkOfsY+rfvzQyJlcWHGhlKaWb+czAV6YPVjHYH6GUaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZL+tFqVN; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZL+tFqVN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0KpuxQmSZw/bo37+Fshfi9GPR3npLLH3JhHIDG4umNM=; b=ZL+tFqVN615wBUCL63EXtLBHeU
	SxpkZWJhwG9n8rrs4h7wdI8Q5AP14NMZVE6bZvnErbiFzTKZMNynYAWk/QTz9DqlXZpHYdfIZDN7B
	atcBKc7aIPF0bMrnPaTjc8El0yy6IV5usXMbF2RUzVOX4n3G5Wou0GIWtXeq93umjDyaZIEs0ArGO
	v/RB1BS7OEQOurbUuUR2sDyCUvjlbt40juWZPlUKAMeOXQtLsTsug0xnc+FNipTIoXcvJrFBYqMdu
	cMEgIJO311l2cE8e+nK87r73umTHKpnvwYlEedas95t8OqQEJkGEJsuXZtnEsvm0gh251CLi7XSAM
	Xg035GNA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEvE-000000003nf-48nt;
	Wed, 13 Aug 2025 19:05:57 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 01/14] tests: py: Drop duplicate test in any/meta.t
Date: Wed, 13 Aug 2025 19:05:36 +0200
Message-ID: <20250813170549.27880-2-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250813170549.27880-1-phil@nwl.cc>
References: <20250813170549.27880-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The expected invalid meta hour argument of 24:00 is tested already.

Fixes: a6717ae094db2 ("evaluate: Fix for 'meta hour' ranges spanning date boundaries")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/any/meta.t | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 74e4ba28343d9..c5ab2ad908c46 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -221,7 +221,6 @@ meta hour "00:01" drop;ok
 meta hour "01:01" drop;ok
 meta hour "02:02" drop;ok
 meta hour "03:03" drop;ok
-meta hour "24:00" drop;fail
 meta hour "23:59:60" drop;ok;meta hour "00:00" drop
 meta hour "00:00"-"02:02" drop;ok
 meta hour "01:01"-"03:03" drop;ok
-- 
2.49.0

