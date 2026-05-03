Received: from out-03.smtp.spacemail.com (out-03.smtp.spacemail.com [63.250.43.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918DD3AE18F;
	Sun,  3 May 2026 08:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.250.43.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777797168; cv=none; b=UptsNGNmaKiOqQ24bymYAM0F/UNZw9ahHXIIqFVi47VN2/C57Khz6raqAYrBGkksYBA5kvIz99HfylFhQA1pChxVmPwQIaWoKiooEvNHdZJSJpXA+ve8XN2/UlYjnRkgJ9STDkOx5VUFJDBQZeace8GCgOmwW961QvdrlX3CnC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777797168; c=relaxed/simple;
	bh=BAXgMmZoWgTPFjt7XDGP1bmdkbgyrtKmxKELB1n6rZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKeR1Kd5T+EkFRmXPg2nKV6X8J2hbx5oVX5v0z/vU1gd0FMocufGREGXvkaJ8eg66tbrEJKeOda4P8pk1wuWvFjfx7LtHQgTFnnhG4rd4y3I5KcOtGsuJIAzGewjlQEJANCMkg0TR55N17b0zlF6ZlQtDvyI9RY+5j0ZcYSP3X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=LsyyN2Ji reason="key not found in DNS"; arc=none smtp.client-ip=63.250.43.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="LsyyN2Ji"
Received: from Kyren (unknown [49.207.224.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4g7dLs0Wjbz8sc7;
	Sun, 03 May 2026 08:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1777797160;
	bh=yWHWMBOnJe+2nuPfat7/83G7fQtGgpLEP8FXNjZryYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LsyyN2Ji9WB5HCs9Mv8TnVujP4mDFw54Zk1v3Lb0DYR0qdl7C/oNIgGEV+qvm3bUr
	 qaDIMz5CRTWETHFlcBMQnusvc+wk47AQQNgLQ9Do+UsFdBqQKlPxL9qM2OOEiSbwnY
	 CyB3dWQZZCg5/63rJA4mY2BzSUjuSWAXSYwLST9C6+3QX5saHs48h8zwESZmpEdyoJ
	 TxtWHoC0n9kwdkEXp+znvMupmJYw12pZgVuLbonSpkW/OaplCjq6knferG1goAdAMz
	 g22pt8wB0z8JzIcXWFiVCj6OtUFpgJaf9kLvMKXapPGUJghajZ2RJ7TP/Agtmtzd+n
	 u68b7HZ/bwGRg==
From: HACKE-RC <rc@rexion.ai>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	HACKE-RC <rc@rexion.ai>
Subject: [PATCH net-next v3 2/4] netfilter: nf_conntrack_irc: use nf_ct_helper_parse_port()
Date: Sun,  3 May 2026 14:02:18 +0530
Message-ID: <20260503083220.630655-3-rc@rexion.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260503083220.630655-1-rc@rexion.ai>
References: <afSBzDE-caw3Dsr1@orbyte.nwl.cc>
 <20260503083220.630655-1-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

Replace simple_strtoul() with the new nf_ct_helper_parse_port() helper.
This removes the dependency on NUL-terminated strings and adds an
explicit port range check, rejecting port 0 and values above 65535.

Fixes: 869f37d8e48f ("netfilter: nf_conntrack_irc - Fix uninitialised variable warning")
Signed-off-by: HACKE-RC <rc@rexion.ai>
---
 net/netfilter/nf_conntrack_irc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 522183b9a..1b51f5a6a 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -93,7 +93,9 @@ static int parse_dcc(char *data, const char *data_end, __be32 *ip,
 		data++;
 	}
 
-	*port = simple_strtoul(data, &data, 10);
+	if (nf_ct_helper_parse_port(data, data_end - data, port, &data))
+		return -1;
+
 	*ad_end_p = data;
 
 	return 0;
-- 
2.54.0

