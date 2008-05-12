From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Module aliases for xt_iprange
Date: Mon, 12 May 2008 19:55:52 +0200
Message-ID: <482884A8.2030502@trash.net>
References: <20080512174246.GA28222@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49346 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbYELR4a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 13:56:30 -0400
In-Reply-To: <20080512174246.GA28222@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester wrote:
> Using iptables 1.3.8 with kernel 2.6.25, rules which include '-m iprange'
> don't automatically pull in xt_iprange module.  Below patch adds module
> aliases to fix that.  Patch against latest -git, but seems like a good 
> candidate for -stable also.

Applied, thanks Phil. I'll also push it to -stable once it hits
upstream.
