From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: shell: cover transactions via nft -f using
 flat syntax
Date: Wed, 22 Jun 2016 18:16:42 +0200
Message-ID: <20160622161642.GB2075@salvia>
References: <1466594336-24231-1-git-send-email-pablo@netfilter.org>
 <CAOkSjBjZsn5ePJynyjdaEorcQHrQm4uo+62D7hZKJrdvvecFVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53391 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbcFVQRE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 12:17:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AF8001C4368
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 18:16:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9C7C61B3085
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 18:16:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4F44811A665
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 18:16:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBjZsn5ePJynyjdaEorcQHrQm4uo+62D7hZKJrdvvecFVg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 22, 2016 at 04:16:27PM +0200, Arturo Borrero Gonzalez wrote:
> On 22 June 2016 at 13:18, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This patch covers transactions using the flat syntax representation, eg.
> >
> >         add table x
> >         add chain x y { type filter hook forward priority 0; }
> >         add chain x y { policy drop; }
> >
> > This also covers things like:
> >
> >         add element x whitelist { 1.1.1.1 }
> >         delete element x whitelist { 1.1.1.1 }
> >
> > The one above may look silly from a human behaviour point of view, but
> > silly robots may very well behave like this.
> >
> > These tests require several kernel patches though in order to pass
> > successfully.
> >
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> I reviewed most of the testscases and they seem fine to me,
> 
> Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> 
> Side note:
> 
> if you execute some of them without the kernel patches (so they fail),
> a segfault happens in nft (I guess related to cache handling).
> 
> W: [FAILED] ./testcases/transactions/0037set_0: expected 0 but got 139
> ./testcases/transactions/0037set_0: line 19: 15139 Segmentation fault
>     $NFT -f $tmpfile
> W: [FAILED] ./testcases/transactions/0038set_0: expected 0 but got 139
> ./testcases/transactions/0038set_0: line 21: 15151 Segmentation fault
>     $NFT -f $tmpfile
> W: [FAILED] ./testcases/transactions/0039set_0: expected 0 but got 139
> ./testcases/transactions/0039set_0: line 21: 15163 Segmentation fault
>     $NFT -f $tmpfile

You need this:

http://patchwork.ozlabs.org/patch/639098/

I have just pushed this mainstream.
