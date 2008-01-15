From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] Inline functions iptcc_is_builtin() and set_changed().
Date: Tue, 15 Jan 2008 18:01:54 +0100
Message-ID: <478CE702.3060306@trash.net>
References: <1198244659.23885.8.camel@localhost.localdomain> <1198244774.23885.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>,
	Harald Welte <laforge@netfilter.org>,
	Martin Josefsson <gandalf@netfilter.org>
To: jdb@comx.dk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44765 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbYAORCG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:02:06 -0500
In-Reply-To: <1198244774.23885.10.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jesper Dangaard Brouer wrote:
> The two functions are obvious candidates for inlining.
> Using gprof(1) shows that they actually affects performance.
> 
> Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>

Applied, thanks.
