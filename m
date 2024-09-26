Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C816D347B4
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 10:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727347098; cv=none; b=kb4Cw7KLFDmqDSk1CzIo92FxaRhL4mMMXyo36XBSUjpXeu7a/ejTkagpbTuzmBBclgxl0LhO7j5LC0vx3Avt+sgyqe2E1HcU9CrWwp5f6B3UomaGTDwkAIjqQabQIckuwhEmKJLyXJ+OZLT/u2Ft7tZo1xQ/+U70aT7aQPnhSY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727347098; c=relaxed/simple;
	bh=jVL+9GssSV7qZqm0ouOCv4Mn9WCjfrXWQvC/noZ7yAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mMVKqE3KIB2wUj3u6GlkBE4LyZNm88YZ2LIr+CcwUVa3PId6tZvC6TXW2daikkHee39oSAVju8npWxwBgIEn+RPDPObIF2cHlR1dJcOCBNJcPZymFyWCKxcvQ0vqcJC2/pwCUVMWRJAt+v1oGw2zAYUZhZY0qjE0Qj+NXB1yOFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=43868 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1stlsv-001Pfp-Pv; Thu, 26 Sep 2024 12:38:12 +0200
Date: Thu, 26 Sep 2024 12:38:08 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: =?utf-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] conntrack: -L doesn't take a value, so don't discard one
 (same for -IUDGEFA)
Message-ID: <ZvU5kFP-523XCzqU@calendula>
References: <hpsesrayjbjrtja3unjpw4a3tsou3vtu7yjhrcba7dfnrahwz2@tarta.nabijaczleweli.xyz>
 <ZtbHMe6STK_W6yfA@calendula>
 <bymeee6fsub6oz64xtykfru25aq6xx4k2agjbeabekzfobu4jd@tarta.nabijaczleweli.xyz>
 <ZvQj_TOKcN7A9kmz@calendula>
 <qe4cxltrompmuajfgfkedrecefkyy2eopi3erttlm7c3xigs2g@tarta.nabijaczleweli.xyz>
 <ZvRze9JEBJ28ityC@calendula>
 <2pdkunyljqasunwbqeofqdetpda2xfdqtyrqg6sqr4efwuwzlq@tarta.nabijaczleweli.xyz>
 <ZvU4WBNuXWQ-wEuL@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZvU4WBNuXWQ-wEuL@calendula>
X-Spam-Score: -1.9 (-)

On Thu, Sep 26, 2024 at 12:33:00PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 26, 2024 at 10:28:58AM +0200, наб wrote:
> > On Wed, Sep 25, 2024 at 10:32:59PM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Sep 25, 2024 at 05:11:01PM +0200, Ahelenia Ziemiańska wrote:
> > > > On Wed, Sep 25, 2024 at 04:53:49PM +0200, Pablo Neira Ayuso wrote:
> > > > > On Tue, Sep 03, 2024 at 04:53:46PM +0200, Ahelenia Ziemiańska wrote:
> > > > > > On Tue, Sep 03, 2024 at 10:22:09AM +0200, Pablo Neira Ayuso wrote:
> > > > > > > On Tue, Sep 03, 2024 at 04:16:21AM +0200, Ahelenia Ziemiańska wrote:
> > > > > > > > The manual says
> > > > > > > >    COMMANDS
> > > > > > > >        These options specify the particular operation to perform.
> > > > > > > >        Only one of them can be specified at any given time.
> > > > > > > > 
> > > > > > > >        -L --dump
> > > > > > > >               List connection tracking or expectation table
> > > > > > > > 
> > > > > > > > So, naturally, "conntrack -Lo extended" should work,
> > > > > > > > but it doesn't, it's equivalent to "conntrack -L",
> > > > > > > > and you need "conntrack -L -o extended".
> > > > > > > > This violates user expectations (borne of the Utility Syntax Guidelines)
> > > > > > > > and contradicts the manual.
> > > > > > > > 
> > > > > > > > optarg is unused, anyway. Unclear why any of these were :: at all?
> > > > > > > Because this supports:
> > > > > > >         -L
> > > > > > >         -L conntrack
> > > > > > >         -L expect
> > > > > > Well that's not what :: does, though; we realise this, right?
> > > > > > 
> > > > > > "L::" means that getopt() will return
> > > > > >   "-L", "conntrack" -> 'L',optarg=NULL
> > > > > >   "-Lconntrack"     -> 'L',optarg="conntrack"
> > > > > > and the parser for -L (&c.) doesn't... use optarg.
> > > > > Are you sure it does not use optarg?
> > > > > 
> > > > > static unsigned int check_type(int argc, char *argv[])
> > > > > {
> > > > >         const char *table = get_optional_arg(argc, argv);
> > > > > 
> > > > > and get_optional_arg() uses optarg.
> > > > This I've missed, but actually my diagnosis still holds:
> > > >   static unsigned int check_type(int argc, char *argv[])
> > > >   {
> > > >   	const char *table = get_optional_arg(argc, argv);
> > > >   
> > > >   	/* default to conntrack subsystem if nothing has been specified. */
> > > >   	if (table == NULL)
> > > >   		return CT_TABLE_CONNTRACK;
> > > > 
> > > >   static char *get_optional_arg(int argc, char *argv[])
> > > >   {
> > > >   	char *arg = NULL;
> > > >   
> > > >   	/* Nasty bug or feature in getopt_long ?
> > > >   	 * It seems that it behaves badly with optional arguments.
> > > >   	 * Fortunately, I just stole the fix from iptables ;) */
> > > >   	if (optarg)
> > > >   		return arg;
> > > > 
> > > > So, if you say -Lanything, then
> > > >   optarg=anything
> > > >   get_optional_arg=(null)
> > > > (notice that it says "return arg;", not "return optarg;",
> > > >  i.e. this is "return NULL").
> > > > 
> > > > It /doesn't/ use optarg, because it explicitly treats an optarg as no optarg.
> > > > 
> > > > It's unclear to me what the comment is referencing,
> > > > but I'm assuming some sort of confusion with what :: does?
> > > > Anyway, that if(){ can be removed now, since it can never be taken now.
> > > Then, this breaks:
> > > # conntrack -Lexpect
> > > conntrack v1.4.9 (conntrack-tools): Bad parameter `xpect'
> > > Try `conntrack -h' or 'conntrack --help' for more information.
> > > 
> > > Maybe your patch needs an extension to deal with this case too?
> > 
> > This doesn't "break", this is equivalent to conntrack -L -e xpect.
> > It's now correct. This was the crux of the patch, actually.
> > 
> > Compare the manual:
> >   SYNOPSIS
> >     conntrack -L [table] [options] [-z]
> >   COMMANDS
> >     -L --dump     List connection tracking or expectation table
> >   PARAMETERS
> >     -e, --event-mask [ALL|NEW|UPDATES|DESTROY][,...]
> >                   Set the bitmask of events that are to be generated by the in-kernel ctnetlink event code.  Using this parameter, you can reduce the event messages  generated
> >                   by the kernel to the types that you are actually interested in.  This option can only be used in conjunction with "-E, --event".
> > 
> > Previously, it /was/ broken: conntrack -Lexpect was as-if --dump=expect
> > (also not legal since --dump doesn't take an argument),
> > and the "expect" was ignored, so it was equivalent to conntrack -L.
> > You can trivially validate this by running an older version.
> > 
> > (Well, --dump=expect /is/ accepted. And ignored.
> >  So fix that too with s/optional_argument/no_argument/ (or s/2/0/).
> >  I didn't actually look at the longopts before.)
> > 
> > > The issue that I'm observing is that
> > >   # conntrack -Lconntrack
> > > now optarg is NULL after your patch, so 'conntrack' is ignored, so it
> > > falls back to list the conntrack table.
> > 
> > What do you mean "now". That shit was always ignored.
> > You can read trace the calls yourself if you don't believe my analysis.
> > Now it behaves as-documented (-L -c onntrack).
> > 
> > And, per
> >                 case 'c':
> >                         options |= opt2type[c];
> >                         nfct_set_attr_u32(tmpl->ct,
> >                                           opt2attr[c],
> >                                           strtoul(optarg, NULL, 0));
> >                         break;
> > -c onntrack is equivalent to -c 0.
> > This is also obviously wrong.
> > 
> > I will repeat this and you can confirm this once more
> > (or refer back to my analysis above):
> > for all of -LIUDGEFA, an optional parameter was accepted, and always discarded.
> > It now isn't, and behaves as-expected per the USG
> > ("the USG" is an annoying way to say "how getopt() works".
> > 
> > > Regarding your question, this parser is old and I shamelessly took it
> > > from the original iptables to make syntax similar.
> > So you have someone to blame it on when it turns out to be dysfunctional.
> > But you also have a huge parser that doesn't work.
> > Win some/lose some, I suppose.
> 
> Your stuff breaks existing behaviour. I will revert and leave it as is.
> 
> There is a risk of breaking existing applications.
> 
> You can use the word shit, dysfunctional, and keep augment your
> wording as many times as you want, but that does not change my point.

So either fix it is a backward compatible way or there will be no fix.
