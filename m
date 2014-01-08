From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] add markmask for hash:ip,mark data type
Date: Wed, 8 Jan 2014 22:22:54 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1401082213110.27937@blackhole.kfki.hu>
References: <alpine.DEB.2.10.1312032006500.32285 () blackhole ! kfki ! hu> <1387288904-26456-1-git-send-email-vytas.dauksa@smoothwall.net> <1387288904-26456-2-git-send-email-vytas.dauksa@smoothwall.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Vytas Dauksa <vytas.dauksa@smoothwall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:44287 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbaAHVW5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:22:57 -0500
In-Reply-To: <1387288904-26456-2-git-send-email-vytas.dauksa@smoothwall.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 17 Dec 2013, Vytas Dauksa wrote:

> Introduce packet mark mask for hash:ip,mark data type. This allows to
> set mark bit filter for the ip set.

Why it's important that the kernel should mask the mark value, when the 
user could add the intended value directly? The only case where it's 
required when entries added/deleted by the SET target. It's more natural 
for me if the markmask value has a meaning and effect for kernel side 
add/del operations only, and ignored for user add/del/test and kernel 
tests. What's your opinion?

A small thing, but I'd prefer if the mark value were printed/saved in hex 
instead of decimal, similarly to iptables. Better introduce a new print 
function for it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
