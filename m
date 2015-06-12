From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv6 2/4] netfilter: bridge: rename br_parse_ip_options
Date: Fri, 12 Jun 2015 14:25:51 +0200
Message-ID: <20150612122551.GE13530@salvia>
References: <1432992542-4127-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55711 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbbFLMUl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 08:20:41 -0400
Content-Disposition: inline
In-Reply-To: <1432992542-4127-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 30, 2015 at 03:29:02PM +0200, Bernhard Thaler wrote:
> br_parse_ip_options() does not parse any IP options, it validates IP
> packets as a whole and the function name is misleading.
> 
> Rename br_parse_ip_options() to br_validate_ipv4() and remove unneeded
> commments.

Applied, thanks.

