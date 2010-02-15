From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 03/10] netfilter: CONFIG_COMPAT: allow delta to exceed
 32767
Date: Mon, 15 Feb 2010 17:37:59 +0100
Message-ID: <20100215163759.GA20183@Chamillionaire.breakpoint.cc>
References: <1265897559-10610-1-git-send-email-fw@strlen.de>
 <1265897559-10610-4-git-send-email-fw@strlen.de>
 <4B797759.7030106@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46354 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322Ab0BOQiA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:38:00 -0500
Content-Disposition: inline
In-Reply-To: <4B797759.7030106@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > This happens because the compat delta is using a short int.
> > Easily reproducible via "iptables -m limit" ; after about 2050
> > rules inserting new ones fails with -ELOOP.
> > 
> > Note that compat_delta included 2 bytes of padding on x86_64, so
> > structure size remains the same.
> 
> The first three patches already look fine, I'll apply those
> after a bit of testing. The remaining ones should get submitted
> very soon in order to still make the 2.6.34 merge window.

Thanks, I'll send out v3 of the patches (only changes are the ones suggested
by Bart) once those three appear in nf-next-2.6.

Thanks, Florian
