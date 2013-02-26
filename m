From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables nfacct match question
Date: Tue, 26 Feb 2013 14:55:29 +0100
Message-ID: <20130226135529.GA9526@localhost>
References: <51292D41.8000703@googlemail.com>
 <20130225154848.GA20609@localhost>
 <512BC79F.1070708@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56575 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab3BZNzf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Feb 2013 08:55:35 -0500
Content-Disposition: inline
In-Reply-To: <512BC79F.1070708@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Michael,

On Mon, Feb 25, 2013 at 08:20:47PM +0000, Michael Zintakis wrote:
[...]
> I've given up on my initial idea, which was to create this custom
> formatting (as well as object creation) at the point where the first
> iptables statement is created for a particular nfacct object, so I
> adopted a "plan b", where everything is done via the "nfacct"
> executable.

Thanks for the explanation. I think that, for most users, something
like:

        nfacct list MiB

would be just fine, so all counters will be displayed using the
formatting (MiB in the example case) that has been requested.

I'm still missing why different formatting according to the accounting
object can be useful.

Regards.
