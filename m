Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7581935C196
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2025 21:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156020; cv=none; b=Xu9Qdrf3LZqFpKIhyrJWinKx3t8PP6u+DGOlWNXlhdN2fOu9/F/p4se7cJo/3XBktPpOw3f5zzNW0fcNDDI3x9CxmGHKMNY+1udqwOjIlo7hETrzBFZBmb+SVUAyy46k2fQF3x4Lj1zWvsMxvzWpm5hvyjmo1ULKfusmL/VZ3Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156020; c=relaxed/simple;
	bh=D1dgHF6m94r3VNlKtG5FiNMlRTCLlQOkY3o8rWNBQ2c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=V5/HhtEwjzB1qRGePMPkMktR+ZWPm8RlLEzKN09h5gJhve7NrJUlg2Elt4NTOEaKs4E51fy1Z3jj2RFtIuaDGlydxGZ+sM85+1QPMgnN+22FQXCI0AsD2U8HQAkQEVOQrTsiXYBCsUMuuxsaTBPqMHFgAN2RG4ojfbA1WiF/Jf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=ZDIQditu; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ZDIQditu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YpuJ12w7WKKznFpFDTh68ghtEeLlFb/uwb7Wf0b1IUw=; b=ZDIQditu4UF9gkzJLwMuCQmV6g
	8SOvRpHunqRnqtvW3ZMtseDOkwWYYYh5ATLe7AKbHVq2lF0jFnfJQw1haxmwp0qmRcbRcUp7TrYjm
	rKsSymJi7H22R+0l/L/FmgaOqCIOcRGzhTLlme0/V4d6BPMHi3tLruJdlE2aX9XKOs7LK02BsH1ir
	sz/rjcJwfGRBmMBgzZPQmn3DM4fDsSE8hboWp5Ruh/BCEDt2M7uiqc8P7+zsdzUhpmuowi60FgXRI
	HpxysO2sNPYp+JgQmHPRkE80YwYxBZMLxoyVKm5bpzzzfSf8hPpLdPtlrEvbgT6eENEYA7iBq8Odo
	0U/PYrng==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vK0v3-00000001Nuz-0pwT
	for netfilter-devel@vger.kernel.org;
	Fri, 14 Nov 2025 21:01:21 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables] xshared: restore legal options for combined `-L -Z` commands
Date: Fri, 14 Nov 2025 21:01:09 +0000
Message-ID: <20251114210109.1825562-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.51.0
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

Prior to commit 9c09d28102bb ("xshared: Simplify generic_opt_check()"), if
multiple commands were given, options which were legal for any of the commands
were considered legal for all of them.  This allowed one to do things like:

	# iptables -n -L Z chain

Commit 9c09d28102bb did away with this behaviour.  Restore it for the specific
combination of `-L` and `-Z`.

Fixes: 9c09d28102bb ("xshared: Simplify generic_opt_check()")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables/xshared.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index fc61e0fd832b..9bda28f1c213 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -943,16 +943,16 @@ static void parse_rule_range(struct xt_cmd_parse *p, const char *argv)
 #define CMD_IDRAC	CMD_INSERT | CMD_DELETE | CMD_REPLACE | \
 			CMD_APPEND | CMD_CHECK | CMD_CHANGE_COUNTERS
 static const unsigned int options_v_commands[NUMBER_OF_OPT] = {
-/*OPT_NUMERIC*/		CMD_LIST,
+/*OPT_NUMERIC*/		CMD_LIST | CMD_ZERO,
 /*OPT_SOURCE*/		CMD_IDRAC,
 /*OPT_DESTINATION*/	CMD_IDRAC,
 /*OPT_PROTOCOL*/	CMD_IDRAC,
 /*OPT_JUMP*/		CMD_IDRAC,
 /*OPT_VERBOSE*/		UINT_MAX,
-/*OPT_EXPANDED*/	CMD_LIST,
+/*OPT_EXPANDED*/	CMD_LIST | CMD_ZERO,
 /*OPT_VIANAMEIN*/	CMD_IDRAC,
 /*OPT_VIANAMEOUT*/	CMD_IDRAC,
-/*OPT_LINENUMBERS*/	CMD_LIST,
+/*OPT_LINENUMBERS*/	CMD_LIST | CMD_ZERO,
 /*OPT_COUNTERS*/	CMD_INSERT | CMD_REPLACE | CMD_APPEND | CMD_SET_POLICY,
 /*OPT_FRAGMENT*/	CMD_IDRAC,
 /*OPT_S_MAC*/		CMD_IDRAC,
-- 
2.51.0

