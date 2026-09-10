Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6821D30FF30;
	Thu, 10 Sep 2026 00:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789000742; cv=none; b=cf6RnxM7yskIH9QaqJM+o9bVCCBaO2vkw5tR42VPGnaKawhNnV34sPIsBzMoWBUkA3qC0pVLWtL/R3a2HJGK20GoRVhQp/8ZkScLs2lTMKCOSBaJMeMWKk7R/ZA0RHZ5+fxf664ME0oejEcHx7peMlCpBrNPqN/2RsAvW4a8inA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789000742; c=relaxed/simple;
	bh=3r0SBKxk74JyZctThil+pvDrzEAa0SCbRbKlfSnroJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSF6bcgxgIzrdbM6w+InVYQNJh0fQlGfhSZ0bCyFiiUY+WWMfycGX6Jm/z8Pr5FFOZS/EKlmcd9sEEnl0FoQfjp/+VnLcZEuGwpoNfI+/c+NxSILNaZ1mMVjdT6VkGe4hyTEwL+nR6L4dy1yZP839PbLH2Zz5RL3Q8H1sRpHj+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WR+qBR8S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WR+qBR8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC001F00899;
	Thu, 10 Sep 2026 00:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789000741;
	bh=A5NbmLopHGo6DYM4Aiw/xk1psYZzmj5Ko/ihVEr9Jps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WR+qBR8Si0BM5Ai919zayXVVXsiR4Koeh6jHrRJWbdXTVAv7TyGyEQo97r8wiqwBp
	 5Rn9Ro4b8t3hGRm6nNNxqnId3KLzRsbBvM5NGFPaYMi9+E8GK22X+iOuCIajgDZJIo
	 l3+SOuRhnGWLdGfA5dsMUtviZgh7nPU6nrA4gm/d5jXABtl8tgIQmACOCXzpddaSbp
	 KRsO1ps0RBdCE+uLpIaeEILaw3TM8aNhGbTgsUhLlmamkLxT/8kSORTq+FTmk1l8Dz
	 SLlg9/C0+GjCbWSgJEjmBsf5GcBXmMAf3EtBK78XZ0Oz8KCcwmkQ/NKmgJhUgvTpTk
	 MfJuhpCXrNaUg==
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
Subject: [PATCH net-next 5/7] netlink: specs: conntrack: describe CTA_HELP_INFO
Date: Wed,  9 Sep 2026 17:38:49 -0700
Message-ID: <20260910003852.2184031-6-kuba@kernel.org>
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

nfnl_cthelper_to_nlattr() seems to output CTA_HELP_INFO but the spec
doesn't have a definition for it, add one.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/conntrack.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/netlink/specs/conntrack.yaml b/Documentation/netlink/specs/conntrack.yaml
index 0d1528507c4b..ec90d3d05841 100644
--- a/Documentation/netlink/specs/conntrack.yaml
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -292,6 +292,12 @@ doc: >-
         name: help-name
         type: string
         doc: helper name
+      -
+        name: help-info
+        type: binary
+        doc: >-
+          Private data of a user space helper, only present for helpers
+          registered via nfnetlink_cthelper with a non-zero data length.
   -
     name: nat-proto-attrs
     attributes:
-- 
2.55.0

