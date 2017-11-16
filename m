From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH] libnftables: Split code into frontend and library
Date: Thu, 16 Nov 2017 15:11:22 +0100
Message-ID: <20171116141122.GL32305@orbyte.nwl.cc>
References: <20171114201710.16419-1-phil@nwl.cc>
 <20171116133448.GC2455@salvia>
 <20171116135630.GA13559@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60426 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932257AbdKPOLX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 09:11:23 -0500
Content-Disposition: inline
In-Reply-To: <20171116135630.GA13559@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 16, 2017 at 02:56:30PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 16, 2017 at 02:34:48PM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Nov 14, 2017 at 09:17:10PM +0100, Phil Sutter wrote:
> > > This finally creates the libnftables shared object.
> > > 
> > > For some reason, this causes two compiler warnings to appear:
> > > 
> > > | parser_bison.y: In function 'nft_parse':
> > > | parser_bison.y:131:3: warning: implicit declaration of function 'nft_set_debug' [-Wimplicit-function-declaration]
> > > |    nft_set_debug(1, scanner);
> > > |    ^~~~~~~~~~~~~
> > > | parser_bison.c:64:25: warning: implicit declaration of function 'nft_lex' [-Wimplicit-function-declaration]
> > > |  #define yylex           nft_lex
> > > |                          ^
> > > | parser_bison.c:4745:16: note: in expansion of macro 'yylex'
> > > |        yychar = yylex (&yylval, &yylloc, scanner);
> > > 
> > > So this patch contains a workaround, namely declaring both functions
> > > in src/parser_bison.y. During linking the objects are found, so this is
> > > rather a matter of cosmetics.
> > 
> > Also applied, thanks Phil.
> 
> This message is popping up here:
> 
>   CCLD     libnftables.la
> ar: `u' modifier ignored since `D' is the default (see `U')

Looks like an automake bug on your system? (Googling turned this up:
https://bugzilla.redhat.com/show_bug.cgi?id=1155273). I don't see the
warning on my machine at least.

Cheers, Phil
> 
