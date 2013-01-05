From: Eric Leblond <eric@regit.org>
Subject: Re: [nfacct PATCH] Add restore command
Date: Sat, 05 Jan 2013 10:32:01 +0100
Message-ID: <1357378321.14581.1.camel@tiger2>
References: <1356596193-2782-1-git-send-email-eric@regit.org>
	 <20130103004420.GA31385@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:44531 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab3AEJck (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2013 04:32:40 -0500
In-Reply-To: <20130103004420.GA31385@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Thu, 2013-01-03 at 01:44 +0100, Pablo Neira Ayuso wrote:
> On Thu, Dec 27, 2012 at 09:16:33AM +0100, Eric Leblond wrote:
> > This patch adds a 'restore' command to nfacct commands. It takes
> > the output of 'list' command and use it to restore the counters.
> > Basically, the user can save the counter with:
> >  nfacct list >nfacct.dump
> > And restore them with:
> >  nfacct restore <nfacct.dump
> 
> Thanks a lot, this is good, I was expecting someone to take it and to
> add support for that :-).

I've just pushed this patch to nfacct git tree.

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

