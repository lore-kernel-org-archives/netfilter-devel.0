From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Netfilter Debugging tips
Date: Sat, 16 Jun 2012 11:55:59 +0200
Message-ID: <20120616095559.GA18022@1984>
References: <aa04pt0d.fsf@s1.test.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: AFT <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36525 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab2FPJ4J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jun 2012 05:56:09 -0400
Content-Disposition: inline
In-Reply-To: <aa04pt0d.fsf@s1.test.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 15, 2012 at 08:08:34PM +0600, AFT wrote:
> 
> Hi,
> 
> I have a working kernel dev setup with KGDB/KDB. Now as i'm going to
> develop a netfilte module, i need a good strategy to debug netfilter
> modules. During configuring the kernel i've bumped into a kernel config
> like following :
> 
> CONFIG_NETFILTER_DEBUG
> 
> But i've found no documentaion describing what actually this
> configuration will enable me to do.
> 
> So anything regarding this config variable or any other general
> debugging strategy will be helpfull.

With this, the kernel will print debugging information on what the
Netfilter core infrastructure is doing. It also includes some
debugging messages from x_tables instances, ie. ebtables, arp_tables,
and so on.

It's been ages since I haven't used this for any useful purpose
(rather than making sure the kernel compilation does not break with it
enabled).
