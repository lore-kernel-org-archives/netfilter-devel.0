Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4EC4779F
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Sep 2024 21:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726436313; cv=none; b=UgM+uV4kRvNkds/qlD6WnCIzFRiftb/SDjhcTWo0TsfZ+Fh+hTzTr9v0FsFQHRW6wAdOxGPVq+94+aHpHMwcuNruFkQBxfSE26+lMVBE3yg2vz2O+SWcB2LGMcd8BycDZPoKjBoGo7gKEMPF6P9fjmfPmEL8PrvAIBAnUN8bBVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726436313; c=relaxed/simple;
	bh=cKY36x30ZxqG1kT0BinfTOv7bR9Nza6YiErOkvNroBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kjYjaRySprJc5Xf6WxFsyzdk0n77kISJth+Wh+SnX50Hi94+OD/0iFfzra9ShAb1EVVwbsHgKzwxU4NVUtZDGQ4jLmRAVDHteG4mWObkMpf1ZpEiftBI9uLUPrryVANyTUXsyvvshN5bl5yb2AF0BAkpKCrwQdGgjyUgYrAP8vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56572 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1spwwt-00EKr5-0c; Sun, 15 Sep 2024 23:38:29 +0200
Date: Sun, 15 Sep 2024 23:38:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] conntrack: -L doesn't take a value, so don't discard one
 (same for -IUDGEFA)
Message-ID: <ZudT0p40Vf0Jcjmw@calendula>
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
> 
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

Your evaluation is correct, patch is applied, thanks.
