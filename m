From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] Rename xfree() to libnftnl_xfree() to avoid
 symbol naming conflict
Date: Wed, 20 Aug 2014 00:02:36 +0200
Message-ID: <20140819220236.GA7136@salvia>
References: <1408196389-15559-1-git-send-email-thomas.petazzoni@free-electrons.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Cc: netfilter-devel@vger.kernel.org
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40295 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbaHSWCR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Aug 2014 18:02:17 -0400
Content-Disposition: inline
In-Reply-To: <1408196389-15559-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 16, 2014 at 03:39:49PM +0200, Thomas Petazzoni wrote:
> When ELF binaries and shared libraries are used, the internal
> functions of libnftnl such as xfree() are not visible to the outside
> world (their visibility is 'hidden'). Therefore, the fact that other
> programs (especially nftables) may have symbols with the same name
> does not cause any problem.
> 
> However, when doing static linking on a non-ELF platform (such as
> Blackfin, which uses the FLAT binary format), there is no way of
> encoding this visibility. Therefore, the xfree() symbols of libnftnl
> becomes visible to the outside world, causing a conflict with the
> xfree() symbol defined by nftables.
> 
> To solve this, this patch renames the libnftnl xfree() function to
> libnftnl_xfree().

Would this small patch solve your problem too?

--45Z9DzgjV8m4Oswq
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/internal.h b/src/internal.h
index e76a5cb..c8dea7e 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -16,6 +16,8 @@
 #include <libnftnl/common.h>
 #include <linux/netfilter/nf_tables.h>
 
+#define xfree(ptr)	free((void *)ptr);
+
 #define BASE_DEC 10
 #define BASE_HEX 16
 
@@ -144,8 +146,6 @@ int nft_event_footer_snprintf(char *buf, size_t bufsize,
 			      uint32_t format, uint32_t flags);
 int nft_event_footer_fprintf(FILE *fp, uint32_t format, uint32_t flags);
 
-void xfree(const void *ptr);
-
 struct expr_ops;
 
 struct nft_rule_expr {
diff --git a/src/utils.c b/src/utils.c
index 1878390..96c8bf2 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -180,11 +180,6 @@ int nft_str2verdict(const char *verdict, int *verdict_num)
 	return -1;
 }
 
-void xfree(const void *ptr)
-{
-	free((void *)ptr);
-}
-
 int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
 		int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj,
 				   uint32_t type, uint32_t flags))

--45Z9DzgjV8m4Oswq--
