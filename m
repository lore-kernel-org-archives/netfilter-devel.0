Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14622F3C18;
	Wed, 25 Mar 2026 17:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774459623; cv=none; b=R0uA9f2CiCCo2E5kU5+L3KcNMLHdo7XNT/P9uP+cY66iAGg03JR4swG2MjpT2cpjmlNIGs7BT383Th6pY+qJOsbzkVXpFo6WKeuMbh6x8katJuUKpXLoTn5J2tbn+Ps5Trcg6guZlsUEtT427bOGejwfuNVj2whclsHNftV5md8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774459623; c=relaxed/simple;
	bh=a4aj5jAmH16K+/PquDZcbtSVDhId/k9irzRhOU0Ai74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bk4H8S8AD/J//8vV6FbsogliCIDAPSp75soEy50HlU9ACH5Hbpb7lMoFQkK2Gu0enMJUxjYfl8KuuYTA/sb4uxCCS9zQWFnyxFN6wY1fPB/JN0A3ntQU/cP2ymVwe4/3rI2v1k1pdavXyJYMUAWZnCkrCzQZsqgr4qaTulvNL6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PqdlzDjX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PqdlzDjX"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 374D3600B5;
	Wed, 25 Mar 2026 18:26:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774459618;
	bh=R/N3iI1l0bnsXgxzIzcUgBpAxd8OgKgFL9Jb7qTamhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PqdlzDjX/bpuRfD0n7MN6PkT2VzmDTcpQnpydbs4UzAUGSiW7eNJdre0GjGxXOG5c
	 q4qzkB45G8zh6tkgstbanuL6GzVgpMcWDXjdasDSNOOXaivp067BIjgeYcujkt7NLM
	 OUw841ze/Erp4oEHq9YPaCpaCGIpHP8+NkQoEtw5Oinyh4FSVfXiqNKy+2R3+iGrCA
	 tu5SB+WugRWu4bcUzxRjIp/Til7xvc30CSKVzWDeqERFfG9rttAgEoEKQQ+NmdvC6p
	 3+KCJqzr07bF5XZXPzPEIHODyuP+Y49wIF2hcjb0BloXdIu9XIrX/TYGIBNaurEP1W
	 ln6FTSWfu1/iw==
Date: Wed, 25 Mar 2026 18:26:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 10/14] netfilter: ctnetlink: ensure safe access to
 master conntrack
Message-ID: <acQa30IdYh3PeLAh@chamomile>
References: <20260325131108.23045-1-fw@strlen.de>
 <20260325131108.23045-11-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="a6qFS7dqxNZJ8s0L"
Content-Disposition: inline
In-Reply-To: <20260325131108.23045-11-fw@strlen.de>


--a6qFS7dqxNZJ8s0L
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Florian,

Sorry for this late followup incremental fix.

On Wed, Mar 25, 2026 at 02:11:04PM +0100, Florian Westphal wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Holding reference on the expectation is not sufficient, the master
> conntrack object can just go away, making exp->master invalid.

This patch needs this update for expectations which do not have
nfct_help(ct), two cases:

- nft_ct creates
- ip_vs_ftp

See attached incremental patch.

--a6qFS7dqxNZJ8s0L
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="fix.patch"

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 509d3eb6f56a..cf39662c4b97 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -325,7 +325,9 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 		       u_int8_t proto, const __be16 *src, const __be16 *dst)
 {
 	struct net *net = read_pnet(&exp->master->ct_net);
-
+	struct nf_conntrack_helper *helper;
+	struct nf_conn *ct = exp->master;
+	struct nf_conn_help *help;
 	int len;
 
 	if (family == AF_INET)
@@ -336,7 +338,14 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 	exp->flags = 0;
 	exp->class = class;
 	exp->expectfn = NULL;
-	rcu_assign_pointer(exp->helper, nfct_help(exp->master)->helper);
+	help = nfct_help(ct);
+	if (help) {
+		helper = rcu_dereference(help->helper);
+		if (helper)
+			rcu_assign_pointer(exp->helper, help->helper);
+	} else {
+		exp->helper = NULL;
+	}
 	write_pnet(&exp->net, net);
 	exp->zone = exp->master->zone;
 	exp->tuple.src.l3num = family;

--a6qFS7dqxNZJ8s0L--
