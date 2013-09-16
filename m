From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH v5] netfilter: ipset: Fix serious failure in CIDR tracking
Date: Mon, 16 Sep 2013 10:46:58 +0200
Message-ID: <2364787.0VxS47rTg4@gentoovm>
References: <1379149553-18945-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309151500440.8707@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:54334 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab3IPIrd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:47:33 -0400
In-Reply-To: <alpine.DEB.2.00.1309151500440.8707@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 15 September 2013 15:01:36 Jozsef Kadlecsik wrote:
> Patch is applied, thanks. I'm going to release a new ipset version next
> week.
> 
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
>           H-1525 Budapest 114, POB. 49, Hungary

Excellent, can you possibly make that a friday, I should have a chance to get 
rebased versions of hash:net,net and comments done a few days before then with 
in hope of getting one or t'other committed.

Also, I'd very much like to see this bugfix in the stable kernels, I'm not 
exactly sure what the etiquette is on getting it into the pre-requisite 
mainline fastest? do I submit it to DaveM's net mailing list or straight to 
LKML, or something else entirely?

Thanks,
Oliver.
