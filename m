From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [netfilter-core] [PATCH] netfilter: nfnetlink_queue: Unregister
 pernet subsys in case of init failure
Date: Wed, 9 Dec 2015 14:48:25 +0100
Message-ID: <20151209134825.GA1183@salvia>
References: <1449483206-22618-1-git-send-email-kernel@kyup.com>
 <56657BA5.6070303@cogentembedded.com>
 <56658284.9080009@kyup.com>
 <20151207131746.GA27860@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	netdev@vger.kernel.org, fruggeri@arista.com,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	kadlec@blackhole.kfki.hu, davem@davemloft.net
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39191 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbbLINsb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 08:48:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 51B8B1324D9
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:48:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3F91DDA7E0
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:48:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 68D0FDA862
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:48:26 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151207131746.GA27860@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 07, 2015 at 02:17:46PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Dec 07, 2015 at 02:58:44PM +0200, Nikolay Borisov wrote:
> > 
> > 
> > On 12/07/2015 02:29 PM, Sergei Shtylyov wrote:
> > > Hello.
> > > 
> > > On 12/07/2015 01:13 PM, Nikolay Borisov wrote:
> > > 
> > >> Commit 3bfe049807c2403 ('netfilter: nfnetlink_{log,queue}:
> > > 
> > >    Double quotes please, that's what scripts/checkpatch.pl enforces now.
> > > 
> > >> Register pernet in first place') reorganised the initialisation
> > >> order of the pernet_subsys to avoid "use-before-initialised"
> > >> condition. However, in doing so the cleanup logic in nfnetlink_queue
> > >> got botched in that the pernet_subsys wasn't cleaned in case
> > >> nfnetlink_subsys_register failed. This patch adds the necessary
> > >> cleanup routine call.
> > >>
> > >> Fixes: 3bfe049807c2403 ('netfilter: nfnetlink_{log,queue}: Register
> > >>                         pernet in first place')
> > > 
> > >    Likewise.
> > 
> > I will resend it with proper quotes (even though I think this is a minor
> > issue) but I'd like to first gather some review feedback.
> 
> Unless someone spots any other more relevant problem with this, I'll
> fix this comestic issues here, no need to resend.

Applied, thanks.
