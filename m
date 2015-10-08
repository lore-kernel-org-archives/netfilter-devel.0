From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft] regarding sets names length
Date: Thu, 8 Oct 2015 20:35:06 +0100
Message-ID: <20151008193506.GB26121@macbook.localdomain>
References: <CAOkSjBiv1M9QE2bjTBTh9Yr1n_5w2c69Rg1ZpoxUroga7oncgA@mail.gmail.com>
 <20151008115524.GA20598@macbook.localdomain>
 <alpine.DEB.2.10.1510081455410.369@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41753 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbbJHTfM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 15:35:12 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1510081455410.369@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.10, Jozsef Kadlecsik wrote:
> Hi,
> 
> On Thu, 8 Oct 2015, Patrick McHardy wrote:
> 
> > On 08.10, Arturo Borrero Gonzalez wrote:
> > >  * enlarge set names sizes
> > 
> > Agreed, I think its a good idea to use 32 as for the other object types.
> 
> I'd suggest 128 or even 256 chars. In ipset the set name is limited to 32 
> too but I had received a few complains and plan to increase it.

I guess we will follow suit then since we should be compatible to ipset
anyways. Did you already decide for a value?
