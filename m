From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCHv3 4/4] netfilter: bridge: rename br_parse_ip_options
Date: Wed, 25 Mar 2015 09:15:52 +0100
Message-ID: <20150325081552.GF1685@breakpoint.cc>
References: <5512685D.2010804@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org, fw@strlen.de
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52597 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbbCYIQB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 04:16:01 -0400
Content-Disposition: inline
In-Reply-To: <5512685D.2010804@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bernhard Thaler <bernhard.thaler@wvnet.at> wrote:
> br_parse_ip_options() does not parse any IP options, it validates IP
> packets as a whole and the function name is misleading.
> 
> Rename br_parse_ip_options().
> 
> Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>

Looks good to me, but your MUA mangled this patch (line breaks, whitespace
damage) so the patch doesn't apply cleanly anymore.

Try mailing the patch to yourself and apply it, if that works
you're good to go.

