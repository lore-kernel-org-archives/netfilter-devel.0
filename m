From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: iptables branch management
Date: Fri, 2 Sep 2011 14:27:40 -0700
Message-ID: <CAHo-OoyXEQGSSvJNh8kpD+Mcq5oQ_E0etH3SWnZOBktBTiy-fw@mail.gmail.com>
References: <alpine.LNX.2.01.1109021604260.4532@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57709 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab1IBV1l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Sep 2011 17:27:41 -0400
Received: by yie30 with SMTP id 30so2497738yie.19
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Sep 2011 14:27:41 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1109021604260.4532@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 2, 2011 at 07:20, Jan Engelhardt <jengelh@medozas.de> wrote:
> I would like to propose a "stable" branch that would be rooted
> in the most recent tag and only receive fixes. Furtheremore,
> the branch is merged time and again into master, so that the
> fix is available in both without cherry-pick. 1.4.12.x releases be made
> from stable, and 1.4.y from master.
> How about it?

I've actually been thinking about suggesting something pretty much identical.
So, I'm all for it.

Maintaining the version x stable branch maybe just a tiny little bit
(~1 month) past the release of version x+1 would probably be
appreciated.

ie. timeline of something along these lines:

initial state:
- version X.0 is released from master, stable is branched from master.
- obvious fixes committed to stable branch, stable branch merged into
master branch, periodically (as needed, every week or two or so) a
stable release is cut from the stable branch, and even if it's not
cut, you can still just use stable HEAD with much happiness.
- features go into master branch
- at some point master branch is cut to produce (X+1).0
- bugfixes which can, still go into the stable branch (which ist still
based off of X.0), X.N continue to be cut as needed
- other bugfixes queue up (or go into master), features are queued
- about 2-3 weeks after the release of X+1, assuming there are bug
fixes queued, a final X.N is cut, and X+1.0 is merged into stable, the
bugfixes are applied and a X+1.1 is cut.
- life continues...
