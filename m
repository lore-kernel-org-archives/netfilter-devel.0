From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/1] add hash:ip,mark data type to ipset
Date: Wed, 8 Jan 2014 22:13:05 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1401082211050.27937@blackhole.kfki.hu>
References: <alpine.DEB.2.10.1312032006500.32285 () blackhole ! kfki ! hu> <1387288904-26456-1-git-send-email-vytas.dauksa@smoothwall.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Vytas Dauksa <vytas.dauksa@smoothwall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:47612 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbaAHVNK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:13:10 -0500
In-Reply-To: <1387288904-26456-1-git-send-email-vytas.dauksa@smoothwall.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 17 Dec 2013, Vytas Dauksa wrote:

> Introduce packet mark support with new ip,mark hash set. This includes
> userspace and kernelspace code, hash:ip,mark set tests and man page
> updates.
> 
> The intended use of ip,mark set is similar to the ip:port type, but for
> protocols which don't use a predictable port number. Instead of port
> number it matches a firewall mark determined by a layer 7 filtering
> program like opendpi.
> 
> As well as allowing or blocking traffic it will also be used for
> accounting packets and bytes sent for each protocol.
[...]

Patch is applied, thanks your work.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
