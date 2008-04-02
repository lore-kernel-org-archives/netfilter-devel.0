From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH][IPTABLES]: libxt_iprange: Fix IP validation logic
Date: Wed, 02 Apr 2008 12:17:39 +0200
Message-ID: <47F35D43.7060408@trash.net>
References: <47F2A670.2000405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60332 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYDBKRo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:17:44 -0400
In-Reply-To: <47F2A670.2000405@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

James King wrote:
> [IPTABLES]: libxt_iprange: Fix IP validation logic
> 
> IP address validation logic was inverted, causing valid addresses to
> be rejected.
> 
> Signed-off-by: James King <t.james.king@gmail.com>


Applied, thanks.
