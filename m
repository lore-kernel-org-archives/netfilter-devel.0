From: Volker Poplawski <volker@openbios.org>
Subject: Re: libnl: Unmatched NL_ACT_DEL and NL_ACT_CHANGE
Date: Mon, 6 Jul 2009 14:17:40 +0200
Message-ID: <200907061417.41282.volker@openbios.org>
References: <200907051144.51967.volker@openbios.org> <4A51E024.8090402@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from khepri.openbios.org ([80.190.231.112]:23777 "EHLO
	khepri.openbios.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbZGFMR3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:17:29 -0400
In-Reply-To: <4A51E024.8090402@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 06 July 2009 13:29:40 you wrote:
> Volker Poplawski wrote:
> > Hi all.
> >
> > Could s.o. please  have a look at my (short) code at
> > http://pastie.org/534637
> >
> > (maybe compile it with g++ -Wall test.c -o test -I ... -L ... -lnl
> > -lnl-genl - lnl-nf -lnl-route)
> >
> > What the code does is to listen to changes in the ct-table using libnl.
> > It keeps score of reported ctId in a lookup table.
> >
> > Problem is: I'm getting a lot of NL_ACT_CHANGE & NL_ACT_DEL without
> > having seen a matching NL_ACT_NEW. (Also there seems to be no initial
> > cache fill)
> >
> > kernel 2.6.27 (opensuse 11.1), libnl 2.0 (git master)
>
> I think I know whats happening - the ct objects don't define the
> attribute(s) distinguishing different entries, so cache_include()
> doesn't recognize them as new.
>
> Does this patch make any difference?

Yes it does,  NL_ACT_DEL , _CHANGE and _DEL are now matching -- for ct-entries 
created after i made my call to nl_cache_mngr_add( ... "netfilter/ct"... )

However, i still don't get a NL_ACT_DEL on already existing connections 
(CHANGE and DEL though)




