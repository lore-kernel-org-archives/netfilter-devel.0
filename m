From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] libnftables: Split code into frontend and library
Date: Thu, 16 Nov 2017 14:34:48 +0100
Message-ID: <20171116133448.GC2455@salvia>
References: <20171114201710.16419-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39376 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750738AbdKPNey (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 08:34:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D1AD82E7855
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 14:34:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C395ADA878
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 14:34:52 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171114201710.16419-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 14, 2017 at 09:17:10PM +0100, Phil Sutter wrote:
> This finally creates the libnftables shared object.
> 
> For some reason, this causes two compiler warnings to appear:
> 
> | parser_bison.y: In function 'nft_parse':
> | parser_bison.y:131:3: warning: implicit declaration of function 'nft_set_debug' [-Wimplicit-function-declaration]
> |    nft_set_debug(1, scanner);
> |    ^~~~~~~~~~~~~
> | parser_bison.c:64:25: warning: implicit declaration of function 'nft_lex' [-Wimplicit-function-declaration]
> |  #define yylex           nft_lex
> |                          ^
> | parser_bison.c:4745:16: note: in expansion of macro 'yylex'
> |        yychar = yylex (&yylval, &yylloc, scanner);
> 
> So this patch contains a workaround, namely declaring both functions
> in src/parser_bison.y. During linking the objects are found, so this is
> rather a matter of cosmetics.

Also applied, thanks Phil.

Upfront warning: I will not consider this API stable until we make the
0.9 release, so we have a bit more time to make API changes.
