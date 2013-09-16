From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v5] netfilter: ipset: Fix serious failure in CIDR
 tracking
Date: Mon, 16 Sep 2013 14:22:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309161416040.10847@blackhole.kfki.hu>
References: <1379149553-18945-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309151500440.8707@blackhole.kfki.hu> <2364787.0VxS47rTg4@gentoovm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:57809 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab3IPMWi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:22:38 -0400
In-Reply-To: <2364787.0VxS47rTg4@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 16 Sep 2013, Oliver wrote:

> On Sunday 15 September 2013 15:01:36 Jozsef Kadlecsik wrote:
> > Patch is applied, thanks. I'm going to release a new ipset version next
> > week.
> 
> Excellent, can you possibly make that a friday, I should have a chance 
> to get rebased versions of hash:net,net and comments done a few days 
> before then with in hope of getting one or t'other committed.

The release can wait till Friday.
 
> Also, I'd very much like to see this bugfix in the stable kernels, I'm not 
> exactly sure what the etiquette is on getting it into the pre-requisite 
> mainline fastest? do I submit it to DaveM's net mailing list or straight to 
> LKML, or something else entirely?

The normal way is that I collect the patches and send them to Pablo who 
then submits those to Dave.

It turned out that the stable kernels lack a lot of bugfixes, so for a 
couple of days I have been working on identifying the missing patches. 
Some backporting is required, so it'll still take some time for me to 
complete and update the trees.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
