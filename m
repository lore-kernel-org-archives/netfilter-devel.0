From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH v2] libnftables: Unexport enum nftables_exit_codes
Date: Mon, 13 Nov 2017 15:04:34 +0100
Message-ID: <20171113140434.GB32305@orbyte.nwl.cc>
References: <20171109192712.GX32305@orbyte.nwl.cc>
 <20171110112715.23289-1-phil@nwl.cc>
 <20171113123100.GA6899@salvia>
 <20171113134904.GA32305@orbyte.nwl.cc>
 <20171113135350.GA2721@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:51956 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751593AbdKMOEf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 09:04:35 -0500
Content-Disposition: inline
In-Reply-To: <20171113135350.GA2721@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 13, 2017 at 02:53:50PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Nov 13, 2017 at 02:49:04PM +0100, Phil Sutter wrote:
> > On Mon, Nov 13, 2017 at 01:31:00PM +0100, Pablo Neira Ayuso wrote:
> > > On Fri, Nov 10, 2017 at 12:27:15PM +0100, Phil Sutter wrote:
> > > > diff --git a/src/main.c b/src/main.c
> > > > index 529bedffc2e3b..8d03f8989b1fc 100644
> > > > --- a/src/main.c
> > > > +++ b/src/main.c
> > > > @@ -183,11 +183,11 @@ int main(int argc, char * const *argv)
> > > >  		switch (val) {
> > > >  		case OPT_HELP:
> > > >  			show_help(argv[0]);
> > > > -			exit(NFT_EXIT_SUCCESS);
> > > > +			exit(0);
> > > 
> > > Better use the standard EXIT_FAILURE and EXIT_SUCCESS here? Instead of
> > > hardcoded 0 and 1 values.
> > 
> > While at it, should I convert nft_run_cmd_from_*() to return those
> > macros as well? This would of course mean changing failure case from -1
> > to 1, but would streamline calls from nft.c. What do you think?
> 
> I prefer to keep EXIT_* in main() only.
> 
> To me, -1 is the standard way to return an error in functions. So
> that's fine to me to keep it around.
> 
> So my suggestion is, you focus on features and fixes at this stage,
> cleanups may come later on, so we avoid too much code churning, ie.
> things that we may need to undo later on when extending things.
> 
> Cleanups can follow up once dust settles down a bit.
> 
> Let me know, thanks.

OK, fine with me! Thanks for your quick feedback.

Cheers, Phil
