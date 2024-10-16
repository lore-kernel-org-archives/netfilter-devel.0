Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3E4187346
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 17:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729098357; cv=none; b=RSK6gBFR8tLceZvvXQgx/6h4DnnVqIH/DDRDesvv57zt6QDQpb0jFClxFDt+LuTNuXAFei/hx58aO9rZXJALV/JxPrj1/eSC2O0/kjhN1v4PDwG1+t7chGlvdFIjzHB7YYhzuUhDTg/dnTN+LwksBEMxscKNA7HnsiZe/6zBJ1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729098357; c=relaxed/simple;
	bh=fzfEe+NWyeExpV0WkHhy+BxmAiSCuXAdnZZJrFv0iP4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o9zfhl46SZXQml4PcITchtSxcClHjEN4J2N8tqCFEJYkH/pNz70QLavZSa9/FiNVZb1rehpoFGmKjNtiroRU3L+wn7JxDlhq+NYSumbFaesbfzf9NsFjwhdR4Vub88GGyGyKRZpG2NDFp1RobogeFo1kRFSiwV7K+vtwB082A7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FzU2i5kT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FzU2i5kT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vt84tmKBFSn0ZomUuLW5bS6L7S65uxS2Me2qeMJ/fuc=; b=FzU2i5kTyD3el/vpXNe4P3ecKB
	p+tHqXkOrF7HhKvzfniuv2Zylfz50XQWKzDAF/+IIqigx/47tKFQu16lNGale5SehTVstGPV/jn93
	WCVB0q+cWEWT0CTK19n2uw+JAv+Scpv/jPvDcW+Y0Sy+QwDAmGLui7uYrn3xvIIayP6taPfno2T55
	tvJOsiArFwrWB/a5l6Dk1gzPzpm/XujbwSYmLu5GgWzkv4hz741rDU5CIDwTJFZ1tqybQ+1B9DdmX
	ywPkxcbTs12bmqOQxIcOTJ+4BZOXYHy2KWD4ofcHLMPso9ZDwcRu3QXU1G+JSb2diynEi40/1ioeF
	6ZFjqSng==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t17T7-000000006J5-2s41;
	Wed, 16 Oct 2024 19:05:53 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] examples: Fix for incomplete license text in nft-ruleset-get.c
Date: Wed, 16 Oct 2024 19:05:50 +0200
Message-ID: <20241016170550.26617-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When converting the license from GPLv2 to GPLv2+, the first line was
dropped by accident.

Fixes: c335442eefcca ("src: incorrect header refers to GPLv2 only")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 examples/nft-ruleset-get.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/examples/nft-ruleset-get.c b/examples/nft-ruleset-get.c
index 34ebe1fb6155c..3acbfa886127e 100644
--- a/examples/nft-ruleset-get.c
+++ b/examples/nft-ruleset-get.c
@@ -5,6 +5,7 @@
  *
  * Copyright (c) 2013 Pablo Neira Ayuso <pablo@netfilter.org>
  *
+ * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published
  * by the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
-- 
2.47.0

