Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F4E13C67C
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 16:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730911367; cv=none; b=NhJhoBIgBPtcqJaU2de2tDun1Sx1MhrZ2gYbIjKsZZUHvFQZ5Za6QBkOZ8wOdK2moYd66yrqIVl1X/s/DHHdByYgx/aFfL0DGkWYFfKrqEwf7kHYhjo9CVa1vhsroLp3XPO3kfzUZfIlziDOQ+UhtEK6F1e1N83U1fQJWDaFeRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730911367; c=relaxed/simple;
	bh=ljqzVcnu61wG/tWomQqyPQ/A1Y0zLh9zpJJNiz0b7BI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=oYMi462zIRmjTPAz+eaz80tnOLBy0oN+9r8oTVDWRuAyryX5+rn8yRMLW9bXi/xGw64VcRxbK202UPU8U4seOuEEbZYPRUeaIh9SOyUU2ZrT1TiNKZsXNiQPmQaiSsWIvIBgwCzMAUnmtw4b8yfR9X1MKuEs1dUASeh/EGkHmwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Zp9lfKlC; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Zp9lfKlC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fihzXb6abj/sD++g6BjFlBPmhwbcL8TQpHn/E9tGni0=; b=Zp9lfKlCjiaXXLHM1ujjWn3pwI
	He9UiguURV76uQV5yhJqWDAoMz8XSAJGJDHM3B4wXKPKOtQUUOdJTLPH4FHbop0uW5TBHZLz6ghUv
	HihGoZoqOvgFJQgyXgi1gMEYXTZX3ep89sadsKtCa6eB29rxdQI/5gEk0Yjxl137VeOYGSa1WUxbs
	8L5slw2tPZcXI8kH7J7ym+P4p1xkUl659BRD/PTuVD5isb93Fon4IhwrC3ma82UtFKA22Rq3CeUP1
	oAVBu9a1F5Jkq18Mx5fEt7XNR4PJQqu4u/MZ7pnAK7jZyg9+F2BmXuoRczVDk2lRIyMRilsq/rUsp
	hgjZLa7Q==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8j76-000000005Ou-2eOK
	for netfilter-devel@vger.kernel.org;
	Wed, 06 Nov 2024 17:42:36 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/5] tests: shell: iptables/0010-wait_0 is unreliable
Date: Wed,  6 Nov 2024 17:42:28 +0100
Message-ID: <20241106164232.3384-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sometimes the test would fail, especially after removing
/run/xtables.lock file. Looks like the supposedly blocking
iptables-restore coproc sometimes takes a moment to set things up.

Fixes: 63ab5b8906f69 ("iptables-legacy: Fix for mandatory lock waiting")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/tests/shell/testcases/iptables/0010-wait_0 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/tests/shell/testcases/iptables/0010-wait_0 b/iptables/tests/shell/testcases/iptables/0010-wait_0
index 4481f966ce435..37a7a58fc5dca 100755
--- a/iptables/tests/shell/testcases/iptables/0010-wait_0
+++ b/iptables/tests/shell/testcases/iptables/0010-wait_0
@@ -11,7 +11,7 @@ esac
 
 coproc RESTORE { $XT_MULTI iptables-restore; }
 echo "*filter" >&${RESTORE[1]}
-
+sleep 0.5
 
 $XT_MULTI iptables -A FORWARD -j ACCEPT &
 ipt_pid=$!
-- 
2.47.0

