From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables (nft-compat) PATCH 7/8] nft: A builtin chain might be created when restoring
Date: Tue, 11 Feb 2014 12:46:47 +0200
Message-ID: <1392115608-6733-8-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16550 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaBKKrJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:47:09 -0500
In-Reply-To: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft_chain_set() is directly used in xtables-restore.c, however at that
point no builtin chains have been created yet thus the need to request
to create it relevantly.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c             | 1 +
 iptables/nft.h             | 1 +
 iptables/xtables-restore.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index a58f9bd..0283d92 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -744,6 +744,7 @@ __nft_chain_set(struct nft_handle *h, const char *table,
 	}
 
 	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
+					h->restore ? NLM_F_ACK|NLM_F_CREATE :
 					NLM_F_ACK, h->seq);
 	nft_chain_nlmsg_build_payload(nlh, c);
 
diff --git a/iptables/nft.h b/iptables/nft.h
index 22af66e..8b64f8b 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -34,6 +34,7 @@ struct nft_handle {
 	struct mnl_nlmsg_batch	*batch;
 	struct nft_family_ops	*ops;
 	struct builtin_table	*tables;
+	bool			restore;
 };
 
 extern struct builtin_table xtables_ipv4[TABLES_MAX];
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 50d2935..0498abc 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -170,6 +170,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 {
 	struct nft_handle h = {
 		.family = family,
+		.restore = true,
 	};
 	char buffer[10240];
 	int c;
-- 
1.8.3.2

