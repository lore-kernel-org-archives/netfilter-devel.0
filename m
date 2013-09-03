From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nftables-kernel PATCH] netfilter: nf_tables: Fixes how a table
 is checked to be in use
Date: Tue, 03 Sep 2013 16:25:40 +0300
Message-ID: <5225E354.4090000@linux.intel.com>
References: <1377855812-15251-1-git-send-email-tomasz.bursztyka@linux.intel.com> <20130830223705.GA9864@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:14716 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759933Ab3ICNZ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:25:59 -0400
In-Reply-To: <20130830223705.GA9864@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> Let's check table's chain list emptyness instead so struct nft_table
>> does not grow and we avoid the (unlikely to happen) overflow.
> I prefer if you send me a patch to export the table use counter. I
> think it can be useful from userspace to know if the table is used at
> all and how many times it's used. I'm neither worry about the 2^32
> chains limit and the extra 4 bytes per table (we'll have a small
> number of tables object in memory).

What's the use case for it? I mean: knowing that the table is in use, I 
can see some use case (and it could be done much simpler).
The number of chains, not really. At least right now, nothing is using 
it so what could be the future need for that?
Same for chains actually.

Tomasz
