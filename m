From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset can't load -N and -A separately
Date: Mon, 6 Apr 2009 11:15:52 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0904061112210.29852@blackhole.kfki.hu>
References: <49D9B571.7090802@bigtelecom.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Badalian Vyacheslav <slavon@bigtelecom.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:38739 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388AbZDFJPz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:15:55 -0400
In-Reply-To: <49D9B571.7090802@bigtelecom.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 6 Apr 2009, Badalian Vyacheslav wrote:

> If i try generate restore file its can't load first all -N and then all
> -A fileds.
> If we do s/^/ipset / its normal load all rules.

That's the normal and documented behaviour, see 'man ipset'. In a restore 
script you must create a set, add all its elements, then create the next 
set, add all of those elements and so on. 
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
