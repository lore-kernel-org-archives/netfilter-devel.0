From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] Add support for ttl translation
Date: Mon, 4 Jan 2016 18:44:33 +0100
Message-ID: <20160104174433.GA3947@salvia>
References: <cover.1451927507.git.shivanib134@gmail.com>
 <20160104174024.GA3706@salvia>
 <CAKHNQQG5oxf2cZ-36ohksHC+rSxGJzFGo2a-Ov_gjbCGh8_WvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55620 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbcADRom (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 12:44:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0224A1324CE
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2016 18:44:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E72F9DA7E0
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2016 18:44:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 10669DA807
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2016 18:44:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQG5oxf2cZ-36ohksHC+rSxGJzFGo2a-Ov_gjbCGh8_WvQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 04, 2016 at 11:12:55PM +0530, Shivani Bhardwaj wrote:
> On Mon, Jan 4, 2016 at 11:10 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Jan 04, 2016 at 10:49:10PM +0530, Shivani Bhardwaj wrote:
> >> This patchset adds ttl translation to nftables by adding ip ttl to
> >> the buffer everytime a ttl match is hit as it is necessary to mention
> >> the protocol version with ttl, that is,
> >> $ sudo nft .. ttl 3 ..             won't work but
> >> $ sudo nft .. ip ttl 3 ..          would work.
> >
> > This above is the right syntax.
> >
> >> Also, since adding ip to the buffer in the code for ttl won't look
> >> suitable, some amendments have been done in the nft-ipv4 code.
> >>
> >> Shivani Bhardwaj (2):
> >>   iptables: nft-ipv4: Add ip ttl to the buffer
> >
> > I don't think you need this change for nft-ipv4.
> 
> Hi Pablo,
> 
> Should I be doing xt_buf_add("ip ttl") in the code for ttl?

Yes, that should be fine.
