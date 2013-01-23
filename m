From: Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH next v3] iptables: add xt_bpf match
Date: Wed, 23 Jan 2013 11:38:20 -0500
Message-ID: <CA+FuTSdZ=e99f16WKusOr=0KAHq+s8xJbMRQj2tWL3j2bre3MQ@mail.gmail.com>
References: <1357776502-21555-1-git-send-email-willemb@google.com>
 <1357776944-28805-1-git-send-email-willemb@google.com> <20130117235328.GA16224@1984>
 <CA+FuTSeU8m8Hect+2cT6QOmfNH3oJ8mASOat-zn3-3WwJxJNZg@mail.gmail.com>
 <20130121134434.GA12865@1984> <20130122084657.GE8541@breakpoint.cc>
 <CA+FuTSfUvDqUOh2f8Z2NJC+ouy_=7UPEhXObz0ZS4mGLxpeQog@mail.gmail.com> <20130123162125.GA27000@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ia0-f169.google.com ([209.85.210.169]:64344 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab3AWQiv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:38:51 -0500
Received: by mail-ia0-f169.google.com with SMTP id j5so4200858iaf.28
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Jan 2013 08:38:51 -0800 (PST)
In-Reply-To: <20130123162125.GA27000@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 23, 2013 at 11:21 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jan 23 2013 at 10:59:28AM -0500, Willem de Bruijn wrote:
>> >> b) provide a separate utility to generate the BPF filter in text-based
>> >> format from some utility that accepts tcpdump-like syntax. The utility
>> >> can be distributed in the utils directory and it would not be
>> >> mandatory to compile it if libpcap is not present.
> [...]
>> > I would go with b) for now; we can always move to a) later on, but not
>> > the other way around (would kill backwards compatibility).
>>
>> This sounds like the consensus (for the record, I also prefer this less
>> disruptive approach). In that case, I can submit a revised libxt_bpf with your
>> suggested changes right away, Pablo, and we can leave the separate
>> userspace tool for a later commit.
>
> Either way is fine, but please we should have that utility compiler
> integrated in the iptables tree by when 3.9-rc1 is released.

Okay. I'll prepare a separate patch with the pcap-based utility, then.

Since utils is built as part of the root make invocation, I think it's
better to test for pcap.h in the root configure.ac and add a test in
utils/Makefile.am to build this tool if found, as opposed to creating
a separate configure.ac under utils. We can also discuss these
details after the first version of the patch, of course.
