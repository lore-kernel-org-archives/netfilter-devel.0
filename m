From: Guillaume Nault <g.nault@alphalink.fr>
Subject: [PATCH libmnl] callback: mark cb_ctl_array 'const' in mnl_cb_run2()
Date: Wed, 3 Aug 2016 12:52:34 +0200
Message-ID: <20160803105234.bmmyt2ikq4cuqknr@alphalink.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zimbra.alphalink.fr ([217.15.80.77]:35041 "EHLO
	zimbra.alphalink.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674AbcHCLaD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Aug 2016 07:30:03 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id BAA482B52069
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Aug 2016 12:52:35 +0200 (CEST)
Received: from zimbra.alphalink.fr ([127.0.0.1])
	by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id KbO0_dzG_vqi for <netfilter-devel@vger.kernel.org>;
	Wed,  3 Aug 2016 12:52:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id 7AA9D2B52091
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Aug 2016 12:52:34 +0200 (CEST)
Received: from zimbra.alphalink.fr ([127.0.0.1])
	by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id hHk488khHY_0 for <netfilter-devel@vger.kernel.org>;
	Wed,  3 Aug 2016 12:52:34 +0200 (CEST)
Received: from c-dev-0.admin.alphalink.fr (94-84-15-217.reverse.alphalink.fr [217.15.84.94])
	by zimbra.alphalink.fr (Postfix) with ESMTP id 547CA2B52069
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Aug 2016 12:52:34 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Users of mnl_cb_run2() would typically pass a 'static const' array as
cb_ctl_array parameter. Unfortunately this triggers a compiler warning
because the prototype doesn't declare cb_ctl_array with the 'const'
qualifier.

Since mnl_cb_run2() and __mnl_cb_run() don't modify cb_ctl_array (and
don't have any reason to do so in the future), we can mark this
parameter as 'const'.

There should be no impact on existing users beyond removing the
compiler warning when using a constant array.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
---
 include/libmnl/libmnl.h | 3 ++-
 src/callback.c          | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 5adb13c..0331da7 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -179,7 +179,8 @@ extern int mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
 
 extern int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
 		       unsigned int portid, mnl_cb_t cb_data, void *data,
-		       mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len);
+		       const mnl_cb_t *cb_ctl_array,
+		       unsigned int cb_ctl_array_len);
 
 /*
  * other declarations
diff --git a/src/callback.c b/src/callback.c
index 00ffcf4..01181e6 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -48,7 +48,7 @@ static const mnl_cb_t default_cb_array[NLMSG_MIN_TYPE] = {
 static inline int __mnl_cb_run(const void *buf, size_t numbytes,
 			       unsigned int seq, unsigned int portid,
 			       mnl_cb_t cb_data, void *data,
-			       mnl_cb_t *cb_ctl_array,
+			       const mnl_cb_t *cb_ctl_array,
 			       unsigned int cb_ctl_array_len)
 {
 	int ret = MNL_CB_OK, len = numbytes;
@@ -130,7 +130,7 @@ out:
 EXPORT_SYMBOL(mnl_cb_run2);
 int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
 		unsigned int portid, mnl_cb_t cb_data, void *data,
-		mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len)
+		const mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len)
 {
 	return __mnl_cb_run(buf, numbytes, seq, portid, cb_data, data,
 			    cb_ctl_array, cb_ctl_array_len);
-- 
2.8.1

