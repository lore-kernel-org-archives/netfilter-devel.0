From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH 5/6] ipset: Support comments in the userspace library.
Date: Fri, 20 Sep 2013 09:15:32 +0200
Message-ID: <14838004.CvyoF7qf1x@gentoovm>
References: <1379423605-22777-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <2453382.7aUm7cClMH@gentoovm> <alpine.DEB.2.00.1309192033210.24965@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:44802 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab3ITHPm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 03:15:42 -0400
In-Reply-To: <alpine.DEB.2.00.1309192033210.24965@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 19 September 2013 20:37:12 Jozsef Kadlecsik wrote:
> On Thu, 19 Sep 2013, Oliver wrote:
> > On Wednesday 18 September 2013 20:43:30 Jozsef Kadlecsik wrote:
> > > On Tue, 17 Sep 2013, Oliver wrote:
> > <snip>
> > 
> > > > diff --git a/lib/types.c b/lib/types.c
> > > > index adaba83..b95114f 100644
> > > > --- a/lib/types.c
> > > > +++ b/lib/types.c
> > > > @@ -607,7 +607,7 @@ ipset_load_types(void)
> > > > 
> > > >  		len = snprintf(path, sizeof(path), "%.*s",
> > > >  		
> > > >  			       (unsigned int)(next - dir), dir);
> > > > 
> > > > -		if (len >= sizeof(path) || len < 0)
> > > > +		if (len >= (int)sizeof(path) || len < (int)0)
> > > > 
> > > >  			continue;
> > > >  		
> > > >  		n = scandir(path, &list, NULL, alphasort);
> > > > 
> > > > @@ -620,7 +620,7 @@ ipset_load_types(void)
> > > > 
> > > >  			len = snprintf(file, sizeof(file), "%s/%s",
> > > >  			
> > > >  				       path, list[n]->d_name);
> > > > 
> > > > -			if (len >= sizeof(file) || len < 0)
> > > > +			if (len >= (int)sizeof(file) || len < (int)0)
> > > > 
> > > >  				goto nextf;
> > > >  			
> > > >  			if (dlopen(file, RTLD_NOW) == NULL)
> > > 
> > > I don't see why these two modifications are required.
> > 
> > Just to prevent a build failure in debug mode because warnings are
> > treated as errors and comparing an int to a size_t obviously makes it
> > unhappy.
> 
> That's good that you compiled the code in debug mode too. But what is your
> gcc version? That "len < (int)0" looks really strange.

GCC 4.7.3, but that cast on the zero constant isn't needed and frankly I'm not 
entirely sure what possessed me to put it there in the first place - I'm going 
to put it down to a lack of coffee.

Kind Regards,
Oliver.
