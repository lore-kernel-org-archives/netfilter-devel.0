From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH v2] libnftables: Unexport enum nftables_exit_codes
Date: Mon, 13 Nov 2017 13:38:37 +0100
Message-ID: <20171113123837.GZ32305@orbyte.nwl.cc>
References: <20171109192712.GX32305@orbyte.nwl.cc>
 <20171110112715.23289-1-phil@nwl.cc>
 <20171113123100.GA6899@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:50998 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752526AbdKMMij (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 07:38:39 -0500
Content-Disposition: inline
In-Reply-To: <20171113123100.GA6899@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 13, 2017 at 01:31:00PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Nov 10, 2017 at 12:27:15PM +0100, Phil Sutter wrote:
> > diff --git a/src/main.c b/src/main.c
> > index 529bedffc2e3b..8d03f8989b1fc 100644
> > --- a/src/main.c
> > +++ b/src/main.c
> > @@ -183,11 +183,11 @@ int main(int argc, char * const *argv)
> >  		switch (val) {
> >  		case OPT_HELP:
> >  			show_help(argv[0]);
> > -			exit(NFT_EXIT_SUCCESS);
> > +			exit(0);
> 
> Better use the standard EXIT_FAILURE and EXIT_SUCCESS here? Instead of
> hardcoded 0 and 1 values.

ACK, I'll prepare v3.

Thanks, Phil
