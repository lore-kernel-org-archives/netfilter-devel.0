From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 01/02: Make nflog quiet when no one listen in
 userspace.
Date: Wed, 11 Jun 2008 17:51:24 -0700 (PDT)
Message-ID: <20080611.175124.76343987.davem@davemloft.net>
References: <484FC81C.9080904@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55674
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755211AbYFLAvY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2008 20:51:24 -0400
In-Reply-To: <484FC81C.9080904@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 11 Jun 2008 14:42:04 +0200

> following are two fixes for netfilter:
> 
> - silence a noisy warning when no logging backend is active
> 
> - fix a ctnetlink related crash in nf_nat_setup_info()
> 
> The second one is a regression present since 2.6.23, I'll
> also send that one to -stable.
> 
> I have another patch queued to fix a NAT crash probably caused
> by a RCU race, but I'd like to get confirmation that it actually
> fixes the problem before sending it upstream, so I'll hold on
> to it for a few more days.
> 
> Please apply, thanks.

Both fixes applied, thanks Patrick!
