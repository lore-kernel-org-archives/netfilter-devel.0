From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2] iptables: allow service names in [DS]NAT targets
Date: Wed, 24 Jul 2013 23:11:48 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1307242308350.23361@blackhole.kfki.hu>
References: <20130708164606.GA10203@linuxace.com> <20130724190038.GA1288@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:46788 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab3GXVLv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:11:51 -0400
In-Reply-To: <20130724190038.GA1288@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 24 Jul 2013, Pablo Neira Ayuso wrote:

> On Mon, Jul 08, 2013 at 09:46:06AM -0700, Phil Oester wrote:
> > As reported by Alexander Hoogerhuis, the [DS]NAT targets do not allow use of
> > service names in the --to argument.  The same problem was fixed in the REDIRECT
> > target in commit 84d758b3 ("extensions: REDIRECT: fix --to-ports parser").
> > Use a similar fix here.
> 
> While testing this I noticed that this works:
> 
> --to-source 1.1.1.1:telnet
> --to-source 1.1.1.1-1.1.1.10:1025-3000
> --to-source 1.1.1.1-1.1.1.10:telnet
> 
> But this does not:
> 
> --to-source 1.1.1.1-1.1.1.10:telnet-http
> iptables v1.4.19.1: SNAT: Bad value for "--to" option:
> "1.1.1.1-1.1.1.10:telnet-ssh"
> 
> I think it should, for consistency (even if I have to confess that it
> looks a bit ugly to me).
> 
> If you decide to address this and send me a new version to support
> this, then it would be also good to update the manpage to say that we
> support services starting 1.4.20.

That is still ambiguous - there are service names with dash. So I suggest 
to support the notation '[name-with-dash]' in order to explicitly express 
and handle such cases.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
