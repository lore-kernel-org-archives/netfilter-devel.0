Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E163E18754D
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2024 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727276038; cv=none; b=MGyX+5r4rySFdtjYHvDRUW1AT5CpEL/5ohqxdkBGJNWyTMnJVaxZLbXGcEy4ceIYGp0+uDZg/2MuLMFyltw08q5J4rXh0liUvdDDTrEAvn5DYnLWc2KjSG2UCdgqAkem3rRI6OE987V+tZk9xQZVV0On0nYliA9YNgKZmaFDmJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727276038; c=relaxed/simple;
	bh=dXNgqrgRmlCkBZCrNLhfm4O7ETCr2Z88mWFprv++X0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CCHgEodQCoxCrJy1IKMqltPFWQryU9oDMuSnJmFGtEoeNVdi6PHXQHccw8rFO1iGPhr3aYC7ok4G7MY0WZRezlWuf7OwoGMyqhjZaqIACadtuECP8f8QQQhLpQqRhPXw1Lx2s164ACbhY21ukkI4esXWvmyoUCHpA9XFsTiZuJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=50672 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1stTOo-000GCH-UJ; Wed, 25 Sep 2024 16:53:53 +0200
Date: Wed, 25 Sep 2024 16:53:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] conntrack: -L doesn't take a value, so don't discard one
 (same for -IUDGEFA)
Message-ID: <ZvQj_TOKcN7A9kmz@calendula>
References: <hpsesrayjbjrtja3unjpw4a3tsou3vtu7yjhrcba7dfnrahwz2@tarta.nabijaczleweli.xyz>
 <ZtbHMe6STK_W6yfA@calendula>
 <bymeee6fsub6oz64xtykfru25aq6xx4k2agjbeabekzfobu4jd@tarta.nabijaczleweli.xyz>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bymeee6fsub6oz64xtykfru25aq6xx4k2agjbeabekzfobu4jd@tarta.nabijaczleweli.xyz>
X-Spam-Score: -1.9 (-)

On Tue, Sep 03, 2024 at 04:53:46PM +0200, Ahelenia Ziemiańska wrote:
> On Tue, Sep 03, 2024 at 10:22:09AM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Sep 03, 2024 at 04:16:21AM +0200, Ahelenia Ziemiańska wrote:
> > > The manual says
> > >    COMMANDS
> > >        These options specify the particular operation to perform.
> > >        Only one of them can be specified at any given time.
> > > 
> > >        -L --dump
> > >               List connection tracking or expectation table
> > > 
> > > So, naturally, "conntrack -Lo extended" should work,
> > > but it doesn't, it's equivalent to "conntrack -L",
> > > and you need "conntrack -L -o extended".
> > > This violates user expectations (borne of the Utility Syntax Guidelines)
> > > and contradicts the manual.
> > > 
> > > optarg is unused, anyway. Unclear why any of these were :: at all?
> > Because this supports:
> >         -L
> >         -L conntrack
> >         -L expect
> Well that's not what :: does, though; we realise this, right?
> 
> "L::" means that getopt() will return
>   "-L", "conntrack" -> 'L',optarg=NULL
>   "-Lconntrack"     -> 'L',optarg="conntrack"
> and the parser for -L (&c.) doesn't... use optarg.

Are you sure it does not use optarg?

static unsigned int check_type(int argc, char *argv[])
{
        const char *table = get_optional_arg(argc, argv);

and get_optional_arg() uses optarg.

> You don't parse the filter (table name? idk.) with getopt at all;
> you can test this /right now/ by running precisely the thing you outlined:
>   # conntrack -L > /dev/null
>   conntrack v1.4.7 (conntrack-tools): 137 flow entries have been shown.
>   # conntrack -L expect > /dev/null
>   conntrack v1.4.7 (conntrack-tools): 0 expectations have been shown.
>   # conntrack -Lexpect > /dev/null
>   conntrack v1.4.7 (conntrack-tools): 152 flow entries have been shown.
> and getopt returns, respectively
>   'L',optarg=NULL
>   'L',optarg=NULL; argv[optind]="expect"
>   'L',optarg="expect"
> ...and once again you discard the optarg for 'L' &c.
