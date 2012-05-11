From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.12 released
Date: Fri, 11 May 2012 10:40:54 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1205111034100.20558@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1205101211080.18562@blackhole.kfki.hu> <alpine.LNX.2.01.1205101238020.20012@frira.vanv.qr> <alpine.DEB.2.00.1205101316470.18862@blackhole.kfki.hu> <alpine.LNX.2.01.1205101327310.12733@frira.vanv.qr> <alpine.DEB.2.00.1205101337160.19028@blackhole.kfki.hu>
 <CAMQP0sn=2jKYzoiUVu+oTRYj-niL84Lg2Z1UoO0UnFXJjV8Ggw@mail.gmail.com> <CAMQP0s=uSzOn-o7jwKLyhTaZud4d04hMN=JXrCQLrFD+6Zinkw@mail.gmail.com> <alpine.DEB.2.00.1205101724370.19418@blackhole.kfki.hu> <CAMQP0sm+_8FytQxQHCgk44DVesxMycYQbMW9z+XR0-09NniT9Q@mail.gmail.com>
 <CAMQP0snnXgGCJqN1iuN+y9_rgpa7HMrRuM0akhCa-NtxmBz_QA@mail.gmail.com> <CAMQP0s=DvvYL9SKURz2nm9WuWHQEXBQv9UEQ487GQMwhqa_rgg@mail.gmail.com> <4FAC3A87.3010500@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:53782 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757940Ab2EKIk5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 May 2012 04:40:57 -0400
In-Reply-To: <4FAC3A87.3010500@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 10 May 2012, Mr Dash Four wrote:

> > the point of this feature is providing the easy way that the
> > third-party or the experimental modules
> > plug into the existing ipset userspace binary without recompile.
> > 
> > You could build the experimental ipset "FOO" kernel module and build
> > the shared-lib of "FOO" userspace tool module and
> > plug into the system without recompile the ipset userspace tool at
> > all. It's inspired by iptables (kernel/userspace module).
> >   
> Is there a documentation on how to do that? For example, if I wish to 
> add my own ipset type/matching (as a separate module), where do I start 
> looking?

As documentation, there's nothing yet.

The userspace part of a set type is quite simple: just the 
parsing, printing, dimension, supported families have to be definied.
The kernel part is, well, another matter. Of course all the existing 
types can be used as examples.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
