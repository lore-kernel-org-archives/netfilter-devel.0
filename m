From: Phil Sutter <phil@nwl.cc>
Subject: RFC: Synopsis syntax change in nft.8
Date: Thu, 10 Aug 2017 20:29:32 +0200
Message-ID: <20170810182932.GJ16375@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:44033 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752639AbdHJS3d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2017 14:29:33 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

When looking at nft man page for the first time, I remember finding the
synopsis for individual commands (e.g. 'add table') rather misleading. I
am biased, but the (BNF style) syntax used in the various iproute2 man
pages is much more precise, so I would like to copy that for nft.8. The
actual SYNOPSIS section at the top gets is quite right, BTW (apart from
some minor flaws in font styles).

Let's look at an example:

| {add | delete | list | flush} \fBtable\fR [\fIfamily\fR] {\fItable\fR}

Since nobody wants HTML in emails, I used groff escape strings to
highlight the different font styles used:

\fB - start bold font
\fI - start italic font
\fR - start normal font

With no prior knowlege of how this syntax works, we start parsing the
line from left to right and find out that something like:

| {foo | bar}

probably means "either 'foo' or 'bar'", no big deal. Next comes 'table'
in bold font. What does bold mean? Looking at some examples, table seems
to be a keyword ('terminal' in BNF-speak). But so are 'add', 'delete',
'list' and 'flush', so why are they in normal font? Anyway, next is
'family' in italic surrounded by brackets. The family is optional (says
the text below that line), so brackets are for optional things. They are
set in normal font style, so that style denotes meta info. What is
italic for then? Probably something which has to be replaced by
something else (read: 'non-terminal'). Sadly the synopsis doesn't
specify what the replacement might be, so there's a dead-end. Finally
there is 'table' in curly braces and italics. Curly braces around a
single item seems redundant (given the assumption made before), and
there is no explanation what 'table' has to be replaced with as well.
Looking at some examples again, 'family' and 'table' seem to stand for
single words one could fill in. Though for 'family' the choice is
limited (to known families) while 'table' allows a (nearly) arbitrary
string.

Sadly things get even more confusing when looking at the next synopsis,
namely that for chains. There e.g. 'priority' is not to be replaced by a
single word, but by 'priority <value>'. I guess you get the point.

In iproute2, there is an (unwritten) agreement to use the following
markups:

normal font: meta info (braces, pipes and the like)
bold font: things to be used literally ("keywords")
italic: non-terminals

Looking at ip.8 and ip-link.8, I notice that italic comes in lower- and
uppercase, and it's not clear which is what. And there are dead-ends as
well, sometimes intentional (things to be replaced by any string/number)
or unintentional to keep things sane (nobody needs a definition of how a
MAC address looks like).

For nft.8, I'd suggest the following:

normal font: meta info (as above)
bold font: keywords (as above)
italics UPPERCASE: non-terminals, followed by a definition
italics lowercase: non-terminals, not followed by a definition

I am not overly familiar with docbook, so that might use other font
styles for the different kinds we need. Also, I like to use the same
font style when referring to elements in prose, which nicely draws
readers attention while skimming through the text searching for
explanations of things. Though I have no idea whether docbook allows for
that without hacks.

What do you think?

Cheers, Phil
