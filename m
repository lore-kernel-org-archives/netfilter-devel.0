From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: nfacct utility now available at git.netfilter.org
Date: Sat, 31 Dec 2011 17:36:05 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1112311733110.26130@blackhole.kfki.hu>
References: <20111230201147.GA14014@1984> <alpine.LNX.2.01.1112302137140.24638@frira.zrqbmnf.qr> <20111231150052.GA17062@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:40035 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab1LaQgH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Dec 2011 11:36:07 -0500
In-Reply-To: <20111231150052.GA17062@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 31 Dec 2011, Pablo Neira Ayuso wrote:

> On Fri, Dec 30, 2011 at 09:37:37PM +0100, Jan Engelhardt wrote:
> > On Friday 2011-12-30 21:11, Pablo Neira Ayuso wrote:
> > 
> > >The nfacct utility is now available at git.netfilter.org
> > >
> > >http://git.netfilter.org/cgi-bin/gitweb.cgi?p=nfacct.git;a=summary
> > 
> > So, not in ./iptables/utils/?
> 
> :-)
> 
> Not sure that it's necessary to enforce the libmnl and libnetfilter_acct
> dependencies that iptables may require since then.
> 
> Thinking it well, better not to pollute the iptables tree with extra
> utilities.

Somehow I have to agree. Everyone can cherry pick which elements to use 
from the toolkit which is built around netfilter.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
