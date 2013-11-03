From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: spurious error in load_extension
Date: Sun, 3 Nov 2013 21:26:06 +0100
Message-ID: <20131103202606.GA31495@localhost>
References: <20131008162015.GB18402@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34930 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab3KCU0K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Nov 2013 15:26:10 -0500
Content-Disposition: inline
In-Reply-To: <20131008162015.GB18402@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 08, 2013 at 09:20:15AM -0700, Phil Oester wrote:
> In commit 927385017047d (iptables: improve error reporting with extension
> loading troubles), a new error message was added in an attempt to handle
> the case where a match does not support a particular protocol family. 
> For instance, attempting to use the osf match on IPv6.
> 
> Unfortunately, this error message now triggers when creating a new chain
> which has the same name as a match extension, because iptables calls
> xtables_find_target with the name of the new chain to verify it does not
> clash with an existing target.  For example:
> 
>     # iptables -N tcp
>     /usr/lib/xtables/libxt_tcp.so: no "tcp" extension found for this protocol
> 
> I attempted to resolve this by adding a new XTF flag, but that required changes
> in many different places (including -j handling).  It seems easiest just to
> remove this warning and stick with the original error message of ENOENT, even
> if less than precise.

Also applied, thanks Phil.
