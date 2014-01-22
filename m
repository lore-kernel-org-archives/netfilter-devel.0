From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables add vs replace
Date: Wed, 22 Jan 2014 10:17:25 +0100
Message-ID: <20140122091725.GA4626@localhost>
References: <20140121110645.GC25197@macbook.localnet>
 <20140121112700.GA21772@localhost>
 <CAOkSjBiKGk66N5Ecg8EM27osWVB1Zbn6r-rPu=o8DczjUjpKiA@mail.gmail.com>
 <20140121114524.GA27552@macbook.localnet>
 <20140122083811.GA4228@localhost>
 <20140122085440.GA30195@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58824 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbaAVJR3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:17:29 -0500
Content-Disposition: inline
In-Reply-To: <20140122085440.GA30195@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 22, 2014 at 08:54:40AM +0000, Patrick McHardy wrote:
> On Wed, Jan 22, 2014 at 09:38:11AM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Jan 21, 2014 at 11:45:25AM +0000, Patrick McHardy wrote:
> > [...]
> > > I think the semantics of "flush table" should be changed though. It should
> > > kill *every* object in the table. Perhaps not the base chains, but at least
> > > all rules, non base chain and also sets.
> > 
> > I think we need to add a new flush operation with the new semantics
> > and keep the old one, at least the compat layer needs a flush
> > operation that leaves all chain objects intact to imitate iptables -F.
> 
> How about:
> 
> flush table: flushes everything, removes chains and sets

This is what Arturo has been asking for his new import/export feature.

> flush chains: flushes rules within all chains (iptables -F)
> flush chain: flushes rules within a chain

This last one also allows -F tablename. There's code for these two, so
I think we only need the "massive destruction" flush mode :)
