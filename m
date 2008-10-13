From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 6/6] [PATCH] remove module dependency between ctnetlink
 and	nf_nat
Date: Mon, 13 Oct 2008 16:08:07 +0200
Message-ID: <48F35647.1010407@netfilter.org>
References: <20081011152116.6436.17277.stgit@Decadence> <20081011152312.6436.15322.stgit@Decadence> <48F3520B.7010306@trash.net> <48F355EA.7050104@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38835 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752201AbYJMOIs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:08:48 -0400
In-Reply-To: <48F355EA.7050104@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Do you want me to apply the patch as attached to this email, or would
>> you prefer to rediff it?
> 
> No, I'll send you a new patchset once you set your tree. This patch also
> needs to include the nfnl_lock/nfnl_unlock logic.

Oh, I see, since you want to put this into 2.6.27, I'll see you a patch
for the NAT issue asap and keep the other in the internal queue.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
