From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_*: Use uint*_t instead of u_int*_t
Date: Fri, 15 May 2015 21:34:08 +0200
Message-ID: <20150515193408.GA21843@salvia>
References: <20150515191039.GB16749@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Felix Janda <felix.janda@posteo.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36123 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbbEOT3U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 May 2015 15:29:20 -0400
Content-Disposition: inline
In-Reply-To: <20150515191039.GB16749@euler>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 15, 2015 at 09:10:39PM +0200, Felix Janda wrote:
> Hello,
> 
> I've been trying to build many netfilter.org projects on a system with
> the musl libc library. Alas, I often get errors about undeclared
> u_int8_t, ... musl will declare these types when <sys/types.h> is
> included and _GNU_SOURCE or _BSD_SOURCE is set. However many
> netfilter.org projects don't include <sys/types.h>.

I suspected this when I applied the patch from the Alpine Linux guy
for libnetfilter_log just a while.

> On the other hand, changing the types to the <stdint.h> uint*_t works
> in most cases because <netinet/in.h> is often included, which (by POSIX)
> includes <inttypes.h> which includes <stdint.h>. (Sometimes <stdint.h> or
> <inttypes.h> is also directly included.)

Last time I looked into this, my conclusion was that it was safe to
migrate to uint*_t stdint types, but it would be good to double check.

> In some cases u_int*_t and uint*_t types are mixed, so I am going to
> prepare a patch series which changing them and making sure that the
> public headers explicitly include <stdint.h> if they use these types.
> 
> Assuming these (relatively invasive in terms of changed lines of code)
> changes are acceptable, I have some questions:
> 
> Are the linux_nfnetlink_*.h only used as includes from other headers?
> (so that they don't need an explicit #include <stdint.h>)

You can refresh those header files to get them in sync with the
kernel, that can come in several initial patches. They are cached
copies of what we have in the kernel, as a result you'll get __u*
types.

Then, the follow up patch can convert them to uint*

> Is there anything I need to be careful about?
> 
> There are also kernel types (e.g. __u8) in some places. Should I also
> bother about these while I'm at it? These were not problematic for me
> since these (mostly?) kernel headers include <linux/types.h>.

Those should remain there, as they are part of a cached copy of what
we have in the linux kernel tree. The idea is basically to ensure
compilation of libraries independently of what linux headers you have
in your system (eg. people with very old header files).
