From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 0/16] introduce libnftables
Date: Thu, 17 Aug 2017 12:47:27 +0200
Message-ID: <20170817104727.GA16375@orbyte.nwl.cc>
References: <20170816204310.3371-1-eric@regit.org>
 <CAOkSjBg8L7QQ2WapAoX_erz4pDm3+q9460w8qnrzgPMPouFL1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:43985 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbdHQKr2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 06:47:28 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBg8L7QQ2WapAoX_erz4pDm3+q9460w8qnrzgPMPouFL1A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 17, 2017 at 10:32:42AM +0200, Arturo Borrero Gonzalez wrote:
> On 16 August 2017 at 22:42, Eric Leblond <eric@regit.org> wrote:
> >
> > Hello,
> >
> > This patchset adds a basi high level libnftables to nftables code.
> > It is currently supporting running a command from a buffer or from
> > a file as well as batch support allowing to chain commands and commit
> > them at once.
> >
> > The API is mostly using existing structures such as nft_ctx that are
> > updated to contain enough information. It also adds a structure
> > dedicated to batch.
> >
> 
> Great work Eric, thanks!

+1! Thanks for pushing this forward.

I noticed a few compiler warnings:

| libnftables.c: In function 'nft_batch_commit':
| ../include/list.h:28:2: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
|   struct list_head name = LIST_HEAD_INIT(name)
|   ^
| libnftables.c:282:2: note: in expansion of macro 'LIST_HEAD'
|   LIST_HEAD(err_list);
|   ^~~~~~~~~

I don't quite understand why that happens, the code removed from
nft_netlink() looks identical. Maybe some compiler flags missing? Or is
it just me?

In addition, I see this one:

| parser_bison.y: In function 'nft_parse':
| parser_bison.y:122:3: warning: implicit declaration of function 'nft_set_debug' [-Wimplicit-function-declaration]
|    nft_set_debug(1, scanner);
|    ^~~~~~~~~~~~~
| parser_bison.c:64:25: warning: implicit declaration of function 'nft_lex' [-Wimplicit-function-declaration]
|  #define yylex           nft_lex
|                          ^
| parser_bison.c:4400:16: note: in expansion of macro 'yylex'
|        yychar = yylex (&yylval, &yylloc, scanner);
|                 ^~~~~

Not sure why that happens, though.

Cheers, Phil
