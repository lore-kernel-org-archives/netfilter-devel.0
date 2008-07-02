From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-2.3.2
Date: Wed, 2 Jul 2008 16:01:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807021559170.32444@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0807021449020.32444@blackhole.kfki.hu>
 <Pine.LNX.4.64.0807021536140.4958@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0807021545290.32444@blackhole.kfki.hu>
 <Pine.LNX.4.64.0807021547090.4958@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:33526 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbYGBOBy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:01:54 -0400
In-Reply-To: <Pine.LNX.4.64.0807021547090.4958@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2 Jul 2008, Krzysztof Oledzki wrote:

> > > Is statically linking still supported?
> > 
> > No, it has never been supported. (Probaly you mean iptables?)
> 
> No, I mean kernel.
> 
> I ask because http://ipset.netfilter.org/install.html no longer points to a
> pom-ng file and it seems that
> ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot/ is currently abandoned
> - there have been no new files created since 2008-05-21.

Oh, I see. I'll add back a pom-ng snapshot to ipset.netfilter.org. The 
pom-ng repository is available from svn - the snapshot creation was 
probably stopped when most of the repositories were moved to git.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
