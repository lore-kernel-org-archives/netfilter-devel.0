From: Martin Josefsson <gandalf@mjufs.se>
Subject: Re: RFC: conntrack: use mod_timer_pending()
Date: Thu, 11 Jun 2009 08:43:37 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0906110840190.10428@wlug.westbo.se>
References: <4A2FAFB4.1050100@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Martin Josefsson <gandalf@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host91-201.netintact.se ([194.153.91.201]:58319 "EHLO
	wlug.westbo.se" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760692AbZFKHLz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2009 03:11:55 -0400
In-Reply-To: <4A2FAFB4.1050100@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 10 Jun 2009, Patrick McHardy wrote:

> This patch changes conntrack to use the new mod_timer_pending()
> function, which only rearms the timer if it was still active.
> This allows to only grab the lock in __nf_ct_refresh_acct when
> accounting is used.
>
> Anyone seing anything wrong with this?

I don't see any problem with it.
Looks good, thanks.

/Martin
