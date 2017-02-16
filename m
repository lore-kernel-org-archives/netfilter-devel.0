From: Florian Westphal <fw@strlen.de>
Subject: Re: conntrack_ftp and DNAT
Date: Thu, 16 Feb 2017 09:41:45 +0100
Message-ID: <20170216084145.GB10526@breakpoint.cc>
References: <20170211220544.qe3tvfrrisllesix@ikki.ethgen.ch>
 <20170216001732.GA10526@breakpoint.cc>
 <20170216081924.5pdbtoed4i46g7iz@ikki.ethgen.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Klaus Ethgen <Klaus+lkml@ethgen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40402 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751583AbdBPImt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2017 03:42:49 -0500
Content-Disposition: inline
In-Reply-To: <20170216081924.5pdbtoed4i46g7iz@ikki.ethgen.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Klaus Ethgen <Klaus+lkml@ethgen.de> wrote:
> > 2. ftp server uses foreign (non-local) ip addresses in PORT command
> >    (this needs fixing of ftp server or use of 'loose' mode, see modinfo
> >     nf_conntrack_ftp)
> 
> It is a standard proftpd with the following relevant settings:
>    PassivePorts 52100 52199
>    MasqueradeAddress X.X.X.X
> Where X.X.X.X is the outside IP.

Try without the "MasqueradeAddress".

The netfilter conntrack helper by default only
installs expectations for PORT addresses that match the originating
ip of the control connection.

If the server already uses the to-be-natted-to address in the
control connection the helper will ignore them unless you enable
"loose" tracking (see modinfo above).

Doing that has security implications (which can be worked around
by restricting related matches like this:

-s (address) -d (address) -m conntrack --ctstate RELATED -m helper
--helper ftp -j ACCEPT
-p tcp -m conntrack --ctstate RELATED -j DROP

> > you seem to be using a bridge, maybe there is some bug w.
> > call-iptables...  I can have a look next week.
> 
> Yes. This is using a bridge that bridges between the master and its KVM
> hosts.
> 
> How can I check or rule out this?

I guess its caused by ProFtp masquerade setting.
