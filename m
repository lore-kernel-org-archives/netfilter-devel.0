From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xtables: use strspn() to check if string needs to be
 quoted
Date: Thu, 17 Feb 2011 12:00:40 +0100
Message-ID: <4D5CFFD8.8000804@trash.net>
References: <20110214065445.30608.81511.stgit@woodpecker.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53391 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab1BQLAx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Feb 2011 06:00:53 -0500
In-Reply-To: <20110214065445.30608.81511.stgit@woodpecker.blarg.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 14.02.2011 07:54, schrieb Max Kellermann:
> Problem: the call xtables_save_string("'") prints just a single quote,
> not enclosed in double quoted and not escaped.
> 
> Steps to reproduce:
> 
>  $ iptables -A foo -m comment --comment "'" -j ACCEPT
>  $ iptables-multi save|grep foo
>  -A foo -m comment --comment ' -j ACCEPT
> 
> The cause was the use of strcspn() to locate the first character which
> justified quoting the string in double quotes.  That however was
> wrong, because the way strcspn() was called, it returned a pointer to
> the first character that was not to be escaped, which did the right
> thing most of the time, but not for strings consisting only of quote
> characters.  This patch changes strcspn() to strspn().

Looks good to me, applied. But please remember to sign off your
patches.

