From: Patrick McHardy <kaber@trash.net>
Subject: Re: CONNMARK 0xffffffff patch
Date: Wed, 04 Nov 2009 13:15:02 +0100
Message-ID: <4AF17046.9000804@trash.net>
References: <alpine.LSU.2.00.0911041311300.10500@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36857 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbZKDMPD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:15:03 -0500
In-Reply-To: <alpine.LSU.2.00.0911041311300.10500@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hi Patrick,
> 
> 
> I just saw your patch to libxt_MARK.c and remembered that CONNMARK needs 
> the same.
> 
> 
> 
> The following changes since commit 3d915e1ac610bce44250b4aea556f4726387388d:
>   Patrick McHardy (1):
>         MARK: print mark rules with mask 0xffffffff as --set-mark instead of --set-xmark
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/iptables master
> 
> Jan Engelhardt (1):
>       CONNMARK: print mark rules with mask 0xffffffff as set instead of xset
> 
>  extensions/libxt_CONNMARK.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Pulled and pushed out again, thanks Jan.
