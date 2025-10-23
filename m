Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1208D28D8CC
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236081; cv=none; b=glUHm4ISsJzDTXj/vwMxFwoKYQc2s6Amw788FWutOlc+NQe1UEMwMiWriZMbE+uLTtC8paPk7lIR5ECu40lgKzw7WDLLYIDw5Rv6iOM+iFmbo1HY9UMkq+pvlFnI+6zGzFyZ5IQpqDyHkk6WylJD7IQBC6fafwIXXzqiYiDp7JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236081; c=relaxed/simple;
	bh=HCVcnQVjtGqlyKxq2gGB/aEeunUWQ13Z5LacQb3C+5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2NClt/5U5EHCX95moMu6XAc/e/GOY8jPrRYZhONfyxRzwGJ3AgEgOygRcikJtjqMK3actdXe77xmLEHJG7gQaSqGZzCVayd2ydK/NBTksLZuj+niLtzUnCgXnpdLRPRetXHS16rWIEMNBTd8F7cdvLkjtid2l/XvgOeQTKLhgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=o9vSrDw2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="o9vSrDw2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=arsiGaQnB/QH4eGGC9kgXggBmlTiM27chAO8xLb4nZI=; b=o9vSrDw24ZWKemw1Q3a7ERityZ
	uEm5jx0Wz31BeR/f8/eUp6tBWSbvjzLjyi4/E7V3D3UJaiQ/E6F0TEGm+Ykuo4mhse6R35EbtUyuA
	rB+vBb4HEGVSaI7xaIuOKobITpBUpcG1+dJhTsamsOl7XFuEusSo58FdlpinrvPJOA/g6zDs7Z120
	Phdq1TBnoXk+zAP2+Mewp3e4al9svcqCL5q8lL+SYSEIAFqT2/qQarM4yLoT7oABrTURe4S31umG7
	KKSnNUVFV/WgI9pvNZ9fUfcalV37js2kS0vrw0v9lJYYZZCTcN9dlU16ociVELB/WgH4jj+JQ9vQF
	YHiTPhpA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxS-0000000005i-2IMk;
	Thu, 23 Oct 2025 18:14:37 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 06/28] tests: py: Fix for using wrong payload path
Date: Thu, 23 Oct 2025 18:13:55 +0200
Message-ID: <20251023161417.13228-7-phil@nwl.cc>
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

If one family has a per-family payload record, following families used
it by accident for a .got file when they actually should use the generic
name.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/nft-test.py | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 35b29fc90870b..019c828f957a5 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -817,9 +817,10 @@ def set_delete_elements(set_element, set_name, table, filename=None,
     for table in table_list:
         if rule[1].strip() == "ok":
             table_payload_expected = None
+            table_payload_path = payload_path
             try:
                 payload_log = open("%s.payload.%s" % (filename_path, table.family))
-                payload_path = payload_log.name
+                table_payload_path = payload_log.name
                 table_payload_expected = payload_find_expected(payload_log, rule[0])
             except:
                 if not payload_log:
@@ -868,14 +869,14 @@ def set_delete_elements(set_element, set_name, table, filename=None,
                 error += 1
 
                 try:
-                    gotf = open("%s.got" % payload_path)
+                    gotf = open("%s.got" % table_payload_path)
                     gotf_payload_expected = payload_find_expected(gotf, rule[0])
                     gotf.close()
                 except:
                     gotf_payload_expected = None
                 payload_log.seek(0, 0)
                 if not payload_check(gotf_payload_expected, payload_log, cmd):
-                    gotf = open("%s.got" % payload_path, 'a')
+                    gotf = open("%s.got" % table_payload_path, 'a')
                     payload_log.seek(0, 0)
                     gotf.write("# %s\n" % rule[0])
                     while True:
-- 
2.51.0

