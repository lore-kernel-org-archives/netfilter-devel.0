From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH next v3] iptables: add xt_bpf match
Date: Tue, 22 Jan 2013 09:46:57 +0100
Message-ID: <20130122084657.GE8541@breakpoint.cc>
References: <1357776502-21555-1-git-send-email-willemb@google.com>
 <1357776944-28805-1-git-send-email-willemb@google.com>
 <20130117235328.GA16224@1984>
 <CA+FuTSeU8m8Hect+2cT6QOmfNH3oJ8mASOat-zn3-3WwJxJNZg@mail.gmail.com>
 <20130121134434.GA12865@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Willem de Bruijn <willemb@google.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55537 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795Ab3AVIrA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:47:00 -0500
Content-Disposition: inline
In-Reply-To: <20130121134434.GA12865@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Jan 18, 2013 at 11:48:34AM -0500, Willem de Bruijn wrote:
> [...]
> > To compile code right now, the little bpf compiler that I emailed
> > before can be downloaded from
> > http://code.google.com/p/kernel/downloads/detail?name=bpf2decimal.c
> > 
> > I don't think that a compiler has to be shipped with iptables itself,
> > let alone make iptables link against libraries. That said,  it is not
> > impossible to detect pcap.h in configure.ac and optionally enable a
> > "-m bpf --string" mode that calls pcap_compile_nopcap from within
> > libxt_bpf, so let me know if you would like me to code that up. I can
> > also try to send a patch to tcpdump that extends compilation (`-ddd -y
> > <type>`) to arbitrary link layer types.
> 
> We have to decide if:
> 
> a) we add a new hard library dependency to iptables (libpcap) for just
> for one single module, that is, the libxt_bpf depends on libpcap.
> 
> or
> 
> b) provide a separate utility to generate the BPF filter in text-based
> format from some utility that accepts tcpdump-like syntax. The utility
> can be distributed in the utils directory and it would not be
> mandatory to compile it if libpcap is not present.
> 
> I'd like to hear pro and cons arguments from others on this.

a) is arguably more user friendly, however, I don't think we can
   retain the 'text representation' for iptables-save so users
   would still be confronted with the compiled data at some point
   (i.e., they need to write down the original expression anyway to
    figure out what the rule they added 6 months back actually does...)

I would go with b) for now; we can always move to a) later on, but not
the other way around (would kill backwards compatibility).
