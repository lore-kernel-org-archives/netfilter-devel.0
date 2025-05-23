Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7003D2920AA;
	Fri, 23 May 2025 13:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006875; cv=none; b=Cw/xLF3prxzvuz8PM3qG/J+NJXj547xUVPTftjiKWmLkd+l4JFG1OeFtmmNPb5tj/zzaQ16KU9oJK4EHF8VMvvGnAG0wUhkpZdxv2aBeoz2bjzbAH681UKo/+Uey+InsyZU9ioJpxP4r2YCJAG/XLiqcbZ0/8xdZaEw1UIUPmfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006875; c=relaxed/simple;
	bh=R6lBbr9j7LlwJiLupFk985xmeRLWeRceIxsmZhXILEE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HycCiwWJdO9Wfb9pg2pMpAlht7AJpV8JYxa1MrbU+7ipScZfWpl5yumMjshls6gfulFMhfcMlrJlAxcbGd1Ff2GPQDyOJwr5aTZaj16gkPQRdwFljwj0ORuwmcOQpOOa6MJVhxv4dxdV/akx+zYIB4kaMSFk4lZor6++aYE2WgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QMEO2baa; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fErsup6G; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QMEO2baa";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fErsup6G"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3BCB060298; Fri, 23 May 2025 15:27:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006873;
	bh=7+8rNsQHuGn78VP8QDzb4tbhD/GtmhyAQzafzrrpBPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMEO2baaaJgv4Yg7qartl9BawxX0uLrrxulnJCmN8BNSb+Zcb2QTHZZyXaZGBMBny
	 gLmCe0ZLovGKddx/doqfNCdChzw//x8s0JQk9MG8V1JCDbfGSeWnQ05OuhQhdI9keB
	 /zYsslv8OpM0zjRjc3eIjQIbHKmiIoSzfMIWe61otSb0IqeHJlM2oeNGcb5hwJ4Keq
	 vO6YExmEQzJleOJzIdH0TkgHMsmKmXsh+fiLmoh0h+mO7ApIEgVPQxIqdrrYYuZhyF
	 AhOns2kbMOOC4xxbama1kgo6jQHtEW1dcS4iQzqlREXBDxo4sBwivgrFfnw5bnkf+n
	 122dy63Gxo6GA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BCD1C60764;
	Fri, 23 May 2025 15:27:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006848;
	bh=7+8rNsQHuGn78VP8QDzb4tbhD/GtmhyAQzafzrrpBPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fErsup6G2NeqMY+fYeK6mU3ahoBcP+uxgzOek5K1t0CP+za9NVJ/650SGU/Rca2OQ
	 CiadW+TVNlbKLMvACy27gsd9Uswg4nreyaRH+fX670hIMGNRsU2J77jD3V86xWBW6f
	 qEQnqZMoM3UuisVmaDfbpXlLI3LNCxocWXZ2nQVoRiSvZYNS2ZXFXOa9HxCmlvAsIK
	 b7NE17jRWt3PQ2pCGSltkh7Go8+1d/sCcakL6jWyiqoQLHbzEEbjvlEfcuHWxiSHt2
	 8msazQb7DaWgqLn6H3Hf/v003z+jPDuwwe5+b1JogM8tL3ojE4YEEhfb990quRe4n+
	 G7TZ7iwR2ghbg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 12/26] netfilter: conntrack: make nf_conntrack_id callable without a module dependency
Date: Fri, 23 May 2025 15:26:58 +0200
Message-Id: <20250523132712.458507-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250523132712.458507-1-pablo@netfilter.org>
References: <20250523132712.458507-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

While nf_conntrack_id() doesn't need any functionaliy from conntrack, it
does reside in nf_conntrack_core.c -- callers add a module
dependency on conntrack.

Followup patch will need to compute the conntrack id from nf_tables_trace.c
to include it in nf_trace messages emitted to userspace via netlink.

I don't want to introduce a module dependency between nf_tables and
conntrack for this.

Since trace is slowpath, the added indirection is ok.

One alternative is to move nf_conntrack_id to the netfilter/core.c,
but I don't see a compelling reason so far.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h         | 1 +
 net/netfilter/nf_conntrack_core.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 892d12823ed4..20947f2c685b 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -470,6 +470,7 @@ struct nf_ct_hook {
 	void (*attach)(struct sk_buff *nskb, const struct sk_buff *skb);
 	void (*set_closing)(struct nf_conntrack *nfct);
 	int (*confirm)(struct sk_buff *skb);
+	u32 (*get_id)(const struct nf_conntrack *nfct);
 };
 extern const struct nf_ct_hook __rcu *nf_ct_hook;
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index de8d50af9b5b..201d3c4ec623 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -505,6 +505,11 @@ u32 nf_ct_get_id(const struct nf_conn *ct)
 }
 EXPORT_SYMBOL_GPL(nf_ct_get_id);
 
+static u32 nf_conntrack_get_id(const struct nf_conntrack *nfct)
+{
+	return nf_ct_get_id(nf_ct_to_nf_conn(nfct));
+}
+
 static void
 clean_from_lists(struct nf_conn *ct)
 {
@@ -2710,6 +2715,7 @@ static const struct nf_ct_hook nf_conntrack_hook = {
 	.attach		= nf_conntrack_attach,
 	.set_closing	= nf_conntrack_set_closing,
 	.confirm	= __nf_conntrack_confirm,
+	.get_id		= nf_conntrack_get_id,
 };
 
 void nf_conntrack_init_end(void)
-- 
2.30.2

