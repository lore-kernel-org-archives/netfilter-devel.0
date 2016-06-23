From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft shell tests
Date: Thu, 23 Jun 2016 12:59:24 +0200
Message-ID: <20160623105924.GA2149@salvia>
References: <20160623104320.GA13710@salvia>
 <CAOkSjBgP8x8BY-9J5Vj69Su8oR8B4scoxXY77rwAGZkEXNDpog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54256 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbcFWK7c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 06:59:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 97299E7DB4
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:59:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 874409EBA8
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:59:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5EA279EBB2
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:59:28 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBgP8x8BY-9J5Vj69Su8oR8B4scoxXY77rwAGZkEXNDpog@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 23, 2016 at 12:53:54PM +0200, Arturo Borrero Gonzalez wrote:
> On 23 June 2016 at 12:43, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Arturo,
> >
> > I think it would be good if the run-test.sh script uses the binary
> > in this tree, just like nft-tests.py. Instead of using the one that is
> > available on the system.
> >
> > Let me know, thanks.
> 
> You can use arbitrary binaries passing the NFT variable:
> 
> % NFT=../../src/nft ./run-tests.sh
> 
> would you like to change the behaviour to use the nft binary from src/
> by default?

I think it's a good default to use the nft binary from src/

Otherwise, if you forget to 'make install' you may end up testing
something else :)

This would be very useful for continuous integration as we don't need
to install the binary itself on the test infrastructure to run the
tests.
