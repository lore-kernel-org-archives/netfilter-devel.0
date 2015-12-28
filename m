From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] extensions: libxt_connmark: Add translation to nft
Date: Mon, 28 Dec 2015 13:00:28 +0100
Message-ID: <20151228120028.GA14723@salvia>
References: <20151223143333.GA16694@gmail.com>
 <20151225121352.GA4822@salvia>
 <CAKHNQQGsMzYtziBfCQzdUXeNORaQys7UdCv_DPqiBoPKuvH8nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55739 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbbL1MAd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Dec 2015 07:00:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BC5F71324C2
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 13:00:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AC927DA86D
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 13:00:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B49CDDA80B
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 13:00:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQGsMzYtziBfCQzdUXeNORaQys7UdCv_DPqiBoPKuvH8nw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 25, 2015 at 08:09:40PM +0530, Shivani Bhardwaj wrote:
> On Fri, Dec 25, 2015 at 5:43 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > The size of unsigned long depends on the architecture, so this code
> > will not work correctly.
> >
> > You have to add a connmark_mt_xlate_v0() and connmark_mt_xlate_v1(),
> > in each of these functions you have to cast data to the right
> > structure layout.
> >
> > Thanks.
> 
> Thanks for explaining. I understand it now but why is this patch
> wrong? I have used connmark_xlate() and connmark_mt_xlate() in their
> respective places. Do I still get it wrong?
> 
> I'm correcting this mistake for MARK.

This patch correctly handles what I indicated above, but MARK is still
wrong.

So I'm applying this patch, thanks.
