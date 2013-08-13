From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCHv2] iptables: link against libnetfilter_conntrack
Date: Tue, 13 Aug 2013 22:42:17 +0200
Message-ID: <20130813204217.GO29345@breakpoint.cc>
References: <1376411824-22311-1-git-send-email-gustavo@zacarias.com.ar>
 <alpine.LSU.2.10.9.1308132051420.22862@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51818 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758264Ab3HMUmW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:42:22 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.10.9.1308132051420.22862@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> The righteous patch would be something like the following.

Gustavo, could you please test Jans patch and report back
if that fixes the build for you?

[..]

> If libnetfilter_conntrack is not found, @libnetfilter_conntrack_CFLAGS@
> and @libnetfilter_conntrack_LIBS@ (and their ${} ones) should be empty,
> therefore producing no harm to include unconditionally.

Good point...
