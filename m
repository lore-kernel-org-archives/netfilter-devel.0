From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 4/4] netfilter: bridge: rename br_parse_ip_options and
 delete unneeded code
Date: Mon, 23 Mar 2015 13:43:22 +0100
Message-ID: <20150323124322.GB6203@breakpoint.cc>
References: <1426715768-17011-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org, fw@strlen.de
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43794 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278AbbCWMn3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2015 08:43:29 -0400
Content-Disposition: inline
In-Reply-To: <1426715768-17011-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bernhard Thaler <bernhard.thaler@wvnet.at> wrote:
> br_parse_ip_options() does not parse any IP options, it validates IP
> packets as a whole and the function name is misleading.

Right.
> Rename it and delete unneeded assignment of iph variable.

?

I don't see any change in this regard.

