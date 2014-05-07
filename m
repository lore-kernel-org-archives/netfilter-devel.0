From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] ruleset: fix erroneus call to snprintf
Date: Wed, 7 May 2014 15:39:21 +0200
Message-ID: <20140507133921.GA4890@localhost>
References: <20140506150933.31175.48901.stgit@nfdev.cica.es>
 <CAOkSjBiuZvgQrxH2rJDk2Sq593gq7Tv30nCx5RTua1BuTLg0Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32907 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932959AbaEGNj1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 May 2014 09:39:27 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBiuZvgQrxH2rJDk2Sq593gq7Tv30nCx5RTua1BuTLg0Sw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 06, 2014 at 05:53:01PM +0200, Arturo Borrero Gonzalez wrote:
> On 6 May 2014 17:09, Arturo Borrero Gonzalez
> <arturo.borrero.glez@gmail.com> wrote:
> > This snprintf call is taking an erroneus value for size.
> >
> 
> Please Pablo fix the message if you apply this. erroneus -> erroneous.

Fixed and applied, thanks.
