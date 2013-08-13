From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCHv2] iptables: link against libnetfilter_conntrack
Date: Tue, 13 Aug 2013 20:59:03 +0200
Message-ID: <20130813185903.GN29345@breakpoint.cc>
References: <1376411824-22311-1-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:6672 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758085Ab3HMS7G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:59:06 -0400
Content-Disposition: inline
In-Reply-To: <1376411824-22311-1-git-send-email-gustavo@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gustavo Zacarias <gustavo@zacarias.com.ar> wrote:
> When libnetfilter_conntrack is available iptables needs to link
> against it otherwise we get build failures.

Again, I doubt that this is the case.

The only caller of libnetfilter_conntrack functions is libxt_connlabel,
and that is not tied to the xtables-multi binary, UNLESS you
build with --enable-static (which puts the extensions into the
executable).  So, afaiu, we should not need -lnetfilter_conntrack in the
!ENABLE_STATIC case.
