Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447AB34D4EE
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 11:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773920689; cv=none; b=ORJ8kZ30Mbmyn0GKdr6JvkmyEdPni0VxA08r1ga+CJ3B0eBcRCb4QIfP8oMw1jbISC4Pech/DIvCiLDYcq/faW4y7xhwDa5LZmy7N2TteizpxBk/D0L+13Kx/o9c4JeE02PnUHJHf5He10GF/PL7GudBb/GKQAKf50WmnQ7hbPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773920689; c=relaxed/simple;
	bh=fdv1Xd4XwYHZ2V/mzSGzUTf13a/6dR4i9kCWEU6RMHg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IB0I3FPB+1GzqA2IdNpw1zlpFYYQzUn4gGYaZPpJd9AijO6GrMcnZ0M1uYxOZNMptApCYj4vzslWY/XGy0VcGVO2s020gUS0gTvbzqLLXU/ct5iPeBBsP1eSmwG1TK72tSsRxDJufRQILW+uwDiztK0Kzn943deJkd5EAyPyCxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pPLmQ4xK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pPLmQ4xK"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C5C766027C
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 12:44:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773920685;
	bh=Bwa4cli2EOlCourC/jVGjvaQgDnlkenTrkG+b8BrEQU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=pPLmQ4xKN4xINpqJqzJXcUV87vCsNBse1PMShyI+/mD0GBLVSRW/dTIJ+tTX8wH+I
	 TYxQgxuXmVDa1RA3fqb+k3FT0TnqVn7PQRVbBcZ3OSZ6B1oP3nRSk0IFoKoV84Ku5d
	 P7iXqMpiCkBf281Fbk8Tl51ZffezncoyXqypQEYRlC16u2e29VFaKMHNiDZlO1F4sS
	 PGgO0idDmxEY+456TTqXLFKIT1hD7jg6qcL7D00baBTBJlmU4xq9hNPKqQiX0aRF5f
	 7tYBxUaDkvvfRCciB2CwVAH18KYf7V8JarTbJmKswERtCxs+V5jZW5d0vViAGnRz1T
	 oI58svbr9JFXA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 2/2] tunnel: validate geneve class and type from setter
Date: Thu, 19 Mar 2026 12:44:41 +0100
Message-ID: <20260319114441.205740-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319114441.205740-1-pablo@netfilter.org>
References: <20260319114441.205740-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

Ensure size is correct, otherwise bail out with EINVAL.

Fixes: 239fbdb8979d ("tunnel: add support to geneve options")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/obj/tunnel.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
index 08adeb50b107..4b302f66ecc5 100644
--- a/src/obj/tunnel.c
+++ b/src/obj/tunnel.c
@@ -866,9 +866,17 @@ static int nftnl_tunnel_opt_geneve_set(struct nftnl_tunnel_opt *opt, uint16_t ty
 {
 	switch(type) {
 	case NFTNL_TUNNEL_GENEVE_CLASS:
+		if (data_len != sizeof(uint16_t)) {
+			errno = EINVAL;
+			return -1;
+		}
 		memcpy(&opt->geneve.geneve_class, data, data_len);
 		break;
 	case NFTNL_TUNNEL_GENEVE_TYPE:
+		if (data_len != sizeof(uint8_t)) {
+			errno = EINVAL;
+			return -1;
+		}
 		memcpy(&opt->geneve.type, data, data_len);
 		break;
 	case NFTNL_TUNNEL_GENEVE_DATA:
-- 
2.47.3

