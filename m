From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] netfilter: bridge: re-order
 br_nf_pre_routing_finish_ipv6()
Date: Fri, 12 Jun 2015 14:25:16 +0200
Message-ID: <20150612122516.GB13530@salvia>
References: <1432992417-4016-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55482 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625AbbFLMUD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 08:20:03 -0400
Content-Disposition: inline
In-Reply-To: <1432992417-4016-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 30, 2015 at 03:26:57PM +0200, Bernhard Thaler wrote:
> Put br_nf_pre_routing_finish_ipv6() after daddr_was_changed() and
> br_nf_pre_routing_finish_bridge() to prepare calling these functions
> from there.

Also applied, thanks.

