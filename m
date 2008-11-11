From: "OpenSource Dev" <dev.opensource@gmail.com>
Subject: Re: how to update payload using QUEUE
Date: Mon, 10 Nov 2008 18:48:07 -0600
Message-ID: <c813aacf0811101648l169bdffne799c41d014733d9@mail.gmail.com>
References: <c813aacf0811091503u26425f2fw368689d7d0ea6d6b@mail.gmail.com>
	 <1189733016.20081110095859@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:47186 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbYKKAsL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 19:48:11 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1254998nfc.21
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2008 16:48:08 -0800 (PST)
In-Reply-To: <1189733016.20081110095859@yandex.ru>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 10, 2008 at 12:58 AM, Kuzin Andrey <kuzinandrey@yandex.ru> wrote:
> OD> I am trying to use netfilter QUEUE to process IP payload in
> OD> user-space. So far I have successfully retrived the packet (payload),
> OD> done with my processing but I don't know how to put it back (modified
> OD> payload) back to original outbound packet.
> OD> this is what I have tried:
> OD> --------------
> OD> len  = nfq_get_payload(tb, &payload);
> OD> if (len >>= 0 ) {
> OD>     new_len = process_payload(payload, *newPayload, len);
> OD>    //trying memcpy
> OD>    memcpy(payload, newPayload, len);
> OD>    pkt->ip->check = 0;
> OD>    free(newPayload);
> OD> }
> OD> return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
> OD> --------------
> OD> I tried using memcpy() to copy new payload data to existing, but I
> OD> think that is being done on user space only. or do  I need to call
> OD> some nfa_set.. function ?
> OD> I will be glad if someone could point me to right direction.
>
> OD> Thank you,
>
> Cut from libnetfilter_queue.c
> ================================
> int nfq_set_verdict(struct nfq_q_handle *qh, u_int32_t id,
>                u_int32_t verdict, u_int32_t data_len,
>                unsigned char *buf)
> ================================
>
> You call this function in this way:
> return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
>
> I think right function call:
> ===================
> ret = nfq_set_verdict(qh, id, NF_ACCEPT, new_len, newPayload);
> free(newPayload);
> return ret;
> ===================
> and my be without any memcpy()
>
> Try this...

Thank you all. It worked for me.
Now I think I am in right direction :)

However, now I am having problem with checksum. After processing
payload, I set the iphdr checksum value to 0 hoping system would
automatically compute the check sum but it is not. Tcpdump shows "bad
checksum" value (0).

Or do I need to compute and set checksum manually. Ideally I would
like to offload-checksum when possible.

Looking for your suggestions.

thanks again :)

Bikrant
