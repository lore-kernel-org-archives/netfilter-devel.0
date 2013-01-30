From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/3] Introduce aliases for matches and targets
Date: Wed, 30 Jan 2013 22:05:19 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301302204260.24048@blackhole.kfki.hu>
References: <1359405175-4394-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:34235 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab3A3VFW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:05:22 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 77CBD1F4091
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jan 2013 22:05:19 +0100 (CET)
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fxQrlr0ufhdr for <netfilter-devel@vger.kernel.org>;
	Wed, 30 Jan 2013 22:05:19 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp2.kfki.hu (Postfix) with ESMTP id 5610E1F408F
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jan 2013 22:05:19 +0100 (CET)
In-Reply-To: <1359405175-4394-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Mon, 28 Jan 2013, Jozsef Kadlecsik wrote:

> The next patches introduce the alias support for matches and targets in
> iptables. The goal is to keep the old syntax of matches/targets merged
> into "super" matches/targets. This way firewall scripts can run unmodified,
> using the old extensions.
> 
> The NOTRACK alias requires a new revision of the CT target (flags are checked
> in the current revision). Next follows the kernel part of the patches. Until
> the new revision is missing, instead of the warning, a notice is printed
> to the users.
> 
> Please comment/ACK the patches.

Is it OK then to apply these patches in the git tree of iptables?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
