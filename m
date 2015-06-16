From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/2] netfilter: bridge: split ipv6 code out of
 the core
Date: Tue, 16 Jun 2015 14:39:45 +0200
Message-ID: <20150616123945.GA32573@salvia>
References: <1434458106-32445-1-git-send-email-pablo@netfilter.org>
 <1434458106-32445-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, bernhard.thaler@wvnet.at
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45010 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbbFPMe3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 08:34:29 -0400
Content-Disposition: inline
In-Reply-To: <1434458106-32445-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 16, 2015 at 02:35:06PM +0200, Pablo Neira Ayuso wrote:
> Reduce ifdef pollution by moving the IPv6 code into a separated
> br_netfilter_ipv6.c file that is compiled if CONFIG_IPV6 is set.

This patch description is wrong btw, if you confirm this is OK, I'll
replace it by

"Resolve compilation breakage when CONFIG_IPV6 is not set by moving the
IPv6 code into a separated br_netfilter_ipv6.c file."

> Fixes: efb6de9b4ba0 ("netfilter: bridge: forward IPv6 fragmented packets")
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Bernhard: Could you please test this to check if it solves kbuild robot
> problems with CONFIG_IPV6 n, y and m? It would be also good to test this in
> your testbed too to make sure IPv6 things didn't break. Thanks.
> 
> I think it should be possible to refactor this a little bit more so other
> remaining IPv6 code specific can go into the file.
