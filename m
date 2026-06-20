Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C222EBBA4;
	Sat, 20 Jun 2026 22:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781994473; cv=none; b=L1xmbQyllMtJrDV1g+Qg0dDKcX+PzPt+lTCFcVKv6ZZqLUw7661KkxwQ1haP9mOct9hogelCW5LHuDgj3MbJylyLBw2mLNKJUgjix4s0vI3MNQPZQ3yx0JiyKiRTm7A1XL9jmNcw890+WrN9zAXT1m9gLPGTz87p5znFq/bGM7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781994473; c=relaxed/simple;
	bh=Cctvo3ka08rA2RgqUCoipHjqp+aCGXZHtlh/rMOzF88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQK7tZwnVLVU3r0eJM3Vuy/QNfEEyNYfE3Op9ulz9rkxN2b2IxUWJYJuwVIq5xq0jB/LGKD94P0kDAGsa4mcq1MLpUgDErsYAW3MpMD2NlXlLRHyy1KraoCRJIalEIp9nDR6hzNTGbICEs7M1+00/wfzBuJYhbVSdGLn8ymGv40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gGNZbw5i; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gGNZbw5i"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3100F60181;
	Sun, 21 Jun 2026 00:27:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781994463;
	bh=rRCknTVPe8kEOXE8SHhKPUK4i1g1mN85/ghVx+xSnpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGNZbw5izcRPMCfaNZvfriZS3mIEoTIOQSpNMHUJV2VhAkGskdFs7VQ6kb5sGHHo/
	 /DtbKDAQqE7zSNt8c4gJ43fr3Ji6Hz386xIGVbdB0IgL5j+egMR0WK59KJdiWNR1MZ
	 ctKmjFkF6goP2GwVd6NTRVXgsRNY14WAe2yTQK9ydhqaQdtrrLnyGPsIPWny1OeuNr
	 B0YiSCWvQTz1fMLJhVhLKUc2XqN3Ne3Z7X3nY36Rbcasl0BVf4PHpPo9FzPvAcoF3u
	 F/rrtH1wfjtCPw2qbDFbnfCcINdxU5nJmFtN+HPWmjg0x54khexueGBhLnjVwCGx3S
	 QxKgNWO4s7MJg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 01/14] netfilter: flowtable: fix offloaded ct timeout never being extended
Date: Sun, 21 Jun 2026 00:27:25 +0200
Message-ID: <20260620222738.112506-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620222738.112506-1-pablo@netfilter.org>
References: <20260620222738.112506-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Adrian Bente <adibente@gmail.com>

OpenWrt has recently migrated many platforms to kernel 6.18. On the
MediaTek platform, which supports hardware network offloading, WiFi
connections accelerated via the WED path were observed to drop after
roughly 300 seconds.

After several debugging sessions, assisted by the Claude LLM, the
problem was narrowed down as follows:

nf_flow_table_extend_ct_timeout() extends ct->timeout for offloaded
flows using:

	cmpxchg(&ct->timeout, expires, new_timeout);

'expires' comes from nf_ct_expires(ct) and is a relative value, while
ct->timeout holds an absolute timestamp. The two are never equal, so
the cmpxchg always fails and the timeout is never extended.

This goes unnoticed for most flows, but a long-lived hardware (WED)
offloaded flow on MediaTek MT7986 eventually has ct->timeout decay to
zero, the conntrack entry is reaped and the connection breaks.

Open-code the relative value from a single READ_ONCE(ct->timeout)
snapshot and compare against that same absolute snapshot in the
cmpxchg, so the timeout extension actually takes effect while the
datapath remains authoritative if it updates ct->timeout concurrently.

Fixes: 03428ca5cee9 ("netfilter: conntrack: rework offload nf_conn timeout extension logic")
Cc: stable@vger.kernel.org
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Adrian Bente <adibente@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 785d8c244a77..99c5b9d671a0 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -505,8 +505,13 @@ static u32 nf_flow_table_tcp_timeout(const struct nf_conn *ct)
  */
 static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 {
-	static const u32 min_timeout = 5 * 60 * HZ;
-	u32 expires = nf_ct_expires(ct);
+	static const s32 min_timeout = 5 * 60 * HZ;
+	u32 ct_timeout = READ_ONCE(ct->timeout);
+	s32 expires;
+
+	expires = ct_timeout - nfct_time_stamp;
+	if (expires <= 0) /* already expired */
+		return;
 
 	/* normal case: large enough timeout, nothing to do. */
 	if (likely(expires >= min_timeout))
@@ -524,7 +529,7 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 	if (nf_ct_is_confirmed(ct) &&
 	    test_bit(IPS_OFFLOAD_BIT, &ct->status)) {
 		u8 l4proto = nf_ct_protonum(ct);
-		u32 new_timeout = true;
+		u32 new_timeout = 1;
 
 		switch (l4proto) {
 		case IPPROTO_UDP:
@@ -549,7 +554,7 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 		 */
 		if (new_timeout) {
 			new_timeout += nfct_time_stamp;
-			cmpxchg(&ct->timeout, expires, new_timeout);
+			cmpxchg(&ct->timeout, ct_timeout, new_timeout);
 		}
 	}
 
-- 
2.47.3

