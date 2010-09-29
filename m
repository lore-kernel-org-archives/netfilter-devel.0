From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: could ipporthash be extended/modified
Date: Wed, 29 Sep 2010 09:12:12 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1009290908140.4241@blackhole.kfki.hu>
References: <4CA25F28.8050202@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:33532 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab0I2HVO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:21:14 -0400
In-Reply-To: <4CA25F28.8050202@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 28 Sep 2010, Mr Dash Four wrote:

> Currently the above type can only accept /16 (B-class) type addresses. Is
> there any reason for this limitation? 

The limitation makes possible to store the IP address and port data pair 
in 32 bits.

> Could this be extended to accept any IP address?

In the next ipset branch the limitation is lifted. That version will be 
announced and released next month, around the netfilter workshop.
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
