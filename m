From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: Re: how to update payload using QUEUE
Date: Mon, 10 Nov 2008 09:58:59 +0300
Message-ID: <1189733016.20081110095859@yandex.ru>
References: <c813aacf0811091503u26425f2fw368689d7d0ea6d6b@mail.gmail.com>
Reply-To: Kuzin Andrey <kuzinandrey@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.mjkmail.ru ([212.45.5.115]:57608 "HELO mail.mjkmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753217AbYKJHF0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:05:26 -0500
In-Reply-To: <c813aacf0811091503u26425f2fw368689d7d0ea6d6b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

OD> I am trying to use netfilter QUEUE to process IP payload in
OD> user-space. So far I have successfully retrived the packet (payload),
OD> done with my processing but I don't know how to put it back (modified
OD> payload) back to original outbound packet.
OD> this is what I have tried:
OD> --------------
OD> len  = nfq_get_payload(tb, &payload);
OD> if (len >>= 0 ) {
OD>     new_len = process_payload(payload, *newPayload, len);
OD>    //trying memcpy
OD>    memcpy(payload, newPayload, len);
OD>    pkt->ip->check = 0;
OD>    free(newPayload);
OD> }
OD> return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
OD> --------------
OD> I tried using memcpy() to copy new payload data to existing, but I
OD> think that is being done on user space only. or do  I need to call
OD> some nfa_set.. function ?
OD> I will be glad if someone could point me to right direction.

OD> Thank you,

Cut from libnetfilter_queue.c
================================
int nfq_set_verdict(struct nfq_q_handle *qh, u_int32_t id,
                u_int32_t verdict, u_int32_t data_len,
                unsigned char *buf)
================================

You call this function in this way:
return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);

I think right function call:
===================
ret = nfq_set_verdict(qh, id, NF_ACCEPT, new_len, newPayload);
free(newPayload);
return ret;
===================
and my be without any memcpy()

Try this...




