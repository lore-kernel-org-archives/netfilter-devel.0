From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH][xt-addons] extensions: fix ipv6_find_hdr upstream change
 fallout
Date: Sat, 21 Jul 2012 15:42:15 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207211542050.19759@frira.zrqbmnf.qr>
References: <1342798118-6861-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:57771 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab2GUNmU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jul 2012 09:42:20 -0400
In-Reply-To: <1342798118-6861-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2012-07-20 17:28, Florian Westphal wrote:

>uptream commit 84018f55ab883f03d41ec3c9ac7f0cc80830b20f
>(netfilter: ip6_tables: add flags parameter to ipv6_find_hdr())
>changed the offset parameter of ipv6_find_hdr() to be an in-output
>value. Moreover, if it is non-zero, it MUST point to a valid
>ipv6 header embedded in the packet.

Processed.
