From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/2] ipset: add forceadd userspace support for hash set
 types
Date: Fri, 14 Feb 2014 11:24:04 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1402141121380.19460@blackhole.kfki.hu>
References: <1391261452-11266-1-git-send-email-johunt@akamai.com> <1391261452-11266-3-git-send-email-johunt@akamai.com> <alpine.DEB.2.10.1402141032310.19460@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:60275 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaBNKYI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:24:08 -0500
In-Reply-To: <alpine.DEB.2.10.1402141032310.19460@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Josh,

One bit is missing and I forgot to add: the new option in userspace should 
be added to ipset_data_sizeof too, to the flags section.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
