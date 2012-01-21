From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: xtables2 a8, netlink interface
Date: Sat, 21 Jan 2012 15:10:05 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201201422230.11124@blackhole.kfki.hu>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:54147 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab2AUOKH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jan 2012 09:10:07 -0500
In-Reply-To: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Thu, 19 Jan 2012, Jan Engelhardt wrote:

> So here is the first set of patches implementing part of the xt2 core
> and nfnl interface. Please review, I am sure you will have something
> to say :)

At a first glance I must say it looks very promising. Good job!
What seems to be missing is some kind of protocol version negotiation 
support between kernel and userspace. Or it'll come in the next batch of 
patches? :-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
