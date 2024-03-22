Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE0A59163
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Mar 2024 16:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711123612; cv=none; b=sKfmDN3SIiO+Bhd3fsJYiwkbulyi5Hvyi8aFZcdmRHS6ozHJZKWsD34+X5Hu3mzBy1qIYHvMPTbiJ6h4VWcgCiPtbptOBORE3Jd4iW8BHIkAOXeQqWc8IUB4ryaClh2rD9bxxSCd+dEQQRtbDb6JwOVFhpRaqd4bqMm0dVEFJ7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711123612; c=relaxed/simple;
	bh=dLpsrfKdZMQt9iaRNdFUzrgrZ9oX/G7hjJ0Sf745CIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVWBCx1lMIaMOLuOr2ALqmozTg4Dn6qNN3YEl9hBTgIRTJy0WlJDE6pxDE1weedQ1bT3rUP155vCHRZNCAMszX7cvV7JyJLHW5YVtxD61SbexufKqFKfj5odX5n8WwY2QI3HfaifrWqNv9y49yzAbHsMLtuDWo+UpW5Gk3Z3MOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jqIqv55p; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jqIqv55p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sU4K15TCFAAXN1H/dPyuVPJ+jb1LaJcDEEbLYdeya9A=; b=jqIqv55pGZahr2y2JEpUyYvt8y
	cxWe9t5XzMQJrrLhfuz7hzWrjFPrx9AcB3sw5pG7OXE28dza+rJdNwHiR4Ibz4WZxLvzCajz+HzwN
	//CaNrK3JNZnjgXG46eYc94eNk4y470x4EWbvguAblmlycLuTHgdYU42xEgX8zgzeKveIV9bxn3hI
	GmMy6sGO11rX+X/crvbhgYBNVuiGTFFp7XHUjncALqIg6m2eE5o6sU5PPcv6UQ/xrvp3T1k4SYdVB
	Uodb5RsNgPhQ2d3fEUAhTp1sVfG/+wtAMDTdbzHQ2wSBIuiOATigL67wnGNcjOnpIFJmLmwgGc8dI
	m6xHs+LQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rnhPt-000000000yJ-13fw;
	Fri, 22 Mar 2024 17:06:49 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 4/5] tests: py: Warn if recorded JSON output matches the input
Date: Fri, 22 Mar 2024 17:06:44 +0100
Message-ID: <20240322160645.18331-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240322160645.18331-1-phil@nwl.cc>
References: <20240322160645.18331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Actively support spring-cleaning by nagging callers.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/nft-test.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index a7d27c25f9fe0..1bc8955836d0d 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -809,6 +809,8 @@ def set_delete_elements(set_element, set_name, table, filename=None,
                     reason = "Invalid JSON syntax in expected output: %s" % json_expected
                     print_error(reason)
                     return [-1, warning, error, unit_tests]
+                if json_expected == json_input:
+                    print_warning("Recorded JSON output matches input for: %s" % rule[0])
 
     for table in table_list:
         if rule[1].strip() == "ok":
-- 
2.43.0

