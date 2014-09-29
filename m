From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v2] netfilter: conntrack: disable generic tracking for
 known protocols
Date: Mon, 29 Sep 2014 12:31:58 +0200
Message-ID: <20140929103158.GA15475@salvia>
References: <20140926093542.GD26716@breakpoint.cc>
 <alpine.DEB.2.10.1409261212510.18634@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	dborkman@redhat.com
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44981 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbaI2Kar (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:30:47 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1409261212510.18634@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 26, 2014 at 12:13:44PM +0200, Jozsef Kadlecsik wrote:
> On Fri, 26 Sep 2014, Florian Westphal wrote:
> 
> > Given following iptables ruleset:
> > 
> > -P FORWARD DROP
> > -A FORWARD -m sctp --dport 9 -j ACCEPT
> > -A FORWARD -p tcp --dport 80 -j ACCEPT
> > -A FORWARD -p tcp -m conntrack -m state ESTABLISHED,RELATED -j ACCEPT
> > 
> > One would assume that this allows SCTP on port 9 and TCP on port 80.
> > Unfortunately, if the SCTP conntrack module is not loaded, this allows
> > *all* SCTP communication, to pass though, i.e. -p sctp -j ACCEPT,
> > which we think is a security issue.
> > 
> > This is because on the first SCTP packet on port 9, we create a dummy
> > "generic l4" conntrack entry without any port information (since
> > conntrack doesn't know how to extract this information).
> > 
> > All subsequent packets that are unknown will then be in established
> > state since they will fallback to proto_generic and will match the
> > 'generic' entry.
> > 
> > Our originally proposed version [1] completely disabled generic protocol
> > tracking, but Jozsef suggests to not track protocols for which a more
> > suitable helper is available, hence we now mitigate the issue for in
> > tree known ct protocol helpers only, so that at least NAT and direction
> > information will still be preserved for others.
> > 
> >  [1] http://www.spinics.net/lists/netfilter-devel/msg33430.html
> > 
> > Joint work with Daniel Borkmann.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> 
> Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Applied, thanks.

