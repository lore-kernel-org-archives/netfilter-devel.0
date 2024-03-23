Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E9801362
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Mar 2024 03:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711163217; cv=none; b=PwsA42DOpNJdyGQ2GkrVSgr8ZJGYAbYxSaUVKgv0YPoMldAVpY1IyypYGbcExWhr006P0X9B1MZs54yPrxtQMQm8TSmsTVQ5v5bkd0xpZTKbGLc3zpbstukgADIaHw6bPWfQuTRTBZf9QEBNhrssyMNlIcf4t8TaMHHIL9iyUE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711163217; c=relaxed/simple;
	bh=SrlhXWyl3ud7/emoyLhi7JzSRgrYEzvz96YjStcmnW0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NMj1Tng1c0Y3s1oSy7uQ6/M0SP4SYWIWYMOAfTjEbHohHLIaWLyGw2CLDiKJYxRtKrwUs5XxtmaWM3ICR4uDRtSrHVWOCVIGovyR73SJzjIQ50sov0CmdhrdL+oPFiAYmO6uTmP4lm9FOzouzi/aK/2dP47p89b8I+gi0GfFw9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id A2AA172C8CC;
	Sat, 23 Mar 2024 06:06:49 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [193.43.10.9])
	by imap.altlinux.org (Postfix) with ESMTPSA id 9119F36D071C;
	Sat, 23 Mar 2024 06:06:49 +0300 (MSK)
From: Vitaly Chikunov <vt@altlinux.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Cc: Vitaly Chikunov <vt@altlinux.org>,
	Jan Engelhardt <jengelh@inai.de>,
	Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Subject: [PATCH iptables] libxtables: Fix xtables_ipaddr_to_numeric calls with xtables_ipmask_to_numeric
Date: Sat, 23 Mar 2024 06:06:41 +0300
Message-ID: <20240323030641.988354-1-vt@altlinux.org>
X-Mailer: git-send-email 2.42.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Frequently when addr/mask is printed xtables_ipaddr_to_numeric and
xtables_ipmask_to_numeric are called together in one printf call but
xtables_ipmask_to_numeric internally calls xtables_ipaddr_to_numeric
which prints into the same static buffer causing buffer to be
overwritten and addr/mask incorrectly printed in such call scenarios.

Make xtables_ipaddr_to_numeric to use two static buffers rotating their
use. This simplistic approach will leave ABI not changed and cover all
such use cases.

Interestingly, testing stumbled over this only on non-x86 architectures.
Error message:

  extensions/libebt_arp.t: ERROR: line 11 (cannot find: ebtables -I INPUT -p ARP --arp-ip-src ! 1.2.3.4/255.0.255.255)

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Cc: Jan Engelhardt <jengelh@inai.de>
Cc: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
---
 libxtables/xtables.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 748a50fc..16a0640d 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1505,7 +1505,9 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
 
 const char *xtables_ipaddr_to_numeric(const struct in_addr *addrp)
 {
-	static char buf[16];
+	static char abuf[2][16];
+	static int bufnum = 0;
+	char *buf = abuf[++bufnum & 1];
 	const unsigned char *bytep = (const void *)&addrp->s_addr;
 
 	sprintf(buf, "%u.%u.%u.%u", bytep[0], bytep[1], bytep[2], bytep[3]);
-- 
2.42.1

