From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH] extensions: libipt_icmp: Add translation to nft
Date: Sun, 6 Mar 2016 21:11:03 +0100
Message-ID: <20160306201101.GA9308@sonyv>
References: <20160305200039.GA14269@sonyv>
 <CAKHNQQE7S-x63bez0qdhwujESbwqPHSftc_aMXHkHh=Y5amrZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35541 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbcCFULH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Mar 2016 15:11:07 -0500
Received: by mail-wm0-f52.google.com with SMTP id l68so59238801wml.0
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Mar 2016 12:11:06 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAKHNQQE7S-x63bez0qdhwujESbwqPHSftc_aMXHkHh=Y5amrZA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 06, 2016 at 03:31:15PM +0530, Shivani Bhardwaj wrote:
> There are some icmp types that nftables does not support, have you

And these types (and subtypes) are not supported yet or will never be supported?

> tried adding up rules corresponding to all the packet types?
> 

Yes, but not all of them.

> $ sudo nft add table filter
> $ sudo nft add chain filter INPUT { type filter hook input priority 0\;}
> $ sudo <your generated rule goes here>
> 
> Please consider finding out such packet types and mention about them
> in commit message.

Ok.

> Also, here you are using the array icmp_codes, this will give out the
> same packet names as iptables. But, some packet names are different in
> nftables. May be not in case of icmp but in case of icmp6. Please have
> a look at this.
> 

Ok, as there isn't a direct translation I'll provide a v2 with a list
of supported types.

Thanks!

