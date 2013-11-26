From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: RE: ip_set_hash_netnet.c:62: possible typo ?
Date: Tue, 26 Nov 2013 21:22:25 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1311262120260.9669@blackhole.kfki.hu>
References: <DUB118-W3449F030E13F8088A847CC9CED0@phx.gbl>,<alpine.DEB.2.10.1311252149230.5977@blackhole.kfki.hu> <DUB118-W48FC0FEE04F347D23F33C9CED0@phx.gbl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: David Binderman <dcb314@hotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:44860 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab3KZUW1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:22:27 -0500
In-Reply-To: <DUB118-W48FC0FEE04F347D23F33C9CED0@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 25 Nov 2013, David Binderman wrote:

> >> static inline bool
> >> hash_netnet4_data_equal(const struct hash_netnet4_elem *ip1,
> >>              const struct hash_netnet4_elem *ip2,
> >>              u32 *multi)
> >> {
> >>     return ip1->ipcmp == ip2->ipcmp &&
> >>            ip1->ccmp == ip2->ccmp;
> >> }
> >>
> >> would be better code ?
> >
> > Yes, you are completely right. I'm going to check why the testsuite did
> > not catch it.
> 
> Maybe because the function is dead code ?
> 
> I couldn't find any callers of it. Maybe that's another bug and
> it should be called from somewhere else in the same file.

No, it's not dead code, the common part (ip_set_hash_gen.h) "calls" it at 
several places. The tests were insufficient to check the case.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
