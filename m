From: Florian Westphal <fw@strlen.de>
Subject: Re: Packet loss when using NFQUEUE and nf_conntrack_ipv4
Date: Fri, 19 Jul 2013 11:25:47 +0200
Message-ID: <20130719092547.GF22686@breakpoint.cc>
References: <CAOmdcgVVgPxB2BV0qxoXVquPVt-21+JvYq0ywFu7=RiJ4i7JXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Daniel Collins <daniel.collins@smoothwall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39847 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509Ab3GSJZu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:25:50 -0400
Content-Disposition: inline
In-Reply-To: <CAOmdcgVVgPxB2BV0qxoXVquPVt-21+JvYq0ywFu7=RiJ4i7JXQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Daniel Collins <daniel.collins@smoothwall.net> wrote:
> NF_ACCEPT'd using nfq_set_verdict and forwarded on by the kernel, as
> expected. Any packets transmitted within a small window (microseconds,
> depending on hardware) after the first packet, are received by the
> userspace program, the call to nfq_set_verdict suceeds but the kernel
> doesn't forward the packet on. Any packets transmitted after this
> window are received and forwarded correctly.
> 
> Is this a known issue?

Yes.  The packets are tossed because the conntrack they're associated
with is unconfirmed, and on reinject they clash with the unconfirmed
ct of the 1st packet that has been inserted into the conntrack table.

The packets that arrive after the first packet has left the box
go through because the conntrack lookup finds an existing
entry.
