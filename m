From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_mark: Add translation to nft
Date: Sat, 19 Dec 2015 18:47:20 +0100
Message-ID: <20151219174720.GA1421@salvia>
References: <20151206033214.GA5939@gmail.com>
 <20151209132600.GA29450@salvia>
 <CAKHNQQF3XFhMJaoi8gBLOeGTLJjxncPQ-s9Tke3nC0FNoGVJjg@mail.gmail.com>
 <CAKHNQQEtTZ0Hg57VcgrOTaFZww-3T8nc8+P1WFq5Ms4Ap2qmbg@mail.gmail.com>
 <CAKHNQQGSbN8QQru8PB9GntbGGBKLT7v3VRYnjhEObshs7qKPcg@mail.gmail.com>
 <20151218214013.GA26438@salvia>
 <CAKHNQQGcET7S+RJENLs+p5zwCe4Xd8FdmJTCT5E-16zjD_PNqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53978 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933015AbbLSRr1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Dec 2015 12:47:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E168C24A0E4
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 18:47:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D1C04DA80B
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 18:47:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 23463DA803
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 18:47:22 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQGcET7S+RJENLs+p5zwCe4Xd8FdmJTCT5E-16zjD_PNqw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 19, 2015 at 07:56:56PM +0530, Shivani Bhardwaj wrote:
> On Sat, Dec 19, 2015 at 3:10 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > But, anyway after applying you patch I can see:
> >
> > # iptables-translate -I INPUT -m mark --mark 10
> > nft insert rule ip filter INPUT ct mark  & xa counter
> >
> > So this kind of work already.
> >
> 
> Hi,
> 
> I just tried adding this rule to nft. It does not work. It only works
> for integer values of mark. nft shows syntax error for ampersand and
> hex values.
>
> Isn't there something wrong? Please let me know.

The line above should be:

nft insert rule ip filter INPUT ct mark & 0xa counter

You have to add a simple table and chain configuration to test it:

nft add table filter
nft add chain filter INPUT { type filter hook input priority 0\; }

The two lines above create a filter table, then it adds an INPUT chain
to that table.

The correct translation for:

iptables-translate -I INPUT -m mark --mark 10

is:

nft insert rule ip filter INPUT ct mark 0xa counter

Then for:

iptables-translate -I INPUT -m mark --mark 10/10

is:

nft insert rule ip filter INPUT ct mark and 0xa == 0xa counter

You have to take the time to find the right translation too and make
sure they work.

Thanks.
