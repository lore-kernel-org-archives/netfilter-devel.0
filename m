From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfacct utility now available at git.netfilter.org
Date: Sat, 31 Dec 2011 16:00:52 +0100
Message-ID: <20111231150052.GA17062@1984>
References: <20111230201147.GA14014@1984>
 <alpine.LNX.2.01.1112302137140.24638@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53397 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab1LaPA7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Dec 2011 10:00:59 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1112302137140.24638@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 30, 2011 at 09:37:37PM +0100, Jan Engelhardt wrote:
> On Friday 2011-12-30 21:11, Pablo Neira Ayuso wrote:
> 
> >Hi!
> >
> >The nfacct utility is now available at git.netfilter.org
> >
> >http://git.netfilter.org/cgi-bin/gitweb.cgi?p=nfacct.git;a=summary
> 
> So, not in ./iptables/utils/?

:-)

Not sure that it's necessary to enforce the libmnl and libnetfilter_acct
dependencies that iptables may require since then.

Thinking it well, better not to pollute the iptables tree with extra
utilities.
