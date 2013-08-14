From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCHv2] iptables: link against libnetfilter_conntrack
Date: Wed, 14 Aug 2013 16:46:33 +0200 (CEST)
Message-ID: <alpine.LSU.2.10.9.1308141639340.15949@nerf07.vanv.qr>
References: <1376411824-22311-1-git-send-email-gustavo@zacarias.com.ar> <alpine.LSU.2.10.9.1308132051420.22862@nerf07.vanv.qr> <20130813204217.GO29345@breakpoint.cc> <520AD9A0.9000604@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:35811 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435Ab3HNOqf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:46:35 -0400
In-Reply-To: <520AD9A0.9000604@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2013-08-14 03:13, Gustavo Zacarias wrote:

>On 08/13/2013 05:42 PM, Florian Westphal wrote:
>
>> Gustavo, could you please test Jans patch and report back
>> if that fixes the build for you?
>
>Yes, works for the three combinations (shared, static, shared+static).
>But shouldn't @libnetfilter_conntrack_CFLAGS@ be added to AM_CFLAGS
>rather than AM_CPPFLAGS for correctness?

pkgconfig does not distinguish between preprocessor and compiler
flags. pkgconfig's Cflags field is most often used for preprocessor
directives, and most .pc files do not contain any compiler flags
either for good reason, because handing out those (particularly -f
and -m) could conflict with one's own program.
