From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] nf_tables: fix bogus warning in nft_data_uninit()
Date: Fri, 15 May 2015 22:08:46 +0200
Message-ID: <20150515200846.GA3680@salvia>
References: <1431720355-3604-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, exa.exa@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38246 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934700AbbEOUEA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 May 2015 16:04:00 -0400
Content-Disposition: inline
In-Reply-To: <1431720355-3604-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 15, 2015 at 10:05:55PM +0200, Pablo Neira Ayuso wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.orgi>
> 
> From: Mirek Kratochvil <exa.exa@gmail.com>

Just for the record: I'll mangle this to restore your original
authorship before applying, that was my intention.

> The values 0x00000000-0xfffffeff are reserved for userspace datatype. When,
> deleting set elements with maps, a bogus warning is triggered.
> 
> WARNING: CPU: 0 PID: 11133 at net/netfilter/nf_tables_api.c:4481 nft_data_uninit+0x35/0x40 [nf_tables]()
> 
> This fixes the check accordingly to enum definition in
> include/linux/netfilter/nf_tables.h
