From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't
 work
Date: Sat, 16 Aug 2008 19:12:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0808161902320.20936@blackhole.kfki.hu>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>
 <Pine.LNX.4.64.0808152127180.20054@blackhole.kfki.hu>
 <412e6f7f0808151705j58845461y952805d122bcf2a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:49349 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbYHPRMZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2008 13:12:25 -0400
In-Reply-To: <412e6f7f0808151705j58845461y952805d122bcf2a7@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 16 Aug 2008, Changli Gao wrote:

> On Sat, Aug 16, 2008 at 3:31 AM, Jozsef Kadlecsik
> > With your patch applied we'd loose supporting multiple matches of the same
> > type.
> >
> 
> No we don't loose that function. Look at this example:

Yes, you are right: it seems it was too late yesterday for mental 
patching, compiling and testing ;-).

Still, with your patch we'd break backward compatibility by making 
mandatory for match options to strictly follow '-m matchname'.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
