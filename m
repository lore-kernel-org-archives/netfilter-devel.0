From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2 1/4] netfilter: bridge: refactor frag_max_size
Date: Fri, 12 Jun 2015 14:25:42 +0200
Message-ID: <20150612122542.GD13530@salvia>
References: <1432992508-4092-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55605 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbbFLMUZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 08:20:25 -0400
Content-Disposition: inline
In-Reply-To: <1432992508-4092-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 30, 2015 at 03:28:28PM +0200, Bernhard Thaler wrote:
> Currently frag_max_size is member of br_input_skb_cb and copied back and
> forth using IPCB(skb) and BR_INPUT_SKB_CB(skb) each time it is changed or
> used.
> 
> Attach frag_max_size to nf_bridge_info and set value in pre_routing and
> forward functions. Use its value in forward and xmit functions.

Applied, thanks.

