Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A915419047F
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 10:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728471053; cv=none; b=plWz0PImWbK8saEgzmaWdOiN9Jmq1DoE0TwEfL9N3TOGf1RZbSFfzUO8yE9WlcTl9h8fR8fLLr/z3VUmu+5R/ZBqsg6FgvobzFpxkLpOQOFAcDt0+wHTGdOTVeCFfchcxaH+pqdrmE6qEAcA8b6TrJ0RPBq5NPqxL5t6SoBHB30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728471053; c=relaxed/simple;
	bh=di4v5lrzhBqk9ZM/7PoAFHnqkQ4ktHyi6ZeXUgzu0S0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CC99gn03MIE2njKSBzepw0EGqx4DSwI619rvmxTPBe4rgLJGo/Hmm+jg/eRxRlAVZusWwkwiMQolm8C8/HzrmV8g2oygF/krB6ngHOu3BimsAXKt059wZF9/047YkLprkqBUbvKJqF8t5T76LXNHOWvtK7vUEpR0ugMkeOFPCK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=U/StTOLB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="U/StTOLB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pcTlrKRCDONI7q0Tee0nW2e1Fq432lW+L0dXxfSLMbk=; b=U/StTOLBKsqPAAHiHq6+v5u58o
	Cb3H6KY+K1prlAR9ReHYmcxQF4fgqplgTWdDBGwrunVRd/utaNG1GW2KtDlz84YdDKI6mDO1n4wMp
	vPQElZlOgJfkoZhwxLjrZYkvuT3GmP5Ptd0zzEMHaQSvVuoacWEF+0mVb6zeYO0zT4souWw81Xlyu
	HDNj4ThmaqCzs7THAlWNo7r8MBx8uhsJa2IJqsgoOhEmuPSzNjySr3GvXcsHaA6zmNZZ6UkkLJ8DJ
	DwwA0/lasOaDSLsrM4nPW7u5wIgJuWe7ASPIQnNapmNFADU0mVElkemfQ77FgX1/D3Ny3p/aLCIS9
	MOUGpAHQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syUHD-000000007QY-2z69
	for netfilter-devel@vger.kernel.org;
	Wed, 09 Oct 2024 12:50:43 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/5] xshared: iptables does not support '-b'
Date: Wed,  9 Oct 2024 12:50:37 +0200
Message-ID: <20241009105037.30114-6-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241009105037.30114-1-phil@nwl.cc>
References: <20241009105037.30114-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This flag is merely known to iptables-restore but actively rejected
there and it does not use IPT_OPTSTRING at all.

Fixes: 384958620abab ("use nf_tables and nf_tables compatibility interface")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xshared.h b/iptables/xshared.h
index 0018b7c70bd83..a111e79793b54 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -80,7 +80,7 @@ struct xtables_rule_match;
 struct xtables_target;
 
 #define OPTSTRING_COMMON "-:A:C:D:E:F::I:L::M:N:P:R:S::VX::Z::" "c:d:i:j:o:p:s:t:v"
-#define IPT_OPTSTRING	OPTSTRING_COMMON "W::" "46bfg:h::m:nw::x"
+#define IPT_OPTSTRING	OPTSTRING_COMMON "W::" "46fg:h::m:nw::x"
 #define ARPT_OPTSTRING	OPTSTRING_COMMON "h::l:nx" /* "m:" */
 #define EBT_OPTSTRING	OPTSTRING_COMMON "h"
 
-- 
2.43.0

