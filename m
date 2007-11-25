From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix make/compile error for iptables-1.4.0rc1
Date: Sun, 25 Nov 2007 16:13:59 +0100
Message-ID: <47499137.3060709@trash.net>
References: <1195245146.15945.50.camel@localhost.localdomain>	 <Pine.LNX.4.64.0711162234000.21235@fbirervta.pbzchgretzou.qr>	 <1195390182.15945.57.camel@localhost.localdomain>	 <1195395787.15945.77.camel@localhost.localdomain>	 <1195600242.1228.7.camel@localhost.localdomain>	 <4743E403.8090408@trash.net>	 <1195673456.1228.14.camel@localhost.localdomain>	 <47455A68.3030309@trash.net>	 <1195828201.3866.20.camel@localhost.localdomain> <1195834612.3866.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: yasuyuki@netfilter.org,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: jdb@comx.dk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61652 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbXKYPOi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 10:14:38 -0500
In-Reply-To: <1195834612.3866.42.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jesper Dangaard Brouer wrote:
> Fixing a make/compile issue with iptables, release candidate 1.4.0rc1,
> which has existed since SVN changeset 6920.  This patch adds ip_tables.h
> and ip6_tables.h, and updates x_tables.h, taken from Linus'es git tree.
> 
> Changeset 6920 added the include file x_tables.h from kernel source, but
> didn't add ip_tables.h and ip6_tables.h.
> 
> At some point (Tue Nov 14 19:48:48 2006, by Yasuyuki Kozakai) these
> kernel headers where changed, which actually removes certain
> depencencies from ip_tables.h and ip6_tables.h to x_tables.h.
> 
> If compiling will fail, with old kernel headers (ip_tables.h and
> ip6_tables.h) available in systems include path, because they depend on
> certaine defines in x_tables.h with is missing in the version in SVN.


Applied, but I stripped the #ifdef __KERNEL__ sections first.
Thanks Jesper.
