Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E718A330B11
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Mar 2026 17:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772733256; cv=none; b=ky1GixBe4DOGVOAAIxeP7nyz+u0ApMMjhD+HWsdWGbam6WWGsUcANyzQYhwShWw21v521Hhi85CMT0VP6D9GbdTjAodNbVfb+GlDOFXnv3o3m9IuYCYAZMc5JAHD5jVBZHlV6rCYMd3MO6D70NESRfxrSEwG/OxfAkoXosPfkxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772733256; c=relaxed/simple;
	bh=9maTzi4kO86aJ+HqCnFteqNJfSKEzzUnj1+L5Wez5og=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=kq9KlN4BsUJ4YPBYfiuZiChmtwIjJuBJoNDmx5rHKCKvmDR3m2jIjj7IXrxTLVwXwGWnYHi7Yd38qAbG9GVnxJ0gLvATs3hivs3Q0E8ej2ZmsVvW8LSIAQM7jEDRGo60xDfCEpLQxHCA5Qnjzd0m23shP1xoPd4LHyrMPLORp/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=WRzFc8fj; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="WRzFc8fj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3pSrIKqLfOc/3zSklBDMVzqwcN8DX7djR/CZCxwI8bg=; b=WRzFc8fj/oY69AreFVKxCRGpCK
	oIB3fLE7M0lYqO5Gsy+Eyyx4IZ7lBYzYGj2dhSMK6YAGNC0ZTZfst9PvofpwwZQG4iqPqEqR+E6vM
	y77K/Cuu/WvHpk6thm86AFaFn6s1xPc+27ZUAp2ZlXszE0qWvxeBHir0M8v+iW0e4GluYhO8mF1Gt
	8iDQ0BiBv+uNe8tru+TOX1lfOY7Ob/nyG0YnuDxufUuR7OTSis+2J4zq4MCPyo12ofidVPm+BVquT
	kWOPz5yiSHYGLefv2tAXASxAsCPgrVtBcXaKLfprZU2q+VL2oN6lLUr6MUn9I1r+BU9KJIkl1V+fg
	V/VMtiLQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vyCtp-0000000ACGk-1IlV
	for netfilter-devel@vger.kernel.org;
	Thu, 05 Mar 2026 17:54:13 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft] tests: py: use `os.unshare` Python function
Date: Thu,  5 Mar 2026 17:53:58 +0000
Message-ID: <20260305175358.806280-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

Since Python 3.12 the standard library has included an `os.unshare` function.
Use it if it is available.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/nft-test.py | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 53fd3f7ae6fe..64837da36035 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -1466,7 +1466,14 @@ def run_test_file(filename, force_all_family_option, specific_file):
     return [tests, passed, total_warning, total_error, total_unit_run]
 
 def spawn_netns():
-    # prefer unshare module
+    # prefer stdlib unshare function ...
+    try:
+        os.unshare(os.CLONE_NEWNET)
+        return True
+    except Exception as e:
+        pass
+
+    # ... or unshare module
     try:
         import unshare
         unshare.unshare(unshare.CLONE_NEWNET)
-- 
2.51.0

