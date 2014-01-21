From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables add vs replace
Date: Tue, 21 Jan 2014 17:37:23 +0000
Message-ID: <20140121173723.GA19246@macbook.localnet>
References: <20140121110645.GC25197@macbook.localnet>
 <20140121112700.GA21772@localhost>
 <CAOkSjBiKGk66N5Ecg8EM27osWVB1Zbn6r-rPu=o8DczjUjpKiA@mail.gmail.com>
 <20140121114524.GA27552@macbook.localnet>
 <20140121151541.GA23738@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41364 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbaAURh1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:37:27 -0500
Content-Disposition: inline
In-Reply-To: <20140121151541.GA23738@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 07:15:42AM -0800, Phil Oester wrote:
> On Tue, Jan 21, 2014 at 11:45:25AM +0000, Patrick McHardy wrote:
> > I think the semantics of "flush table" should be changed though. It should
> > kill *every* object in the table. Perhaps not the base chains, but at least
> > all rules, non base chain and also sets.
> 
> +1, as current method of having to clear out a table in 2 or 3 steps is
> a major PITA.

I've added it to my TODO list. I don't insist on doing it myself though :)
