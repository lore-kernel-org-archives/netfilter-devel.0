From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: Re: [PATCHv2] iptables: link against libnetfilter_conntrack
Date: Tue, 13 Aug 2013 22:13:04 -0300
Message-ID: <520AD9A0.9000604@zacarias.com.ar>
References: <1376411824-22311-1-git-send-email-gustavo@zacarias.com.ar> <alpine.LSU.2.10.9.1308132051420.22862@nerf07.vanv.qr> <20130813204217.GO29345@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:36684 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038Ab3HNBNX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Aug 2013 21:13:23 -0400
In-Reply-To: <20130813204217.GO29345@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/13/2013 05:42 PM, Florian Westphal wrote:

> Gustavo, could you please test Jans patch and report back
> if that fixes the build for you?

Yes, works for the three combinations (shared, static, shared+static).
But shouldn't @libnetfilter_conntrack_CFLAGS@ be added to AM_CFLAGS
rather than AM_CPPFLAGS for correctness?
Regards.

