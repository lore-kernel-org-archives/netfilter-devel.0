From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 14/23] netfilter: xtables: move extension arguments into
 compound structure (1/6)
Date: Wed, 08 Oct 2008 11:15:52 +0200
Message-ID: <48EC7A48.1040901@trash.net>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de> <f2c244bfb599465f55831331087b82ea613c5dfe.1223294924.git.jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43340 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYJHJQD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 05:16:03 -0400
In-Reply-To: <f2c244bfb599465f55831331087b82ea613c5dfe.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> The function signatures for Xtables extensions have grown over time.
> It involves a lot of typing/replication, and also a bit of stack space
> even if they are not used. Realize an NFWS2008 idea and pack them into
> structs. The skb remains outside of the struct so gcc can continue to
> apply its optimizations.
> 
> This patch does this for match extensions' match functions.
> 
> A few ambiguities have also been addressed. The "offset" parameter for
> example has been renamed to "fragoff" (there are so many different
> offsets already) and "protoff" to "thoff" (there is more than just one
> protocol here, so clarify).

Applied, thanks.
