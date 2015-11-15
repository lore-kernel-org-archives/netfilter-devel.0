From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2] Root in namespace owns x_tables /proc entries
Date: Sun, 15 Nov 2015 19:53:53 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1511151951050.9313@blackhole.kfki.hu>
References: <20151114091214.GA486@compaq.slightly-cracked.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>,
	netfilter-devel@vger.kernel.org
To: Philip Whineray <phil@firehol.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:45407 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbbKOSwN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Nov 2015 13:52:13 -0500
In-Reply-To: <20151114091214.GA486@compaq.slightly-cracked.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Philip,

On Sat, 14 Nov 2015, Philip Whineray wrote:

> Since it's in danger of getting quite complicate, would one or more of
> the following be acceptable?
> 
> - Choose permission in a module parameter
> 
> - Allow setting with sysctl e.g. net.netfilter.conf.xtable_proc_perms
> 
> - Match permissions of /proc/modules (grsec restricts these so we will
>   gain the same policy).

In my opinion either one is good and I'd pick the sysctl setting. That way 
the permissions could be changed without reloading the module and 
independently of the permissions of /proc/modules.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
