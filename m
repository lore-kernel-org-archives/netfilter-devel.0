From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset: Pass IPSET_BIN to test scripts to change binary
 location
Date: Mon, 7 Apr 2014 21:57:45 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1404072157120.9857@blackhole.kfki.hu>
References: <20140404032422.GA5954@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:43221 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbaDGT5p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:57:45 -0400
In-Reply-To: <20140404032422.GA5954@nitrogen.neutroncom.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 4 Apr 2014, Neutron Soutmun wrote:

> In the "as-installed" package testing situation, the test scripts should
> invokes the system installed "ipset" binary.
> Therefore, the IPSET_BIN could be passed to change the binary location.
> 
>   IPSET_BIN=/sbin/ipset ./runtest.sh
> 
> The test scripts run fine in build source tree without IPSET_BIN.

This patch is also applied, thanks.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
