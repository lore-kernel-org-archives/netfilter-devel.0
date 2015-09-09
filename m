From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft] segfault bug in simple ruleset, regression?
Date: Wed, 9 Sep 2015 18:01:41 +0200
Message-ID: <20150909160141.GA6002@salvia>
References: <CAOkSjBhk00k9H98Nx0hdxvrf5b8vAP5ad=iiKrdB2v4rHimoMw@mail.gmail.com>
 <20150909142903.GA3447@salvia>
 <20150909152924.GB24810@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55388 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbbIIPzE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 11:55:04 -0400
Content-Disposition: inline
In-Reply-To: <20150909152924.GB24810@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 09, 2015 at 05:29:24PM +0200, Florian Westphal wrote:
> I can reproduce it, but with slight tweak.
> 
> flush ruleset
> table inet filter {
>         chain test0 {
>         }
>         chain test {
>                 oif vmap {
>                         eth0 : jump test0,
>                 }
>         }
> }
> 
> (load it with nft -f )
> 
> Then edit file to add 2nd chain:
> flush ruleset
> table inet filter {
>         chain test0 {
>         }
>         chain test1 {
>         }
>         chain test {
>                 oif vmap {
>                         eth0 : jump test0,
>                         lo: jump test1,
>                 }
>         }
> }
> 
> load it. poof..

Thanks, I can now reproduce this. This is related to the cache
consolidation, will look at this asap.
