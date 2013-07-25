From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH v2] iptables: allow service names in [DS]NAT targets
Date: Wed, 24 Jul 2013 17:17:12 -0700
Message-ID: <20130725001712.GA14675@linuxace.com>
References: <20130708164606.GA10203@linuxace.com>
 <20130724190038.GA1288@localhost>
 <alpine.DEB.2.00.1307242308350.23361@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48430 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3GYARE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 20:17:04 -0400
Received: by mail-pb0-f51.google.com with SMTP id um15so30667pbc.38
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jul 2013 17:17:04 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1307242308350.23361@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 24, 2013 at 11:11:48PM +0200, Jozsef Kadlecsik wrote:
> On Wed, 24 Jul 2013, Pablo Neira Ayuso wrote:
> > But this does not:
> > 
> > --to-source 1.1.1.1-1.1.1.10:telnet-http
> > iptables v1.4.19.1: SNAT: Bad value for "--to" option:
> > "1.1.1.1-1.1.1.10:telnet-ssh"
> > 
> > I think it should, for consistency (even if I have to confess that it
> > looks a bit ugly to me).
> > 
> > If you decide to address this and send me a new version to support
> > this, then it would be also good to update the manpage to say that we
> > support services starting 1.4.20.
> 
> That is still ambiguous - there are service names with dash. So I suggest 
> to support the notation '[name-with-dash]' in order to explicitly express 
> and handle such cases.

Or perhaps as an alternative, we don't allow more than one port if one
wishes to use service names?  It seems the port parser is going to get so
complicated it will lead to bugs.  Particularly since ip6tables uses [ ] for
addresses to disambiguate them from the :port section.  Now we'd have to be
able to handle multiple [] arguments.

So these would be acceptable:

    :22-23
    :ssh
    :wap-push (port 2948)

this would not:

    :ssh-telnet

Phil
