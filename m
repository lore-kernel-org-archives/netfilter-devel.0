From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] build: bump library versioning
Date: Wed, 16 Sep 2015 20:49:39 +0200
Message-ID: <20150916184939.GA14450@salvia>
References: <1442423567-12120-1-git-send-email-jengelh@inai.de>
 <20150916172836.GA29575@salvia>
 <20150916180048.GA4886@salvia>
 <20150916182251.GA3346@salvia>
 <alpine.LSU.2.20.1509162031310.13589@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49512 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbbIPSnD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Sep 2015 14:43:03 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1509162031310.13589@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 16, 2015 at 08:31:47PM +0200, Jan Engelhardt wrote:
> On Wednesday 2015-09-16 20:22, Pablo Neira Ayuso wrote:
> >On Wed, Sep 16, 2015 at 08:00:48PM +0200, Pablo Neira Ayuso wrote:
> >> On Wed, Sep 16, 2015 at 07:28:36PM +0200, Pablo Neira Ayuso wrote:
> >[...]
> >> Sorry, what you propose is fine actually. But this should be
> >> LIBNFTNL_3 instead, I already bumped LIBVERSION from 2:0:2 to 3:0:3,
> >> see 9e1e8052025fde.
> >> 
> >> If no concerns, I'll mangle your patch to make use LIBNFTNL_3 instead.
> >
> >I think your LIBNFTNL_4 is intentional, now we're at 3:0:3 after
> >1.0.4, so to escape the current situation upcoming libnftnl-1.0.5
> >should be 4:0:0, hence the LIBNFTNL_4 in the map file.
> 
> "Yes" again :)

I'm attaching your original patch, but I also included the LIBVERSION
update into it.

If no further concerns, I'll be releasing libnftnl 1.0.5 soon, thanks.

--Q68bSM7Ycu6FN28Q
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-build-bump-library-versioning.patch"

>From 5a36269fd23c8e2905305dbe86404b59d5c76308 Mon Sep 17 00:00:00 2001
From: Jan Engelhardt <jengelh@inai.de>
Date: Wed, 16 Sep 2015 19:12:47 +0200
Subject: [PATCH libnftnl] build: bump library versioning

Commit libnftnl-1.0.3-31-g5ea54b2 removed a symbol. Such requires a
bumped to n+1:0:0. The symbol groups can be merged again to save time
processing them as the groups are relative to a particular SONAME
(of which we have a new one).

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Make_global.am   |    2 +-
 src/libnftnl.map |   14 ++------------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 14ddeef..6720d28 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -18,7 +18,7 @@
 # set age to 0.
 # </snippet>
 #
-LIBVERSION=3:0:3
+LIBVERSION=4:0:0
 
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_srcdir}/include ${LIBMNL_CFLAGS} ${LIBMXML_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS} ${GCC_FVISIBILITY_HIDDEN}
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 14ec88c..991fe9d 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -1,4 +1,4 @@
-LIBNFTNL_1.0 {
+LIBNFTNL_4 {
 global:
   nft_table_alloc;
   nft_table_free;
@@ -397,10 +397,6 @@ global:
   nftnl_parse_perror;
 
 
-local: *;
-};
-
-LIBNFTNL_1.1 {
   nft_table_attr_set_data;
   nft_table_attr_get_data;
   nft_chain_attr_set_data;
@@ -423,9 +419,6 @@ LIBNFTNL_1.1 {
   nftnl_set_set_data;
   nftnl_set_get_data;
 
-} LIBNFTNL_1.0;
-
-LIBNFTNL_1.2 {
   nft_set_elems_nlmsg_build_payload_iter;
   nft_batch_is_supported;
   nft_batch_begin;
@@ -469,9 +462,6 @@ LIBNFTNL_1.2 {
   nftnl_gen_fprintf;
 
 
-} LIBNFTNL_1.1;
-
-LIBNFTNL_1.2.0 {
   nft_ruleset_ctx_is_set;
   nft_ruleset_ctx_get;
   nft_ruleset_ctx_get_u32;
@@ -506,4 +496,4 @@ LIBNFTNL_1.2.0 {
   nftnl_batch_iovec_len;
   nftnl_batch_iovec;
 
-} LIBNFTNL_1.2;
+};
-- 
1.7.10.4


--Q68bSM7Ycu6FN28Q--
