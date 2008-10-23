From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 2.4 released
Date: Thu, 23 Oct 2008 16:58:18 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810231657350.28810@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0810201254190.23040@blackhole.kfki.hu>
 <alpine.LNX.1.10.0810230418300.20661@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:42452 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbYJWO6T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:58:19 -0400
In-Reply-To: <alpine.LNX.1.10.0810230418300.20661@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 23 Oct 2008, Krzysztof Oledzki wrote:

> More problems. :| Restoring my sets+iptables configuration and running "ipset
> -F" oopses the kernel, please look at the attached oops.

This is a serious issue in 2.4.x, I'll look into it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
