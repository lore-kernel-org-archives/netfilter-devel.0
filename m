From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 00/13] ipset patches for nf-next
Date: Sat, 27 Apr 2013 20:44:33 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1304272042070.1511@blackhole.kfki.hu>
References: <1367067045-960-1-git-send-email-kadlec@blackhole.kfki.hu> <517BCA9A.3080602@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:51875 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab3D0Sof (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Apr 2013 14:44:35 -0400
In-Reply-To: <517BCA9A.3080602@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 27 Apr 2013, Dash Four wrote:

> Jozsef Kadlecsik wrote:
>
> > Please consider applying the next patches against your nf-next tree.
> > 
> > The patches introduce the new extensions infrastructure in ipset and
> > add packet/byte counters as a new extension besides timeouts. The set
> > match is extended by the functionality to match the counters too.
> >   
> Jozsef, are these features already supported in userspace or are you going to
> release a separate version?

It's already supported in userspace in the main branch of the git tree. As 
the patch for the userspace part of the set match is committed in the 
iptables git tree, there'll come the new ipset release.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
