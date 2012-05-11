From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.12 released
Date: Fri, 11 May 2012 21:40:11 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1205112138580.22653@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1205101211080.18562@blackhole.kfki.hu> <alpine.LNX.2.01.1205101238020.20012@frira.vanv.qr> <alpine.DEB.2.00.1205101316470.18862@blackhole.kfki.hu> <alpine.LNX.2.01.1205101327310.12733@frira.vanv.qr> <alpine.DEB.2.00.1205101337160.19028@blackhole.kfki.hu>
 <CAMQP0sn=2jKYzoiUVu+oTRYj-niL84Lg2Z1UoO0UnFXJjV8Ggw@mail.gmail.com> <CAMQP0s=uSzOn-o7jwKLyhTaZud4d04hMN=JXrCQLrFD+6Zinkw@mail.gmail.com> <alpine.DEB.2.00.1205101724370.19418@blackhole.kfki.hu> <CAMQP0sm+_8FytQxQHCgk44DVesxMycYQbMW9z+XR0-09NniT9Q@mail.gmail.com>
 <CAMQP0snnXgGCJqN1iuN+y9_rgpa7HMrRuM0akhCa-NtxmBz_QA@mail.gmail.com> <CAMQP0s=DvvYL9SKURz2nm9WuWHQEXBQv9UEQ487GQMwhqa_rgg@mail.gmail.com> <4FAC3A87.3010500@googlemail.com> <CAMQP0smebRtU8zpjYZTP0EKmOHS=Ncn+iShbcZQdBHnH7ed4bw@mail.gmail.com>
 <4FAD09FC.30707@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Neutron Soutmun <neo.neutron@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:59170 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422670Ab2EKTkP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 May 2012 15:40:15 -0400
In-Reply-To: <4FAD09FC.30707@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 11 May 2012, Mr Dash Four wrote:

> > However I'm working on the "ipset_hash_iplookup" which is proposed to
> > be used with "SETRAWNAT" target.
> > Both are my experimental ipset type and iptables/xtables target
> > respectively. No problems for SETRAWNAT as the iptables/xtables
> > provides the dynamic module loading support already.
> >   
> I don't suppose you are working on ways to include ipset targets in tc 
> by any chance, are you? *hopeful look*

Nothing required, all iptables targets are supported by tc.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
