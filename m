Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42743E3147
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 11:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781092651; cv=none; b=WY6NMmltdchNlvRyN+kRlpLDUTy7CONLBUDjBi8xCEsp0B8gRQ2k9CKRaI6eLTl2UMC3ck7K4qZW8Ix5Go2Lsg6ddtxw5xtedkL7j8fMWbHsa2/2I3a2h7eTjmjvCH74Dgkd1TiTSOZQfyda65djY324CgQ/q4Dmq/9gEugka4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781092651; c=relaxed/simple;
	bh=zu9ClWIYJnIL378rjjKCE/c5IU0plxNZdtm1CLusmHw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CvRhSJSk9B+nVynhanL/W/H/Qq93Fr4JztgyDTNHmaccOXhgDqWdjn0iTSiP90MM0y8a8OPiOv0C48e7UINMu5fa4dPbGAprTTz4mOphAG3K5AnXMSeVXDpjwYphU6E9s5d8ZNDl5qtE4a1ddBSkJUAL40MLEP0i9csAa1EmaVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=K7srVozc; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="K7srVozc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1EHidgftUymVodrdW7O2c/HAgNGt9naELxh8erVY4cc=; b=K7srVozcgn5hAUrPF4Fg6JFEdJ
	mZHl27JparrC+LvCAJAa/kPoHPqNE6uUDdVG0ix2DI+TKmq5xbSVW56BZmvLqKjI4ur3uZEiNMnjn
	WXviWfVAlRysUkkPcvbmnFYsEC9m5/QVRYun3Z3JWeEROZ7m9n9vLqt2M2QNR43aZFgTobCUB4ezn
	rYsu3Ok4FEyOkPu0xVivDmiwm2LuWtziSEqUmc/3mgA29mg52CiPzcp8zkKEE06auIH0q74o5pObr
	9tPbg+yATwIlDlPnk29fXGVv9Zc3jV98iLS7UTXsNErBREvEkfw4umZp5ZOlCZbOlL9VMEAGNRbjA
	tSP2tQCw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wXHYm-000000005sf-1oHU;
	Wed, 10 Jun 2026 13:57:28 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] profiling: Include unistd.h to avoid compiler warnings
Date: Wed, 10 Jun 2026 13:57:23 +0200
Message-ID: <20260610115723.3982210-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

RHEL8's gcc-8.5.0 emits these warnings:

src/profiling.c: In function ‘get_signalfd’:
src/profiling.c:32:3: warning: implicit declaration of function ‘close’; did you mean ‘pclose’? [-Wimplicit-function-declaration]
   close(fd);
   ^~~~~
   pclose
src/profiling.c: In function ‘check_signalfd’:
src/profiling.c:42:6: warning: implicit declaration of function ‘read’; did you mean ‘fread’? [-Wimplicit-function-declaration]
  if (read(fd, &info, sizeof(info)) < (signed)sizeof(info))
      ^~~~
      fread

Fixes: 868040f892238 ("configure: Implement --enable-profiling option")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/profiling.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/profiling.c b/src/profiling.c
index 34d91cc1746ec..f9ac36bd1c183 100644
--- a/src/profiling.c
+++ b/src/profiling.c
@@ -12,6 +12,7 @@
 #include <sys/signalfd.h>
 #include <signal.h>
 #include <stdio.h>
+#include <unistd.h>
 
 int get_signalfd(void)
 {
-- 
2.54.0

