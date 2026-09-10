Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3C72F3C07;
	Thu, 10 Sep 2026 00:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789000743; cv=none; b=pq5NWy51dPJ+XVRj7Yw726PgzOuZ0TNdRoigeRTANwhEuWSeXyca1T/WO1Std8OjHAMVegxNmgugRVN4vi1qljyGg1TDOPZEIDfOdO+wKYhORZepD3YjztM69JXcZTXJ3QOYXdviV65tCawdtp88tCoYGUXs777BX4N7plNadrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789000743; c=relaxed/simple;
	bh=HtZ/FaiWy3G92BIVc4aBnXKTuSdgn2yluHqB8/qNAEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkJk60a7+FOB9xIWd8Iao8/Y2pjSUJXMomT77MVjKn2mTDkLX2+zVu0V2TFfiLXxjm5ZnRieev1bWrVrksJ79dBiIJE/RqSTwvVgWF4qng6JBm/yCs0ETCf0Llr7tQwezRsObdukDIIReEo0Hf3qPHTggFBKMaV4Ljz49NEJCHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NEJgQExZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NEJgQExZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CE31F00893;
	Thu, 10 Sep 2026 00:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789000742;
	bh=WV5VcM+tSlqjapfOmSj938u9AtiyS4h6/2mxeEkuHns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NEJgQExZ1X4UKxIF7MFP0Wl8/JHg25X2ESzBPZi58XN+GDTuoLkwM68ZDGj5gbwwC
	 IOt+hhI+x71G6Mgva1yzojBbD9QzZoJR/WpZ8sSangQcuWuC2XDz6K8+V4LiQFxK21
	 B6L0aF7608JzmMDlGvKiaLxc2Ay1UireBiYtDIH5aH3K2D9d06GSLOoD7yA03ICWnx
	 5y1MBmzo2tm0/yoSLroS/XoVjFJah05w3RwA1YutkOBDgzy+LlBfDL+3Xw9lZbN65h
	 AV9OlAjkveH+V0ZWOHK/ZNILDkDo7Hw4IYuR4ni3YoZjoLkXmJaqevnftN79J1tmaY
	 DnmGbtW1eJeWg==
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
Subject: [PATCH net-next 7/7] netlink: specs: conntrack: tweak definition of obsolete attrs
Date: Wed,  9 Sep 2026 17:38:51 -0700
Message-ID: <20260910003852.2184031-8-kuba@kernel.org>
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

CTA_SECMARK, CTA_COUNTERS32_{PACKETS,BYTES} are all obsolete
be32 attrs. Since they are obsolete we don't bother with
the byte-order annotation, but let's be consistent about
marking them as u32 with doc: obsolete.

The attrs were obsoleted by:
commit 584015727a3b ("netfilter: accounting rework: ct_extend + 64bit counters (v4)")
commit 1cc63249adfa ("conntrack: export lsm context rather than internal secid via netlink")

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/conntrack.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/conntrack.yaml b/Documentation/netlink/specs/conntrack.yaml
index 9ba93370275d..1d163130241a 100644
--- a/Documentation/netlink/specs/conntrack.yaml
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -116,9 +116,11 @@ doc: >-
       -
         name: packets-old
         type: u32
+        doc: obsolete
       -
         name: bytes-old
         type: u32
+        doc: obsolete
       -
         name: pad
         type: pad
@@ -465,7 +467,7 @@ doc: >-
         nested-attributes: seqadj-attrs
       -
         name: secmark
-        type: binary
+        type: u32
         doc: obsolete
       -
         name: zone
-- 
2.55.0

