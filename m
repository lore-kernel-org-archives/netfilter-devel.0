From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next v3] iptables: add xt_bpf match
Date: Mon, 21 Jan 2013 14:44:34 +0100
Message-ID: <20130121134434.GA12865@1984>
References: <1357776502-21555-1-git-send-email-willemb@google.com>
 <1357776944-28805-1-git-send-email-willemb@google.com>
 <20130117235328.GA16224@1984>
 <CA+FuTSeU8m8Hect+2cT6QOmfNH3oJ8mASOat-zn3-3WwJxJNZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Florian Westphal <fw@strlen.de>
To: Willem de Bruijn <willemb@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56823 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab3AUNom (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:44:42 -0500
Content-Disposition: inline
In-Reply-To: <CA+FuTSeU8m8Hect+2cT6QOmfNH3oJ8mASOat-zn3-3WwJxJNZg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 18, 2013 at 11:48:34AM -0500, Willem de Bruijn wrote:
[...]
> To compile code right now, the little bpf compiler that I emailed
> before can be downloaded from
> http://code.google.com/p/kernel/downloads/detail?name=bpf2decimal.c
> 
> I don't think that a compiler has to be shipped with iptables itself,
> let alone make iptables link against libraries. That said,  it is not
> impossible to detect pcap.h in configure.ac and optionally enable a
> "-m bpf --string" mode that calls pcap_compile_nopcap from within
> libxt_bpf, so let me know if you would like me to code that up. I can
> also try to send a patch to tcpdump that extends compilation (`-ddd -y
> <type>`) to arbitrary link layer types.

We have to decide if:

a) we add a new hard library dependency to iptables (libpcap) for just
for one single module, that is, the libxt_bpf depends on libpcap.

or

b) provide a separate utility to generate the BPF filter in text-based
format from some utility that accepts tcpdump-like syntax. The utility
can be distributed in the utils directory and it would not be
mandatory to compile it if libpcap is not present.

I'd like to hear pro and cons arguments from others on this.
