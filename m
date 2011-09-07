From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: install nf_nat.h and related headers to
 INSTALL_HDR_PATH
Date: Wed, 7 Sep 2011 11:31:04 +0200
Message-ID: <20110907093104.GA9078@1984>
References: <1315075784-10163-1-git-send-email-basile@opensource.dyc.edu>
 <20110905174847.GB32733@1984>
 <4E664E05.4090907@opensource.dyc.edu>
 <alpine.LNX.2.01.1109062001450.19110@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Anthony G. Basile" <basile@opensource.dyc.edu>,
	davem@davemloft.net, kaber@trash.net, blueness@gentoo.org,
	gurligebis@gentoo.org, base-system@gentoo.org, kernel@gentoo.org,
	toolchain@gentoo.org, mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, arnd@arndb.de,
	eparis@redhat.com, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41469 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab1IGQhu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:37:50 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1109062001450.19110@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 06, 2011 at 08:11:30PM +0200, Jan Engelhardt wrote:
> 
> On Tuesday 2011-09-06 18:44, Anthony G. Basile wrote:
> >> 
> >> Could anyone clarify why miniupnpd (or any other application) require
> >> this?
> >> 
> >> Those headers contain structure layouts that may change along time
> >> without further notice, thus breaking backward compatibility.
> >
> >It makes use of
> >
> >   union nf_conntrack_man_proto
> >   struct nf_nat_range
> >   struct nf_nat_multi_range_compat
> 
> miniupnpd is fiddling with the binary representation. Yes, classic
> case of "all the xt headers are exported, just DNAT/SNAT's structs are not".
> 
> Did miniupnpd consider using the text-based interface?

The iptables NAT targets are using this binary representation, so we
should export those definitions. We gain nothing from keeping them
defined privately.
