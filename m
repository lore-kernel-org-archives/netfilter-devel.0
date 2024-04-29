Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A57713F006
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Apr 2024 20:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714421183; cv=none; b=rT6xhWnHfkc0TZh7AjUXxq8UfHL4ksgzOtSGYFq45/jrVla4tFUUJvWneuWxQBdYUBZaXZDhe7VNgePk0CYtvcLioYPLHDgzJ8MHKZYqmO+UatJ0LFW5+DG2rahhrQ5TM18qadkf/RDGr/eqYOdDMDhDtxswRYYrKhEHPjWNsek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714421183; c=relaxed/simple;
	bh=aCi4Na4ck4bx8W5akCYJ9jiW+WTZ+fRdbGwXMxnIcKY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQemzA7TmhE5HVc+imHN3mcK8t9KBpwD3Fe6d1FmDNWwdiWCOOoKHz8ZifYMTaThQ38s5P7FQXQi/05h4NQh/Yx3aoNjklppVPFdDiUL8fFCRQ7TXAeOwZPobjVIqGDJnciXaahgcaRr6vN53obKgufOW5dfHiT2vWjFoGJhh/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=FJy7dnVS; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="FJy7dnVS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3pqArfhh3gJbAyCVjORpTvQXMLgwTCYMXyLLOV6TFpY=; b=FJy7dnVSf3uPXDwrEcvb591y05
	nK5c7frSuGvOJUPQxenKZpC9Wp9KQTVZYqmMyc6RL1VaxNpl5U6vL0CNPj/b0dj1ehzKiOj/eMpuT
	lqmgJeZzRYDaGa12J6yj9YK1pioio2v/YHcl4p4HgZ8do7eFHfDPI84lma82RRXuE2+63Pympgvk4
	lBtkn8+9Ve/ON9k3g8vP1ZGxVczQCBmn38jkFzGc7u+VmA5G9j2SgkLQf10PnS+6d5M8D/RYQGqNx
	Q810ZRC6yEzyQxvGklkB0OtENWgXVZBNPs4WVX0iKEOP1JkWwsI95RvwXhav/2i9h05w9P89TXO0J
	YQ29zWkA==;
Received: from dreamlands.azazel.net ([81.187.231.252] helo=ulthar.dreamlands.azazel.net)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1s1WfP-00G8U5-2W
	for netfilter-devel@vger.kernel.org;
	Mon, 29 Apr 2024 20:27:59 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 1/2] evaluate: handle invalid mapping expressions in stateful object statements gracefully.
Date: Mon, 29 Apr 2024 20:27:52 +0100
Message-ID: <20240429192756.1347369-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240429192756.1347369-1-jeremy@azazel.net>
References: <20240429192756.1347369-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 81.187.231.252
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

Currently, they are reported as assertion failures:

  BUG: invalid mapping expression variable
  nft: src/evaluate.c:4618: stmt_evaluate_objref_map: Assertion `0' failed.
  Aborted

Instead, report them more informatively as errors:

  /space/azazel/tmp/ruleset.1067161.nft:15:29-38: Error: invalid mapping expression variable
      quota name ip saddr map $quota_map
                 ~~~~~~~~     ^^^^^^^^^^

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1682ba58989e..f28ef2aad8f4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4615,8 +4615,9 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 					  "Expression is not a map with objects");
 		break;
 	default:
-		BUG("invalid mapping expression %s\n",
-		    expr_name(map->mappings));
+		return expr_binary_error(ctx->msgs, map->mappings, map->map,
+					 "invalid mapping expression %s",
+					 expr_name(map->mappings));
 	}
 
 	if (!datatype_compatible(map->mappings->set->key->dtype, map->map->dtype))
-- 
2.43.0

