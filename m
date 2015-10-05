From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2 nf-next 0/4] netfilter: nfnetlink_log attach conntrack
 information
Date: Mon, 5 Oct 2015 17:33:55 +0200
Message-ID: <20151005153355.GA22755@salvia>
References: <1443724990-4014-1-git-send-email-pablo@netfilter.org>
 <1443724990-4014-2-git-send-email-pablo@netfilter.org>
 <20151005024454.GA14637@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56253 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbbJEP05 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 11:26:57 -0400
Content-Disposition: inline
In-Reply-To: <20151005024454.GA14637@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 05, 2015 at 11:44:54AM +0900, Ken-ichirou MATSUZAWA wrote:
> Hi Pablo,
> 
> I rebased on top of your patches, would you review these?
> 
> You suggested it might be better to divide ct attaching Kconfig to
> each of nfqueue and nflog, but I think it makes less sense now
> because of your rework. is it right?

Series applied, thanks for your patience.

Please, follow up with fixes in case of problems.
