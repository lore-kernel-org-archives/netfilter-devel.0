From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables add vs replace
Date: Wed, 22 Jan 2014 08:54:40 +0000
Message-ID: <20140122085440.GA30195@macbook.localnet>
References: <20140121110645.GC25197@macbook.localnet>
 <20140121112700.GA21772@localhost>
 <CAOkSjBiKGk66N5Ecg8EM27osWVB1Zbn6r-rPu=o8DczjUjpKiA@mail.gmail.com>
 <20140121114524.GA27552@macbook.localnet>
 <20140122083811.GA4228@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47344 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaAVIyo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:54:44 -0500
Content-Disposition: inline
In-Reply-To: <20140122083811.GA4228@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 22, 2014 at 09:38:11AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 21, 2014 at 11:45:25AM +0000, Patrick McHardy wrote:
> [...]
> > I think the semantics of "flush table" should be changed though. It should
> > kill *every* object in the table. Perhaps not the base chains, but at least
> > all rules, non base chain and also sets.
> 
> I think we need to add a new flush operation with the new semantics
> and keep the old one, at least the compat layer needs a flush
> operation that leaves all chain objects intact to imitate iptables -F.

How about:

flush table: flushes everything, removes chains and sets
flush chains: flushes rules within all chains (iptables -F)
flush chain: flushes rules within a chain
