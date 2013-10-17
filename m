From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH RFC 3/3] acct: add input and output interface index
Date: Thu, 17 Oct 2013 13:33:45 +0200
Message-ID: <20131017113345.GQ13405@imap.eitzenberger.org>
References: <20130926153150.280914229@eitzenberger.org>
 <20130926154005.592908761@eitzenberger.org>
 <20131017110630.GA11148@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Krzysztof Piotr Oledzki <ole@ans.pl>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:53921 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3JQLeA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Oct 2013 07:34:00 -0400
Content-Disposition: inline
In-Reply-To: <20131017110630.GA11148@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> I like patches 1/3 and 2/3, they are nice cleanups.

thanks for looking into this.

> If you only set indev/outdev once we can skip the conntrack extension
> by passing the skb to nf_ct_deliver_cached_events and include this
> information in the conntrack events. That would not allow to dump the
> device from conntrack dumps though. I still have concerns with this
> approach as this doesn't seem to cover the scenario in which the
> in/outdev changes.

I know that doing it this simiple way is only "best effort", as e. g.
with IP multipathing or 802.3ad this information is not % correct
in all cases.

And the question we have to answer is whether this interface
information *has* to be correct in every case, even the less commonly
used cases.

For IPFIX I would answer this question with a 'no'.

And we can later extend this to update the interface information
correctly in every case.  It's only a few patches away.

 /Holger

