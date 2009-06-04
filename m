From: Patrick McHardy <kaber@trash.net>
Subject: Re: [resend net-next] socket: Added 'transparent' option
Date: Thu, 04 Jun 2009 18:08:09 +0200
Message-ID: <4A27F169.9090003@trash.net>
References: <1244122013-25970-1-git-send-email-panther@balabit.hu> <4A27CD5A.6040303@trash.net> <alpine.LSU.2.00.0906041653420.13894@fbirervta.pbzchgretzou.qr> <4A27E7F0.6010403@balabit.hu> <alpine.LSU.2.00.0906041759320.20094@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Laszlo Attila Toth <panther@balabit.hu>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35840 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbZFDQIK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:08:10 -0400
In-Reply-To: <alpine.LSU.2.00.0906041759320.20094@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-06-04 17:27, Laszlo Attila Toth wrote:
> Also, if possible, try combining all the TBF implementations; limit
> and hashlimit are so close to each other, the latter would only need
> a "--hashlimit-mode notuple" (from a userspace pov) , and xt_limit
> could be obsoleted.

If we're going to touch the ABI and add a new revision, we should
at the same time try to get rid of the resolution problems so we
don't need yet another reversion when someone finally fixes this.
