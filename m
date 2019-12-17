Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E315EC43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 10:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD0D32072D
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 10:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfLQKm5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 05:42:57 -0500
Received: from correo.us.es ([193.147.175.20]:45378 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfLQKm5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 05:42:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 07DF7100793
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 11:42:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9F3EDA70B
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 11:42:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DEEB3DA707; Tue, 17 Dec 2019 11:42:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B325BDA702;
        Tue, 17 Dec 2019 11:42:51 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 11:42:51 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.199.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 793594265A5A;
        Tue, 17 Dec 2019 11:42:51 +0100 (CET)
Date:   Tue, 17 Dec 2019 11:42:51 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        fw@strlen.de
Subject: Re: [PATCH nft,RFC] main: remove need to escape quotes
Message-ID: <20191217103509.nj4wsu7y2wyjpdyp@salvia>
References: <20191216214157.551511-1-pablo@netfilter.org>
 <20191217004257.GI14465@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217004257.GI14465@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Dec 17, 2019 at 01:42:57AM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Mon, Dec 16, 2019 at 10:41:57PM +0100, Pablo Neira Ayuso wrote:
> > If argv[i] contains spaces, then restore the quotes on this string.
> > 
> > There is one exception though: in case that argc == 2, then assume the
> > whole input is coming as a quoted string, eg. nft "add rule x ...;add ..."
> > 
> > This patch is adjusting a one test that uses quotes to skip escaping one
> > semicolon from bash. Two more tests do not need them.
> 
> I appreciate your efforts at making my BUGS note obsolete. :)
> In this case though, I wonder if this really fixes something:

nft add rule x y log prefix "test: "

instead of

nft add rule x y log prefix \"test: \"

> I use quotes in only two cases:
> 
> A) When forced by the parser, e.g. with interface names.

Interface names have no spaces, so this patch fixes nothing there indeed.

> B) To escape the curly braces (and any semi-colons inside) in chain or
>    set definitions.
> 
> Unless I miss something, case (A) will still need escaped quotes since
> interface names usually don't contain whitespace. In case (B), your
> patch would typically bite me as I merely quote the braces, like so:
> 
> | # nft add chain inet t c '{ type filter hook input priority filter; policy drop; }'

You do this trick not to escape three times, ie.

| #nft add chain inet t c \{ type filter hook input priority filter; policy drop\; \}

Your trick works fine right now because the argv list is not honored
by the main function, your quotes to avoid escaping the values will
result in:

argv[0] = nft
argv[1] = add
argv[2] = chain
argv[3] = inet
argv[4] = t
argv[5] = c
argv[6] = { type filter hook input priority filter; policy drop; }

This is not a problem because main translates this into a plain buffer
to feed the bison parser for the command line mode.

With my patch, this will still work:

| # nft 'add chain inet t c { type filter hook input priority filter; policy drop; }'

So you can still use quotes to avoid escaping, but quotes are
restricted to the whole command OR to use them to really quote a
string.

So I'm debating if it's worth providing a simple and consistent model
we can document on how to use quotes in nft from the command line, in
this patch:

1) You can quote the whole command to avoid escape characters that
   have special semantics in your shell, eg. { and ; in zsh. Or ; in bash.

2) You do not need to escape quotes anymore as in the example above
   for log prefix.

Otherwise, we are allowing for quotes basically anywhere.

If in the future, we decide to stop using bison for whatever reason
and we rely on argc and argv, this might make things harder for a new
parser. Not telling I have an incentive to replace the parser right
now though.

> Of course that's a matter of muscle memory, but IIUC, your fix won't
> work if one wants to pass flags in addition to a quoted command. Or does
> getopt mangle argc?

argc is left untouch, it would need to pass it as a pointer to
getopt_long() to update it. Not related, but getopt mangles argv,
because it reorders options, it is placing them right before the
non-options, so optind points to the beginning of what main passes to
the bison parser. Well actually mangling will not happen anymore if
the patch to enforce options before command is applied (looks like
feedback on the mailing list points to that direction).

Probably not worth the effort and we should start promoting people to
use the interactive interface for `nft -i'. If autocompletion is
supported there, then there would be a real incentive for users to
pick `nft -i'.

Thanks.
