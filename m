Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93EE19049A;
	Tue, 25 Mar 2025 19:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742932096; cv=none; b=tUkY31Cc48Pq6EYDilspHtJKlccE9wJIonN7JrPRJjzKW+/2SSrdm0q9MYqCEAOr1JiSikqdGbbmhYo/eVrUyhjN9/4vegu7N88uyM87iTTHA8Jl+OYuilI7McVyyyUgVGU1kyk4xAlMDdcuklts1mEz5E8DbXN5UP80TAzPIy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742932096; c=relaxed/simple;
	bh=qtqOUPArf4ltJ5B5t2rNbSPqwSNz9SM4S/kBnokKLFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nZ5JFEEFddZq2Hdk0MSsCw3WbS/+piK+aART5f+/P8KUwVKQSqfwT7scGTDgng5uH5NxryIpLVVnqwKrDWafg6rjG8djMK1G1zMs6fUaE6F/NVBZKOKig7bWIkvnBgKUwH1IxnqRbYXETu7piH1mDCun0Yf6x9NX+Wto3Y1dUSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1txAFo-0008KT-Gb; Tue, 25 Mar 2025 20:48:04 +0100
Date: Tue, 25 Mar 2025 20:48:04 +0100
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [net-next v3 0/3] Disable LEGACY iptables on PREEMPT_RT
Message-ID: <20250325194804.GA18860@breakpoint.cc>
References: <20250325165832.3110004-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325165832.3110004-1-bigeasy@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> The per-CPU xt_recseq is a custom netfilter seqcount. It provides
> synchronisation for the replacement of the xt_table::private pointer and
> ensures that the two counter in xt_counters are properly observed during
> an update on 32bit architectures. xt_recseq also supports recursion.

I applied following diff on top of this series, after that
./iptables-test.py -n
and
iptables/tests/shell/run-tests.sh

pass (legacy version fails as expected).
The change in xt_mark is awkward but its the only place that
needs it so its not worth to add a new kconfig symbol to avoid ||
test.

diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -91,7 +91,7 @@ tcpoptstrip_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	return tcpoptstrip_mangle_packet(skb, par, ip_hdrlen(skb));
 }
 
-#if IS_ENABLED(CONFIG_IP6_NF_MANGLE)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 static unsigned int
 tcpoptstrip_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -119,7 +119,7 @@ static struct xt_target tcpoptstrip_tg_reg[] __read_mostly = {
 		.targetsize = sizeof(struct xt_tcpoptstrip_target_info),
 		.me         = THIS_MODULE,
 	},
-#if IS_ENABLED(CONFIG_IP6_NF_MANGLE)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	{
 		.name       = "TCPOPTSTRIP",
 		.family     = NFPROTO_IPV6,
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -48,7 +48,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 		.targetsize     = sizeof(struct xt_mark_tginfo2),
 		.me             = THIS_MODULE,
 	},
-#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)
+#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES) || IS_ENABLED(CONFIG_NFT_COMPAT_ARP)
 	{
 		.name           = "MARK",
 		.revision       = 2,

