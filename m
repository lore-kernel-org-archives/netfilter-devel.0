From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] erec: Make error messages in nft consistent
Date: Tue, 15 Nov 2016 20:56:31 +0100
Message-ID: <20161115195631.GA4297@salvia>
References: <20161115192237.GA29317@lennorien.com>
 <20161115195010.GA3948@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39114 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751496AbcKOT4g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2016 14:56:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6F7291C438F
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2016 20:56:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 60F65DA804
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2016 20:56:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 62E16DA809
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2016 20:56:32 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161115195010.GA3948@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 15, 2016 at 08:50:10PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Nov 15, 2016 at 05:22:38PM -0200, Elise Lennion wrote:
> > Error messages in nft should start with "syntax error" to keep
> > consistency. A new function add_syntax_error() was created to add this
> > prefix when necessary.
> 
> Probably you can just add EREC_SYNTAX_ERROR to enum
> error_record_types, then add:
> 
> #define syntax_error(loc, fmt, args...) \
>        erec_create(EREC_SYNTA_ERROR, (loc), (fmt), ## args)

Actually, git grep "erec_queue(error(" tells me all:

        erec_queue(error(...

occur in parser_bison.y, so we can just update #define error in erec.h

You will have to define something like __error, which doesn't include
the "syntax error" string, as bison is already including it in this
spot below:

static void yyerror(struct location *loc, void *scanner,
                    struct parser_state *state, const char *s)
{
        erec_queue(__error(loc, "%s", s), state->msgs);
}

So it will be a simple patch in the end.

Thanks.
