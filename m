From: Florian Westphal <fw@strlen.de>
Subject: nfqueue: detect when packet has already been checksummed?
Date: Sun, 26 May 2013 22:48:26 +0200
Message-ID: <20130526204826.GC6578@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: nf-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36794 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755110Ab3EZUs2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 May 2013 16:48:28 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@strlen.de>)
	id 1Ughre-0000tQ-UD
	for netfilter-devel@vger.kernel.org; Sun, 26 May 2013 22:48:27 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

When using nfqueue, userspace currently has no way
to tell wheter queued packets have a bad checksum, i.e.
applications that need data integrity must do full checksum
validation in userspace (except maybe when only queueing in OUTPUT).

However, there are several places where incoming packets are already
checksummed in kernel, before packet hits nfqueue, e.g. via nic rx
csum offload, or in conntrack.

So I think it would be nice to provide a hint that kernel already did
checksumming.

The SKB_INFO attribute added in -net for GRO support seems like a
candidate.  However, since 'already checksummed' is the common case this
would mean adding that attribute most of the time.

Unless we would do the opposite hint, i.e. tell userspace when
checksumming has NOT been performed yet.

Such change would however need to go into -net, else userspace can't tell
'checksum ok' from 'kernel too old to provide flag in SKB_INFO attribute'.

Following patch illustrates what I had in mind, adding hint for incoming
packets and packets that are most likely not locally generated (forwarded
packet in POSTROUTING).

Comments appreciated.
