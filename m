From: Florian Westphal <fw@strlen.de>
Subject: Re: using nft & iptables nat in parallel
Date: Wed, 14 Jun 2017 11:58:03 +0200
Message-ID: <20170614095803.GC10130@breakpoint.cc>
References: <20170614092448.GB10130@breakpoint.cc>
 <CAOkSjBiSrj_V0nJoV8zXmfN-0mDcbfYEuf_knAnp+cHgOa=ePA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52846 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751608AbdFNJ6m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Jun 2017 05:58:42 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBiSrj_V0nJoV8zXmfN-0mDcbfYEuf_knAnp+cHgOa=ePA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arturo Borrero Gonzalez <arturo@debian.org> wrote:
> I'm curious, What is the use case of using both nftables and iptables
> at the same time?
> Some missing functionality in nft?
> Perhaps some ipt->nft partial migration procedure?

Yes, partial migration.

Right now there are an awful lot of tools out there (docker, libvirt,
kubernetes, ..) that call iptables(-restore) directly (or inject them via
firewalld).

And unfortunately I don't see how we can magically move all of this
to nftables.

So allowing to do a step-by-step migration seems the only viable
option.
