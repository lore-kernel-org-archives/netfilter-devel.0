From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: Re: iptables-dev Source Example
Date: Tue, 9 Oct 2012 17:05:53 +0200
Message-ID: <CAFpD06QSeXHVCW+Gv_KWVB=EKvCez5N1F+6erZ8=tgf4i+Yveg@mail.gmail.com>
References: <5072D6F8.2010707@iit.demokritos.gr>
	<20121008152237.GA8350@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Katia Sarsempagieva <katias@iit.demokritos.gr>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60410 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2JIPFz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:05:55 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so3292868wey.19
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Oct 2012 08:05:54 -0700 (PDT)
In-Reply-To: <20121008152237.GA8350@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2012/10/8 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Mon, Oct 08, 2012 at 04:36:56PM +0300, Katia Sarsempagieva wrote:
>> Hello everyone!
>>
>> I'm totally new to the iptables development sphere, so I would like
>> to kindly request for a favor...
>>
>> I have installed the iptables-dev package on my Debian Linux machine.
>> What I want to do is to write my very own program using the iptables
>> library to query the interface information
>> of various machines (queues, lost packets, total packets etc).
>>
>> But no matter how much I've tried to find a single tutorial or a
>> source code sample (with the compiler command, of cource)
>> I failed.
>> So, can any of you please help me out? Maybe give me a tip on where
>> to search or pass me a link to a tutorial page
>> or anything that could contain a program sample and compilation
>> instructions..?
>
> I don't think you'll find much information. The library that iptables
> provides is mostly internal. We know of people that has been tinkering
> with it in their projects, but the API has not been stable along years
> and it is not documented. I expect to solve this situation soon.
>
> I'm afraid that the only reference you have is the source code by now.
> Good luck.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Can be documented these API?
