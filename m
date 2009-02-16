From: Anton VG <anton.vazir@gmail.com>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024
	entries, dropping packets(s). Dropped: 582) - bug or just some defaults
	increase required?
Date: Mon, 16 Feb 2009 20:41:25 +0500
Message-ID: <c4b050a10902160741i6d7a42deqaa41f9e22bdc4484@mail.gmail.com>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com>
	 <200902121545.16590.anton.vazir@gmail.com>
	 <4996FBBE.20009@netfilter.org>
	 <200902161819.27630.anton.vazir@gmail.com>
	 <49996D49.9050606@netfilter.org>
	 <c4b050a10902160638s231bd34by7e90f320dde3e27e@mail.gmail.com>
	 <49998504.9020004@netfilter.org>
	 <c4b050a10902160733y605a5cc1l710596b0aa658f5d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Vitaly Bodzhgua <vitaly@eastera.tj>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:58116 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZBPPl1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:41:27 -0500
Received: by bwz5 with SMTP id 5so3171696bwz.13
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Feb 2009 07:41:25 -0800 (PST)
In-Reply-To: <c4b050a10902160733y605a5cc1l710596b0aa658f5d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>From the fcntl MAN page

If the O_NONBLOCK flag is not enabled, then  system  call
is  blocked  until the lock is removed or converted to a mode that is
compatible with the access.

So, just to clarify, that commenting out the non-blocking fcntl - does
not solve the problem, Error persists.

2009/2/16 Anton VG <anton.vazir@gmail.com>:
> The same stuff with commented out
>
> // fcntl(nfqfd,F_SETFL,O_NONBLOCK);
>>
>> With the current interface of libnetfilter_queue, the queue creation must be
>> blocking to ensure serialization. I'll document this. I can add some
>> functions to allow non-blocking queue creation but that's a different point.
