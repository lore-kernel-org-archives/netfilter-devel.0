Received: from cvsmtppost25.nm.naver.com (cvsmtppost25.nm.naver.com [114.111.35.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4A03B47F0
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 18:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484710; cv=none; b=QyKKzUZcGUap0VDrn5UPbNo6CGiWpaZxPbwg90oQfB4/o34WZ7QkDlIv8eho/sbsmkq55hvofEl2OoGXj7ZKaP8X7J5bMrE0Isx8jR4wauI2w08bEPsPVlmfOPETQHj9f4pzQarBGeQT+IZRdwGipN8AEqN7wB06zCdLhYUv2jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484710; c=relaxed/simple;
	bh=0NFayBRz51jI9OmZgpuIgWN5qJo2iGWblN0XITihY/c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iquDpjrHZNDj1HKUOrhgCWUdYTid3Hu+8M/I5y4Xp0zOOMXPEthkhbPZGXtqjQFfGUtdtX+/UVjJhy1HMfRSyyMaHOsJG7lNzVUw11DV/Jzbvj+eCduvA6dmPe+8nRvWuYSMflDH5+lcVSZsKkdIAG4fNzqVuAjPmQ1CHQeZOLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=om1z+Ckh; arc=none smtp.client-ip=114.111.35.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="om1z+Ckh"
Received: from cvsendbo034.nm ([10.112.20.50])
  by cvsmtppost25.nm.naver.com with ESMTP id aHPP8kHRRRaYBLudV61NzQ
  for <netfilter-devel@vger.kernel.org>;
  Thu, 08 Oct 2026 18:38:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791484698; bh=0NFayBRz51jI9OmZgpuIgWN5qJo2iGWblN0XITihY/c=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=om1z+CkhJKXi0IKu5hmsVeSCFi258Qn2eVd6FJpxPFUGjC3IgDdE++T754tbrCm46
	 /Vtd/C82KjWEImRRSWy+QR2hFwxuSQpgXt5xKz2VnYxdCbbY+JV+5W2m4OPFhQ7zPY
	 xHYiK1GzCGhCugLCdT1ao0M3b6rY0EXHffsX69Wm+mDUh4xx4Qbn1x8itaJW5YrKNS
	 TGR697HKd60NTsmgTKkQI90GobPwSozQNXlI3D/oFV1I42WJoyDSTUYse7jjDeV7ST
	 efuOijh6aP4515GxV05Mb9cO3xenlguW15FI8GTqqgwnw5eHaE5eoUtYU84xYH6NTR
	 bSYj4r9Rq9Z0Q==
X-Session-ID: LuRutOFXQkGmo7K+mO4PgA
X-Works-Send-Opt: OPFwpzGdjHmdKHFOMr39Ko3YKBmqjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: sdb9FAulFqJZ+Hm/axUZ+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp011.nm.naver.com with ESMTP id LuRutOFXQkGmo7K+mO4PgA
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Thu, 08 Oct 2026 18:38:18 -0000
From: tjdqudcks0424@naver.com
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Sung Byeongchan <tjdqudcks0424@naver.com>
Subject: [PATCH] netfilter: xt_dccp: handle reserved options as single-byte
Date: Fri,  9 Oct 2026 03:38:14 +0900
Message-ID: <20261008183814.10521-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sung Byeongchan <tjdqudcks0424@naver.com>

The DCCP UAPI defines option numbers 3 through 31 as reserved.  Like
Padding and Mandatory, these options occupy one byte.  dccp_find_option()
only treats values below 2 as single-byte and interprets the byte after a
reserved option as a TLV length.

This can skip a later option and invert an XT_DCCP_OPTION rule result.  A
local production-hook fixture installed the same DROP rule for IPv4 and
IPv6.  In three fresh boots per kernel, a target-only packet was dropped
20/20 times, while adding reserved option 3 before the same target let
20/20 packets reach the protected receiver.  The fixed kernel dropped all
trigger packets in three fresh boots and preserved the normal controls.

Treat every option up to DCCPO_MAX_RESERVED as single-byte, matching the
protocol definition.  Triggering requires
CONFIG_NETFILTER_XTABLES_LEGACY, CONFIG_NETFILTER_XT_MATCH_DCCP, an
option-based rule, and remote protocol-33 reachability.  The touched source
is unchanged at 0c2669a9f4a1d607e7591ae50ccf3c432a0aff08, where the patch
applies and builds cleanly.

The demonstrated impact is a conditional remote filter-verdict bypass.
No memory-safety violation, information disclosure, RCE, or LPE was
demonstrated.  The source reproducer and complete logs are available on
request and are not included in this public report.

OpenAI Codex assisted source inspection, test design, patch drafting, and
evidence organization.

Fixes: 1d3de414eb20 ("[NETFILTER]: New iptables DCCP protocol header match")
Assisted-by: LLM
Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
---
 net/netfilter/xt_dccp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 3db81e041af9b..23a4e3e8df7de 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -62,7 +62,7 @@ dccp_find_option(u_int8_t option,
 			return true;
 		}
 
-		if (op[i] < 2 || i == optlen - 1)
+		if (op[i] <= DCCPO_MAX_RESERVED || i == optlen - 1)
 			i++;
 		else
 			i += op[i + 1] ? : 1;
-- 
2.43.0

