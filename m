Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E61340A57;
	Fri, 10 Apr 2026 11:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775820256; cv=none; b=ukGrJO6s6/ByyRKBnbDb1PQ34Dx4TzYK54LyCp6+uCAwVHYmT/hkuUrWTuLgkAX3Esww958gEhHuGRfplp9tEnfZp9xgUbJoiK5lcrl2MEU00a4r2fgdjJ+i7JpnHd5hRen4KWDNl/SyuA5Z/Wb2G4C6O+KaT5zG64k0XrkVvgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775820256; c=relaxed/simple;
	bh=4XmxidoOF/y3Pc0J5mnUEYyng5coGfSki2nSQjs+Bjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UL91jIf5opxBnrripWTX4xNjsGia05uqrSndnuH1RYJliIWrGbSGnE+CIDj+dnshywWLajFP0+ZHSwVz6wnzdVHZgghRIvOMk9ejgvL2n7xw20GvciYqKck7/3gXQCMjyVZ4G33ea2atnuP8cJRKkNfYixlr420dhZZhF+O1jAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 93B8260490; Fri, 10 Apr 2026 13:24:13 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 04/11] netfilter: x_physdev: reject empty or not-nul terminated device names
Date: Fri, 10 Apr 2026 13:23:45 +0200
Message-ID: <20260410112352.23599-5-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260410112352.23599-1-fw@strlen.de>
References: <20260410112352.23599-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reject names that lack a \0 character and reject the empty string as
well. iptables allows this but it fails to re-parse iptables-save output
that contain such rules.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_physdev.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 343e65f377d4..53997771013f 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -107,6 +107,28 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 		return -EINVAL;
 	}
 
+#define X(memb) strnlen(info->memb, sizeof(info->memb)) >= sizeof(info->memb)
+	if (info->bitmask & XT_PHYSDEV_OP_IN) {
+		if (info->physindev[0] == '\0')
+			return -EINVAL;
+		if (X(physindev))
+			return -ENAMETOOLONG;
+	}
+
+	if (info->bitmask & XT_PHYSDEV_OP_OUT) {
+		if (info->physoutdev[0] == '\0')
+			return -EINVAL;
+
+		if (X(physoutdev))
+			return -ENAMETOOLONG;
+	}
+
+	if (X(in_mask))
+		return -ENAMETOOLONG;
+	if (X(out_mask))
+		return -ENAMETOOLONG;
+#undef X
+
 	if (!brnf_probed) {
 		brnf_probed = true;
 		request_module("br_netfilter");
-- 
2.52.0

