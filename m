From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v3 2/2] netfilter: xt_addrtype: ipv6 support
Date: Tue, 15 Mar 2011 20:41:40 +0100
Message-ID: <4D7FC0F4.9070001@trash.net>
References: <1300214971-20345-1-git-send-email-fw@strlen.de> <1300214971-20345-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49369 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab1COTlm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2011 15:41:42 -0400
In-Reply-To: <1300214971-20345-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15.03.2011 19:49, Florian Westphal wrote:
> From: Florian Westphal <fwestphal@astaro.com>
> 
> No new match revision is introduced, as binary compatibility
> is not broken (XT_ADDRTYPE_ values match the RTN_ "bitshifted"
> ones used by old iptables userspace).
> 
> The kernel will refuse certain types that do not work in ipv6 mode.
> We can then add these features incrementally without risk of userspace
> breakage.
> 

Applied, thanks.
