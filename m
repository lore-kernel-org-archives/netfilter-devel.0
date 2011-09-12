From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack (nf_conn) locking question
Date: Mon, 12 Sep 2011 20:53:54 +0200
Message-ID: <20110912185354.GB4018@1984>
References: <CAOAcFN-fXwCrtDu1snSAH-O5ud92bcBS4Dh8fR2m38pc=5hbTA@mail.gmail.com>
 <20110912084557.GA2080@1984>
 <CAOAcFN8DeYAk_sv+f=DrDykEqxd7jQ-yBKCBnqieHOr=RofY5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Gidon Miller <gmiller@vasonanetworks.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52270 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab1ILSx4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Sep 2011 14:53:56 -0400
Content-Disposition: inline
In-Reply-To: <CAOAcFN8DeYAk_sv+f=DrDykEqxd7jQ-yBKCBnqieHOr=RofY5g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 12, 2011 at 01:11:50PM +0300, Gidon Miller wrote:
> Hi Pablo,
> thanks for your reply. can you please refer me to any documentation on
> how to use ct extensions?

Only code, see net/netfilter/nf_conntrack_acct.c for instance.
