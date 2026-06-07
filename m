Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63AD4071FE;
	Sun,  7 Jun 2026 09:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780825830; cv=none; b=RClT6nqjHPqGi68CNAmL3mM9y33w45GD4lxja3e/9nltnXXesy6HSNqIhZqeE2/lFYiDTu3pcL6nnORUxC957V0EOd5jnCj5QU+q4l6YX+Cu+M1vJ0Ch7JqjphYp5fHGZJHZ7/o5sspZiObvtwnvQ/sxzAiuVjkiwPLYHdBUWOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780825830; c=relaxed/simple;
	bh=x4FciXz4Pgj1xXWuG/FRvoFuHeIa3bXOlDEc1mx5PDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXgPtgEL1lIvjml8yhFG9T8We/Cd2H97kbztjDaJ4yBr+LxYD/0RDxWZL9NlgF24kMOf7z5AyIL/wJDG/3fQMIGYSTEwT/jkS/B5LAQanYZi29i9gSZUMV+V9WOx6xrL0biHG7YgEUYBASP8GZtW+yqfd40XmBDzLF0wTuKj/6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XeUj7r60; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XeUj7r60"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B651D601AF;
	Sun,  7 Jun 2026 11:50:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780825827;
	bh=8bsgA67qW2EyeKMVDKI4MI1DUw6mc8ko9lrHR+cbK/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XeUj7r60TOPet7yNplbPf14XFzbg1Hk/9F+tY0fwECjKUVBYGJqLbNkUekuO2YFHe
	 RNj5ovovCIcnS2a1dos9pu+FPlrzwjCsBM4o3C8vqWEfiX3h/fMZ7xVJU2vxl4h2Fw
	 wBytkLNT3UJZjG8Xw56tVABd6yw3QgC4AH96PzGp/GnPecM09epZXvzzrPB4j03uz3
	 iz8wabYenFGnBJav0ZQtxkUzAzGT3bQSPYY3sWv0r+4+CP6hLDbJ7Vy1rgR3k9/LeH
	 XhL2juUatExKFLIf8CHwGF869CTchnJIebOmd2HkGL1ZROfq+BhLYoQM+tPh0kT4NK
	 3oATEPiQfI9QQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 15/15] netfilter: nf_conntrack: use get_unaligned_be32() in tcp_sack()
Date: Sun,  7 Jun 2026 11:49:54 +0200
Message-ID: <20260607094954.48892-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260607094954.48892-1-pablo@netfilter.org>
References: <20260607094954.48892-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rosen Penev <rosenp@gmail.com>

The timestamp-only fast path dereferences the option stream as
*(__be32 *)ptr, which assumes 4-byte alignment that the TCP option
stream does not guarantee. Use get_unaligned_be32() instead, which
reads the value safely and already returns host byte order, so the
htonl() on the comparison constant can be dropped.

This matches the existing get_unaligned_be32() use later in the same
function.

Assisted-by: Claude:Opus-4.7
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 027d69edba44..ceeed3d7fe52 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -405,11 +405,11 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 		return;
 
 	/* Fast path for timestamp-only option */
-	if (length == TCPOLEN_TSTAMP_ALIGNED
-	    && *(__be32 *)ptr == htonl((TCPOPT_NOP << 24)
-				       | (TCPOPT_NOP << 16)
-				       | (TCPOPT_TIMESTAMP << 8)
-				       | TCPOLEN_TIMESTAMP))
+	if (length == TCPOLEN_TSTAMP_ALIGNED &&
+	    get_unaligned_be32(ptr) == ((TCPOPT_NOP << 24) |
+					(TCPOPT_NOP << 16) |
+					(TCPOPT_TIMESTAMP << 8) |
+					TCPOLEN_TIMESTAMP))
 		return;
 
 	while (length > 0) {
-- 
2.47.3

