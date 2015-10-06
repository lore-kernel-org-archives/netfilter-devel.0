From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] expression: provide clone operation for set element
 ops
Date: Tue, 6 Oct 2015 11:53:45 +0200
Message-ID: <20151006095345.GA2215@salvia>
References: <1443653206-25841-1-git-send-email-fw@strlen.de>
 <CAOkSjBgNSz4+k=bDVsfsabYAH26LDOYY65A_PQYmFz+HcYWzVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34509 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbbJFJqv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Oct 2015 05:46:51 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBgNSz4+k=bDVsfsabYAH26LDOYY65A_PQYmFz+HcYWzVA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 06, 2015 at 10:58:59AM +0200, Arturo Borrero Gonzalez wrote:
> On 1 October 2015 at 00:46, Florian Westphal <fw@strlen.de> wrote:
> > define addrs={ 1.2.3.4 }
> > table ip filter {
> >         chain input {
> >                 type filter hook input priority 0;
> >                 ip saddr $addrs accept
> >         }
> > }
> >
> > segfaults. Using saddr { 1.2.3.4 } instead of $addrs works.
> >
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  src/expression.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> 
> Tested-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

Testing helps us a lot to speed up submission process. Thanks.
