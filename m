Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749672E62D
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 21:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722116217; cv=none; b=ht9RHFxngAYd2IMvL8+3fwAeAjiSQIVJQMMT7FMwEEZW74ef+LwiZnpqtZ4dJf7cvUCIzzy17BPe3eV0tfluzLze5eO+tkJltIEQhcUSBMCe7V+A18adT0tVTtJXUV/v/HKhnifYtWkNEykDVv3oKkN7rOkNJVf6+0vonjwarQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722116217; c=relaxed/simple;
	bh=jWOvhC1jFmmmj7M68maXvzu6SiTjDVg3QraTX/9ZewQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0faNHlHhR5JzICMdF+Ok92l+sfgenEOaHW0PKpXfGQLS85Bn5/NH3olbWUNSQFZDaDAo2PHFBachEQe3z4ee8DegcMexGDSoRJ4MEZdLdwPbPTlMCaoG3/zv4KgeUE9k9yoiGUMz1rlDVdEbJOQBrFbZiS1zv7SbmbGMimYIwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=OZdBgVoQ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="OZdBgVoQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FFUYs14xPf8M8Yb1I/oAvBVrpHQ3rfRLFqXElzOYVHo=; b=OZdBgVoQZj9lWTPa6LV/pq132V
	SL5ssGb3sZZ0ceHAtS0bQ9yYsZFgPn2VUsw3w4nzOhuSsthun2aKrYGEDQqaAYBNDUJFX0Gb7T/Iy
	A3Izykz0f9gO8iaES7QorpC9J+05Vgxu9OIXzYql+8UP9v4X/KQkbPRs2XHh2wikO5jzXguJqiHTy
	+Jce8GsEEjqP4aoRcSEAPaR6DFYyCjFARpC7Pj1Lv0Xhd5SstXMQtrR2o1Dp7ITD7wtIryv8q87Q+
	my6bDa4FVI2NfSc5rsGrjGgDwLu4AhgL+ahVcySDlgs/bc1xG4lD0eZCCHXCyqYyDUM+EeAfGCJ8g
	W3UaPR1A==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXp5x-000000002UO-2BS2
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 23:36:53 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 03/14] extensions: recent: Fix format string for unsigned values
Date: Sat, 27 Jul 2024 23:36:37 +0200
Message-ID: <20240727213648.28761-4-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240727213648.28761-1-phil@nwl.cc>
References: <20240727213648.28761-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both fields 'seconds' and 'hit_count' are unsigned, use '%u'
accordingly. While being at it, also fix coding-style in those lines.

Basically a day-1 bug, have Fixes: point at a reasonably old commit.

Fixes: af1660fe0e88c ("Move libipt_recent to libxt_recent")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_recent.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 055ae35080346..0221d4462408f 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -193,10 +193,12 @@ static void recent_print(const void *ip, const struct xt_entry_match *match,
 		printf(" UPDATE");
 	if (info->check_set & XT_RECENT_REMOVE)
 		printf(" REMOVE");
-	if(info->seconds) printf(" seconds: %d", info->seconds);
+	if (info->seconds)
+		printf(" seconds: %u", info->seconds);
 	if (info->check_set & XT_RECENT_REAP)
 		printf(" reap");
-	if(info->hit_count) printf(" hit_count: %d", info->hit_count);
+	if (info->hit_count)
+		printf(" hit_count: %u", info->hit_count);
 	if (info->check_set & XT_RECENT_TTL)
 		printf(" TTL-Match");
 	printf(" name: %s", info->name);
@@ -233,10 +235,12 @@ static void recent_save(const void *ip, const struct xt_entry_match *match,
 		printf(" --update");
 	if (info->check_set & XT_RECENT_REMOVE)
 		printf(" --remove");
-	if(info->seconds) printf(" --seconds %d", info->seconds);
+	if (info->seconds)
+		printf(" --seconds %u", info->seconds);
 	if (info->check_set & XT_RECENT_REAP)
 		printf(" --reap");
-	if(info->hit_count) printf(" --hitcount %d", info->hit_count);
+	if (info->hit_count)
+		printf(" --hitcount %u", info->hit_count);
 	if (info->check_set & XT_RECENT_TTL)
 		printf(" --rttl");
 	printf(" --name %s",info->name);
-- 
2.43.0

