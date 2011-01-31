From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables: misc fixes
Date: Mon, 31 Jan 2011 17:12:59 +0100
Message-ID: <4D46DF8B.8050801@trash.net>
References: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56041 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1AaQNF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:13:05 -0500
In-Reply-To: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 31.01.2011 03:12, schrieb Jan Engelhardt:
> The following changes since commit 6f03bf79952753fbc0dc8611aa4d6e70a108dbc7:
> 
>   Fix listing/saving the new revision of the SET target (2011-01-21 21:55:05 +0100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/iptables master
> 
> Jan Engelhardt (8):
>       libxt_quota: clarifications on matching
>       iptables: improve error reporting with extension loading troubles
>       libxt_u32: enclose argument in quotes
>       xtables: set custom opts to NULL on free
>       iptables: warn when parameter limit is exceeded
>       iptables: remove bogus address-of
>       iptables: remove more redundant casts
>       iptables: do not print trailing whitespaces

Pulled, thanks Jan.
