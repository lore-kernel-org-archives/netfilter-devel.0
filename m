From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/1] nft: Fix nlmsg_type in GET operation callbacks
Date: Tue, 1 Sep 2015 18:46:10 +0200
Message-ID: <20150901164610.GA3434@salvia>
References: <1440887695-15068-1-git-send-email-subramanian.vijay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Vijay Subramanian <subramanian.vijay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54854 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbbIAQjn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Sep 2015 12:39:43 -0400
Content-Disposition: inline
In-Reply-To: <1440887695-15068-1-git-send-email-subramanian.vijay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Vijay,

On Sat, Aug 29, 2015 at 03:34:55PM -0700, Vijay Subramanian wrote:
> nf_tables_gettable(), nf_tables_getchain() and nf_tables_getrule()
> send replies with nlmsg_type that correspond to ADD operation
> instead of GET. Set the type correctly.

We always NFT_MSG_NEWTABLE as message type other major netlink
subsystems that I can remember, so that is there for consistency.

Is there any why reason you need this change?
