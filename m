From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libmnl] Move declaration of visibility attributes before
 definition.
Date: Fri, 1 Jul 2016 15:54:25 +0200
Message-ID: <20160701135425.GA4438@salvia>
References: <1457278391-10086-1-git-send-email-pefoley2@pefoley.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Peter Foley <pefoley2@pefoley.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55960 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbcGANya (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2016 09:54:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CE4F81B1DF1
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 15:54:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C094EFAB46
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 15:54:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B86A8FAB46
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 15:54:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1457278391-10086-1-git-send-email-pefoley2@pefoley.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 06, 2016 at 10:33:11AM -0500, Peter Foley wrote:
> When compiling with clang, the visibility attributes are ignored
> since they are after the definition of the exported function.
> 
> Fix this by moving the attribute declaration before the function.
> 
> attr.c:439:1: error: attribute declaration must precede definition [-Werror,-Wignored-attributes]
> EXPORT_SYMBOL(mnl_attr_put_u8);
> ^
> ./internal.h:7:41: note: expanded from macro 'EXPORT_SYMBOL'
>                                               ^
> ./internal.h:6:35: note: expanded from macro '__visible'
>                                                ^
> attr.c:435:6: note: previous definition is here
> void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data)
>      ^

I don't like that we have to change coding style for this, but given
many of you have follow up on this, I'm willing to help so I'm
applying this.

Thanks for your patience.
