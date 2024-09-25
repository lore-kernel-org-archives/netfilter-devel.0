Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F161D5AD4
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2024 20:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727296397; cv=none; b=qdN+NuigaMsI2zAeXwfZ8rlvFWeTGfFo5ZqXNboUTrUhkn57U6hde2HVKs69LoRhM+6my5jTGFY+2NnhMjmFECQmk1jykwns19/T/YuAmWWZ9ZTAqUyjx18qPvhv74YkTOda739XvOshwD7LL7raj1EZHo1v39iI97QeDbsIYw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727296397; c=relaxed/simple;
	bh=JO4gMsutdAq6tKak7EICEjRDdnkKY5Q0/JpULC/ACFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SORoDXD7Lqtv6fNObHofR7cWWqvrXDklypz8lGHL7/s/zBW155eWHzf0SA8zdRUdmVw3MPN0S5xvChlfXuuHa03S7xGBqUcoqwZS4jhBEKHxsasPzEtkKPSQuTFuVZoNJEcSz7iPm0kSL6ysD7jJV8/fL90rV+rNdc1LX5HqXv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=50602 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1stYh3-000aea-1W; Wed, 25 Sep 2024 22:33:03 +0200
Date: Wed, 25 Sep 2024 22:32:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] conntrack: -L doesn't take a value, so don't discard one
 (same for -IUDGEFA)
Message-ID: <ZvRze9JEBJ28ityC@calendula>
References: <hpsesrayjbjrtja3unjpw4a3tsou3vtu7yjhrcba7dfnrahwz2@tarta.nabijaczleweli.xyz>
 <ZtbHMe6STK_W6yfA@calendula>
 <bymeee6fsub6oz64xtykfru25aq6xx4k2agjbeabekzfobu4jd@tarta.nabijaczleweli.xyz>
 <ZvQj_TOKcN7A9kmz@calendula>
 <qe4cxltrompmuajfgfkedrecefkyy2eopi3erttlm7c3xigs2g@tarta.nabijaczleweli.xyz>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <qe4cxltrompmuajfgfkedrecefkyy2eopi3erttlm7c3xigs2g@tarta.nabijaczleweli.xyz>
X-Spam-Score: -1.9 (-)

On Wed, Sep 25, 2024 at 05:11:01PM +0200, Ahelenia Ziemiańska wrote:
> On Wed, Sep 25, 2024 at 04:53:49PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Sep 03, 2024 at 04:53:46PM +0200, Ahelenia Ziemiańska wrote:
> > > On Tue, Sep 03, 2024 at 10:22:09AM +0200, Pablo Neira Ayuso wrote:
> > > > On Tue, Sep 03, 2024 at 04:16:21AM +0200, Ahelenia Ziemiańska wrote:
> > > > > The manual says
> > > > >    COMMANDS
> > > > >        These options specify the particular operation to perform.
> > > > >        Only one of them can be specified at any given time.
> > > > > 
> > > > >        -L --dump
> > > > >               List connection tracking or expectation table
> > > > > 
> > > > > So, naturally, "conntrack -Lo extended" should work,
> > > > > but it doesn't, it's equivalent to "conntrack -L",
> > > > > and you need "conntrack -L -o extended".
> > > > > This violates user expectations (borne of the Utility Syntax Guidelines)
> > > > > and contradicts the manual.
> > > > > 
> > > > > optarg is unused, anyway. Unclear why any of these were :: at all?
> > > > Because this supports:
> > > >         -L
> > > >         -L conntrack
> > > >         -L expect
> > > Well that's not what :: does, though; we realise this, right?
> > > 
> > > "L::" means that getopt() will return
> > >   "-L", "conntrack" -> 'L',optarg=NULL
> > >   "-Lconntrack"     -> 'L',optarg="conntrack"
> > > and the parser for -L (&c.) doesn't... use optarg.
> > Are you sure it does not use optarg?
> > 
> > static unsigned int check_type(int argc, char *argv[])
> > {
> >         const char *table = get_optional_arg(argc, argv);
> > 
> > and get_optional_arg() uses optarg.
> 
> This I've missed, but actually my diagnosis still holds:
>   static unsigned int check_type(int argc, char *argv[])
>   {
>   	const char *table = get_optional_arg(argc, argv);
>   
>   	/* default to conntrack subsystem if nothing has been specified. */
>   	if (table == NULL)
>   		return CT_TABLE_CONNTRACK;
> 
>   static char *get_optional_arg(int argc, char *argv[])
>   {
>   	char *arg = NULL;
>   
>   	/* Nasty bug or feature in getopt_long ?
>   	 * It seems that it behaves badly with optional arguments.
>   	 * Fortunately, I just stole the fix from iptables ;) */
>   	if (optarg)
>   		return arg;
> 
> So, if you say -Lanything, then
>   optarg=anything
>   get_optional_arg=(null)
> (notice that it says "return arg;", not "return optarg;",
>  i.e. this is "return NULL").
> 
> It /doesn't/ use optarg, because it explicitly treats an optarg as no optarg.
> 
> It's unclear to me what the comment is referencing,
> but I'm assuming some sort of confusion with what :: does?
> Anyway, that if(){ can be removed now, since it can never be taken now.

The issue that I'm observing is that

# conntrack -Lconntrack

now optarg is NULL after your patch, so 'conntrack' is ignored, so it
falls back to list the conntrack table.

Then, this breaks:

# conntrack -Lexpect
conntrack v1.4.9 (conntrack-tools): Bad parameter `xpect'
Try `conntrack -h' or 'conntrack --help' for more information.

Maybe your patch needs an extension to deal with this case too?

Regarding your question, this parser is old and I shamelessly took it
from the original iptables to make syntax similar.
