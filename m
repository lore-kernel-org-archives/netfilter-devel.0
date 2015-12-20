From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_mark: Add translation to nft
Date: Sun, 20 Dec 2015 03:18:45 +0100
Message-ID: <20151220021845.GA946@salvia>
References: <CAKHNQQF3XFhMJaoi8gBLOeGTLJjxncPQ-s9Tke3nC0FNoGVJjg@mail.gmail.com>
 <CAKHNQQEtTZ0Hg57VcgrOTaFZww-3T8nc8+P1WFq5Ms4Ap2qmbg@mail.gmail.com>
 <CAKHNQQGSbN8QQru8PB9GntbGGBKLT7v3VRYnjhEObshs7qKPcg@mail.gmail.com>
 <20151218214013.GA26438@salvia>
 <CAKHNQQGcET7S+RJENLs+p5zwCe4Xd8FdmJTCT5E-16zjD_PNqw@mail.gmail.com>
 <20151219174720.GA1421@salvia>
 <CAKHNQQGddf+RKXceY6X_wWHv5Nok10FRw2bZUA044kaOyt15RQ@mail.gmail.com>
 <CAKHNQQE+_cy2d59ro-Uth0Lkr8U3DK-ovcYjOXja_Z4_Di1mvw@mail.gmail.com>
 <20151219183443.GA2170@salvia>
 <CAKHNQQEPML7UN+0+tE0pzAvr2GRRdAOi61q8b1TDvYZVYLM7xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56928 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbbLTCS4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Dec 2015 21:18:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 60AE911E5A5
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Dec 2015 03:18:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5090EDA7FF
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Dec 2015 03:18:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 766BFDA7FF
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Dec 2015 03:18:50 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQEPML7UN+0+tE0pzAvr2GRRdAOi61q8b1TDvYZVYLM7xw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 20, 2015 at 01:06:33AM +0530, Shivani Bhardwaj wrote:
> On Sun, Dec 20, 2015 at 12:04 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sat, Dec 19, 2015 at 11:51:14PM +0530, Shivani Bhardwaj wrote:
> >> Ampersand again causes syntax error. However, it works fine as below:
> >>
> >> nft insert rule ip filter INPUT ct mark 0xa counter
> >
> > Yes, that is fine as I indicated in a previous email.
> 
> Thank you.
> Could you please tell why ct mark and not simply mark?

This should obviously be simply mark, not ct mark.
