From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [patch 1/6] ipset: turn Set name[] into a const pointer
Date: Tue, 25 Jan 2011 21:26:04 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101252124270.19492@blackhole.kfki.hu>
References: <20110124213631.195499507@jonathan.eitzenberger.org> <20110124214009.410600508@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:42140 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab1AYU0G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:26:06 -0500
In-Reply-To: <20110124214009.410600508@jonathan.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 24 Jan 2011, Holger Eitzenberger wrote:

> Also check for the name length.
> 
> Note that passing errno values back is not done consistently at
> various place, as there are some functions which set errno manually,
> others pass -errno back.  I use the -errno approach here, as it is
> slightly shorter.
> 
> Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Applied, thanks Holger!
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
