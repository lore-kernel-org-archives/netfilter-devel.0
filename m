From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/3] netlink_delinearize: fix listing of set members
 in host byteorder using integer_type
Date: Tue, 9 Dec 2014 15:19:22 +0100
Message-ID: <20141209141922.GA3721@salvia>
References: <1418077474-6431-1-git-send-email-pablo@netfilter.org>
 <1418077474-6431-2-git-send-email-pablo@netfilter.org>
 <20141209075320.GA15583@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41860 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbaLIORE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:17:04 -0500
Content-Disposition: inline
In-Reply-To: <20141209075320.GA15583@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 09, 2014 at 07:53:21AM +0000, Patrick McHardy wrote:
> On 08.12, Pablo Neira Ayuso wrote:
> >  nft list table filter
> >  ...
> >         cpu { 50331648, 33554432, 0, 16777216} counter packets 8 bytes 344
> 
> I'm certain this used to work for mark values, so I'm wondering
> what broke it. We might have a more fundamental bug somewhere.

mark values don't use the integer_type, they use mark_type which has
an specific byteorder. So they work fine.

The problem is integer_type, it has no specific byteorder. Actually,
it is left unset so it is BYTEORDER_INVALID, which is handled when
importing/exporting as BYTEORDER_BIG_ENDIAN.

Solutions that I can see are:

1) Add specific integer_types, ie. be_integer_type (subtype of
   integer) that uses BYTEORDER_BIG_ENDIAN so the datatype tells us
   the endianness, but this doesn't seem convenient:
   http://marc.info/?l=netfilter-devel&m=141806352422510&w=2

2) From the postprocess step as you suggested. In this case, if we see
   an integer_type, we use the left-hand side expr->byteorder. Note that
   integer_type is also used in several header fields (where this
   should be a big endian integer). That case currently works because
   BYTEORDER_INVALID defaults on BYTEORDER_BIG_ENDIAN when
   importing/exporting. This new integer_postprocess() function should
   be also called. This is what this patch does.

Let me know, thanks.
