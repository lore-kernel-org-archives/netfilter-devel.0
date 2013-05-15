From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] xtables-addons: xt_RAWNAT: skb writable part might not
 include whole l4 header (ipv4 case).
Date: Wed, 15 May 2013 17:04:45 +0200
Message-ID: <20130515150445.GA5614@localhost>
References: <20130505220504.1a3f2380a1e798b37e628dd1@highloadlab.com>
 <20130505222433.5c27056103b98340bba773df@highloadlab.com>
 <alpine.LNX.2.01.1305081322250.29391@nerf07.vanv.qr>
 <20130508191202.4cb5233820bbb96a1e611329@highloadlab.com>
 <alpine.LNX.2.01.1305082320440.21875@nerf07.vanv.qr>
 <20130513135020.ea2e50fc6327fb3ffe9cb667@highloadlab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: Dmitry Popov <dp@highloadlab.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34323 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759275Ab3EOPEx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 11:04:53 -0400
Content-Disposition: inline
In-Reply-To: <20130513135020.ea2e50fc6327fb3ffe9cb667@highloadlab.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 13, 2013 at 01:50:20PM +0400, Dmitry Popov wrote:
> On Wed, 8 May 2013 23:32:16 +0200 (CEST)
> Jan Engelhardt <jengelh@inai.de> wrote:
> 
> > The only way to solve the NAT problem is to do without it.
> > Full NAT is not simple at all, it requires DPI.
> > RAWNAT is just a dumb l3addr replacer and does not help
> > getting multi-connection sessions (such as 959ish FTP) going.
> 
> Well, in means of full nat - yes. I have no statistics of how people use 
> nf_nat/xt_RAWNAT, but in my tasks I have a lot of packets that do
> not need DPI.

Not only DPI. You're also leaking your network topology though ICMP
error messages, as the internal header is not mangled.
