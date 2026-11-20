Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136126;
	b=tV6wQNrF+m0fPKxEP0GbtieQ/G4ZD4PBiStIjpzGuDBWhMPA285r1lCFS3E1fJrDSpJx
	 mv2xGJYOHhQaxEhi5s3iN1Ff+qHq6OVYErs01Z0QPgRFqchUVwSXtO7w7cBGLyfaMLi9p
	 uDjZjJCLBjssms5tLNyqTajSaFWjXcW4LHsfoOJeDeVjekSsnWHlOF7PIw8cCkzw9OzGI
	 F6bbkoiXEwU8Cv7bV3l5A9jNlmaHkPDgYpyuV+5bkx9/C4yugym1pOSSzUQzAlnbLVwV9
	 fl83AcQyQ4HBK1qH+g6YyjQjUBuAzcVeZFf1qNX5pUB4sOE8r+mPFDu7QHw+ikJMh8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136126;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=fu148dgjHNsFj/x+juMfeuPX0lRReNeViWIIvasAr8g=;
	b=3VExwO3fBNXpgAgkfJIKOB/0tN5VnC35J+iQuKruF/zuhShMSWdYDJsd+UvUUN7nT1Yh
	 VdRgGGDgZN6fYisYFfUde1haTndEQqyL4RaiRkMOSggkro/1qhuwb2ayBkjDr0+e9W42O
	 GHuunjz6PSvlxrx/6LlDaWOP6ND9WbWfj22PpErbCFBwU79xn7n0gnYc1NbzeuP3csvmd
	 I0MeAWFFthr5go8wUAuAhPROk2gR47s+0GCmfGlVOGkxwYbk86x+XeLzl68bskcT2xZfl
	 zr9fyLB4b+U0XEwwSJ+c8gC03JSFLnnf0WzTmQPymuZhz31gf83Zx1IPsEGQ+ac/+qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=p5eHTd06;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE200606A320
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 00:55:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE200606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=p5eHTd06
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795136124;
	bh=fu148dgjHNsFj/x+juMfeuPX0lRReNeViWIIvasAr8g=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=p5eHTd06RlKqjVBeeswu1/tyj9LHtKa8T792TkRwj+G2nD2JdaJDZ13r3lbcvhccM
	 fG9821GrRyIQ8if74/ghc9Q3v6eqgkVPxuEwq5wLzOKgO8OuUxcskjC1AvTbK7yfLs
	 mf6boIAIhEWwsNhVi87Jczw8LKZZipRp4IQxtiSYCzDKThPz1ae/QHqzOUxC+jiAab
	 pUdEVEbFPgxiqfOtucbPhc4k1jOSvWggnFi7G0PFHxZpFXjr7b1v37fKdZZHW5sYY+
	 Yw5IcTYVTYqCgPRfXzQ1qsBVNtm/k8/ZipjBvfwIR0IKxZffsWh8F23xAAPEIorYkR
	 NGj51OG17Rm3A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 208F960057
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 01:55:24 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v5 2/3] netfilter: nf_tables: flush destroy work from flowtable netdev event handler
Date: Fri, 20 Nov 2026 01:55:17 +0100
Message-ID: <20261120005518.3446074-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120005518.3446074-1-pablo@netfilter.org>
References: <20261120005518.3446074-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko reports that the following race is possible while dismantling
the flowtable with hardware offload:

CPU0                                  CPU1 (kworker)
nf_tables_commit()
  list_del_rcu(&flowtable->list)
  nft_unregister_flowtable_net_hooks()
nf_tables_commit_release()
  schedule_work(&destroy_work)
  mutex_unlock(&commit_mutex)
                                      nf_tables_trans_destroy_work()
                                        synchronize_rcu()
                                        ...
unregister_netdevice()
  nf_tables_flowtable_event()
    /* flowtable not in
     * table->flowtables, ops->dev
     * stays on flowtable->hook_list
     */
  free_netdev(dev)
                                        nf_tables_flowtable_destroy()
                                          nft_flowtable_hooks_destroy()
                                            ...
                                            flowtable->data.type->setup(
                                              ..., ops->dev,
                                              FLOW_BLOCK_UNBIND)
                                              <-- use-after-free

A netdevice event could happen in between the netns .pre_exit and .exit.
After .pre_exit, the flowtable has been removed from the table list,
therefore, it is not reachable by the flowtable netdevice handler so the
hook cannot be unregistered and a stale reference to the netdevice
remains in place, leading to possible UaF from the commit_release path
when accessing the netdevice.

Fix this by flushing the pending destroy work before handling netdevice
events.

This patch is a requirement for the follow up commit ("netfilter:
nf_tables: perform unbind callback on hook release").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: no changes

 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d3c04a71c924..24db948b851b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9902,6 +9902,8 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	nft_net = nft_pernet(net);
 	mutex_lock(&nft_net->commit_mutex);
 
+	nf_tables_trans_destroy_flush_work(net);
+
 	if (event == NETDEV_CHANGENAME) {
 		if (__nf_tables_flowtable_event(NETDEV_REGISTER, dev, true)) {
 			ret = NOTIFY_BAD;
-- 
2.47.3

