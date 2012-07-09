From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH v2 5/6] netfilter: tarpit: Add IPv6 support
Date: Mon, 9 Jul 2012 18:58:03 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207091855540.1876@frira.zrqbmnf.qr>
References: <1341771085-5771-1-git-send-email-johunt@akamai.com> <1341771085-5771-6-git-send-email-johunt@akamai.com> <alpine.LNX.2.01.1207082125590.11837@frira.zrqbmnf.qr> <4FFAE45D.6070603@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:41994 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab2GIQ6F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jul 2012 12:58:05 -0400
In-Reply-To: <4FFAE45D.6070603@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2012-07-09 16:02, Josh Hunt wrote:
>On 07/08/2012 02:36 PM, Jan Engelhardt wrote:
>
>I just sent a patch doing what you've requested above against the
>tarpit6 branch, and it builds fine now with Linus' latest git.
>However, I did not see the compat layer stuff to keep me from
>neededing #ifdefs. Perhaps I wasn't looking in the right spot.

I thought I had added it, but that was xtnu_ipv6_find_hdr.
For TARPIT I had to add xtnu_ipv6_skip_exthdr, and did so now.

>Also, please let me know if there are any issues with the libxt
>patch. I did not see it in the tarpit6 branch.

I held it off; this is now all merged.
