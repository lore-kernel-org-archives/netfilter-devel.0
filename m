From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [patch 2/6] ipset: fix the Netlink sequence number
Date: Tue, 25 Jan 2011 21:26:47 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101252126120.19492@blackhole.kfki.hu>
References: <20110124213631.195499507@jonathan.eitzenberger.org> <20110124214010.719680787@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:54289 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab1AYU0s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:26:48 -0500
In-Reply-To: <20110124214010.719680787@jonathan.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 24 Jan 2011, Holger Eitzenberger wrote:

> Do not use time() as a Netlink sequence number for each message,
> as otherwise the same seq number will be used when sending
> another message in the same second.  Instead use time() just for
> initialization, then increment per message.
> 
> Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Yes, you are right, also applied.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
