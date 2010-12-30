From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/4] utils: resolve compiler warnings
Date: Fri, 31 Dec 2010 00:42:15 +0100
Message-ID: <1293752536-13491-5-git-send-email-jengelh@medozas.de>
References: <1293752536-13491-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43799 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab0L3XmW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:42:22 -0500
In-Reply-To: <1293752536-13491-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

make  nfulnl_test ulog_test
make[1]: Entering directory `/home/jengelh/code/libnetfilter_log/utils'
  CC     nfulnl_test.o
nfulnl_test.c: In function "cb":
nfulnl_test.c:47:1: warning: no return statement in function returning =
non-void
nfulnl_test.c: In function "main":
nfulnl_test.c:102:20: warning: unused variable "nlh"
  CCLD   nfulnl_test
  CC     ulog_test.o
ulog_test.c: In function "handle_packet":
ulog_test.c:27:9: warning: format "%d" expects type =E2=80=98int=E2=80=99=
, but argument 4 has type =E2=80=98size_t=E2=80=99
ulog_test.c: In function "main":
ulog_test.c:79:3: warning: suggest parentheses around assignment used a=
s truth value
  CCLD   ulog_test
make[1]: Leaving directory `/home/jengelh/code/libnetfilter_log/utils'

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 utils/nfulnl_test.c |    4 ++--
 utils/ulog_test.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/utils/nfulnl_test.c b/utils/nfulnl_test.c
index 139013d..ae5da79 100644
--- a/utils/nfulnl_test.c
+++ b/utils/nfulnl_test.c
@@ -44,6 +44,7 @@ static int cb(struct nflog_g_handle *gh, struct nfgen=
msg *nfmsg,
 		struct nflog_data *nfa, void *data)
 {
 	print_pkt(nfa);
+	return 0;
 }
=20
=20
@@ -99,7 +100,6 @@ int main(int argc, char **argv)
=20
 	printf("going into main loop\n");
 	while ((rv =3D recv(fd, buf, sizeof(buf), 0)) && rv >=3D 0) {
-		struct nlmsghdr *nlh;
 		printf("pkt received (len=3D%u)\n", rv);
=20
 		/* handle messages in just-received packet */
@@ -121,5 +121,5 @@ int main(int argc, char **argv)
 	printf("closing handle\n");
 	nflog_close(h);
=20
-	exit(0);
+	return EXIT_SUCCESS;
 }
diff --git a/utils/ulog_test.c b/utils/ulog_test.c
index d568aa4..f3adec2 100644
--- a/utils/ulog_test.c
+++ b/utils/ulog_test.c
@@ -23,7 +23,7 @@ void handle_packet(ulog_packet_msg_t *pkt)
 	unsigned char *p;
 	int i;
 =09
-	printf("Hook=3D%u Mark=3D%lu len=3D%d ",
+	printf("Hook=3D%u Mark=3D%lu len=3D%zu ",
 	       pkt->hook, pkt->mark, pkt->data_len);
 	if (strlen(pkt->prefix))
 		printf("Prefix=3D%s ", pkt->prefix);
@@ -76,7 +76,7 @@ int main(int argc, char *argv[])
 			exit(1);
 		}
 		printf("%d bytes received\n", len);
-		while (upkt =3D ipulog_get_packet(h, buf, len)) {
+		while ((upkt =3D ipulog_get_packet(h, buf, len)) !=3D NULL) {
 			handle_packet(upkt);
 		}
 	}
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
