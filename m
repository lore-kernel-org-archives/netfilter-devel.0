From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] iptables: allow service names in [DS]NAT targets
Date: Wed, 24 Jul 2013 21:00:38 +0200
Message-ID: <20130724190038.GA1288@localhost>
References: <20130708164606.GA10203@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49391 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab3GXTAp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:00:45 -0400
Content-Disposition: inline
In-Reply-To: <20130708164606.GA10203@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 08, 2013 at 09:46:06AM -0700, Phil Oester wrote:
> As reported by Alexander Hoogerhuis, the [DS]NAT targets do not allow use of
> service names in the --to argument.  The same problem was fixed in the REDIRECT
> target in commit 84d758b3 ("extensions: REDIRECT: fix --to-ports parser").
> Use a similar fix here.

While testing this I noticed that this works:

--to-source 1.1.1.1:telnet
--to-source 1.1.1.1-1.1.1.10:1025-3000
--to-source 1.1.1.1-1.1.1.10:telnet

But this does not:

--to-source 1.1.1.1-1.1.1.10:telnet-http
iptables v1.4.19.1: SNAT: Bad value for "--to" option:
"1.1.1.1-1.1.1.10:telnet-ssh"

I think it should, for consistency (even if I have to confess that it
looks a bit ugly to me).

If you decide to address this and send me a new version to support
this, then it would be also good to update the manpage to say that we
support services starting 1.4.20.

Thanks.
