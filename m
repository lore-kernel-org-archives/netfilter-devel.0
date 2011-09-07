From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/6] netfilter: ipset: Dumping error could lead to kernel
 BUG
Date: Wed, 07 Sep 2011 16:42:31 +0200
Message-ID: <4E6782D7.3020101@trash.net>
References: <1315339147-9617-1-git-send-email-kadlec@blackhole.kfki.hu> <1315339147-9617-3-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61990 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab1IGQ0Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:26:24 -0400
In-Reply-To: <1315339147-9617-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06.09.2011 21:59, Jozsef Kadlecsik wrote:
> If there was a dumping error in the middle, the set-specific variable was
> not zeroed out and thus the 'done' function of the dumping wrongly tried
> to release the already released reference of the set. The already released
> reference was caught by __ip_set_put and triggered a kernel BUG message.
> The issue was reported by Jean-Philippe Menil.

Applied, thanks.
