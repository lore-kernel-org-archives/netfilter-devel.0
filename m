From: "Ondrej Slanina" <oslanina@gmail.com>
Subject: Re: libipq_compat not work ?
Date: Mon, 14 Sep 2009 17:47:56 +0200
Message-ID: <09853F7CBDC04312ABC7E869B2E967F3@kerio.local>
References: <4AAE532C.1010100@nitrosecurity.com> <2af341ab0909140734g4ac9a696o4fb54a1827edd02c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41209 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbZINPrz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:47:55 -0400
Received: by bwz19 with SMTP id 19so2173955bwz.37
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2009 08:47:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
thanks for response. In my code I can use it, but as I said, I tried to 
compile Snort inline which is third - party software and which is still 
depended on libipq. And I think that we can find more old software which 
depends on libipq. I only want to know, if I just missed something or if 
I'am doing something wrong or if it's not implemented yet.
Best regards,
Ondra



----- Original Message ----- 
From: Dave Remien
To: Ondrej Slanina
Sent: Monday, September 14, 2009 4:34 PM
Subject: Fwd: libipq_compat not work ?


Hello!


Just at a question, why not use nfnetlink_queue natively, instead of the 
libipq way (which really is a "compatibility" layer on top of nfqueue since 
2.6.14)?
IIRC, nfqueue is the default set in the configure script.


Regards,


Dave




+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Hi,
I just tried to compile Snort inline version on Ubuntu and I think that
compatibility layer over new libnetfilter_queue is not working. Maybe I'am
doing something wrong but I also tried to make a simple sample app and it's
not working too :-( I used libnetfilter_queue-0.0.17 and libnfnetlink-1.0.0
on clean Ubuntu 8.04 LTS x86 with kernel 2.6.24-23-generic
Here are my notes:

1. libipq_compat.c, line 172 (ipq_read)
some function named ipq_netlink_recvfrom is commented out ? How can be
packet received ? Next piece of code just parse some data, check family and
parse attributes. In all cases it return 0 which means that timeout or
signal occured. OK, I can probably call nfq_fd and recv() but I think that
it have to be implemented directly in compat code.

2. libipq_compat.c, line 172 (ipq_create_handle)
   - nfq_open -> nfq_bind_pf -> nfq_create_queue
   This is OK, but when destroing ipq handle by ipq_destroy_handle only
nfq_close is called (not nfq_unbind_pf and nfq_destroy_queue) You can't
start the same app again -> error while binding

3. nfqnl_test.c , line 92
   I think that is not a good idea to exit after unsuccessful call to
nfq_unbind_pf() because no binding is available while you are running app
for the first time


Thanks for your response,
Ondra


BTW nfqnl_test which uses new API works fine...


__________ Informace od ESET NOD32 Antivirus, verze databaze 4423 (20090914) 
__________

Tuto zpravu proveril ESET NOD32 Antivirus.

http://www.eset.cz



--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" 
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
.

This e-mail message and any attachments contain information that is 
confidential and may be privileged.  If the reader of this e-mail is not the 
intended recipient, you are hereby notified that any dissemination, 
distribution or copying of this communication is strictly prohibited.  If 
you have received this communication in error, please immediately notify us 
by replying to this message or by sending an email to 
postmaster@nitrosecurity.com, and destroy all copies of this message and any 
attachments without reading or disclosing them.  Thank you.





-- 
"Of course, someone who knows more about this will correct me if I'm
wrong, and someone who knows less will correct me if I'm right."
David Palmer (palmer@tybalt.caltech.edu) 


__________ Informace od ESET NOD32 Antivirus, verze databaze 4424 (20090914) __________

Tuto zpravu proveril ESET NOD32 Antivirus.

http://www.eset.cz



