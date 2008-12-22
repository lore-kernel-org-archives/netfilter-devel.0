From: Piotr Duszynski <regis44@gmail.com>
Subject: Re: [PATCH 1/1 ] Conntrack extensions : Interrupt timeout
Date: Mon, 22 Dec 2008 20:22:12 +0100
Message-ID: <494FE8E4.4080406@gmail.com>
References: <49467ACC.8080107@trash.net>	 <20081216.012018.196068498.davem@davemloft.net>	 <49495F88.2010103@gmail.com>	 <38bcb3ec0812171836r4c6161b2m1026d73722a72cfe@mail.gmail.com>	 <494D4A11.5080304@gmail.com> <38bcb3ec0812220107y64c4f495s1e37adb0169741ec@mail.gmail.com> <494F6FF2.1010502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:31643 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916AbYLVTV5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2008 14:21:57 -0500
Received: by fg-out-1718.google.com with SMTP id 19so843417fgg.17
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Dec 2008 11:21:56 -0800 (PST)
In-Reply-To: <494F6FF2.1010502@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

unfortunately my problem isn't related to vmware environment. .
I really don't know what to do .


> Sorry, my mistake .
> 
> One interesting thing about this issue is that it might be realted to
> vmware clock issues, since sometimes I am getting the 'clocksource tsc
> unstable' with huge delta in ns . I have tried booting my new kernel
> with noapic and the result is that it hangs even faster . Today I will
> try to check this on a normal PC and see if this is the case
> 
> Piotrek
