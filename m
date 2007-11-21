From: Patrick McHardy <kaber@trash.net>
Subject: Re: [FIX] Re: Make/compile error for iptables-1.4.0rc1
Date: Wed, 21 Nov 2007 08:53:39 +0100
Message-ID: <4743E403.8090408@trash.net>
References: <1195245146.15945.50.camel@localhost.localdomain>	 <Pine.LNX.4.64.0711162234000.21235@fbirervta.pbzchgretzou.qr>	 <1195390182.15945.57.camel@localhost.localdomain>	 <1195395787.15945.77.camel@localhost.localdomain> <1195600242.1228.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: yasuyuki@netfilter.org,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: jdb@comx.dk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55933 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbXKUHxu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Nov 2007 02:53:50 -0500
In-Reply-To: <1195600242.1228.7.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jesper Dangaard Brouer wrote:
> The problem is that "linux/netfilter/x_tables.h" got included in SVN
> (changeset 6920).  The fix is to delete it from SVN, so that the systems
> "x_tables.h" has effect again.
> 
> Can someone with SVN write access fix this?
> 
>   "svn rm include/linux/netfilter/x_tables.h"


Actually the fix is the other way around, we want to be able to
build iptables without having kernel sources locally. So I
guess the x_tables.h file should be resynced or something?
