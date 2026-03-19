Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5471030EF92;
	Thu, 19 Mar 2026 09:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773913134; cv=none; b=bkyNOmuYs0My8oc/hcMQ+fsDWfHKdsRBakV4aXy4syr58AiD/Fk+43bt83VjgquaPXKb05LS2H1Wjex06hap5bxFfAgwt8XNBDjcGXcXlGSPwDou6xYwBKwULmV8qOzMurBzNcjd7BowhlHfDF2vjaT2VXEQHvZQm8WwkFHuNIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773913134; c=relaxed/simple;
	bh=Am0kw2DSI5ybTUAh3vL9h/v8qez1jurpms7CgaCSyhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnCykY+GmZsaS3+Fleg04/f4ab1/sF8TgUZQnBPDPMbZtZgK/zSrLps6MPjwiORmLawMF7HQ8cQklIAK6RJkk4THidRECFnwa+SFR9SH6n+37D0ZnJdVG6dw+twivsfH9hKw9VYl2O07/OlyakdS8mrc7ejyJicG0z05kAUrXHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 33481608E0; Thu, 19 Mar 2026 10:38:51 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 3/3] nfnetlink_osf: validate individual option lengths in fingerprints
Date: Thu, 19 Mar 2026 10:38:34 +0100
Message-ID: <20260319093834.19933-4-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260319093834.19933-1-fw@strlen.de>
References: <20260319093834.19933-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Weiming Shi <bestswngs@gmail.com>

nfnl_osf_add_callback() validates opt_num bounds and string
NUL-termination but does not check individual option length fields.
A zero-length option causes nf_osf_match_one() to enter the option
matching loop even when foptsize sums to zero, which matches packets
with no TCP options where ctx->optp is NULL:

 Oops: general protection fault
 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 RIP: 0010:nf_osf_match_one (net/netfilter/nfnetlink_osf.c:98)
 Call Trace:
  nf_osf_match (net/netfilter/nfnetlink_osf.c:227)
  xt_osf_match_packet (net/netfilter/xt_osf.c:32)
  ipt_do_table (net/ipv4/netfilter/ip_tables.c:293)
  nf_hook_slow (net/netfilter/core.c:623)
  ip_local_deliver (net/ipv4/ip_input.c:262)
  ip_rcv (net/ipv4/ip_input.c:573)

Additionally, an MSS option (kind=2) with length < 4 causes
out-of-bounds reads when nf_osf_match_one() unconditionally accesses
optp[2] and optp[3] for MSS value extraction.  While RFC 9293
section 3.2 specifies that the MSS option is always exactly 4
bytes (Kind=2, Length=4), the check uses "< 4" rather than
"!= 4" because lengths greater than 4 do not cause memory
safety issues -- the buffer is guaranteed to be at least
foptsize bytes by the ctx->optsize == foptsize check.

Reject fingerprints where any option has zero length, or where an MSS
option has length less than 4, at add time rather than trusting these
values in the packet matching hot path.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_osf.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 94e3eac5743a..45d9ad231a92 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -302,7 +302,9 @@ static int nfnl_osf_add_callback(struct sk_buff *skb,
 {
 	struct nf_osf_user_finger *f;
 	struct nf_osf_finger *kf = NULL, *sf;
+	unsigned int tot_opt_len = 0;
 	int err = 0;
+	int i;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -318,6 +320,17 @@ static int nfnl_osf_add_callback(struct sk_buff *skb,
 	if (f->opt_num > ARRAY_SIZE(f->opt))
 		return -EINVAL;
 
+	for (i = 0; i < f->opt_num; i++) {
+		if (!f->opt[i].length || f->opt[i].length > MAX_IPOPTLEN)
+			return -EINVAL;
+		if (f->opt[i].kind == OSFOPT_MSS && f->opt[i].length < 4)
+			return -EINVAL;
+
+		tot_opt_len += f->opt[i].length;
+		if (tot_opt_len > MAX_IPOPTLEN)
+			return -EINVAL;
+	}
+
 	if (!memchr(f->genre, 0, MAXGENRELEN) ||
 	    !memchr(f->subtype, 0, MAXGENRELEN) ||
 	    !memchr(f->version, 0, MAXGENRELEN))
-- 
2.52.0

