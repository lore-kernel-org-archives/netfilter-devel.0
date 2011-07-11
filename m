From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] netfilter: ipset: Fix compiler warnings "'hash_ip4_data_next'
 declared inline after being called"
Date: Mon, 11 Jul 2011 18:51:49 +0200
Message-ID: <4E1B2A25.207@trash.net>
References: <1310377975-993-1-git-send-email-kadlec@blackhole.kfki.hu> <1310377975-993-2-git-send-email-kadlec@blackhole.kfki.hu> <1310377975-993-3-git-send-email-kadlec@blackhole.kfki.hu> <1310377975-993-4-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Chris Friesen <chris.friesen@genband.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51890 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177Ab1GKQvv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:51:51 -0400
In-Reply-To: <1310377975-993-4-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 11.07.2011 11:52, schrieb Jozsef Kadlecsik:
> Some gcc versions warn about prototypes without "inline" when the declaration
> includes the "inline" keyword. The fix generates a false error message
> "marked inline, but without a definition" with sparse below 0.4.2.
> 
> Signed-off-by: Chris Friesen <chris.friesen@genband.com>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Applied, thanks.

But please try to keep the subject lines to something like 72
characters, if it exceeds that amount by a lot its better to
put the exact warning inside the body.
