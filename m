From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/13] src: avoid using deprecated unspecified argument lists
Date: Sat, 23 Oct 2010 07:44:39 +0200
Message-ID: <1287812691-14470-3-git-send-email-jengelh@medozas.de>
References: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55088 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab0JWFpA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 01:45:00 -0400
In-Reply-To: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 examples/netfilter/nfct-event.c |    2 +-
 examples/rtnl/rtnl-link-dump.c  |    2 +-
 examples/rtnl/rtnl-link-dump2.c |    2 +-
 examples/rtnl/rtnl-link-dump3.c |    2 +-
 examples/rtnl/rtnl-link-event.c |    2 +-
 examples/rtnl/rtnl-route-dump.c |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/examples/netfilter/nfct-event.c b/examples/netfilter/nfct-event.c
index c713946..3a87071 100644
--- a/examples/netfilter/nfct-event.c
+++ b/examples/netfilter/nfct-event.c
@@ -205,7 +205,7 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-int main()
+int main(void)
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
diff --git a/examples/rtnl/rtnl-link-dump.c b/examples/rtnl/rtnl-link-dump.c
index d47d32e..76e6c2c 100644
--- a/examples/rtnl/rtnl-link-dump.c
+++ b/examples/rtnl/rtnl-link-dump.c
@@ -66,7 +66,7 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-int main()
+int main(void)
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
diff --git a/examples/rtnl/rtnl-link-dump2.c b/examples/rtnl/rtnl-link-dump2.c
index 8189e7c..d8da121 100644
--- a/examples/rtnl/rtnl-link-dump2.c
+++ b/examples/rtnl/rtnl-link-dump2.c
@@ -57,7 +57,7 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-int main()
+int main(void)
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
diff --git a/examples/rtnl/rtnl-link-dump3.c b/examples/rtnl/rtnl-link-dump3.c
index d8cacb4..ccfc8a1 100644
--- a/examples/rtnl/rtnl-link-dump3.c
+++ b/examples/rtnl/rtnl-link-dump3.c
@@ -57,7 +57,7 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-int main()
+int main(void)
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
diff --git a/examples/rtnl/rtnl-link-event.c b/examples/rtnl/rtnl-link-event.c
index 4aa11ef..83c516c 100644
--- a/examples/rtnl/rtnl-link-event.c
+++ b/examples/rtnl/rtnl-link-event.c
@@ -65,7 +65,7 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-int main()
+int main(void)
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
diff --git a/examples/rtnl/rtnl-route-dump.c b/examples/rtnl/rtnl-route-dump.c
index 22395c4..7e86017 100644
--- a/examples/rtnl/rtnl-route-dump.c
+++ b/examples/rtnl/rtnl-route-dump.c
@@ -196,7 +196,7 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-int main()
+int main(void)
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-- 
1.7.1

