From: "Ondrej Slanina" <oslanina@gmail.com>
Subject: libipq_compat not work ?
Date: Mon, 14 Sep 2009 15:17:52 +0200
Message-ID: <CA28E0E5FAF84C11B341EA8542565F4B@kerio.local>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:64139 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZINNRu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:17:50 -0400
Received: by fxm17 with SMTP id 17so822719fxm.37
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2009 06:17:53 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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


__________ Informace od ESET NOD32 Antivirus, verze databaze 4423 (20090914) __________

Tuto zpravu proveril ESET NOD32 Antivirus.

http://www.eset.cz



