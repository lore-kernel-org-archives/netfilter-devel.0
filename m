From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 2/2] src: internal set id allocation from
 nft_ruleset_parse*()
Date: Thu, 9 Oct 2014 18:52:36 +0200
Message-ID: <20141009165236.GB13593@salvia>
References: <1412359360-30695-1-git-send-email-alvaroneay@gmail.com>
 <1412359360-30695-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44171 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbaJIQv2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:51:28 -0400
Content-Disposition: inline
In-Reply-To: <1412359360-30695-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 03, 2014 at 08:02:40PM +0200, Alvaro Neira Ayuso wrote:
> Extends this function to attach the set to the rule through the set_id. If it
> doesn't exist in the list, maybe the set exists in the kernel. In that case, we
> don't set any id.

Also applied, thanks.

