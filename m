From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: ipset: timeout values corrupted on set
 resize
Date: Mon, 25 Feb 2013 18:53:40 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302251851450.6565@blackhole.kfki.hu>
References: <1361302559-8657-1-git-send-email-johunt@akamai.com> <alpine.DEB.2.00.1302202238210.9720@blackhole.kfki.hu> <51254FA8.3050407@akamai.com> <alpine.DEB.2.00.1302211749080.11814@blackhole.kfki.hu> <512BA116.9000207@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:32883 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758695Ab3BYRxm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:53:42 -0500
In-Reply-To: <512BA116.9000207@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 25 Feb 2013, Mr Dash Four wrote:

> > The new extension to be introduced is the packet and bytes counters per
> > elements.   
> That would be superb - a feature truly missed since I started using ipsets.
> Would that count packet/bytes in sub-sets (members of set:list) as well?

Yes, the counters extension, similarly to the timeouts, will be supported 
in all set types.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
