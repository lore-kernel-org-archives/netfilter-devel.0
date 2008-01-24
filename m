From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Set default policy of chains in filter tables to
 DROP/ACCEPT
Date: Thu, 24 Jan 2008 15:37:50 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801241533540.15487@blackhole.kfki.hu>
References: <1201183885868-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:60837 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbYAXOhw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 09:37:52 -0500
In-Reply-To: <1201183885868-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, 24 Jan 2008, Laszlo Attila Toth wrote:

> Set the default policy of INPUT/FORWARD/OUTPUT chains of IPv4/IPv6 filter
> tables to DROP or ACCEPT in kernel configuration. It can be override by
> a module parameter (defaultdrop for IPv4 and defaultdropv6 for IPv6).

The best practice is to load in the rules before bringing up the 
interfaces. So what would be the real benefit from the patch?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
