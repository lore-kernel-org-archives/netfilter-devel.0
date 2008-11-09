From: "OpenSource Dev" <dev.opensource@gmail.com>
Subject: how to update payload using QUEUE
Date: Sun, 9 Nov 2008 17:03:09 -0600
Message-ID: <c813aacf0811091503u26425f2fw368689d7d0ea6d6b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.237]:57614 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbYKIXDL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Nov 2008 18:03:11 -0500
Received: by qb-out-0506.google.com with SMTP id f11so1295289qba.17
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Nov 2008 15:03:10 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am trying to use netfilter QUEUE to process IP payload in
user-space. So far I have successfully retrived the packet (payload),
done with my processing but I don't know how to put it back (modified
payload) back to original outbound packet.

this is what I have tried:

--------------
len  = nfq_get_payload(tb, &payload);
if (len >= 0 ) {
    new_len = process_payload(payload, *newPayload, len);

   //trying memcpy
   memcpy(payload, newPayload, len);
   pkt->ip->check = 0;
   free(newPayload);

}

return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
--------------


I tried using memcpy() to copy new payload data to existing, but I
think that is being done on user space only. or do  I need to call
some nfa_set.. function ?
I will be glad if someone could point me to right direction.

Thank you,

Bikrant
