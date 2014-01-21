From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: nftables add vs replace
Date: Tue, 21 Jan 2014 14:08:17 +0200
Message-ID: <52DE6331.4030902@linux.intel.com>
References: <20140121110645.GC25197@macbook.localnet> <20140121112700.GA21772@localhost> <CAOkSjBiKGk66N5Ecg8EM27osWVB1Zbn6r-rPu=o8DczjUjpKiA@mail.gmail.com> <52DE5E10.5000403@linux.intel.com> <20140121114955.GA27718@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbaAUMIq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:08:46 -0500
In-Reply-To: <20140121114955.GA27718@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

> I'm working on my proposed solution. So far just the add vs. create,
> the replace command will be a bit more involved.
>
> # src/nft create table filter
> <cmdline>:1:1-19: Error: Could not add table: File exists
> create table filter
> ^^^^^^^^^^^^^^^^^^^
> # src/nft add table filter
> #

Actually, after your patch and Arturo's, it could be possible to improve 
the ruleset management so
it would use create/add/replace accordingly.

Though it means it would need to dump first the targeted tables/chains 
to do so,
thus I am not sure how relevant is my blabbering from performance point 
of view.

Tomasz
