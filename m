From: Tamas Lengyel <tamas.k.lengyel@gmail.com>
Subject: [PATCH] libnetfilter_queue: Fix Valgrind errors of unitialized
 byte(s) during call to nfq_unbind_pf
Date: Sat, 1 Jun 2013 00:20:57 +0200
Message-ID: <CABfawhm7V6htNehkNrf-pCSsHt-gjZCOgBhAMAoCh7UyY=rapQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:45145 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3EaWU7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 May 2013 18:20:59 -0400
Received: by mail-wg0-f47.google.com with SMTP id e11so1633112wgh.2
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2013 15:20:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Valgrind generates error reports of unitialized byte(s) during a call
to the nfq_unbind_pf function:

==00:00:00:08.662 22111== 4 errors in context 1 of 1:
==00:00:00:08.662 22111== Syscall param socketcall.sendto(msg) points
to uninitialised byte(s)
...
==00:00:00:08.662 22111== Uninitialised value was created by a stack allocation
==00:00:00:08.662 22111== at 0x679C30B: __build_send_cfg_msg
(libnetfilter_queue.c:178

The following (tiny) patch gets rid of the issue. I made the patch
available on github as well at
git://github.com/tklengyel/libnetfilter_queue.git

Signed-off-by: Tamas K Lengyel <tamas.k.lengyel@gmail.com>
---

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 2894ccd..bf944f0 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -186,6 +186,7 @@ __build_send_cfg_msg(struct nfq_handle *h, u_int8_t command,
  nfnl_fill_hdr(h->nfnlssh, &u.nmh, 0, AF_UNSPEC, queuenum,
  NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);

+ cmd._pad = 0;
  cmd.command = command;
  cmd.pf = htons(pf);
  nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_CMD, &cmd, sizeof(cmd));
