From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipsets and network namespaces
Date: Sun, 8 Apr 2012 20:06:15 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1204082001370.4765@blackhole.kfki.hu>
References: <CAFJYBU3q9au5qS0_CC4kp_jsRo-r08hejhQb_nvMqXGt57WdSw@mail.gmail.com> <alpine.DEB.2.00.1204051324190.23192@blackhole.kfki.hu> <4F8149A3.1080607@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Gorik Van Steenberge <gorik.vansteenberge@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:36494 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab2DHSGT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Apr 2012 14:06:19 -0400
In-Reply-To: <4F8149A3.1080607@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 8 Apr 2012, Gao feng wrote:

> ? 2012?04?05? 19:24, Jozsef Kadlecsik ??:
> > On Thu, 5 Apr 2012, Gorik Van Steenberge wrote:
> > 
> >> I've noticed that when creating a new network namespace (using the lxc
> >> tools) that ipsets (userspace v6.11 on kernel 3.3.1) are still global,
> >> i.e. an ipset created in the container is visible in the host and vice
> >> versa. Iptables rulesets, however, are isolated.
> >>
> >> Is this an as of yet unimplemented feature or a conscious design decision?
> > 
> > It's an unimplemented feature - no one requested it yet ;-).
> 
> And I see there are a lot of /proc/sys/entries are not isolated.
> is this an unimplemented feature too?

I don't know what you mean here. There's nothing under /proc/sys which is 
related to ip_set* modules.
 
> If so,I want to implement it. How do you think about this?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
