From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftables 2/3] expr: log: use real length when fetching
 attributes
Date: Sat, 14 Sep 2013 21:10:13 +0200
Message-ID: <20130914191013.GB13409@localhost>
References: <1379083488-20752-1-git-send-email-fw@strlen.de>
 <1379083488-20752-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48378 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab3INTKZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Sep 2013 15:10:25 -0400
Content-Disposition: inline
In-Reply-To: <1379083488-20752-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 13, 2013 at 04:44:47PM +0200, Florian Westphal wrote:
> NFTA_LOG_SNAPLEN is u32 and NFTA_LOG_QTHRESHOLD is u16.
> Without this, netlink messages from kernel fail mnl_validate step when
> QTHRESH or SNAPLEN was set.
> 
> Also, nft_rule_expr_log_get must update data_length, else 'nft list' doesn't
> show log arguments (prefix, group ..) because the netlink message
> decoding uses nft_rule_expr_get_u16/32 etc. which validate the length, too.

Also applied, thanks.
