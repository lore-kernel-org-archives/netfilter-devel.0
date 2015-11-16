From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrackd PATCH v3] conntrackd: add systemd support
Date: Mon, 16 Nov 2015 12:31:44 +0100
Message-ID: <20151116113144.GA16631@salvia>
References: <144741224967.19762.12430502552848102506.stgit@r2d2.cica.es>
 <CAOkSjBim_sssQko+JedaZaa1w=SPVhYKBPvFKW7hGmCFFKXw5A@mail.gmail.com>
 <20151113155431.GA1353@salvia>
 <CAOkSjBjPGx+bsuiEshN8SCnKqhs3fSAEnPOQFz08MmhMDNrQfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40033 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbbKPLbp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Nov 2015 06:31:45 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2AC78613B8
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 12:31:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1C8471788EC
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 12:31:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2EB9517891F
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 12:31:42 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAOkSjBjPGx+bsuiEshN8SCnKqhs3fSAEnPOQFz08MmhMDNrQfw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 16, 2015 at 11:54:57AM +0100, Arturo Borrero Gonzalez wrote:
> On 13 November 2015 at 16:54, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >>
> >> Perhaps it makes sense to factorize all of the conntrackd
> >> configuration examples in a single man page, let's say
> >> 'conntrackd.conf(5)'.
> >
> > Absolutely, a manpage is good to have.
> 
> It's ok if I wait until this patch is merged?

Yes, you can send a follow up patch for this thing. Thanks.
