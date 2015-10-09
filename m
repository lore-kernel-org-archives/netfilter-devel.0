From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [nft] regarding sets names length
Date: Fri, 9 Oct 2015 14:26:15 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1510091423001.21032@nerf40.vanv.qr>
References: <CAOkSjBiv1M9QE2bjTBTh9Yr1n_5w2c69Rg1ZpoxUroga7oncgA@mail.gmail.com> <20151008115524.GA20598@macbook.localdomain> <alpine.DEB.2.10.1510081455410.369@blackhole.kfki.hu> <20151008193506.GB26121@macbook.localdomain>
 <alpine.DEB.2.10.1510091308500.4639@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:33037 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbbJIM0R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Oct 2015 08:26:17 -0400
In-Reply-To: <alpine.DEB.2.10.1510091308500.4639@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2015-10-09 13:12, Jozsef Kadlecsik wrote:
>> 
>> I guess we will follow suit then since we should be compatible to ipset
>> anyways. Did you already decide for a value?
>
>I thought 32 chars should be enough for everybody ;-) so I'm unsure about 
>the good enough value. 128 seems just pretty long, but the name length is 
>actually not critical, it could be 256. What do you think?

42.

Is there a particular reason to stick to any particular length limit?
Besides the Netlink packet limitations and page size restrictions,
are there any "char x[STATICLIMIT]" fields that prohibit us from just
offering practically-arbitrary-length strings (zero-terminated in C)?
