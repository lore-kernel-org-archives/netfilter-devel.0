From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables add vs replace
Date: Tue, 21 Jan 2014 12:11:48 +0000
Message-ID: <20140121121147.GB30577@macbook.localnet>
References: <20140121110645.GC25197@macbook.localnet>
 <20140121112700.GA21772@localhost>
 <CAOkSjBiKGk66N5Ecg8EM27osWVB1Zbn6r-rPu=o8DczjUjpKiA@mail.gmail.com>
 <52DE5E10.5000403@linux.intel.com>
 <20140121114955.GA27718@macbook.localnet>
 <52DE6331.4030902@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38773 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbaAUMLw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:11:52 -0500
Content-Disposition: inline
In-Reply-To: <52DE6331.4030902@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 02:08:17PM +0200, Tomasz Bursztyka wrote:
> Hi Patrick,
> 
> >I'm working on my proposed solution. So far just the add vs. create,
> >the replace command will be a bit more involved.
> >
> ># src/nft create table filter
> ><cmdline>:1:1-19: Error: Could not add table: File exists
> >create table filter
> >^^^^^^^^^^^^^^^^^^^
> ># src/nft add table filter
> >#
> 
> Actually, after your patch and Arturo's, it could be possible to
> improve the ruleset management so
> it would use create/add/replace accordingly.
> 
> Though it means it would need to dump first the targeted
> tables/chains to do so,
> thus I am not sure how relevant is my blabbering from performance
> point of view.

How would that work? Dumping rules, flushing the old ones and reinstalling
them is prone to race conditions.
