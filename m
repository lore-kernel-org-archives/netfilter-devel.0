From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [libnftnl PATCH] Rename xfree() to libnftnl_xfree() to avoid
 symbol naming conflict
Date: Wed, 20 Aug 2014 15:00:18 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1408201459330.23974@nerf08.vanv.qr>
References: <1408196389-15559-1-git-send-email-thomas.petazzoni@free-electrons.com> <20140819220236.GA7136@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:50493 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbaHTNAU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:00:20 -0400
In-Reply-To: <20140819220236.GA7136@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2014-08-20 00:02, Pablo Neira Ayuso wrote:

>On Sat, Aug 16, 2014 at 03:39:49PM +0200, Thomas Petazzoni wrote:
>> [...] the xfree() symbols of libnftnl
>> becomes visible to the outside world, causing a conflict with the
>> xfree() symbol defined by nftables.
>> 
>> To solve this, this patch renames the libnftnl xfree() function to
>> libnftnl_xfree().
>
>Would this small patch solve your problem too?
>
>[non-inline attachment]

It would, but why add the redundant cast?
