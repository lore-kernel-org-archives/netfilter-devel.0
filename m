From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 2/7] netfilter: ipset: Support comments in hash-type
 ipsets.
Date: Fri, 20 Sep 2013 23:35:22 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309202332390.28758@blackhole.kfki.hu>
References: <1379665825-42563-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1379665825-42563-3-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309202319250.28758@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:48327 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab3ITVfY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 17:35:24 -0400
In-Reply-To: <alpine.DEB.2.00.1309202319250.28758@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 20 Sep 2013, Jozsef Kadlecsik wrote:

> On Fri, 20 Sep 2013, Oliver wrote:
> 
> > From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> > 
> > This provides kernel support for creating ipsets with comment support.
> > 
> > This does incur a penalty to flushing/destroying an ipset since all
> > entries are walked in order to free the allocated strings, this penalty
> > is of course less expensive than the operation of listing an ipset to
> > userspace, so for general-purpose usage the overall impact is expected
> > to be little to none.
> 
> This patch and the one for the bitmap type look all right.

I have to correct myself: the IPSET_ATTR_COMMENT attribute is not added to 
the adt_policy of the set type definitions.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
