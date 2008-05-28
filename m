From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Wed, 28 May 2008 08:43:45 +0200
Message-ID: <483CFF21.40608@trash.net>
References: <483AB493.6010503@trash.net> <x6skw443x5@gzp>	<483BB9DE.6050003@trash.net> <x6y75w3q2j@gzp>	<483C088E.4020405@trash.net> <x67idfq6d8@gzp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: "Gabor Z. Papp" <gzp@papp.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41524 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbYE1Gns (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 May 2008 02:43:48 -0400
In-Reply-To: <x67idfq6d8@gzp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gabor Z. Papp wrote:
> * Patrick McHardy <kaber@trash.net>:
> 
> | Your types.h doesn't seem to include the endian annotated
> | types at all. Does this patch work?
> 
> Yes. Next problem:
> 
>   CC       libxt_conntrack.oo
> In file included from libxt_conntrack.c:21:
> ../include/linux/netfilter/xt_conntrack.h:38: error: expected specifier-qualifier-list before '__be32'
> ../include/linux/netfilter/xt_conntrack.h:45: error: expected specifier-qualifier-list before '__be32'
> libxt_conntrack.c: In function 'conntrack_parse': libxt_conntrack.c:321: error: 'struct <anonymous>' has no member named 'protonum'

Yes, I also noticed a bunch of other problems with old
kernel headers. I'll resync the headers and fix it up,
but it might take until tommorrow since I'm not sure
whether I'll get near an internet connection again today.
