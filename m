From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_nat: fix buffer overflow in IRC NAT
 helper
Date: Tue, 31 Dec 2013 18:35:45 +0100
Message-ID: <20131231173545.GA4004@localhost>
References: <1388503719-17766-1-git-send-email-dborkman@redhat.com>
 <20131231172952.GA3857@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Harald Welte <laforge@gnumonks.org>,
	Noel Butler <noel.butler@ausics.net>
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40184 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab3LaRfw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Dec 2013 12:35:52 -0500
Content-Disposition: inline
In-Reply-To: <20131231172952.GA3857@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 31, 2013 at 06:29:52PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Dec 31, 2013 at 04:28:39PM +0100, Daniel Borkmann wrote:
> > Commit 5901b6be885e attempted to introduce IPv6 support into
> > IRC NAT helper. By doing so, the following code seemed to be removed
> > by accident:
> > 
> >   ip = ntohl(exp->master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip);
> >   sprintf(buffer, "%u %u", ip, port);
> >   pr_debug("nf_nat_irc: inserting '%s' == %pI4, port %u\n", buffer, &ip, port);
> > 
> > This leads to the fact that buffer[] was left uninitialized and
> > contained some stack value. When we call nf_nat_mangle_tcp_packet(),
> > we call strlen(buffer) on excatly this uninitialized buffer. If we
> > are unlucky and the skb has enough tailroom, we overwrite resp. leak
> > contents with values that sit on our stack into the packet and send
> > that out to the receiver.
> > 
> > Since the rather informal DCC spec [1] does not seem to specify
> > IPv6 support right now, we log such occurences so that admins can
> > act accordingly, and drop the packet. I've looked into XChat source,
> > and IPv6 is not supported there: addresses are in u32 and print
> > via %u format string.
> > 
> > Therefore, restore old behaviour as in IPv4, use snprintf(), and
> > log IPv6 packets for now (maybe if there's consensus one day, we
> > can still add support here). By this, we can safely use strlen(buffer)
> > in nf_nat_mangle_tcp_packet() and prevent a buffer overflow. Also
> > simplify some code as we now have ct variable anyway.
> > 
> >   [1] http://www.irchelp.org/irchelp/rfc/ctcpspec.html
> 
> Thanks Daniel.
> 
> No need for red blinking light on...

Oh well, this also affects IPv4. Will pass this to master. Thanks.
