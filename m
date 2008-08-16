From: "Changli Gao" <xiaosuo@gmail.com>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't work
Date: Sat, 16 Aug 2008 09:29:14 +0800
Message-ID: <412e6f7f0808151829v2150c9f9v31241115b6dd4717@mail.gmail.com>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>
	 <48A5CEFE.5090407@netfilter.org>
	 <alpine.LNX.1.10.0808151633500.10478@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0808152243280.20098@blackhole.kfki.hu>
	 <alpine.LNX.1.10.0808151743310.10478@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0808160037390.20328@blackhole.kfki.hu>
	 <412e6f7f0808151738k3b03cafax900b01f45726051e@mail.gmail.com>
	 <alpine.LNX.1.10.0808152104380.30044@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>,
	"Pablo Neira Ayuso" <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:5317 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbYHPB3Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 21:29:16 -0400
Received: by ti-out-0910.google.com with SMTP id b6so503501tic.23
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2008 18:29:14 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0808152104380.30044@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 16, 2008 at 9:09 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
>>I encountered this issue when I debugging a match. Its parse function
>>is like this:
>>
>>parse(...)
>>{
>>        if (*flags)
>>                error...;
>>        switch (c) {
>>        case 'a':
>>                ....
>>                break;
>>        default:
>>                return 0;
>>        }
>>       *flags = 1;
>>
>>        return 1;
>>}
>>
>>it will fail if there is another kinds of match after it, as all the
>>options not belong to it are parsed to its parse function. I think it
>>is the reason why default branch in switch exists. I make things a
>>little different from my original thought.
>
> Why should it fail?
> Once you gave -m secondmatch, you OBVIOUSLY want options
> from the second one, and rarely from the first.
>
The match mentioned above applies one option only. When the option is
got, *flags will be set to 1, to avoid being set second time. Before
checking c, I check the value of *flags first, if it is set, report an
error and exit directly. However, if there is another kind of match
after it, iptables will pass the new options to every matches one by
one until one eats it. When the parse function gets a option doesn't
belong to it, it finds *flags is set, then error is reported.

                                for (matchp = matches; matchp; matchp = matchp->
next) {
                                        if (matchp->completed)
                                                continue;
                                        if (matchp->match->parse(c - matchp->mat
ch->option_offset,
                                                     argv, invert,
                                                     &matchp->match->mflags,
                                                     &fw,
                                                     &fw.nfcache,
                                                     &matchp->match->m))
                                                break;
                                }


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
