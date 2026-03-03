Received: from mail-10699.protonmail.ch (mail-10699.protonmail.ch [79.135.106.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD2130C371
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2026 19:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772567969; cv=none; b=LqRYTHINP2pTSxQSoy/7d/z4kyz1MTqCK40xN+zY3p6NIavDuI1KsJi8G5AkewG5EEtBtsNzPFgTiZLp+E72Mds7rhLkHosUZEAv10q33QW4eQnz5epSYYUf4R99ge/Y/FwqwYmXg5dk1AZ7JPR27VmGThbRshu/uDCx/OvEHDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772567969; c=relaxed/simple;
	bh=Hc0DUDaW4pxUr+vmssBmWGcwNCrwXiW66JlO4gokU4Y=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=agYsZ5L+PVO4K46LmNGmBk5MfF919qBMrKN+S+O8RBgx0A10ZuUE+/h+ZqIde22rIH+yVd0dXQ6B2cNHXjOlAEecbSMCpiOwdjvzcdmYaky8JPMR9F1fZ44vOjTwdCFqGN+zy2FEQKkY2/3kxK8XirA3V4n6x+BqmhRpOMD9q8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=Q+QoTRj4; arc=none smtp.client-ip=79.135.106.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="Q+QoTRj4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1772567964; x=1772827164;
	bh=5HArFHOXUsiqRFgB/yRF4JMk5deic6zBEP/abKX8Ndc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Q+QoTRj4oEACaeT/NSKczBsV+Xg/9GJlx+AD2dlD5MeWh7p+upBMpTa4z1G0o0wie
	 WkVn6R7tbc1JxhIRdkN/M16g5d2UeDqpLsPjRC6QROU1LRb7Jb1WvFkK5AqbsIeivP
	 LkG2gRy/3sKc7bJ9hmvyEW9tS09P8xUOc/HLkfxY1LPvJNEb2823ebMIZt4PCrRaXM
	 c91W6ArNiHjJstkDf713cEtGuHqgSBmXkMjPAPPPNXikstxJTFhcxE44mo7YcyXV5U
	 dKwXTQUOT0N3fX2Bh/ZZmNwYNIPTIe5vqxqEd73yyUXqXvqaTi4/naauLmVRcSWt/0
	 uDxmNS+IhPBHg==
Date: Tue, 03 Mar 2026 19:59:19 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH net-next v8 4/5] doc/netlink: nftables: Add sub-messages
Message-ID: <20260303195638.381642-5-one-d-wide@protonmail.com>
In-Reply-To: <20260303195638.381642-1-one-d-wide@protonmail.com>
References: <20260303195638.381642-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: e58a46e25e75575965f34bab2175ffd5eff5ef71
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

New sub-messsages:
- log
- match
- numgen
- range

Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
---
 Documentation/netlink/specs/nftables.yaml | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netl=
ink/specs/nftables.yaml
index ba62adfb4..086b16b12 100644
--- a/Documentation/netlink/specs/nftables.yaml
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -1480,15 +1480,24 @@ sub-messages:
       -
         value: immediate
         attribute-set: expr-immediate-attrs
+      -
+        value: log
+        attribute-set: log-attrs
       -
         value: lookup
         attribute-set: expr-lookup-attrs
+      -
+        value: match
+        attribute-set: compat-match-attrs
       -
         value: meta
         attribute-set: expr-meta-attrs
       -
         value: nat
         attribute-set: expr-nat-attrs
+      -
+        value: numgen
+        attribute-set: numgen-attrs
       -
         value: objref
         attribute-set: expr-objref-attrs
@@ -1498,6 +1507,9 @@ sub-messages:
       -
         value: quota
         attribute-set: quota-attrs
+      -
+        value: range
+        attribute-set: range-attrs
       -
         value: reject
         attribute-set: expr-reject-attrs
@@ -1507,6 +1519,9 @@ sub-messages:
       -
         value: tproxy
         attribute-set: expr-tproxy-attrs
+        # There're more sub-messages to go:
+        #   grep -A10 nft_expr_type
+        # and look for .name\s*=3D\s*"..."
   -
     name: obj-data
     formats:
--=20
2.51.2


