From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnetfilter_queue PATCH 1/2] utils: Remove unused variable in nfqnl_test
Date: Fri,  6 Jun 2014 11:52:40 +0200
Message-ID: <1402048360-12166-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36773 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaFFJx0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2014 05:53:26 -0400
Received: by mail-wg0-f52.google.com with SMTP id l18so2537512wgh.35
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Jun 2014 02:53:24 -0700 (PDT)
Received: from localhost.localdomain (186.169.216.87.static.jazztel.es. [87.216.169.186])
        by mx.google.com with ESMTPSA id qq5sm20431753wic.10.2014.06.06.02.53.23
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Jun 2014 02:53:24 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 utils/nfqnl_test.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
index 34cb113..4decd50 100644
--- a/utils/nfqnl_test.c
+++ b/utils/nfqnl_test.c
@@ -83,7 +83,6 @@ int main(int argc, char **argv)
 {
 	struct nfq_handle *h;
 	struct nfq_q_handle *qh;
-	struct nfnl_handle *nh;
 	int fd;
 	int rv;
 	char buf[4096] __attribute__ ((aligned));
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
