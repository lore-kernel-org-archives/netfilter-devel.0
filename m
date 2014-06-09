From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnetfilter_queue PATCH 2/2 v3] utils: add the parameter queue number in nfqnl_test
Date: Mon,  9 Jun 2014 10:52:24 +0200
Message-ID: <1402303944-8402-1-git-send-email-alvaroneay@gmail.com>
References: <1402050005-14844-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:43662 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbaFIIxK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:53:10 -0400
Received: by mail-we0-f170.google.com with SMTP id u57so5544295wes.15
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Jun 2014 01:53:08 -0700 (PDT)
Received: from localhost.localdomain (186.169.216.87.static.jazztel.es. [87.216.169.186])
        by mx.google.com with ESMTPSA id pq9sm24042367wjc.35.2014.06.09.01.53.00
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jun 2014 01:53:08 -0700 (PDT)
In-Reply-To: <1402050005-14844-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

This patch allows to stablish the number of the queue that
we want to read the packets.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v3]
* I have changed the argument 1 to 0 in the error message.

 utils/nfqnl_test.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
index 4decd50..8c503f3 100644
--- a/utils/nfqnl_test.c
+++ b/utils/nfqnl_test.c
@@ -85,8 +85,17 @@ int main(int argc, char **argv)
 	struct nfq_q_handle *qh;
 	int fd;
 	int rv;
+	uint32_t queue =3D 0;
 	char buf[4096] __attribute__ ((aligned));
=20
+	if (argc =3D=3D 2) {
+		queue =3D atoi(argv[1]);
+		if (queue > 65535) {
+			fprintf(stderr, "Usage: %s [<0-65535>]\n", argv[0]);
+			exit(EXIT_FAILURE);
+		}
+	}
+
 	printf("opening library handle\n");
 	h =3D nfq_open();
 	if (!h) {
@@ -106,8 +115,8 @@ int main(int argc, char **argv)
 		exit(1);
 	}
=20
-	printf("binding this socket to queue '0'\n");
-	qh =3D nfq_create_queue(h,  0, &cb, NULL);
+	printf("binding this socket to queue '%d'\n", queue);
+	qh =3D nfq_create_queue(h,  queue, &cb, NULL);
 	if (!qh) {
 		fprintf(stderr, "error during nfq_create_queue()\n");
 		exit(1);
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
