From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 7/8] netlink: add socket error reporting helper function
Date: Mon, 14 Apr 2014 12:17:41 +0200
Message-ID: <20140414101741.5018.56767.stgit@nfdev.cica.es>
References: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42790 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752045AbaDNKRn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:17:43 -0400
In-Reply-To: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a simple helper function to report errors while
opening the Netlink socket.

To help users to diagnose problems, a new NFT_EXIT_NONL exit code is included,
which is 3.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 doc/nftables.xml   |    1 +
 include/netlink.h  |    1 +
 include/nftables.h |    1 +
 src/netlink.c      |   10 +++++++++-
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/doc/nftables.xml b/doc/nftables.xml
index 055d4a6..27915be 100644
--- a/doc/nftables.xml
+++ b/doc/nftables.xml
@@ -928,6 +928,7 @@
 			On success, nftables exits with a status of 0. Unspecified
 			errors cause it to exit with a status of 1, memory allocation
 			errors with a status of 2.
+			If unable to open Netlink socket, the return code is 3.
 		</para>
 	</refsect1>
 
diff --git a/include/netlink.h b/include/netlink.h
index 4e3f8aa..1fb0356 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -138,6 +138,7 @@ extern void netlink_dump_set(struct nft_set *nls);
 extern int netlink_batch_send(struct list_head *err_list);
 extern int netlink_io_error(struct netlink_ctx *ctx,
 			    const struct location *loc, const char *fmt, ...);
+extern void netlink_open_error(void) __noreturn;
 
 extern struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 						const struct handle *h,
diff --git a/include/nftables.h b/include/nftables.h
index 7f3968d..3394e32 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -39,6 +39,7 @@ enum nftables_exit_codes {
 	NFT_EXIT_SUCCESS	= 0,
 	NFT_EXIT_FAILURE	= 1,
 	NFT_EXIT_NOMEM		= 2,
+	NFT_EXIT_NONL		= 3,
 };
 
 struct input_descriptor;
diff --git a/src/netlink.c b/src/netlink.c
index 84f2b7e..5a9e42e 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -15,6 +15,7 @@
 #include <libmnl/libmnl.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
+#include <stdlib.h>
 
 #include <libnftnl/table.h>
 #include <libnftnl/chain.h>
@@ -46,7 +47,7 @@ static void __init netlink_open_sock(void)
 {
 	nf_sock = mnl_socket_open(NETLINK_NETFILTER);
 	if (nf_sock == NULL)
-		memory_allocation_error();
+		netlink_open_error();
 
 	fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK);
 	mnl_batch_init();
@@ -73,6 +74,13 @@ int netlink_io_error(struct netlink_ctx *ctx, const struct location *loc,
 	return -1;
 }
 
+void __noreturn netlink_open_error(void)
+{
+	fprintf(stderr, "E: Unable to open Netlink socket: %s\n",
+		strerror(errno));
+	exit(NFT_EXIT_NONL);
+}
+
 struct nft_table *alloc_nft_table(const struct handle *h)
 {
 	struct nft_table *nlt;

