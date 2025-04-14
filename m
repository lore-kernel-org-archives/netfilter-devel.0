Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E111827A118
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Apr 2025 14:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.252.153.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744641391; cv=none; b=svV9umOYS2dC7ma1K/5XmqM8S7hkgk5JunVusflDUkwpDhavvGDfSbsOSHHGYx3kQMK63kOS0gun5HGtW/uaTuMQcP6HYcjczWPHjlW1ihqb1pW1ieERGXAFfxxuRoyyxssQ4avPsFjMP97j1CI55nHiSUmOHxj1r8dLwteL93o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744641391; c=relaxed/simple;
	bh=/opPyPMHngvNulSRoZHmLft7j/S1h4xnT2uctUNJQNc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e1ItzKEWUuGbq7CbeiySb7s+fdFeU8OagMaeyVa3kKX/cc4Q8d69uR+qyEeO3mOu2/MccrRAB5yoqirApBw6nd7jLbQuSpNf5ogKEIQBB9BQar1of1zDuPVOUndCqQ+omiVWAVK+mCaLL1uPliazCDwMce+zsEM5Vu6DZXM37b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net; spf=pass smtp.mailfrom=riseup.net; dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b=NF8nnOXn; arc=none smtp.client-ip=198.252.153.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riseup.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="NF8nnOXn"
Received: from fews01-sea.riseup.net (fews01-sea-pn.riseup.net [10.0.1.109])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1.riseup.net (Postfix) with ESMTPS id 4Zbqbx0cjTzDqRT;
	Mon, 14 Apr 2025 14:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
	t=1744641389; bh=/opPyPMHngvNulSRoZHmLft7j/S1h4xnT2uctUNJQNc=;
	h=From:To:Cc:Subject:Date:From;
	b=NF8nnOXnJ5/CQ3lZVv9kkM4JHMM4QEiisBlIkPBYJiD+bux+4xvKw5gAWZyPtPot3
	 pTu3yHdx18wzEp/ZqG1gguLw4y3bt6hCjD902tSzOqGe/27qfeCXl5g0nMpQV8uNhZ
	 oi/A3c25xGav1qKi98adkqnOIPBHQe4HyZy0K2Fo=
X-Riseup-User-ID: C1BBF53A157BC924B2D94FF33E60FAB4771DDC85E3F9DB735DF1F76B2921CDCA
Received: from [127.0.0.1] (localhost [127.0.0.1])
	 by fews01-sea.riseup.net (Postfix) with ESMTPSA id 4Zbqbv45ktzJtm8;
	Mon, 14 Apr 2025 14:36:27 +0000 (UTC)
From: Fernando Fernandez Mancera <ffmancera@riseup.net>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH libnftnl] tunnel: add missing inner nested netlink attribute for vxlan options
Date: Mon, 14 Apr 2025 16:36:04 +0200
Message-ID: <20250414143604.4144-1-ffmancera@riseup.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The VXLAN options must be nested inside the NFTA_TUNNEL_KEY_OPTS_VXLAN
netlink attribute.

Fixes: ea63a05272f5 ("obj: add tunnel support")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 src/obj/tunnel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
index 980bffd..8941e39 100644
--- a/src/obj/tunnel.c
+++ b/src/obj/tunnel.c
@@ -175,7 +175,7 @@ static void
 nftnl_obj_tunnel_build(struct nlmsghdr *nlh, const struct nftnl_obj *e)
 {
 	struct nftnl_obj_tunnel *tun = nftnl_obj_data(e);
-	struct nlattr *nest;
+	struct nlattr *nest, *nest_inner;
 
 	if (e->flags & (1 << NFTNL_OBJ_TUNNEL_ID))
 		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_ID, htonl(tun->id));
@@ -214,16 +214,16 @@ nftnl_obj_tunnel_build(struct nlmsghdr *nlh, const struct nftnl_obj *e)
 		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_FLAGS, htonl(tun->tun_flags));
 	if (e->flags & (1 << NFTNL_OBJ_TUNNEL_VXLAN_GBP)) {
 		nest = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS);
+		nest_inner = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS_VXLAN);
 		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_VXLAN_GBP,
 				 htonl(tun->u.tun_vxlan.gbp));
+		mnl_attr_nest_end(nlh, nest_inner);
 		mnl_attr_nest_end(nlh, nest);
 	}
 	if (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_VERSION) &&
 	    (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX) ||
 	     (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID) &&
 	      e->flags & (1u << NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR)))) {
-		struct nlattr *nest_inner;
-
 		nest = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS);
 		nest_inner = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS_ERSPAN);
 		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_ERSPAN_VERSION,
-- 
2.49.0

