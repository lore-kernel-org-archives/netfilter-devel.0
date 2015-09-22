From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft] all chains of a table are listed
Date: Tue, 22 Sep 2015 18:02:43 +0200
Message-ID: <20150922160243.GA3900@salvia>
References: <CAOkSjBiSbL1sJ268dL-6n1upXNW=5c0j864dTubu8FKMSxQruw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45428 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933719AbbIVP4F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Sep 2015 11:56:05 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBiSbL1sJ268dL-6n1upXNW=5c0j864dTubu8FKMSxQruw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 22, 2015 at 02:06:25PM +0200, Arturo Borrero Gonzalez wrote:
> Hi!
> 
> It seems all chains of a given table are always listed. Is this the
> intended behaviour?

There's a bugzilla ticket on that issue.

I don't think it's the intended behaviour, the filtering should be
working. It should be easy to fix though.

Thanks for reporting.
