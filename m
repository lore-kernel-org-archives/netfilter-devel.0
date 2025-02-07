Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3474471747
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2025 20:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738961285; cv=none; b=PRAQyCHo/1HmmVkJ7KkchKO47QpdKvwfhDUFBVhmVswLfftnZJqxHxB13B05GGz1qwmrG+fJ43J6cDKcThyuRoid6eO8l1XrBnNo7UXdjSdSR/2r9Du1fAEH9p8aYergnCqKkh7exuZb03fKTLbzWJCOMOMInLVL7IGH78rJELk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738961285; c=relaxed/simple;
	bh=0Opk8bppPhJ/YWfbt75DrIITGn/cFlxG8zz4T6sTKR0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7RA3O+BXYwHEdyuwNp/gih7rVsuINaIVwMXoTQOp0x2hxtT4SCOEgazWh4EMSE6weNWQfORl+tc4zmgVkNTRO3nrQX01eYrAzbWDDZQ9fWLWzGlbFHFbQsqDahumxXfCnAqosv69xsGLOJzRsu3cZxqYPRWgCHF+rS6G359H14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=DS7JPY35; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="DS7JPY35"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ie3ZJy1RinnkSxA5xOgeHIkyTIOHb8kgroSxmUCR5ZA=; b=DS7JPY35vkDOuPOkxT3KSwfdWy
	WbgDEXIdf5rttJXlYR/xucIt1LKF2T3/M3lnOhP6DNhQMfAmPLQidN6tQJFxzKIfpenJrCYNLR6lw
	esQSTSVwDnoxllf6fCQ1BKLKsuqcW9GcvzoBGUb5LNnYwnUp0+mt+U8navPHuKi8/b11Vv74SpCQE
	GcNn+9nzghG1HqzW3XYoNQAsBUE4VNKhyrMrzijob6y1NDHB4hvALZn0DhGNL7OydNtr9iHTVVN7h
	xUVUaSe/DVhCTg7pQTE3lef1v0/kakFDuoBnBf3NBlZQYO0ZbpMpz6Ds7BgyhSDOxzJEz9UAbkmxY
	wHMJRP7g==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1tgUeB-00BgIB-0f
	for netfilter-devel@vger.kernel.org;
	Fri, 07 Feb 2025 20:08:19 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ipset 2/2] bash-completion: restore fix for syntax error
Date: Fri,  7 Feb 2025 20:08:13 +0000
Message-ID: <20250207200813.9657-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250207200813.9657-1-jeremy@azazel.net>
References: <20250207200813.9657-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

There is a syntax error in a redirection:

  $ bash -x utils/ipset_bash_completion/ipset
  + shopt -s extglob
  utils/ipset_bash_completion/ipset: line 365: syntax error near unexpected token `('
  utils/ipset_bash_completion/ipset: line 365: `done < <(PATH=${PATH}:/sbin ( command ip -o link show ) 2>/dev/null)'

Move the environment variable assignment into the sub-shell.

This fix was previously applied in commit 417ee1054fb2 ("bash-completion:
fix syntax error"), but then reverted, presumably by mistake, in commit
0378d91222c1 ("Bash completion utility updated").

Fixes: 0378d91222c1 ("Bash completion utility updated")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 utils/ipset_bash_completion/ipset | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/ipset_bash_completion/ipset b/utils/ipset_bash_completion/ipset
index d258be234806..fc95d4043865 100644
--- a/utils/ipset_bash_completion/ipset
+++ b/utils/ipset_bash_completion/ipset
@@ -362,7 +362,7 @@ _ipset_get_ifnames() {
 while read -r; do
     REPLY="${REPLY#*: }"
     printf "%s\n" ${REPLY%%:*}
-done < <(PATH=${PATH}:/sbin ( command ip -o link show ) 2>/dev/null)
+done < <(( PATH=${PATH}:/sbin command ip -o link show ) 2>/dev/null)
 }
 
 _ipset_get_iplist() {
-- 
2.47.2

