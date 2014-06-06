From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnetfilter_queue PATCH v2] utils: add the parameter queue number in nfqnl_test
Date: Fri,  6 Jun 2014 12:20:05 +0200
Message-ID: <1402050005-14844-1-git-send-email-alvaroneay@gmail.com>
References: <1402048683-12587-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46997 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaFFKY0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:24:26 -0400
Received: by mail-wg0-f44.google.com with SMTP id a1so2579677wgh.27
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Jun 2014 03:24:24 -0700 (PDT)
Received: from localhost.localdomain (186.169.216.87.static.jazztel.es. [87.216.169.186])
        by mx.google.com with ESMTPSA id s3sm11728859wje.36.2014.06.06.03.24.22
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Jun 2014 03:24:24 -0700 (PDT)
In-Reply-To: <1402048683-12587-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

This patch allows to stablish the number of the queue that
we want to read the packets.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
* I have changed the variable queue to unsigned
* I have changed the message in case that queue > 65535 and also I have=
 used
  exit(EXIT_FAILURE) in error case.

 utils/nfqnl_test.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
index 4decd50..557db1d 100644
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
+			fprintf(stderr, "Usage: %s [<0-65535>]\n", argv[1]);
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
