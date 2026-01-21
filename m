Received: from mail-06.mail-europe.com (mail-06.mail-europe.com [85.9.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED4F3B8D46
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Jan 2026 18:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769021282; cv=none; b=O6Pvdms5/pLf1YvIc1vhRnYUBge/35fdIzdZFy2k6fbAdKiU23XYpYVvyYhTliHV+GMoEnl91RnlNYkvj/2XZBZaZ3KUF2f0e4DPMNa0D8Lb6KGil4aK6Ixrd5TPm0cY7h8yXFvb0jWok6kyS7aD7anU9ARFGGLnajMVl5Sm/6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769021282; c=relaxed/simple;
	bh=SITNZl8yT+OUCa0hgqc3NpjfhMKBkWHMtii2JgwpXAc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RLFsLIDoeOvlxfe9UpvGBDk7Iu1erYheeg0QOyoxxC/c5ZVi4oBtaWudBBI41ZLNuL9c4WmKWGzd/gKa9alHdE3Q5mfaynMXoosuUx4xhgnf0pHcnzJFkUqOeIdWO6hpTu/ELKU+27uFXZYr4HryoEtC8r0LPctfz6v6tJhOJiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=QVEAcwxH; arc=none smtp.client-ip=85.9.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="QVEAcwxH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1769021271; x=1769280471;
	bh=DT7HJGURoWKpzWp+pjIjO/vYbZgPFGVjZD9nc+fd+Us=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=QVEAcwxHPrajGDUKaYIO1g/s60PHXr92rkDmzMkSrt4snfE7wnnWjJff2asYU4Uda
	 J066O0SIvAx0mbDztDuTG1lRgkrr0KQPDXgDoV4ZreiLkvDHNhs7JnmnOCgQ7jFN7x
	 PwCsdTIv6pSla2UtLr+d1zM+vhdiWNYw6pUYAed459TxWJKT/NGUkJ8t0D8wTb+WwQ
	 C90qzn33iU0x1og6f90la8FgzSTweY2GYNnCJ3MwbMYajSYStfNbbNgkmiS+S6yfkI
	 mvLG7ULMsea7Kn+GOLPmdI1ZT/dtytAzXNhWCV8lFxy0NiKpc8tmyrNohxhPyMq/3N
	 +eEA1fH5MiDtg==
Date: Wed, 21 Jan 2026 18:47:48 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH v6 5/6] doc/netlink: nftables: Add getcompat operation
Message-ID: <20260121184621.198537-6-one-d-wide@protonmail.com>
In-Reply-To: <20260121184621.198537-1-one-d-wide@protonmail.com>
References: <20260121184621.198537-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: 600946a7b2c8bcf420bf7b5d987a4d552f9145ac
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
---
 Documentation/netlink/specs/nftables.yaml | 25 +++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netl=
ink/specs/nftables.yaml
index 4b1f5b107..ce11312b9 100644
--- a/Documentation/netlink/specs/nftables.yaml
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -1509,6 +1509,31 @@ sub-messages:
 operations:
   enum-model: directional
   list:
+    -
+      # Defined as nfnl_compat_subsys in net/netfilter/nft_compat.c
+      name: getcompat
+      attribute-set: compat-attrs
+      fixed-header: nfgenmsg
+      doc: Get / dump nft_compat info
+      do:
+        request:
+          value: 0xb00
+          attributes:
+            - name
+            - rev
+            - type
+        reply:
+          value: 0xb00
+          attributes:
+            - name
+            - rev
+            - type
+      dump:
+        reply:
+          attributes:
+            - name
+            - rev
+            - type
     -
       name: batch-begin
       doc: Start a batch of operations
--=20
2.51.2


