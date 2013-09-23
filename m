From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Developing own utils based on libipset
Date: Mon, 23 Sep 2013 17:11:25 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309231657210.4412@blackhole.kfki.hu>
References: <loom.20130923T160412-833@post.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Daniel Fiala <danfiala@zoho.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:32858 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab3IWPL2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:11:28 -0400
In-Reply-To: <loom.20130923T160412-833@post.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 23 Sep 2013, Daniel Fiala wrote:

> I would need to perform some manipulations with IPSet tables from my own 
> application written in C. It seems that I understand the interface and 
> can successfully use it. But is it safe and can I rely on the library 
> interface, or can it change significantly in the near future?

The library evolves as ipset itself does, see the different versions in 
lib/libipset.map. Significant change in the API may be required if 
there'll be a need to change the kernel-userspace communication protocol 
and that'll mean a bumped IPSET_PROTOCOL. There's no such plan presently.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
