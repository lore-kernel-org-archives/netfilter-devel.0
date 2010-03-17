From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/9] netfilter: xtables: restrict TCPMSS to mangle table
 as intended
Date: Wed, 17 Mar 2010 14:36:58 +0100
Message-ID: <4BA0DAFA.80104@trash.net>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-4-git-send-email-jengelh@medozas.de> <4BA0D97D.6020701@trash.net> <alpine.LSU.2.01.1003171431420.6297@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57734 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab0CQNg7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:36:59 -0400
In-Reply-To: <alpine.LSU.2.01.1003171431420.6297@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-03-17 14:30, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> References: http://bugs.debian.org/567050
>>> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
>> So we removed those artificial restrictions in other modules
>> just to introduce them somewhere else?
> 
> Couldn't MSS be relevant to routing?
> Just trying to figure out how the manpage came to mention it would need 
> to be limited.

Because it mangles the packet. But I don't see any point in restricting
those modules to the mangle table, the only thing that is really special
about it is rerouting.

