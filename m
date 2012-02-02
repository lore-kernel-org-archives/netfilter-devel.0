From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfqueue library setup requires root
Date: Thu, 2 Feb 2012 19:49:05 +0100
Message-ID: <20120202184905.GB5268@1984>
References: <20111229140019.23841ead@wwwwww-701SD>
 <4F29679F.6090704@mutluit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, abirvalg@lavabit.com
To: "U.Mutlu" <for-gmane@mutluit.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51205 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab2BBStJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Feb 2012 13:49:09 -0500
Content-Disposition: inline
In-Reply-To: <4F29679F.6090704@mutluit.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 01, 2012 at 05:26:07PM +0100, U.Mutlu wrote:
> abirvalg@lavabit.com wrote, On 12/29/11 15:00:
> >Hi,
> >I launched my application with CAP_NET_ADMIN capability, yet both nfq_unbind_pf and nfq_bind_pf produce an error.
> >When I setuid(0) no error is produced and everything works as expected.
> >Could you please confirm that Library setup operations require root.
> >Isn't it a bit misleading that libnetfilter_queue docu states that CAP_NET_ADMIN is required without mentioning root permissions.
> >Would it be possible to do Library Setup with only CAP_NET_ADMIN and without root priviliges in future versions?
> 
> On a host node I didn't need CAP_NET_ADMIN when starting it as root
> (ie. maybe on my system root already has that cap by default; would make sense).

Yes, root is fine. You should also get it running with CAP_NET_ADMIN.

> But on a VPS on the same host node I couldn't get it working yet.
> It always gives errno=111 (ECONNREFUSED; "Connection refused").

This has nothing to do with permissions (in that case you'll hit
-EPERM).

> Does yours work in a virtual machine, ie. on a VPS ?

By "virtual machine" you mean one linux container (lxc)?
