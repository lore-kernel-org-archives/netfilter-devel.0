From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024 	entries,
 dropping packets(s). Dropped: 582) - bug or just some defaults 	increase
 required?
Date: Tue, 17 Feb 2009 18:15:36 +0100
Message-ID: <499AF0B8.5060202@netfilter.org>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com>	 <200902121545.16590.anton.vazir@gmail.com>	 <4996FBBE.20009@netfilter.org>	 <200902161819.27630.anton.vazir@gmail.com>	 <49996D49.9050606@netfilter.org>	 <c4b050a10902160638s231bd34by7e90f320dde3e27e@mail.gmail.com>	 <49998504.9020004@netfilter.org>	 <c4b050a10902160733y605a5cc1l710596b0aa658f5d@mail.gmail.com>	 <c4b050a10902160741i6d7a42deqaa41f9e22bdc4484@mail.gmail.com> <c4b050a10902170858j698c32c3ye6c58682911c59eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060404010402080009010707"
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Vitaly Bodzhgua <vitaly@eastera.tj>
To: Anton VG <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37206 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752690AbZBQRPq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:15:46 -0500
In-Reply-To: <c4b050a10902170858j698c32c3ye6c58682911c59eb@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060404010402080009010707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Anton VG wrote:
> Pablo,
> A little update, just tried non-patched variant with blocking, the
> only difference is - it generated ERROR only once and hanged (waiting
> for data)
> Any update from you?

Yes, I got a trace of the problem (with blocking behaviour):

userspace                       kernelspace
create queue (seq=x) --->
add iptables rule    --->
                     <--- (seq=0) packet sent
verdict (seq=x+1)    --->
                     <--- (seq=0) packet sent
verdict (seq=x+2)    --->
                     <--- (seq=x) ACK message

Then, it hits EILSEQ. The patch attached applies to libnfnetlink, it
sets the sequence number for messages if we expect to receive an answer
from kernelspace. With it, I can hit ENOBUFS (that's normal), but not
EILSEQ anymore.

With non-blocking behaviour, you may still hit EILSEQ (even with the
patch applied) since the current API does not allow non-blocking queue
creation.

BTW, why don't open one socket handler per queue? That will reduce the
chances to hit ENOBUFS. Now the problem for you would be that you'll
have a lot of descriptors in userspace to handle (probably select() is
not the best choice anymore) but more netlink bandwidth in return.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------060404010402080009010707
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/src/libnfnetlink.c b/src/libnfnetlink.c
index d4212f9..5cfe2f5 100644
--- a/src/libnfnetlink.c
+++ b/src/libnfnetlink.c
@@ -418,7 +418,11 @@ void nfnl_fill_hdr(struct nfnl_subsys_handle *ssh,
 	nlh->nlmsg_type = (ssh->subsys_id<<8)|msg_type;
 	nlh->nlmsg_flags = msg_flags;
 	nlh->nlmsg_pid = 0;
-	nlh->nlmsg_seq = ++ssh->nfnlh->seq;
+	/* set sequence number if we expect an answer from kernelspace */
+	if (msg_flags & (NLM_F_ACK | NLM_F_ECHO | NLM_F_DUMP))
+		nlh->nlmsg_seq = ++ssh->nfnlh->seq;
+	else
+		nlh->nlmsg_seq = 0;
 
 	/* check for wraparounds: assume that seqnum 0 is only used by events */
 	if (!ssh->nfnlh->seq)

--------------060404010402080009010707--
