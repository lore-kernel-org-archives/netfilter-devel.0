From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATH nft v2 11/18] libnftables: move iface_cache_release to
 deinit
Date: Thu, 24 Aug 2017 17:55:23 +0200
Message-ID: <20170824155523.GA27883@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-12-eric@regit.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:58522 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752832AbdHXPzt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 11:55:49 -0400
Content-Disposition: inline
In-Reply-To: <20170819152420.22563-12-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Attaching a revamped version of this too.

--C7zPtVaVf+AK4Oqc
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-src-release-caches-from-nft_ctx_free-path.patch"

>From 46aa88ed029b28ec15f26adddb3707148906a535 Mon Sep 17 00:00:00 2001
From: Eric Leblond <eric@regit.org>
Date: Thu, 24 Aug 2017 17:52:26 +0200
Subject: [PATCH] src: release caches from nft_ctx_free() path

Release existing caches from nft_ctx_free(). Still, the iface cache
should be good to place it in the nft_ctx structure.

Joint work with Pablo Neira.

Signed-off-by: Eric Leblond <eric@regit.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/main.c b/src/main.c
index 0cad4d2412e8..08296a6b57dc 100644
--- a/src/main.c
+++ b/src/main.c
@@ -297,6 +297,8 @@ static struct nft_ctx *nft_ctx_new(void)
 
 static void nft_ctx_free(const struct nft_ctx *ctx)
 {
+	iface_cache_release();
+	cache_release(&nft->cache);
 	xfree(ctx);
 }
 
@@ -318,7 +320,6 @@ static int nft_run_cmd_from_buffer(struct nft_ctx *nft,
 
 	scanner_destroy(scanner);
 	erec_print_list(stderr, &msgs, nft->debug_mask);
-	cache_release(&nft->cache);
 
 	return rc;
 }
@@ -347,7 +348,6 @@ static int nft_run_cmd_from_filename(struct nft_ctx *nft,
 err:
 	scanner_destroy(scanner);
 	erec_print_list(stderr, &msgs, nft->debug_mask);
-	cache_release(&nft->cache);
 
 	return rc;
 }
@@ -478,7 +478,6 @@ int main(int argc, char * const *argv)
 	}
 
 	xfree(buf);
-	iface_cache_release();
 	netlink_close_sock(nf_sock);
 	nft_ctx_free(nft);
 	nft_exit();
-- 
2.1.4


--C7zPtVaVf+AK4Oqc--
