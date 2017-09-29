From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/2] main: Flush output from nft_gmp_print()
Date: Fri, 29 Sep 2017 13:26:21 +0200
Message-ID: <20170929112622.11686-2-phil@nwl.cc>
References: <20170929112622.11686-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:37562 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751590AbdI2L0j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2017 07:26:39 -0400
In-Reply-To: <20170929112622.11686-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds a missing call to fflush() to nft_gmp_print() just like in
nft_print(). This is strictly not necessary since usually
nft_gmp_print() is followed by a call to nft_print() but better not rely
upon this assumption.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/main.c b/src/main.c
index 079a05b80e511..6d2422ffeccf9 100644
--- a/src/main.c
+++ b/src/main.c
@@ -403,6 +403,7 @@ int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
 	va_start(arg, fmt);
 	ret = gmp_vfprintf(octx->output_fp, fmt, arg);
 	va_end(arg);
+	fflush(octx->output_fp);
 
 	return ret;
 }
-- 
2.13.1

