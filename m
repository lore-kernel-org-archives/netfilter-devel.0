From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Linux 4.2 build error in net/netfilter/ipset/ip_set_hash_netnet.c
Date: Thu, 20 Aug 2015 21:27:39 +0200
Message-ID: <20150820192739.GA18180@salvia>
References: <CAHTgTXUmreHAqPfgGEd+GJNb_OEzaCuytqBTjZsE2GDqiy3TCw@mail.gmail.com>
 <20150705153520.GA23589@roeck-us.net>
 <mo0o3b$g5d$1@ger.gmane.org>
 <20150713164122.GA26283@salvia>
 <alpine.DEB.2.10.1507141910280.28425@blackhole.kfki.hu>
 <CABA31DpRS5NXQm0_tP3eMxE4E9TdtGmrZbr+ZE8JUiNs3qHbMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Alan Bartlett <ajb@elrepo.org>
To: Akemi Yagi <amyagi@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45314 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbbHTTV3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 15:21:29 -0400
Content-Disposition: inline
In-Reply-To: <CABA31DpRS5NXQm0_tP3eMxE4E9TdtGmrZbr+ZE8JUiNs3qHbMg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 11, 2015 at 08:50:28AM -0700, Akemi Yagi wrote:
> On Tue, Jul 14, 2015 at 10:12 AM, Jozsef Kadlecsik > <kadlec@blackhole.kfki.hu> wrote:
[...]
> > As I mentioned at the workshop, the patch
> > net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch has been
> > added to the -mm tree at Jun 17. My impression was that that way the bug
> > was fixed and everything was all right.
> >
> > Best regards,
> > Jozsef
> 
> The referenced patch does indeed fix the issue but it is still not in
> Linus' tree as of kernel 4.2.0-0.rc6. Does anyone know how to push
> forward this so the official 4.2 kernel would have the fix?

Is this problem still present in 4.2.0-rc7?

I can put this into my nf git tree then pass this up to David. If so,
could you please Cc the author of that patch so he knows this is
following its path to master, I would like to avoid that we get this
from two different paths.

Thanks!
