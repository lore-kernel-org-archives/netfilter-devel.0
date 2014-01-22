From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables add vs replace
Date: Wed, 22 Jan 2014 09:38:11 +0100
Message-ID: <20140122083811.GA4228@localhost>
References: <20140121110645.GC25197@macbook.localnet>
 <20140121112700.GA21772@localhost>
 <CAOkSjBiKGk66N5Ecg8EM27osWVB1Zbn6r-rPu=o8DczjUjpKiA@mail.gmail.com>
 <20140121114524.GA27552@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47379 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbaAVIiR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:38:17 -0500
Content-Disposition: inline
In-Reply-To: <20140121114524.GA27552@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 11:45:25AM +0000, Patrick McHardy wrote:
[...]
> I think the semantics of "flush table" should be changed though. It should
> kill *every* object in the table. Perhaps not the base chains, but at least
> all rules, non base chain and also sets.

I think we need to add a new flush operation with the new semantics
and keep the old one, at least the compat layer needs a flush
operation that leaves all chain objects intact to imitate iptables -F.
