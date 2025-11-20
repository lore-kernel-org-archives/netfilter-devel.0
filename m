Received: from mail-106104.protonmail.ch (mail-106104.protonmail.ch [79.135.106.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9EC35BDB3
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Nov 2025 15:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763651989; cv=none; b=TfOTPFpGQBGDiKUo8DlR6I+OdFGJ9DQe9Kr1DyVaAgLhgm3GPZwgr5uLVDzTsxlcxkuq5bw+25UWQdfBpSjd4cqFT+yNnf/vzQnHAgaYeGFfzIqf0iILV6v0SPHaOXYKkNA9T2NvkyS1++gtvG3KfdTipEVrgQ34X86kWIroT2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763651989; c=relaxed/simple;
	bh=xe9lAh+OlbCS/KDC5DNcjP2+HG60dF6Sml9KUemVRtY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R86c6DKuwPZ/BRZBvK+GYC7OZ2enmeMtAW8bvphZv2VM08WEre8sRfqi4kwfyDEWKaqFi5vMbJLyxcmfKAelV2m92ik1nznZcxCOR0PoXOd9Fh/C0UkDXlg4ZoE3vk1uXLsLvjUFZHm6aINANt/gjiJT8WjVZj3WSxJZ7S8ptWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=B1LWvWgh; arc=none smtp.client-ip=79.135.106.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="B1LWvWgh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1763651985; x=1763911185;
	bh=NvWZZe8t9j8F7By3SijOsvsUmqG4xRBLq5gqTvw4Tec=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=B1LWvWghMDoIz9xg50+KGno6u17U9Bjd3iA3TkuTnXjfwRxDJnVcHJEm/n+BPuBIS
	 gpCgF+KPHOR8YcywTH8QBkhHvF+RFic6wXH+SxbQE0e09kAUAfeyKj+vxLMrI1w1Rh
	 8XDILvu9/Xn4qmRgLsym7c6oKl++Xa7zLVGDuYWfLIHpnFKz18Lr8wyUA7jbXOVeI+
	 pywf+k3owUhOgHKIt2YpZ2zjBdddA4M/kTbL9dN95BmZABIHpK45EE2Dt6517K0qiM
	 xFSXJ4TAy0Hd2RP11g+lAL/J7/hMsi215vMBjCOnNTGm+IHB0k6D8jyaSYZOsjxsVW
	 4H34JTEo56hMQ==
Date: Thu, 20 Nov 2025 15:19:39 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH v5 5/6] doc/netlink: nftables: Add getcompat operation
Message-ID: <20251120151754.1111675-6-one-d-wide@protonmail.com>
In-Reply-To: <20251120151754.1111675-1-one-d-wide@protonmail.com>
References: <20251120151754.1111675-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: 74ea2cb7d5337fedb0a820572f05528a35459e3c
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
index 3cad6f857..79a3b9a20 100644
--- a/Documentation/netlink/specs/nftables.yaml
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -1499,6 +1499,31 @@ sub-messages:
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
2.50.1


