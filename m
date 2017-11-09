From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] libnftables: Flush iface cache after command execution
Date: Thu,  9 Nov 2017 13:24:57 +0100
Message-ID: <20171109122457.25190-1-phil@nwl.cc>
References: <20171108234747.GD1788@salvia>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:34270 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754475AbdKIMZK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2017 07:25:10 -0500
In-Reply-To: <20171108234747.GD1788@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit 94a945ffa81b7 ("libnftables: Get rid of explicit cache flushes")
was a bit too optimistic in that it missed the remaining need to flush
interface cache after each command in interactive mode - otherwise,
newly added interfaces won't be recognized.

Although cli.c only calls nft_run_cmd_from_buffer(), flush caches in
nft_run_cmd_from_filename() as well for matters of consistency.

Fixes: 94a945ffa81b7 ("libnftables: Get rid of explicit cache flushes")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/libnftables.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/libnftables.c b/src/libnftables.c
index 0d04ec21d57d3..dc6a5fdf32640 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -290,6 +290,7 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, char *buf, size_t buflen)
 	erec_print_list(&nft->output, &msgs, nft->debug_mask);
 	nft_ctx_set_output(nft, fp);
 	scanner_destroy(scanner);
+	iface_cache_release();
 
 	return rc;
 }
@@ -322,6 +323,7 @@ err:
 	erec_print_list(&nft->output, &msgs, nft->debug_mask);
 	nft_ctx_set_output(nft, fp);
 	scanner_destroy(scanner);
+	iface_cache_release();
 
 	return rc;
 }
-- 
2.13.1

