Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A516B30ACF6;
	Thu, 10 Sep 2026 00:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789000741; cv=none; b=GarfQLTmHr11wrhUwh7LyWR5hMFEL89H37My4Hxgynb4+IOl5dP6j9rM/cKhD219hhq6+PoKFpiPULiln4uqdqkmfNM6Hm5QMhQrp0IjU1jsxBC9pewdMnQ1t/Jb92oOeqCoxij1hDiZsPI3gpgCNazjw8RxTtzVaxh6V8/5JPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789000741; c=relaxed/simple;
	bh=d4qDxjtvATtvBrTEYertM0Ug46VFizER18J5I+Ym7dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDqfO5sq9y+GrjTXKHTJnTrAs7u/Wz1kU8HK/Eg3LnebZhvOJyJPVb1pE1LGdoALr+A3tn/5x3SL4xu27iAE1dwISWLZeKeaLe15VplJKJ9BBVVEJj7gfc1ekSfLtIxT2PbG5Zi4aCkNmJHbc/HEUuydURP0hcvrFxOHoIP/krU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LknNEf/E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LknNEf/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F791F000FF;
	Thu, 10 Sep 2026 00:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789000740;
	bh=R0rAaEYzAcKziiVTE+nOkSPgjyMT8TchvoOkdjPBLys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LknNEf/ETDdX8reSk0o65pTzTysj3L2mwuRhsubquxvhNW2VNWezAcSq+AY6O1xXg
	 x585E2ucOQXsqpWnTRBpiiLvkgDdKK2VZ1nLDCxhc8513bd5UZuZL3X5S+IFKWQVuT
	 nUKye49XFMMS6f29qa5cGF+XHxf6NxBr6gU5qTu+CxPkK+75FS49OOErgF0a+O1W7P
	 n+9cOqLFNsNQjFsbd7wBL+PPouOJC4Sm9raNpO34f4C21aAJnbmVajvx3qJPAg7ORi
	 x81AOf0WtAM360vQoD6Rw8zhdBT2SjHpMOu7CLFxPsLmptibhoi9gZbDaD+PfaVi7N
	 G4KV9wEYwOFcA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	donald.hunter@gmail.com,
	ast@fiberby.net,
	i.maximets@ovn.org,
	one-d-wide@protonmail.com,
	fw@strlen.de,
	pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/7] netlink: specs: conntrack: fix the nat-attrs attribute IDs
Date: Wed,  9 Sep 2026 17:38:48 -0700
Message-ID: <20260910003852.2184031-5-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910003852.2184031-1-kuba@kernel.org>
References: <20260910003852.2184031-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The enum for attr IDs says:

     CTA_NAT_V4_MINIP,
  #define CTA_NAT_MINIP CTA_NAT_V4_MINIP
     CTA_NAT_V4_MAXIP,
  #define CTA_NAT_MAXIP CTA_NAT_V4_MAXIP
     CTA_NAT_PROTO,
     CTA_NAT_V6_MINIP,
     CTA_NAT_V6_MAXIP,

Move nat-proto to the right place in the YAML spec to make sure
the attr IDs match.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/conntrack.yaml | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/netlink/specs/conntrack.yaml b/Documentation/netlink/specs/conntrack.yaml
index 105b53d4b76a..0d1528507c4b 100644
--- a/Documentation/netlink/specs/conntrack.yaml
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -314,16 +314,16 @@ doc: >-
         name: nat-v4-maxip
         type: u32
         byte-order: big-endian
+      -
+        name: nat-proto
+        type: nest
+        nested-attributes: nat-proto-attrs
       -
         name: nat-v6-minip
         type: binary
       -
         name: nat-v6-maxip
         type: binary
-      -
-        name: nat-proto
-        type: nest
-        nested-attributes: nat-proto-attrs
   -
     name: seqadj-attrs
     attributes:
-- 
2.55.0

