Received: from out-06.smtp.spacemail.com (out-06.smtp.spacemail.com [66.29.159.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6BF231835;
	Fri,  1 May 2026 06:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.29.159.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777617138; cv=none; b=awEF+VTfeN7gYoe1K8OC4r+XOD0vMfc2MZQVfcUIj1s5fEu2vhL6c0dgWP7xOEOu8bErWr1KJ39b+BO689esqxk4equMTqQkIWTrrmQbA/h7v+l9o9MpNZtjaWhQkO9btJROOtZVpHoTriHEwNSnRdKAjrZazq5kqC+hF7OKbCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777617138; c=relaxed/simple;
	bh=AQd2sw1EZKQtxF/RoAKXgzvPNwc2JS7cbKhPcFoLW+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfiqEHRazlRaoFpXeJihL7vx0irn7tD0KujIokhOKJCfuuC2E+KN6Fr9Vi8q0HAz74Hi5zKrOiXO93+Sp7If4yFSxXveFyXbqOVOCGfvaayu75Sqy1XV5P/oapigQefqK1KCVUB14AY4eIVkTCa21f4/h+44qifEn2bR2n7dZqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=ge14SECc reason="key not found in DNS"; arc=none smtp.client-ip=66.29.159.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="ge14SECc"
Received: from Kyren (unknown [49.207.224.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4g6Lmq2CCHz8sX2;
	Fri, 01 May 2026 06:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1777617135;
	bh=ykvFs84X9ifnNLgl1nKjZZCGpsIMTr1LlOqri6Q6e/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ge14SECc/2b+qcGuGlmiqa+I7WmH5Lm3VGj4K+f8oNo4Pu06xlYq+Fn3l43ndfQOd
	 zVbJqfPX4Q/Do7qT6NFFrA5kM9XV8FVi/cmhAlgycDQzyb25zMO+MHa6yEzFkiz63Z
	 sKCHTCPpLqBlz+7okFx5RnTE618hUNbzVTvxEZhLH0atCo3acsoNYXKS9Ax+pQ7JYh
	 DM0GR+SvuRX7JyK64tXcSuqH7/EIhw5qIfpiLVI4TI82K2ylgzCkhsexDCCZN4LaiA
	 p2Ap3W8WILphjPzCPWORGXix9CNuuqJ1GR6G+8NAbJHsW/RfVxxsBkfWnpsjFWoYrw
	 QOtnkNBSUBWAg==
From: HACKE-RC <rc@rexion.ai>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	HACKE-RC <rc@rexion.ai>
Subject: [PATCH net-next v2 1/3] netfilter: conntrack: add shared port parser for helpers
Date: Fri,  1 May 2026 12:01:54 +0530
Message-ID: <20260501063156.2520780-2-rc@rexion.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260501063156.2520780-1-rc@rexion.ai>
References: <20260501063156.2520780-1-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

Add nf_ct_helper_parse_port() to the conntrack helper core. This
provides a port parser that does not rely on nul-terminated strings,
taking an explicit length parameter and validating the result fits
in the 1-65535 range.

Modeled after the approach in 8cf6809cddcb ("netfilter:
nf_conntrack_sip: don't use simple_strtoul") but as a shared
function so IRC, Amanda, and other helpers can use it instead of
open-coding simple_strtoul calls with ad-hoc range checks.

Signed-off-by: HACKE-RC <rc@rexion.ai>
---
 include/net/netfilter/nf_conntrack_helper.h |  3 +++
 net/netfilter/nf_conntrack_helper.c         | 28 +++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index de2f956ab..db19fe25f 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -160,6 +160,9 @@ nf_ct_helper_expectfn_find_by_name(const char *name);
 struct nf_ct_helper_expectfn *
 nf_ct_helper_expectfn_find_by_symbol(const void *symbol);
 
+int nf_ct_helper_parse_port(const char *cp, unsigned int len,
+			    u16 *port, char **endp);
+
 extern struct hlist_head *nf_ct_helper_hash;
 extern unsigned int nf_ct_helper_hsize;
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index a715304a5..12f51670d 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -499,6 +499,34 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat)
 }
 EXPORT_SYMBOL_GPL(nf_nat_helper_unregister);
 
+int nf_ct_helper_parse_port(const char *cp, unsigned int len,
+			    u16 *port, char **endp)
+{
+	unsigned long result = 0;
+	const char *start = cp;
+
+	while (len > 0 && *cp >= '0' && *cp <= '9') {
+		result = result * 10 + (*cp - '0');
+		if (result > 65535)
+			return -1;
+		cp++;
+		len--;
+	}
+
+	if (cp == start)
+		return -1;
+
+	if (result == 0)
+		return -1;
+
+	*port = result;
+	if (endp)
+		*endp = (char *)cp;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_ct_helper_parse_port);
+
 int nf_conntrack_helper_init(void)
 {
 	nf_ct_helper_hsize = 1; /* gets rounded up to use one page */
-- 
2.54.0

