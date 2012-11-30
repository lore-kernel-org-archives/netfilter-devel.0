From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Conntrack helper question
Date: Fri, 30 Nov 2012 14:42:17 +0100
Message-ID: <20121130134217.GA7133@1984>
References: <50B41163.9020102@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Sebastian Zander <sebastian.zander@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48063 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab2K3NmV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:42:21 -0500
Content-Disposition: inline
In-Reply-To: <50B41163.9020102@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 27, 2012 at 12:03:31PM +1100, Sebastian Zander wrote:
> Hi netfilter devs,
> 
> In current Netfilter is there still a way for a conntrack helper to
> listen to all TCP traffic _independent_ of ports to look for primary
> connections (other than registering with 65535 tuples)? Not that I
> advocate this, I just have some old piece of code that apparently
> did that in ancient 2.6 kernels (ports set to zero in the tuple).

With recent kernels you can attach your helper via -j CT --helper ...
to all ports for some specific layer 4 protocol, eg. TCP.

The ports specified in the registration are simply ignored, we still
keep them there to support for old behaviour for quite some time
though.
