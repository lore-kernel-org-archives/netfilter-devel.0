From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: net/netfilter/ipset: work around gcc-4.4.4 initializer bug (was:
 Re: linux-next: Tree for Jun 25)
Date: Thu, 25 Jun 2015 11:14:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1506251111290.7015@blackhole.kfki.hu>
References: <CAMuHMdUvC-Y0eNQ8DEm=ZG1xm99YkfFovTw1VzSTd295SJxjLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux-Next <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	netfilter-devel@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:33393 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbbFYJOw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jun 2015 05:14:52 -0400
In-Reply-To: <CAMuHMdUvC-Y0eNQ8DEm=ZG1xm99YkfFovTw1VzSTd295SJxjLA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 25 Jun 2015, Geert Uytterhoeven wrote:

> On Thu, Jun 25, 2015 at 10:17 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Changes since 20150624:
> >
> > The net-next tree lost its build failure.
> 
> > $ git checkout -b akpm remotes/origin/akpm/master
> > Applying: net/netfilter/ipset: work around gcc-4.4.4 initializer bug
> 
> I can confirm this patch (which I couldn't find on any mailing list) is also
> needed for gcc 4.1.2.
> 
> Note that the issue is in mainline since last night.

Sorry, I haven't checked the patch with older gcc releases.

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
