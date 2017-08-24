From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATH nft v2 15/18] libnftables: set max_errors to 1 in library
Date: Thu, 24 Aug 2017 18:02:08 +0200
Message-ID: <20170824160208.GA29786@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-16-eric@regit.org>
 <20170821083746.GI2982@salvia>
 <1503342769.9868.9.camel@regit.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:58592 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753142AbdHXQCe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 12:02:34 -0400
Content-Disposition: inline
In-Reply-To: <1503342769.9868.9.camel@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Aug 21, 2017 at 09:12:49PM +0200, Eric Leblond wrote:
[...]
> On Mon, 2017-08-21 at 10:37 +0200, Pablo Neira Ayuso wrote:
[...]
> > > diff --git a/src/libnftables.c b/src/libnftables.c
> > > index 61ed4e5..15345ae 100644
> > > --- a/src/libnftables.c
> > > +++ b/src/libnftables.c
> > > @@ -25,7 +25,7 @@
> > >  #include <fcntl.h>
> > >  
> > >  
> > > -unsigned int max_errors = 10;
> > > +unsigned int max_errors = 1;
> > 
> > This is defeating all the work I've done - both in netlink and in
> > userspace - in the past to allow printing several errors in one go.
> > So
> > you likely understand I'm reticent to take this as is :-)
> 
> For sure, I was just trying to get you excited so you decide to cook a
> patch fixing this :P

Not sure it's excitement exactly what I'm feeling here... but I'm
trying to help, believe it or not... ;-)

I'm placing the nft_global_init() and nft_global_deinit() into
nft_ctx_new() and nft_ctx_free() as we've been discussing.

I'm going to stop here for a while. There are still a few pending
issues, and I would like we don't release anything until we discuss
all concerns.

You mentioned about some set issues, please us know. I also want to
think what you would need for the simple API in the exportation and
monitor cases.

Thanks.

--ikeVEW9yuYc//A+q
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-src-call-nft_init-and-nft_exit-from-context-routines.patch"

>From fc55891c99890a1ac65436d78b7b12cd5f63d57d Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 24 Aug 2017 17:56:38 +0200
Subject: [PATCH] src: call nft_init() and nft_exit() from context routines

So we don't forget all these caches should be placed into struct
nft_ctx.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/src/main.c b/src/main.c
index 08296a6b57dc..fd16f0145f6c 100644
--- a/src/main.c
+++ b/src/main.c
@@ -259,7 +259,7 @@ err1:
 	return ret;
 }
 
-void nft_init(void)
+static void nft_init(void)
 {
 	mark_table_init();
 	realm_table_rt_init();
@@ -272,7 +272,7 @@ void nft_init(void)
 #endif
 }
 
-void nft_exit(void)
+static void nft_exit(void)
 {
 	ct_label_table_exit();
 	realm_table_rt_exit();
@@ -285,6 +285,7 @@ static struct nft_ctx *nft_ctx_new(void)
 {
 	struct nft_ctx *ctx;
 
+	nft_init();
 	ctx = xzalloc(sizeof(struct nft_ctx));
 
 	ctx->include_paths[0]	= DEFAULT_INCLUDE_PATH;
@@ -300,6 +301,7 @@ static void nft_ctx_free(const struct nft_ctx *ctx)
 	iface_cache_release();
 	cache_release(&nft->cache);
 	xfree(ctx);
+	nft_exit();
 }
 
 static int nft_run_cmd_from_buffer(struct nft_ctx *nft,
@@ -363,8 +365,6 @@ int main(int argc, char * const *argv)
 	int i, val, rc = NFT_EXIT_SUCCESS;
 	struct mnl_socket *nf_sock;
 
-	nft_init();
-
 	nft = nft_ctx_new();
 
 	nf_sock = netlink_open_sock();
@@ -480,7 +480,6 @@ int main(int argc, char * const *argv)
 	xfree(buf);
 	netlink_close_sock(nf_sock);
 	nft_ctx_free(nft);
-	nft_exit();
 
 	return rc;
 }
-- 
2.1.4


--ikeVEW9yuYc//A+q--
