From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH RFC] monitor: Support printing processes which caused
 the event
Date: Wed, 10 May 2017 16:02:44 +0200
Message-ID: <20170510140244.GW20805@orbyte.nwl.cc>
References: <20170510105510.891-1-phil@nwl.cc>
 <CAOkSjBhBTB8uDspnqx7F9vHt0GcCeAyt_3e+Lzm5nMG9pQKnOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:39439 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753224AbdEJODB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2017 10:03:01 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhBTB8uDspnqx7F9vHt0GcCeAyt_3e+Lzm5nMG9pQKnOA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 10, 2017 at 02:52:49PM +0200, Arturo Borrero Gonzalez wrote:
> On 10 May 2017 at 12:55, Phil Sutter <phil@nwl.cc> wrote:
> > This adds support for printing the process ID and name for changes which
> > 'nft monitor' reports:
> >
> > | nft -a -p monitor
> > | add chain ip t2 bla3 # pid 11616 (nft)
> >
> > If '-n' was given in addition to '-p', parsing the process name from
> > /proc/<pid>/cmdline is suppressed.
> >
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > Cc: Florian Westphal <fw@strlen.de>
> > ---
> >  include/nftables.h |  1 +
> >  src/main.c         | 12 ++++++++++-
> >  src/netlink.c      | 60 +++++++++++++++++++++++++++++++++++++++++++++++++-----
> >  src/rule.c         |  2 --
> >  4 files changed, 67 insertions(+), 8 deletions(-)
> >
> 
> If you are about to parse the textual nft output anyway, (which
> doesn't seems like a good idea BTW),
> why you don't simply add a rule comment?:
> 
> % nft add rule inet filter input counter comment "added by my app"

Sometimes you don't control the instance adding the rule, then this is
not an option.

Cheers, Phil
