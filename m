From: Patrick McHardy <kaber@trash.net>
Subject: Re: Pending fixes, global var reduction
Date: Thu, 30 Jun 2011 13:37:23 +0200
Message-ID: <4E0C5FF3.1080600@trash.net>
References: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44101 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1F3LhZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:37:25 -0400
In-Reply-To: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 21.06.2011 17:53, schrieb Jan Engelhardt:
> The following changes since commit 3b7a22b44d74b9b05d5e4b0529ebf72c49dcbff5:
> 
>   doc: document IPv6 TOS mangling bug in old Linux kernels (2011-06-17 05:46:22 +0200)
> 
> are available in the git repository at:
>   git://dev.medozas.de/iptables master
> 
> Jan Engelhardt (7):
>       doc: include matches/targets in manpage again
>       libipt_LOG: fix ignoring all but last flags
>       libxt_RATEEST: use guided option parser
>       iptables: consolidate target/match init call
>       extensions: support for per-extension instance "global" variable space
>       libxt_rateest: abolish global variables
>       libxt_RATEEST: abolish global variables


Pulled, thanks.
