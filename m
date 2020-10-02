Return-Path: <SRS0=cI96=DJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39C4C4363D
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 11:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C495206E3
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 11:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgJBLol (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Oct 2020 07:44:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36962 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgJBLol (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Oct 2020 07:44:41 -0400
Received: by mail-wr1-f67.google.com with SMTP id z4so1475654wrr.4
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Oct 2020 04:44:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=a3HOBVVlIIKm0zgt9fjVQizcrcaUMFm+zhWiUrEhifM=;
        b=FhBKzKFgJm7dQdWetIsG+0FveBAB+NRLdHhx9HjAEOBFo3d2NrLhtz6AxAslDFlp4P
         CkSkk9o7wugn949Cq1pXuJnYifMWgw6xpv8JEHfyTcB2V9iHZIWCvAeY33Kqt4FGpde+
         Xo3TkAsAC7USwZImhkzcDV/Fg+ZfubeLFE76ODKcdhk/Qy/xdPuKCFYb54Yj0Pzt8QLG
         H+RAz3BFphbTmL2s6TDkOEoYj5bMTSgj2pMCuCPpn9C/GYxjkUGsxdqaDF97jWngqS+e
         fe0A2E89fyItu5Jnuxp38ZDfDNWmynNu1fcZI8Vy16XarSJnvMSDlDxKfAo3V6xqNr7F
         D7gw==
X-Gm-Message-State: AOAM533XO03M+U/+vX6Gdqo36F5F4CCrZ2jRbvaLuTweB0ZmN8hkrOOC
        SX9Z2fk21/zjtogQ6Dg6kA4uZj1JqtYeGg==
X-Google-Smtp-Source: ABdhPJyQF1tx6UlulR8m4hsH1JiF3HyLw60RE6qBU00CYWIVRNpwX9tclkDBHr27oMb686O7xh686w==
X-Received: by 2002:adf:f34a:: with SMTP id e10mr2586578wrp.91.1601639078242;
        Fri, 02 Oct 2020 04:44:38 -0700 (PDT)
Received: from localhost (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id r5sm1428028wrp.15.2020.10.02.04.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 04:44:37 -0700 (PDT)
Subject: [iptables PATCH] iptables-nft: fix basechain policy configuration
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, pablo@netfilter.org
Date:   Fri, 02 Oct 2020 13:44:36 +0200
Message-ID: <160163907669.18523.7311010971070291883.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Previous to this patch, the basechain policy could not be properly configured if it wasn't
explictly set when loading the ruleset, leading to iptables-nft-restore (and ip6tables-nft-restore)
trying to send an invalid ruleset to the kernel.

CC: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 iptables/nft.c                                     |    6 +++++-
 .../testcases/nft-only/0008-basechain-policy_0     |   21 ++++++++++++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)
 create mode 100755 iptables/tests/shell/testcases/nft-only/0008-basechain-policy_0

diff --git a/iptables/nft.c b/iptables/nft.c
index 27bb98d1..f29fe5b4 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -678,7 +678,9 @@ nft_chain_builtin_alloc(const struct builtin_table *table,
 	nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain->name);
 	nftnl_chain_set_u32(c, NFTNL_CHAIN_HOOKNUM, chain->hook);
 	nftnl_chain_set_u32(c, NFTNL_CHAIN_PRIO, chain->prio);
-	nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, policy);
+	if (policy >= 0)
+		nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, policy);
+
 	nftnl_chain_set_str(c, NFTNL_CHAIN_TYPE, chain->type);
 
 	return c;
@@ -911,6 +913,8 @@ int nft_chain_set(struct nft_handle *h, const char *table,
 		c = nft_chain_new(h, table, chain, NF_DROP, counters);
 	else if (strcmp(policy, "ACCEPT") == 0)
 		c = nft_chain_new(h, table, chain, NF_ACCEPT, counters);
+	else if (strcmp(policy, "-") == 0)
+		c = nft_chain_new(h, table, chain, -1, counters);
 	else
 		errno = EINVAL;
 
diff --git a/iptables/tests/shell/testcases/nft-only/0008-basechain-policy_0 b/iptables/tests/shell/testcases/nft-only/0008-basechain-policy_0
new file mode 100755
index 00000000..61e408e8
--- /dev/null
+++ b/iptables/tests/shell/testcases/nft-only/0008-basechain-policy_0
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+[[ $XT_MULTI == *xtables-nft-multi ]] || { echo "skip $XT_MULTI"; exit 0; }
+set -e
+
+# make sure iptables-nft-restore can correctly handle basechain policies when they aren't set
+
+$XT_MULTI iptables-restore <<EOF
+*raw
+:OUTPUT - [0:0]
+:PREROUTING - [0:0]
+:neutron-linuxbri-OUTPUT - [0:0]
+:neutron-linuxbri-PREROUTING - [0:0]
+-I OUTPUT 1 -j neutron-linuxbri-OUTPUT
+-I PREROUTING 1 -j neutron-linuxbri-PREROUTING
+-I neutron-linuxbri-PREROUTING 1 -m physdev --physdev-in brq7425e328-56 -j CT --zone 4097
+-I neutron-linuxbri-PREROUTING 2 -i brq7425e328-56 -j CT --zone 4097
+-I neutron-linuxbri-PREROUTING 3 -m physdev --physdev-in tap7f101a28-1d -j CT --zone 4097
+
+COMMIT
+EOF

