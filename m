Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC88C3ECBE4
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 15:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772119378; cv=none; b=SBJaklJYhKnPNAdLYfLDr/JoBRqtsHrLNptheWt7Gg0si60IwNxw0Hx5OhPOatc2sUBYhW74tH6PCpOrGfZwJh5ZdT2HBiEZm1ANmGtDQOp7wE+9lxTgB8NCcc25Mk/OpOyHvkC67ukeT4GD8U5EhEXVeweRnoHI4mCorcA72a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772119378; c=relaxed/simple;
	bh=7yvUEX+uhHqjq6TFVbqAXeoqbeRyPMaJx9UdtOVeo/M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=WdXhmKi8SApdy9k9sEZiAdw2FloAmFFFEaQaVh25Zyj7Ds4kEtN/3PLpeBM/wSc4rAOH5jaUO+UJktSzBRa/pQaUTt/N4aQs06PzgYiM6zFAAJPF1Nx/ui6v9Ahirp685mSmX/s0Lb1Cm3unykI7Vl6PcD2zs5yb0lw9wWtPlgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fqctQ4X7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fqctQ4X7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=AK1Gg/Spz4I4496sGJlY4v97XJIU+RzBJRDVJv2jER4=; b=fqctQ4X7rAde7pGc3ObFpOCE7g
	wvAMtpouJ5Pi98FtGT+ww+3vhzFTyYCG5AzYGobFhCzenRHV1NWrWD0+EiUBtopdkGl0EIzTAjmEa
	jHJDXZd4r+SITqvCYJvqmmdBI82y3+8+O6uLT6DjM9JQwZ7poeFtqLB8G7QuWHpPcuo3fx1xFqbht
	8YsNvAWm4Iuj/3ZYsE0men4zvo0JHVqt84tstL3V6YfccueXWad/KQKzCOm87FrIc0T9qJ4es0rjP
	+YlXSCMovI5+iilkuv7owROJIfJrApWKa5C0oILBKfqntwiU5pFQNzccZuLvL68O2l96ogN1oDXVt
	66bjqDeQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vvcyo-000000002Ow-0z3a
	for netfilter-devel@vger.kernel.org;
	Thu, 26 Feb 2026 16:08:42 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] monitor: Call FD_ISSET with valid descriptors only
Date: Thu, 26 Feb 2026 16:08:37 +0100
Message-ID: <20260226150837.21210-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This fixes for 'nft monitor' aborting with:

*** bit out of range 0 - FD_SETSIZE on fd_set ***: terminated

It appears FD_ISSET is not tolerating invalid fd values (-1 in this
case).

Fixes: 868040f892238 ("configure: Implement --enable-profiling option")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/mnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index 3f3ef82a25cb5..2e7ae74434094 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -2410,7 +2410,7 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
 		if (ret < 0)
 			return -1;
 
-		if (FD_ISSET(sigfd, &readfds))
+		if (sigfd != -1 && FD_ISSET(sigfd, &readfds))
 			check_signalfd(sigfd);
 
 		if (FD_ISSET(fd, &readfds)) {
-- 
2.51.0

