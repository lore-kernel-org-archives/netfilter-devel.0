From: Justin Yaple <yaplej@gmail.com>
Subject: Re: Recalculate checksums in netfilter queue
Date: Thu, 22 Apr 2010 15:12:41 -0700
Message-ID: <q2q8363055a1004221512v530eccffr1d29eef2e9d55475@mail.gmail.com>
References: <l2z8363055a1004201802x47a250f3ya43e4bec4e79061c@mail.gmail.com>
	 <x2t3fdd6ce01004201902x33440642rd1189d2852aa57a@mail.gmail.com>
	 <z2o8363055a1004212015w2216df48s3074cdb2328c66db@mail.gmail.com>
	 <20100422084313.jk0ntlfyss444g0o@webmail.dartmouth.edu>
	 <l2z8363055a1004221319q17cb25f8k8734736374747f99@mail.gmail.com>
	 <z2o3fdd6ce01004221432yec6c907bz4124144d403be1b4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Bruno Moreira Guedes <thbmatrix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33521 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab0DVWMm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:12:42 -0400
Received: by gwj19 with SMTP id 19so2331163gwj.19
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Apr 2010 15:12:41 -0700 (PDT)
In-Reply-To: <z2o3fdd6ce01004221432yec6c907bz4124144d403be1b4@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> So, talking about the topic - implementing checksum functions on
> netfilter_queue, it would be useful to nfq_set_verdict subcall a
> function which check if the checksums(tcp, ip, udp, anything else) are
> set to 0, and then(if it's 0) it change the ckecksum automatically -
> something like the kernel does when we send a packet through a RAW
> socket.
>
> --Bruno Moreira Guedes

I think thats a great idea.  If the functions were included in the
library you could have nfq_set_verdict call them if any of the
checksums are set to 0.  This would give you the option of either
calling the function yourself, or just setting the checksum to 0 then
let the nfq_set_verdict call the functions to recalculate them.

So maybe it could be implemented like the checksum functions used in
the kernel where the base checksum function is the same, but takes
parameters to determine what protocol the checksum is being calculated
for.  Then a wrapper function is made for each protocol type ip, tcp,
udp...

-Justin.
