From: Willy Tarreau <w@1wt.eu>
Subject: Re: [Fwd: [PATCH 2.4]: ip6t_{hbh,dst}: Rejects not-strict mode on rule insersion]
Date: Wed, 8 Oct 2008 14:52:29 +0200
Message-ID: <20081008125229.GC28783@1wt.eu>
References: <48ECA862.1010204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 1wt.eu ([62.212.114.60]:4659 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbYJHMwg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 08:52:36 -0400
Content-Disposition: inline
In-Reply-To: <48ECA862.1010204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

On Wed, Oct 08, 2008 at 02:32:34PM +0200, Patrick McHardy wrote:
> Hi Willy,
> 
> This patch from Yasuyuki fixes a problem in the hbh/dst matches which
> is currently hidden by broken userspace, but will be exposed once
> we've fixed userspace. Unfortunately neither of us has a working
> 2.4 environment, so all I can do is forward the patch. The upstream
> commit ID is 8ca31ce52.

OK. I still have working 2.4 + IPv6, so if there is any reproducer, I can
test the fix. Otherwise, I'll apply it, as it seems pretty straight-forward
for anyone who doesn't want to precisely understand what it fixes :-)

Thanks,
Willy

