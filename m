From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/2] ulogd2 patches
Date: Mon, 16 Jan 2012 16:58:33 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201161657570.32734@blackhole.kfki.hu>
References: <1326639889-28836-1-git-send-email-kadlec@blackhole.kfki.hu> <20120116124650.GA13273@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	marty <martinbarrowcliff@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:48602 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171Ab2APP6e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:58:34 -0500
In-Reply-To: <20120116124650.GA13273@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 16 Jan 2012, Pablo Neira Ayuso wrote:

> On Sun, Jan 15, 2012 at 04:04:47PM +0100, Jozsef Kadlecsik wrote:
> > 
> > Here follow two patches which address the MySQL support issues. The first
> > one adds the support of stored procedures (which then gives the ability
> > to use SQL transactions) and the second one introduces a new plugin to
> > provide IPv4 addresses in host order, also for MySQL tables.
> > Please consider applying them.
> 
> Jozsef, if everybody is happy with this, feel free to push it yourself to
> ulogd2 git tree.

I have pushed the patches into the ulogd2 git tree.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
