From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: ipset: bitmap:ip,mac type requires "src"
 for MAC
Date: Wed, 13 Apr 2011 13:44:03 +0200
Message-ID: <4DA58C83.2000702@trash.net>
References: <1302379382-32338-1-git-send-email-kadlec@blackhole.kfki.hu> <1302379382-32338-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Lennert Buytenhek <buytenh@wantstofly.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38750 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758504Ab1DMLoF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 07:44:05 -0400
In-Reply-To: <1302379382-32338-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 09.04.2011 22:03, schrieb Jozsef Kadlecsik:
> Enforce that the second "src/dst" parameter of the set match and SET target
> must be "src", because we have access to the source MAC only in the packet.
> The previous behaviour, that the type required the second parameter
> but actually ignored the value was counter-intuitive and confusing.
> 

Applied, thanks Jozsef.
