From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables-nftables: Invalid argument
Date: Fri, 31 May 2013 12:50:31 +0200
Message-ID: <20130531105031.GA3950@localhost>
References: <CAFpD06Qpkm2sXQc0UAN1JfBeHX0sP9TH9mgca4q_d2y5pSQSxA@mail.gmail.com>
 <CAOkSjBi3ogMOU=gT2gij8gU30_Ptqz_JfFQgv564YGMsKqaiVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Giuseppe Longo <giuseppelng@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50442 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab3EaKuh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 May 2013 06:50:37 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBi3ogMOU=gT2gij8gU30_Ptqz_JfFQgv564YGMsKqaiVQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 31, 2013 at 09:52:33AM +0200, Arturo Borrero Gonzalez wrote:
> 2013/5/30 Giuseppe Longo <giuseppelng@gmail.com>:
> > Hello,
> > I've compiled iptables-nftables on debian 7 vm, with kernel 3.2.0
> 
> Hi there,
> 
> try using a newer kernel.
> I would suggest to compile and run 'nf-next' or 'nftables' from here:
> http://1984.lsi.us.es/git/

To be more precise, you have to use this kernel tree:

http://1984.lsi.us.es/git/nftables/
