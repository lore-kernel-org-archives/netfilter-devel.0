From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v10] example: : add nft-ruleset-parse-file.
Date: Thu, 5 Mar 2015 22:01:23 +0100
Message-ID: <20150305210123.GA6231@salvia>
References: <1425322779-6689-1-git-send-email-alvaroneay@gmail.com>
 <1425322779-6689-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35640 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbbCEU5l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2015 15:57:41 -0500
Content-Disposition: inline
In-Reply-To: <1425322779-6689-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 02, 2015 at 07:59:39PM +0100, Alvaro Neira Ayuso wrote:
> With this example, we can parse the objects in the ruleset and create the
> netlink message with the action associated. For example:
> 
> - Flush ruleset
> - Add, delete or flush tables/chains
> - Add, delete sets
> - Add, delete set elements
> - Add, delete, replace or prepend rules

Applied, thanks. Please add a filter in git commit to strip the full
stop from the patch title.
