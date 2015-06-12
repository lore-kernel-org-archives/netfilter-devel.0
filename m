From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] netfilter: bridge: refactor clearing
 BRNF_NF_BRIDGE_PREROUTING
Date: Fri, 12 Jun 2015 14:25:03 +0200
Message-ID: <20150612122503.GA13530@salvia>
References: <1432992373-3954-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55433 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbbFLMTx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 08:19:53 -0400
Content-Disposition: inline
In-Reply-To: <1432992373-3954-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 30, 2015 at 03:26:13PM +0200, Bernhard Thaler wrote:
> use binary AND on complement of BRNF_NF_BRIDGE_PREROUTING to unset
> bit in nf_bridge->mask.

Applied, thanks.

