From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Problem with ipset on sparc64
Date: Thu, 5 Nov 2009 21:03:12 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0911052100010.14609@blackhole.kfki.hu>
References: <4513233BE7DF454BB62D30017EEE55436CFB9228E4@GVW1115EXC.americas.hpqcorp.net> <alpine.LSU.2.00.0911042258430.16456@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Chini, Georg (HP App Services)" <georg.chini@hp.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:39342 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757696AbZKEUDI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:03:08 -0500
In-Reply-To: <alpine.LSU.2.00.0911042258430.16456@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 4 Nov 2009, Jan Engelhardt wrote:

> To workaround the alignedness issue, you could take an x86_64 machine
> and compile a strictly 32-bit ipset on it, and see whether the values
> are also off.

On x86_64 using a 32-bit ipset, the listed values are correct.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
