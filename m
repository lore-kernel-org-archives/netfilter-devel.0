Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB3C3C2F
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 22:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769553044; cv=none; b=A3El7EWMf35wxsvyd19FujpnIHlYtVvdXrz3phlQOqPCP8IpS0Fn+5hBYkqqfrFF0OffSLlWzPWPIZ3MoTEmO+YbnVnxHZ1JSOPRpbFGuyJD3FRdWIcemT9ff7rXf0VAbdIatd4HRONwzkhNyHv1MYTgGBZemkDFd4JiUPwxmKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769553044; c=relaxed/simple;
	bh=kRAcmVlchk80j7NHWzUwYxY6zCBvDd0zjKw8cb3w7ng=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Uy/OThx3VyRc+MQn5XKHo5TXtx2CWz5abv6yyXcd0Qx8eQ4I5tU0uSdw7Ols1VE5EcmH2uCpB7hjlvLHM8V8RbGqhtNyZUP4Ruk34oO8KF4r2JMJS1oVpvulEoiVAfFbesxc0ryqa8jWUYK0xj4SbFyc4vMj9ByNRoT4pwnbc4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WkhWMPhr; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WkhWMPhr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yubL7Yu9ruS4IwT4ERC1Arqw6kniY/XKJjDBbJc+do8=; b=WkhWMPhrmwoeEqIZH+9nkQOZ/H
	2mI3PcwRIoPw79Tl6bLjRYah+Hev7F4LO1TmD835Xcjuff+XwH2ES1G/aT6tmYfjiBto65NGvQdPz
	l32xXcHyt5uE7nkJivYkhOPfOfw6d6eR69GzMM/t5sEfzJwiM8m3/blm6FZj1FxR2xtX05LHSvWgR
	vtiH6bExy+owfDwFKnua30dfU0Vpcl2capP272N1Hsw9gLg515zNFC0DB6kW3uwljxdhg7uADWVce
	PTR/TdkX+p2C6tg6GQqPzwfxXXoWzBurK4SoqN+Yj8atj7D6P8wmYxTMXB1bqDUlsnq3ba0Hfm1oX
	lHJiGHRg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vkra6-000000002pJ-05vv
	for netfilter-devel@vger.kernel.org;
	Tue, 27 Jan 2026 23:30:42 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] Makefile.am: Drop pointless per-project AM_CPPFLAGS
Date: Tue, 27 Jan 2026 23:30:36 +0100
Message-ID: <20260127223036.32299-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are redundant, the common AM_CPPFLAGS variable has it already.

Fixes: c96e0a17f3699 ("build: no recursive make for "examples/Makefile.am"")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 24ffa07cf0c4a..324562964469a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -309,12 +309,10 @@ src_nft_LDADD = src/libnftables.la
 
 check_PROGRAMS += examples/nft-buffer
 
-examples_nft_buffer_AM_CPPFLAGS = -I$(srcdir)/include
 examples_nft_buffer_LDADD = src/libnftables.la
 
 check_PROGRAMS += examples/nft-json-file
 
-examples_nft_json_file_AM_CPPFLAGS = -I$(srcdir)/include
 examples_nft_json_file_LDADD = src/libnftables.la
 
 ###############################################################################
-- 
2.51.0

