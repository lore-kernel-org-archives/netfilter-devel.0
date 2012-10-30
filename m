From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next:nf_tables7 3/3] net/netfilter/nf_tables_api.c:1299:1:
 warning: the frame size of 1184 bytes is larger than 1024 bytes
Date: Tue, 30 Oct 2012 19:36:11 +0100
Message-ID: <20121030183611.GA20628@1984>
References: <508cc50d.M5tgqmAbgcg453NH%yuanhan.liu@linux.intel.com>
 <20121028060736.GA32717@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Fengguang Wu <fengguang.wu@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42532 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab2J3SgU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:36:20 -0400
Content-Disposition: inline
In-Reply-To: <20121028060736.GA32717@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 28, 2012 at 02:07:36PM +0800, Fengguang Wu wrote:
> Hi Pablo,
> 
> FYI, there are new compile warnings show up in
> 
> tree:   git://150.214.188.80/nf-next nf_tables7
> head:   a6332633391e97de473423052cb6173b4e6e7a27
> commit: a6332633391e97de473423052cb6173b4e6e7a27 [3/3] netfilter: nf_tables
> config: m68k-allmodconfig # make ARCH=m68k allmodconfig
> 
> All warnings:
> 
> net/netfilter/nf_tables_api.c: In function 'nf_tables_newrule':
> net/netfilter/nf_tables_api.c:1299:1: warning: the frame size of 1184 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> --
> net/netfilter/nft_ct.c: In function 'nft_ct_eval':
> net/netfilter/nft_ct.c:77:46: warning: the omitted middle operand in ?: will always be 'true', suggest explicit middle operand [-Wparentheses]

I have pushed a couple of fixes for these to the nf_tables7 branch.

Thanks for the report.
