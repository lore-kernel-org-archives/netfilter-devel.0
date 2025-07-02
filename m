Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D4B28468C
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Jul 2025 14:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751467677; cv=none; b=JI1v4m2ROSy9XqdGZtNQa4rOCdoDhBoOHUeWpIrSO6o0D7akv0cxIgMaBtSWmzNsY2TQn1KErqfL8+ByA6zTQxhNIcMpIg3TUNel94KhNycP4op6keniJtbc39tyou8G9M/mqWHr6SH25pkdYmEwAudVZtrQBEfFKE7lc+o8vvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751467677; c=relaxed/simple;
	bh=RudANDxys/FE9DZRw6KxzEU++zmtOKBBbOSqc3liu2M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=cP23XFJQMOTM5rxh+od3fkhb9oY+L7f2JLbXVaqw1MSjHFSAKmuwXdUS8b7nC6HmQ2b6Ls07dHRjrsDkv5VaetUhLTN78JvtOAspdXC+17fUGKMUarIW2BMs/gZMB6H64btvUZeNdxbXwqvOjhN12vTGb0fzU9j7QgBgWSDixFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hrJUbOwj; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hrJUbOwj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Q5TsnGGOldzKWvgvDAtyiRi7tMaU/WIzC3kQ0pY23OU=; b=hrJUbOwjLf1HTOkEqRXpLoQcfo
	lfgzqPOjPF6fUiRTLUEErSZv18LEy2lK5f5b7EDuG7gAwggw0ipRGxzV/o96AxK8x2ahv6ewKJHpi
	2umvxwGrQ3YaXGrobVHcyr+O0GCplSPp7YnYWREO+zih0LrfzEEu7ii6oIHXrPkdEbUIlWamTP5Gx
	lDa7zk2no4LroM+dHwdSPjmyWft32TP0sIsWTH98/OgFZxrcUrKgsgNNnLhx1mYcgrxD4F1KcOgWD
	BIYAscq6b3VW+RvqUiS5fUDhyzAPSxiHAsugr5J+PN7pGrpBwair1hwSKDOj8jr0TJKLPY0as5muj
	hpSk0Q0w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uWykU-000000007O1-2w8N
	for netfilter-devel@vger.kernel.org;
	Wed, 02 Jul 2025 16:47:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: sctp: Translate bare '-m sctp' match
Date: Wed,  2 Jul 2025 16:47:41 +0200
Message-ID: <20250702144741.2689-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just like with TCP and UDP protocol matches, emit a simple 'meta
l4proto' match if no specific header detail is to be matched.

Note that plain '-m sctp' should be a NOP in kernel, but '-p sctp -m
sctp' is not and the translation is deferred to the extension in that
case. Keep things stu^Wsimple and translate unconditionally.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_sctp.c      | 6 ++++--
 extensions/libxt_sctp.txlate | 6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index e8312f0c8abe9..6b0024023cd26 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -535,8 +535,10 @@ static int sctp_xlate(struct xt_xlate *xl,
 	const struct xt_sctp_info *einfo =
 		(const struct xt_sctp_info *)params->match->data;
 
-	if (!einfo->flags)
-		return 0;
+	if (!einfo->flags) {
+		xt_xlate_add(xl, "meta l4proto sctp");
+		return 1;
+	}
 
 	if (einfo->flags & XT_SCTP_SRC_PORTS) {
 		if (einfo->spts[0] != einfo->spts[1])
diff --git a/extensions/libxt_sctp.txlate b/extensions/libxt_sctp.txlate
index 0aa7371d08a13..67eb327915097 100644
--- a/extensions/libxt_sctp.txlate
+++ b/extensions/libxt_sctp.txlate
@@ -1,3 +1,9 @@
+iptables-translate -A INPUT -m sctp -j DROP
+nft 'add rule ip filter INPUT meta l4proto sctp counter drop'
+
+iptables-translate -A INPUT -p sctp -m sctp -j DROP
+nft 'add rule ip filter INPUT meta l4proto sctp counter drop'
+
 iptables-translate -A INPUT -p sctp --dport 80 -j DROP
 nft 'add rule ip filter INPUT sctp dport 80 counter drop'
 
-- 
2.49.0

