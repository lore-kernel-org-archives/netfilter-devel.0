From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/10] netfilter: CONFIG_COMPAT: allow delta to exceed
 32767
Date: Mon, 15 Feb 2010 18:40:58 +0100
Message-ID: <4B79872A.3090605@trash.net>
References: <1265897559-10610-1-git-send-email-fw@strlen.de> <1265897559-10610-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65359 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab0BORlD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 12:41:03 -0500
In-Reply-To: <1265897559-10610-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> with 32 bit userland and 64 bit kernels, it is unlikely but possible
> that insertion of new rules fails even tough there are only about 2000
> iptables rules.
> 
> This happens because the compat delta is using a short int.
> Easily reproducible via "iptables -m limit" ; after about 2050
> rules inserting new ones fails with -ELOOP.
> 
> Note that compat_delta included 2 bytes of padding on x86_64, so
> structure size remains the same.

Also applied, thanks Florian.
