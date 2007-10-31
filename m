From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Introducing libxt_*.man files. Sorted matches and modules
Date: Wed, 31 Oct 2007 12:38:37 +0100
Message-ID: <4728693D.9060600@trash.net>
References: <11934108451679-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54551 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbXJaLlW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:41:22 -0400
In-Reply-To: <11934108451679-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Laszlo Attila Toth wrote:
> The iptables.8 and ip6tables.8 man pages are now generated from libxt_*.man
> files too. For xtables modules one man page is enough with libxt_ prefix.
> 
> The match and target lists are sorted alphabetically.
> 
> The make command doesn't print anything when creates man pages.
> 
> Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>


Applied, thanks Laszlo.
