From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024 entries,
 dropping packets(s). Dropped: 582) - bug or just some defaults increase required?
Date: Mon, 09 Feb 2009 12:20:22 +0100
Message-ID: <49901176.6020502@netfilter.org>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com> <498E3693.6030702@netfilter.org> <200902091556.25407.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080409090508060702020803"
Cc: netfilter-devel@vger.kernel.org
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47642 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753065AbZBILUs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:20:48 -0500
In-Reply-To: <200902091556.25407.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080409090508060702020803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Anton wrote:
> Pablo,
> 
> Just a little more thought, this happened when my 
> application attempted to create a NEW queue, while in 
> kernel packet queue overrun situation. And after calling 
> the nfq_create_queue there was no return from it, and only 
> error message generation in the loop inside the 
> libnetfilter_queue library. Looks like not a very proper 
> behaviour. Am I missing something?

Oh I see, I did not get the point initially. Does this patch fix the
problem?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------080409090508060702020803
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 9e4903b..ec17595 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -141,7 +141,7 @@ __build_send_cfg_msg(struct nfq_handle *h, u_int8_t command,
 	cmd.pf = htons(pf);
 	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_CMD, &cmd, sizeof(cmd));
 
-	return nfnl_talk(h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
+	return nfnl_query(h->nfnlh, &u.nmh);
 }
 
 static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
@@ -553,7 +553,7 @@ int nfq_set_mode(struct nfq_q_handle *qh,
 	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_PARAMS, &params,
 			sizeof(params));
 
-	return nfnl_talk(qh->h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
+	return nfnl_query(qh->h->nfnlh, &u.nmh);
 }
 
 /**
@@ -581,7 +581,7 @@ int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
 	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_QUEUE_MAXLEN, &queue_maxlen,
 			sizeof(queue_maxlen));
 
-	return nfnl_talk(qh->h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
+	return nfnl_query(qh->h->nfnlh, &u.nmh);
 }
 
 /**

--------------080409090508060702020803--
