Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44722344D8B
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 11:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773920690; cv=none; b=h0GxVzuzwE7DcxkrPfEok/aDfbiym8B6KLtjDKFVBiVoXVWddfQjMd+5eEhTh0MMy5mMnaWpv1c8sq44hmEgC1O/iX/JyblhqY2C4flOAVcchd+qQCh8o0RuI71KSqULNsTSTkRC4oUogCF6dM69y1GvaE1Ccypcumeia8RkXws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773920690; c=relaxed/simple;
	bh=osZEMEGGkRgrGAggnnaH2fkPruSYTrE24B2+nmUz+po=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=WKr6DB951LlHCOnIHTwNM4H/kubpLiPL07rOa4y/M09BzUYlJ40bAzBBpRvGvtju8XjdVtT2sZTm+v61UZdAUip9NBCNquWxPYqbwJTIgsSkVgnmbKB764+jEL5xOixGBmyD394kq9JQoyLiI0Jx5tf9EapAprorAzKD5MkFjUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Jvbczgvr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Jvbczgvr"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7B53F60272
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 12:44:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773920684;
	bh=sFwU6te0IXYDHmUrBWaudJ9pKNHrRMW/e2bYlZ3+dcQ=;
	h=From:To:Subject:Date:From;
	b=JvbczgvreP4AMW7eZ+lKmo7ojySKPHlZprDZt5FXNKMnTIUGd3DV2rhmhXj4l7bb5
	 Uwc96k/sCet3gJ0DfyAG4W1P2Oi68vLpnoVacLVAu3fxeYWAwZ8n41+/8Qt0Mh8pP+
	 pmdN1lo/L82I9vy74+14mMKBg5K4qD91XrlRDVElHu770GKGgeV791HvkahgR75iZP
	 ZlpdREcevlyZiN6pMdqC7PjTjIXcAuNGxRCKqM8CuH91Jasienia456nyUMlxplKEM
	 vP7E51LT5aAboW/VC3CU830PKvOMc3VXnOn42ypugc8nn+UCk/4sbaqh8EYjzaYW2T
	 V4etdQ7gOKq6A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 1/2] tunnel: check kernel does not provide too large geneve data
Date: Thu, 19 Mar 2026 12:44:40 +0100
Message-ID: <20260319114441.205740-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

Make sure kernel does not provide geneve data larger than
NFTNL_TUNNEL_GENEVE_DATA_MAXLEN, which might overrun the buffer.

Fixes: 239fbdb8979d ("tunnel: add support to geneve options")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/obj/tunnel.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
index ea9cb021741d..08adeb50b107 100644
--- a/src/obj/tunnel.c
+++ b/src/obj/tunnel.c
@@ -596,6 +596,11 @@ nftnl_obj_tunnel_parse_geneve(struct nftnl_tunnel_opts *opts, struct nlattr *att
 	if (tb[NFTA_TUNNEL_KEY_GENEVE_DATA]) {
 		uint32_t len = mnl_attr_get_payload_len(tb[NFTA_TUNNEL_KEY_GENEVE_DATA]);
 
+		if (len > NFTNL_TUNNEL_GENEVE_DATA_MAXLEN) {
+			free(opt);
+			return -1;
+		}
+
 		memcpy(opt->geneve.data,
 		       mnl_attr_get_payload(tb[NFTA_TUNNEL_KEY_GENEVE_DATA]),
 		       len);
-- 
2.47.3

