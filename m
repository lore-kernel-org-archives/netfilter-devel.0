Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54176204F94
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 16:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730911368; cv=none; b=jic2bEnJjwP1MGQ1zjMQHEn/dTVntEqoC0cvTz4IY75i5qX6iMiFG+gxgBDaYgtzDyIfXHNA17IAb7shz+3zJUURgQllwy5X3b22W8H3R6DK31h8wYbsZy76M7qekWJl1eudx0XPnZC9hDQAvkp1le106T5I4qLBxPoY8M6zn2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730911368; c=relaxed/simple;
	bh=VHm+zxD+9dcuMBPyVIwLn5GeHISHVDrFQBifQRg1DIY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrYcai1FURQi80Hxd/h+RmY49o/KsgMNNVPaiIT+I0/1/nKQtmyawoLfjEYj3NDkOXfrochdR8JXdfrFb2xIoWH2c52JEt3whFaeyyFLGPyCsivXtYVGwGutp/u7R/eLn136QuLscIqPb8VFTBbIBCj6aC2S5lKGHRxmTe9kVkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jJND9TUx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jJND9TUx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tyIkU1Ig/MT+ZMqvM5Yf01oljtjCNhqh2pmM7nCaq64=; b=jJND9TUxAHQagyPhAxG1THxdZf
	VUl0UOzuqnRfnsdj1B5TNzrLeswLSz/YlEbyp3v1hsSuXkNp5JY87jPB8iDU4K4FIrw93bVL1yfiS
	bY1F3oX2AsCjOKLDAcQ7PyFReVjL4E41F+CF21+5qQCrpzmgpDyhc7jI6AZBlmVAWo6p1TidRmD7h
	H3GrEZDfImP+LQ9PCKRi5D+wZdJBSVGTTrpDwmpRzWyW+gl20zHxEhIpMY6Y41h/SYaRY1SN4PXIH
	mcWOWpMh64owAQkfZEKihW31dlhK8XZCLtUr368+VKwK8j9+aS5sh98fADLuoCHhXeLC1NOX1ZMaz
	1qMxP3QA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8j78-000000005PD-3TK8
	for netfilter-devel@vger.kernel.org;
	Wed, 06 Nov 2024 17:42:38 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/5] Makefile.am: Revert to old serial test harness
Date: Wed,  6 Nov 2024 17:42:32 +0100
Message-ID: <20241106164232.3384-5-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106164232.3384-1-phil@nwl.cc>
References: <20241106164232.3384-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Running the different testsuites in parallel is dangerous since despite
running in different netns, legacy iptables still synchronizes via the
common XTABLES_LOCKFILE.

Fixes: e1eaa04e31e44 ("Makefile.am: Integrate testsuites")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index 299ab46d7b8e2..d0ba059c00110 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,7 +1,7 @@
 # -*- Makefile -*-
 
 ACLOCAL_AMFLAGS  = -I m4
-AUTOMAKE_OPTIONS = foreign subdir-objects dist-xz no-dist-gzip
+AUTOMAKE_OPTIONS = foreign subdir-objects dist-xz no-dist-gzip serial-tests
 
 SUBDIRS          = libiptc libxtables
 if ENABLE_DEVEL
-- 
2.47.0

