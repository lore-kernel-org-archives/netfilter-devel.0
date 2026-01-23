Received: from amsel.grmr.de (amsel.grmr.de [49.13.209.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1498834
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2026 12:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.13.209.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769171587; cv=none; b=dSD5UcceuVVPqUM/mpWreb4wzsF6EGVLIyHFXNBMki7fIV6F6wv5jv2oTPCOfXXtzzzc2pP/9QZdefOGR1R0TE2kfnvORnuxV623l9aYfywY3yurlFHao4Q5Q+AQDDxsCiznF1FBOBkmFIQNfjbOB8AQI6dNj4/GIQ5PXaxHBno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769171587; c=relaxed/simple;
	bh=eqMblOqWclC70ktH3QaPsdPNPNL9GWtfIB9MxmZOnSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RoGgFGrZXa9XdWPJCtCc4zkOmq82RbZqoqNl9GXXDKYDbcXQ6gVLQNv6mn7kzTr8obO/6roQMI6UUph0sO2SyaF2VkVihYHXmb06Vnxxn9mULG51rYgEOqfq1pvTbwnXKi+lw5xhQJ78/kx27UQEcAH8bRkoZr/ynoYaiB07838=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=grmr.de; spf=pass smtp.mailfrom=grmr.de; dkim=pass (1024-bit key) header.d=grmr.de header.i=@grmr.de header.b=WOiQ+opN; arc=none smtp.client-ip=49.13.209.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=grmr.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grmr.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grmr.de header.i=@grmr.de header.b="WOiQ+opN"
From: Philipp Bartsch <phil@grmr.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grmr.de; s=mail;
	t=1769171583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DXvDolHPQQ9sgU2aKl6UTfqPLPLg/iqH6m+ljeA75yw=;
	b=WOiQ+opN7lkwyva2/sIy2uw1o6rdYNt4O/26bWZvulAtSDbbS6Yo9Uweo4iINKlP3c6Wyd
	7JpakPmddjqw034DR9ecXsgcO7STkVVRiqF0/g24F1TXiWPZxIbU48Icdm2UkuzWETMvKd
	7qho/aNJkNUCV05AQnmGY+OLT2p1Gyw=
To: netfilter-devel@vger.kernel.org
Cc: Philipp Bartsch <phil@grmr.de>,
	Arnout Engelen <arnout@bzzt.net>
Subject: [nftables PATCH] build: support SOURCE_DATE_EPOCH for reproducible build
Date: Fri, 23 Jan 2026 13:30:40 +0100
Message-ID: <20260123123137.2327427-1-phil@amsel.grmr.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Including build timestamps in artifacts makes it harder to reproducibly
build them.

Allow to overwrite build timestamp MAKE_STAMP by setting the
SOURCE_DATE_EPOCH environment variable.

More details on SOURCE_DATE_EPOCH and reproducible builds:
https://reproducible-builds.org/docs/source-date-epoch/

Fixes: 64c07e38f049 ("table: Embed creating nft version into userdata")
Reported-by: Arnout Engelen <arnout@bzzt.net>
Closes: https://github.com/NixOS/nixpkgs/issues/478048
Signed-off-by: Philipp Bartsch <phil@grmr.de>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index dd172e88..3c672c99 100644
--- a/configure.ac
+++ b/configure.ac
@@ -165,7 +165,7 @@ AC_CONFIG_COMMANDS([nftversion.h], [
 ])
 # Current date should be fetched exactly once per build,
 # so have 'make' call date and pass the value to every 'gcc' call
-AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
+AC_SUBST([MAKE_STAMP], ["\$(shell printenv SOURCE_DATE_EPOCH || date +%s)"])
 
 AC_ARG_ENABLE([distcheck],
 	      AS_HELP_STRING([--enable-distcheck], [Build for distcheck]),
-- 
2.52.0

