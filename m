From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bug 611, plan B
Date: Wed, 04 Nov 2009 12:53:21 +0100
Message-ID: <4AF16B31.90705@trash.net>
References: <1257281901-5063-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36404 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbZKDLxT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:53:19 -0500
In-Reply-To: <1257281901-5063-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Of course there is a plan B that is, given the recent input, is
> undoubtly less intrusive. Intra-! support is retained while option
> bundling is now supported.
> 
> -----
> The following changes since commit 4f0d7b660e0ae8f678142fd2a1722b27ad472169:
>   Jan Engelhardt (1):
>         iptables: fix undersized deletion mask creation
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/iptables bug611
> 
> Jan Engelhardt (3):
>       style: reduce indent in xtables_check_inverse
>       libxtables: hand argv to xtables_check_inverse
>       iptables/extensions: make bundled options work again

This looks better. Pulled and pushed back out, thanks Jan.
