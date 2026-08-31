Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513995A894E;
	Mon, 31 Aug 2026 13:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184353; cv=none; b=KyY/chsaHadt9ZVtmN6ekuueKsIFDgi9sT8OPy8C6RNM7qcQr+4bDZcKLcOHmGKca/vdDA6KQVUv5B2d5DBQrAkfAc7Gb0fijHeZO6R2Z2TOkG4SNcom4hDhUgXngRx0ncfg8N7S3Qhw6n4u7Bx868G1Jo3ZgFI4rnElZ5eeRr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184353; c=relaxed/simple;
	bh=6hqlCQ5kq92jrq7wfiOWwETXA3/B9Z0J2y8N2dHQxzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L+2fe7xC9fy6ailIQeWocuCm7IF4ssJ8gaUiS6rmdX+F+UeqwN8U/XGVOlNrSSG4VLGULXcjw1r3iPhwfieBjVk9HsibLQQ6UZnqF/NLseHnBXe/kGm/ueFZWBQLTDjfDfNZpymUnBuCIcY1FBeVYUnbxC70JBzuOdla4XPfGbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ggqyvOZ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ggqyvOZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAA01F000E9;
	Mon, 31 Aug 2026 13:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184352;
	bh=xktnLdwdOOKm8UHvxL9xClglEUbQ9SR+vS/cFunfwfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ggqyvOZ5d+SM+Hm52IvmEygaA/Nv08/334oY4FTwIgODrz7mL8+PK2nYbOHoaP3Cp
	 gVW5OduI2Y6R4yCm7yVgzrF47OeIxaw9r8YoQjRGj3F5t4nxZ563xgwvYuehldjVK7
	 dQBuKeqqo58rmmiTOW+OAGleX7NOd7037bqomPdPDkDc42k3Yxf8XmtHvHAOjDYkU2
	 FAfi2e4DiNmKIfoxogorsIJCkXDVmxbFDT0oFGYVAK7FfWCg93K1PDgEU793s/BoCj
	 wvCGBG/gTGMpVzetPTubZj3lP/Z6/2IxCLCqnfjKxvjcD2TtwxYfeESyJLBRjPqC0y
	 PPJitEVg/3hUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] netfilter: nfnetlink_log: wait for rcu grace period before freeing pernet state
Date: Mon, 31 Aug 2026 09:31:10 -0400
Message-ID: <20260831133314.4125787-642-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 33d1469b0124cc0baaea7a2032123b77a81e0940 ]

sashiko reports: "nfnl_log_net_exit() calls nf_log_unset(), which
clears the logger pointer without an RCU grace period.  Immediately after,
ops_free_list() frees the per-net state while concurrent packets might
still be executing nf_log_packet() under rcu_read_lock()."

Clear the pointer via .pre_exit to make sure rcu readers have completed
before pernet storage is free'd.  The change in nf_log_syslog.c is only
done for consistency: it doesn't use pernet data.

Link: https://sashiko.dev/#/patchset/20260731151806.849724-1-pablo%40netfilter.org
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background searches finished with no hits:

- **Local tree:** `git log --grep` for the fix subject,
  `nfnl_log_net_pre_exit`, and related terms returned nothing — the
  patch is not in `v6.18.44`.
- **Patchwork:** The kernel.org search also came up empty (no matching
  nfnetlink entries).

That lines up with the earlier analysis: the buggy code is still present
in this tree, and the fix looks like a good backport candidate
(**YES**).

 net/netfilter/nf_log_syslog.c |  4 ++--
 net/netfilter/nfnetlink_log.c | 13 +++++++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 6fa0812cd79ca..07a4f4725fcb2 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -1006,7 +1006,7 @@ static int __net_init nf_log_syslog_net_init(struct net *net)
 	return ret;
 }
 
-static void __net_exit nf_log_syslog_net_exit(struct net *net)
+static void __net_exit nf_log_syslog_net_pre_exit(struct net *net)
 {
 	nf_log_unset(net, &nf_ip_logger);
 	nf_log_unset(net, &nf_arp_logger);
@@ -1017,7 +1017,7 @@ static void __net_exit nf_log_syslog_net_exit(struct net *net)
 
 static struct pernet_operations nf_log_syslog_net_ops = {
 	.init = nf_log_syslog_net_init,
-	.exit = nf_log_syslog_net_exit,
+	.pre_exit = nf_log_syslog_net_pre_exit,
 };
 
 static int __init nf_log_syslog_init(void)
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index a6989966d80d5..68e5429338330 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1160,21 +1160,26 @@ static int __net_init nfnl_log_net_init(struct net *net)
 	return 0;
 }
 
-static void __net_exit nfnl_log_net_exit(struct net *net)
+static void __net_exit nfnl_log_net_pre_exit(struct net *net)
 {
-	struct nfnl_log_net *log = nfnl_log_pernet(net);
-	unsigned int i;
-
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nfnetlink_log", net->nf.proc_netfilter);
 #endif
 	nf_log_unset(net, &nfulnl_logger);
+}
+
+static void __net_exit nfnl_log_net_exit(struct net *net)
+{
+	struct nfnl_log_net *log = nfnl_log_pernet(net);
+	unsigned int i;
+
 	for (i = 0; i < INSTANCE_BUCKETS; i++)
 		WARN_ON_ONCE(!hlist_empty(&log->instance_table[i]));
 }
 
 static struct pernet_operations nfnl_log_net_ops = {
 	.init	= nfnl_log_net_init,
+	.pre_exit = nfnl_log_net_pre_exit,
 	.exit	= nfnl_log_net_exit,
 	.id	= &nfnl_log_net_id,
 	.size	= sizeof(struct nfnl_log_net),
-- 
2.53.0

