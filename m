From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] Incorrect handling of invalid TCP option in TCP connection
 tracking
Date: Tue, 30 Aug 2011 15:45:59 +0200
Message-ID: <4E5CE997.8080408@trash.net>
References: <1314711341-28392-1-git-send-email-kadlec@blackhole.kfki.hu> <1314711341-28392-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55875 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab1H3NqB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 09:46:01 -0400
In-Reply-To: <1314711341-28392-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30.08.2011 15:35, Jozsef Kadlecsik wrote:
> Michael M. Builov reported that in the tcp_options and tcp_sack functions
> of netfilter TCP conntrack the incorrect handling of invalid TCP option
> with too big opsize may lead to read access beyond tcp-packet or buffer
> allocated on stack (netfilter bugzilla #738). The fix is to stop parsing
> the options at detecting the broken option.

Applied, thanks Jozsef.
