From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new
 entries
Date: Thu, 23 Feb 2012 11:12:50 +0100
Message-ID: <20120223101250.GA3547@1984>
References: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu>
 <20120221145234.GB25826@1984>
 <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Zambo Marcell <marcell.zambo@gmail.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44756 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab2BWKM6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Feb 2012 05:12:58 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Tue, Feb 21, 2012 at 04:06:59PM +0100, Jozsef Kadlecsik wrote:
> Or do I miss something else here?

I just noticed one problem.

With your approach, we may lose race if one packet inserts same conntrack
entry while we're adding one conntrack. Thus resulting in two conntracks
with the same tuples in the table.

One possible solution would be to check if it already exists before
adding it to the list, but this will add too many extra cycles for
each conntrack that is added via ctnetlink.

I'm also considering disabling early_drop from ctnetlink and to return
-ENOMEM instead. Not sure if it makes sense the early drop mechanism
via ctnetlink. If we hit ENOMEM from user-space while adding one new
conntrack, we can iterate over the table and delete conntrack based on
some criteria, then retry.
