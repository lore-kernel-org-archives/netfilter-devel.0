From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] src: proto: Add missing packet type
Date: Tue, 1 Mar 2016 15:01:06 +0100
Message-ID: <20160301140106.GC4680@breakpoint.cc>
References: <20160301123912.GA6905@gmail.com>
 <20160301131740.GD22817@breakpoint.cc>
 <CAKHNQQEA74vCr8pq-reDkQu3kSc66hOseUOTzMcYArqsWVcX8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49037 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753690AbcCAOBJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 09:01:09 -0500
Content-Disposition: inline
In-Reply-To: <CAKHNQQEA74vCr8pq-reDkQu3kSc66hOseUOTzMcYArqsWVcX8Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> On Tue, Mar 1, 2016 at 6:47 PM, Florian Westphal <fw@strlen.de> wrote:
> > Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> >> Add missing packet type "invalid" for DCCP.
> >>
> >> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> >> ---
> >>  src/proto.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/src/proto.c b/src/proto.c
> >> index 0ed98ed..4d049f5 100644
> >> --- a/src/proto.c
> >> +++ b/src/proto.c
> >> @@ -443,6 +443,7 @@ static const struct symbol_table dccp_pkttype_tbl = {
> >>               SYMBOL("reset",         DCCP_PKT_RESET),
> >>               SYMBOL("sync",          DCCP_PKT_SYNC),
> >>               SYMBOL("syncack",       DCCP_PKT_SYNCACK),
> >> +             SYMBOL("invalid",       DCCP_PKT_INVALID),
> >
> > I don't think this is a good idea -- when user asks to match
> > 'invalid' then this will check type == DCCP_PKT_INVALID; however
> > the correct way would be to ask for type '> synack' (i.e.,
> > outside of the range of types specified).
> 
> OK. So, should this be removed from the enum dccp_pkt_type as well?

Yes, but we cannot do this anymore for compatibility reasons :-(

> And, if following iptables rules, one tries to get code corresponding
> to dccp type invalid using iptables-translate utility, then the
> corresponding nft rule should be "dccp type gt syncack". Please
> correct me if I'm wrong here.

Good question.
Pablo, I think -m dccp is buggy here, it should not have allowed
INVALID match in the first place.

Looking at kernel part it doesn't seem to special-case this
and will just check for type == INVALID.  But such type isn't
defined in dccp protocol, it just looks like implementation
helper so DCCP stack can do simpler sanity tests.

So I suggest to not support translation of INVALID to nft and
to document the INVALID shortoming in iptables-extensions manpage.

Any comments?
