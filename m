Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF5921CC43
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2025 21:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746740853; cv=none; b=B8X81Nid2xFPmjjkahYfkpeFyTx/29N36nGRa7XPoRv3/4gyRXGdoGuCdugkHa7f8Vsu1578cvCBFv4nJ2Ac4isuR3nmH5sj/mrgCVDdYPgtYREmd+OMGxIyOnVNMyajo3zeA+O/G+fwHFXipvHIYSA8XKSGJxee1FLifLJiZuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746740853; c=relaxed/simple;
	bh=bJyE9Y0t251xp6MHrSTZoPq89lBSZdGlgEp/QUEU9tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAuzjzMV6a1bmzho0UgQCjRs7GTT+ue3YeSi4OcWXCkFYBxTRVhiw6eB8epZB/PyzjO8EvcRuoewWOUiwfuxoQ+6T+yPwRvNFnGMMQXWNBUtsFh0BpR1JdeythcOMHIgKXtkduDGELaI21QLvQ9GybnPaoK7MrYlabbsn7BB+f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LyXoluFy; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LyXoluFy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oW2UHsJlNvz452CVEVmaUGyBRFONi2kE8SkiYvXtSm8=; b=LyXoluFyFDYmSeXxsrI4qbKR8w
	zIqlhwY+/Xd2B/70pnd/Ls9UZ+9fbhRO9H/j+dToltnFtufD7tXbX58wqUWL3V+CMYomUHKmNKMGx
	S7cvaP+IAkD9qRuOEuoZRW6wc4zPTXYPLrPd+GzqZWMyWp/LXHl8iO4EkD3AiK8V+vSHuMje9Toqy
	LtZ9G+Le2Hgz9+ocnLGp6a0dI9viB5Fw/T3D7QFmWAaQxe8COm6Xh+QXU3Ah28gxyzeji7sVbtLEV
	poDiocy74Kd8ATh5EZ8vo/JlwIC8PwEGg8tUkQhxe9WJUQDnKPIhWgg3FIQaWMX2UlSBkgnvR9unM
	Q6R2hdOQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uD95W-000000000nG-1uIv;
	Thu, 08 May 2025 23:47:30 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/6] json: Print single synproxy flags as non-array
Date: Thu,  8 May 2025 23:47:20 +0200
Message-ID: <20250508214722.20808-5-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250508214722.20808-1-phil@nwl.cc>
References: <20250507222830.22525-1-phil@nwl.cc>
 <20250508214722.20808-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/json.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/json.c b/src/json.c
index a8b0abeba6396..0034c02f678ff 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1686,10 +1686,14 @@ json_t *synproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	if (stmt->synproxy.flags & NF_SYNPROXY_OPT_SACK_PERM)
 		json_array_append_new(flags, json_string("sack-perm"));
 
-	if (json_array_size(flags) > 0)
+	if (json_array_size(flags) > 1) {
 		json_object_set_new(root, "flags", flags);
-	else
+	} else {
+		if (json_array_size(flags))
+			json_object_set(root, "flags",
+					json_array_get(flags, 0));
 		json_decref(flags);
+	}
 
 	if (!json_object_size(root)) {
 		json_decref(root);
-- 
2.49.0

