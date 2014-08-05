From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables null pointer
Date: Tue, 5 Aug 2014 12:01:41 +0200
Message-ID: <20140805100141.GA3480@salvia>
References: <CAFnufp1157iUqOpax6Po-PZivC_7TQSeQqtmJnnpNLVm3hzH9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Matteo Croce <technoboy85@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41024 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933078AbaHEKBR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:01:17 -0400
Content-Disposition: inline
In-Reply-To: <CAFnufp1157iUqOpax6Po-PZivC_7TQSeQqtmJnnpNLVm3hzH9w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 05, 2014 at 10:01:56AM +0200, Matteo Croce wrote:
> with vanilla linux 3.16.0 and  ntf 0.3:
> 
> # nft list table nat
> Killed
> nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
> BUG: unable to handle kernel NULL pointer dereference at 00000008
> IP: [<d0b4beef>] nf_tables_fill_chain_info+0x27f/0x350 [nf_tables]

Is this reproducible? If so, please indicate the sequence of commands.
Thanks.
