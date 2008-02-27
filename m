From: Anton <anton.vazir@gmail.com>
Subject: Re: TC interface
Date: Wed, 27 Feb 2008 14:12:20 +0500
Message-ID: <200802271412.20481.anton.vazir@gmail.com>
References: <200802251358.12898.anton.vazir@gmail.com> <200802271337.31505.anton.vazir@gmail.com> <47C525A8.1040502@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from postman.tajik.net ([82.198.21.5]:37449 "HELO postman.tajik.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753457AbYB0JMe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 04:12:34 -0500
In-Reply-To: <47C525A8.1040502@snapgear.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for answer Philip! I googled half a day before asking 
a question in the list and found a few thigs which deals 
with netlink messaging but all outdated, and I thought that 
there might be a library to deal with this stuff and make 
things a little easier.
Thanks again!
Anton.

On Wednesday 27 February 2008 13:56, Philip Craig wrote:
> Anton wrote:
> > Looks like everyone is too proud to answer a simple
> > newbee question...
>
> More likely busy...
>
> >> I'm trying to figure out how to interface with the
> >> kernel's qos structires. I've found libiptc HOWTO -
> >> but it's very outdated and provides only IPTABLES
> >> manipulation, not traffic scheduler. Could anyone
> >> please advice, if there is a C library, which provides
> >> an abstraction for easier manipulation with kernel
> >> internals to not use "tc" and "iptables"?
>
> This should cover tc:
> http://people.suug.ch/~tgr/libnl/
>
> There isn't a C api for iptables other than libiptc, and
> it isn't meant to be used outside of iptables anyway.
>
> Also google showed me http://www.coverfire.com/lql/
> but I know nothing about it.
