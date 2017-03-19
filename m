From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH libnetfilter_cthelper] examples: fix double free in nftc-helper-add
Date: Sun, 19 Mar 2017 22:01:10 +0800
Message-ID: <1489932070-57299-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:45409 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751463AbdCSOtA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Mar 2017 10:49:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

After inputting the following test command, core dump happened:
  # ./examples/nfct-helper-add test 1
  *** Error in
 `.../libnetfilter_cthelper/examples/.libs/lt-nfct-helper-add':
  double free or corruption (fasttop): 0x0000000001f3c070 ***
  ======= Backtrace: =========
  /lib64/libc.so.6(+0x77de5)[0x7fd9ebe88de5]
  /lib64/libc.so.6(+0x8022a)[0x7fd9ebe9122a]
  /lib64/libc.so.6(cfree+0x4c)[0x7fd9ebe9478c]
  [...]

Because "struct nfct_helper_policy *p" had been freed by nfct_helper_free,
so there's no need to invoke nfct_helper_policy_free again, otherwise
dobule free error will happen.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 examples/nfct-helper-add.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/examples/nfct-helper-add.c b/examples/nfct-helper-add.c
index 6c47626..cb7291e 100644
--- a/examples/nfct-helper-add.c
+++ b/examples/nfct-helper-add.c
@@ -32,6 +32,7 @@ int main(int argc, char *argv[])
 	nfct_helper_attr_set_u16(nfct_helper, NFCTH_ATTR_PROTO_L3NUM, AF_INET);
 	nfct_helper_attr_set_u8(nfct_helper, NFCTH_ATTR_PROTO_L4NUM, IPPROTO_TCP);
 
+	/* Will be freed by nfct_helper_free. */
 	p = nfct_helper_policy_alloc();
 	if (p == NULL) {
 		perror("OOM");
@@ -49,7 +50,6 @@ int main(int argc, char *argv[])
 	nfct_helper_nlmsg_build_payload(nlh, nfct_helper);
 
 	nfct_helper_free(nfct_helper);
-	nfct_helper_policy_free(p);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
-- 
2.5.5


