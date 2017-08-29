From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH] examples: Fix memory leaks detected by Valgrind
Date: Tue, 29 Aug 2017 18:19:36 +0530
Message-ID: <1504010976-13897-1-git-send-email-mayhs11saini@gmail.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34357 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdH2Mt4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2017 08:49:56 -0400
Received: by mail-pg0-f68.google.com with SMTP id 63so2663763pgc.1
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2017 05:49:56 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

==11688== HEAP SUMMARY:
==11688==     in use at exit: 40 bytes in 1 blocks
==11688==   total heap usage: 7 allocs, 6 frees, 220 bytes allocated
==11688==
==11688== 40 bytes in 1 blocks are definitely lost in loss record 1 of 1
==11688==    at 0x4C2AB80: malloc (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==11688==    by 0x5068955: mnl_nlmsg_batch_start (nlmsg.c:441)
==11688==    by 0x40133B: main (nft-chain-add.c:103)
==11688==
==11688== LEAK SUMMARY:
==11688==    definitely lost: 40 bytes in 1 blocks
==11688==    indirectly lost: 0 bytes in 0 blocks
==11688==      possibly lost: 0 bytes in 0 blocks
==11688==    still reachable: 0 bytes in 0 blocks
==11688==         suppressed: 0 bytes in 0 blocks

==11831== HEAP SUMMARY:
==11831==     in use at exit: 40 bytes in 1 blocks
==11831==   total heap usage: 7 allocs, 6 frees, 220 bytes allocated
==11831==
==11831== 40 bytes in 1 blocks are definitely lost in loss record 1 of 1
==11831==    at 0x4C2AB80: malloc (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==11831==    by 0x5068955: mnl_nlmsg_batch_start (nlmsg.c:441)
==11831==    by 0x401154: main (nft-chain-del.c:79)
==11831==
==11831== LEAK SUMMARY:
==11831==    definitely lost: 40 bytes in 1 blocks
==11831==    indirectly lost: 0 bytes in 0 blocks
==11831==      possibly lost: 0 bytes in 0 blocks
==11831==    still reachable: 0 bytes in 0 blocks
==11831==         suppressed: 0 bytes in 0 blocks

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 examples/nft-chain-add.c       | 2 ++
 examples/nft-chain-del.c       | 2 ++
 examples/nft-chain-parse-add.c | 4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/examples/nft-chain-add.c b/examples/nft-chain-add.c
index ca1edf9e6f86..e0d889df40eb 100644
--- a/examples/nft-chain-add.c
+++ b/examples/nft-chain-add.c
@@ -138,6 +138,8 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}

+	mnl_nlmsg_batch_stop(batch);
+
 	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
 	while (ret > 0) {
 		ret = mnl_cb_run(buf, ret, chain_seq, portid, NULL, NULL);
diff --git a/examples/nft-chain-del.c b/examples/nft-chain-del.c
index b756b46f9bbd..3a43fd424eb9 100644
--- a/examples/nft-chain-del.c
+++ b/examples/nft-chain-del.c
@@ -113,6 +113,8 @@ int main(int argc, char *argv[])
 		perror("mnl_socket_send");
 		exit(EXIT_FAILURE);
 	}
+
+	mnl_nlmsg_batch_stop(batch);

 	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
 	while (ret > 0) {
diff --git a/examples/nft-chain-parse-add.c b/examples/nft-chain-parse-add.c
index 6d6d989cd81d..abb9ac4641f5 100644
--- a/examples/nft-chain-parse-add.c
+++ b/examples/nft-chain-parse-add.c
@@ -148,7 +148,9 @@ int main(int argc, char *argv[])
 		perror("mnl_socket_send");
 		exit(EXIT_FAILURE);
 	}
-
+
+	mnl_nlmsg_batch_stop(batch);
+
 	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
 	while (ret > 0) {
 		ret = mnl_cb_run(buf, ret, chain_seq, portid, NULL, NULL);
--
1.9.1

