From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nftables 5/5] meta: Add support for input and output
 bridge interface name
Date: Fri, 4 Apr 2014 14:13:06 +0200
Message-ID: <20140404121300.GE27267@macbook.localnet>
References: <1396604851-15348-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1396604851-15348-6-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20140404111134.GA8247@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64088 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbaDDMNJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:13:09 -0400
Content-Disposition: inline
In-Reply-To: <20140404111134.GA8247@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 04, 2014 at 01:11:34PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Apr 04, 2014 at 12:47:31PM +0300, Tomasz Bursztyka wrote:
> > --- a/src/parser.y
> > +++ b/src/parser.y
> > @@ -304,6 +304,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
> >  %token SKGID			"skgid"
> >  %token NFTRACE			"nftrace"
> >  %token RTCLASSID		"rtclassid"
> > +%token BRI_IIFNAME		"bri_iifname"
> > +%token BRI_OIFNAME		"bri_oifname"
> >  
> >  %token CT			"ct"
> >  %token DIRECTION		"direction"
> > @@ -1563,6 +1565,8 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
> >  			|	SKGID		{ $$ = NFT_META_SKGID; }
> >  			|	NFTRACE		{ $$ = NFT_META_NFTRACE; }
> >  			|	RTCLASSID	{ $$ = NFT_META_RTCLASSID; }
> > +			|	BRI_IIFNAME	{ $$ = NFT_META_BRI_IIFNAME; }
> > +			|       BRI_OIFNAME	{ $$ = NFT_META_BRI_OIFNAME; }
> >  			;
> >  
> >  meta_stmt		:	META	meta_key	SET	expr
> > diff --git a/src/scanner.l b/src/scanner.l
> > index 47c5933..61c98b5 100644
> > --- a/src/scanner.l
> > +++ b/src/scanner.l
> > @@ -402,6 +402,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
> >  "skgid"			{ return SKGID; }
> >  "nftrace"		{ return NFTRACE; }
> >  "rtclassid"		{ return RTCLASSID; }
> > +"bri_iifname"		{ return BRI_IIFNAME; }
> > +"bri_oifname"		{ return BRI_OIFNAME; }
> 
> I prefer if we skip the underscore there, I remember that Patrick
> mentioned that he would also like to get rid of it in other cases like
> the ipv4_address type.
> 
> Perhaps iifnamebr
>         oifnamebr?
> 
> briifname and broifname could be an alternative, but I had problems to
> type that myself several times while writing this email. So I prefer
> the iffnamebr / oifnamebr alternative.

Actually I think they all suck :)

The match on bridge ports, so something containing briport would be a lot
more descriptive. briiport and brioport, ibriport and obriport, something
like that?
