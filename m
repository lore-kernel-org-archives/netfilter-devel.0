From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH next v3] iptables: add xt_bpf match
Date: Tue, 22 Jan 2013 10:46:17 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301221021060.31599@blackhole.kfki.hu>
References: <1357776502-21555-1-git-send-email-willemb@google.com> <1357776944-28805-1-git-send-email-willemb@google.com> <20130117235328.GA16224@1984> <CA+FuTSeU8m8Hect+2cT6QOmfNH3oJ8mASOat-zn3-3WwJxJNZg@mail.gmail.com> <20130121134434.GA12865@1984>
 <20130122084657.GE8541@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Willem de Bruijn <willemb@google.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:58723 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab3AVJqU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:46:20 -0500
In-Reply-To: <20130122084657.GE8541@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 22 Jan 2013, Florian Westphal wrote:

> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Jan 18, 2013 at 11:48:34AM -0500, Willem de Bruijn wrote:
> > [...]
> > > To compile code right now, the little bpf compiler that I emailed
> > > before can be downloaded from
> > > http://code.google.com/p/kernel/downloads/detail?name=bpf2decimal.c
> > > 
> > > I don't think that a compiler has to be shipped with iptables itself,
> > > let alone make iptables link against libraries. That said,  it is not
> > > impossible to detect pcap.h in configure.ac and optionally enable a
> > > "-m bpf --string" mode that calls pcap_compile_nopcap from within
> > > libxt_bpf, so let me know if you would like me to code that up. I can
> > > also try to send a patch to tcpdump that extends compilation (`-ddd -y
> > > <type>`) to arbitrary link layer types.
> > 
> > We have to decide if:
> > 
> > a) we add a new hard library dependency to iptables (libpcap) for just
> > for one single module, that is, the libxt_bpf depends on libpcap.
> > 
> > or
> > 
> > b) provide a separate utility to generate the BPF filter in text-based
> > format from some utility that accepts tcpdump-like syntax. The utility
> > can be distributed in the utils directory and it would not be
> > mandatory to compile it if libpcap is not present.
> > 
> > I'd like to hear pro and cons arguments from others on this.
> 
> a) is arguably more user friendly, however, I don't think we can
>    retain the 'text representation' for iptables-save so users
>    would still be confronted with the compiled data at some point
>    (i.e., they need to write down the original expression anyway to
>     figure out what the rule they added 6 months back actually does...)
> 
> I would go with b) for now; we can always move to a) later on, but not
> the other way around (would kill backwards compatibility).

Yes, let's go with b). (But from packaging point of view 
utils/bpf2decimal.c depending on libpcap is not much different from 
extensions/libxt_bpf.c depending on libpcap.)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
