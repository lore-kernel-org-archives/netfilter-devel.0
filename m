From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/6] netfilter: ipset: avoid use of kernel-only types
Date: Wed, 07 Sep 2011 16:44:30 +0200
Message-ID: <4E67834E.4070004@trash.net>
References: <1315339147-9617-1-git-send-email-kadlec@blackhole.kfki.hu> <1315339147-9617-5-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61560 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab1IGQBY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:01:24 -0400
In-Reply-To: <1315339147-9617-5-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06.09.2011 21:59, Jozsef Kadlecsik wrote:
> When using the xt_set.h header in userspace, one will get these gcc
> reports:
> 
> ipset/ip_set.h:184:1: error: unknown type name "u16"
> In file included from libxt_SET.c:21:0:
> netfilter/xt_set.h:61:2: error: unknown type name "u32"
> netfilter/xt_set.h:62:2: error: unknown type name "u32"

Applied, thanks.
