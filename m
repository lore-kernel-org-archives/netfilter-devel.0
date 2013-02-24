From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH next v3] iptables: add xt_bpf match
Date: Sat, 23 Feb 2013 18:15:38 -0800
Message-ID: <CAHo-OowT=DBJ5vFjv1wt4kaaM-pMWMh5_dLWxxuod3to-nHA1Q@mail.gmail.com>
References: <1357776502-21555-1-git-send-email-willemb@google.com>
	<1357776944-28805-1-git-send-email-willemb@google.com>
	<20130117235328.GA16224@1984>
	<CA+FuTSeU8m8Hect+2cT6QOmfNH3oJ8mASOat-zn3-3WwJxJNZg@mail.gmail.com>
	<20130121134434.GA12865@1984>
	<20130122084657.GE8541@breakpoint.cc>
	<CA+FuTSfUvDqUOh2f8Z2NJC+ouy_=7UPEhXObz0ZS4mGLxpeQog@mail.gmail.com>
	<20130123162125.GA27000@1984>
	<CA+FuTSdZ=e99f16WKusOr=0KAHq+s8xJbMRQj2tWL3j2bre3MQ@mail.gmail.com>
	<20130123185620.GA6251@1984>
	<CA+FuTScWmRddTC4kOKqF9+4Ama3NJZ5uv=jHVREq5jARU5897w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Willem de Bruijn <willemb@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:46458 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758975Ab3BXCPk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Feb 2013 21:15:40 -0500
Received: by mail-ve0-f177.google.com with SMTP id m1so1487731ves.8
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Feb 2013 18:15:39 -0800 (PST)
In-Reply-To: <CA+FuTScWmRddTC4kOKqF9+4Ama3NJZ5uv=jHVREq5jARU5897w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

at a guess, there should be a --with/without option for it, and if
--with=tool is specified build/configure should fail if support
libraries are missing


On Sun, Feb 17, 2013 at 7:52 PM, Willem de Bruijn <willemb@google.com> wrote:
> On Wed, Jan 23, 2013 at 1:56 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Wed, Jan 23, 2013 at 11:38:20AM -0500, Willem de Bruijn wrote:
>>> On Wed, Jan 23, 2013 at 11:21 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>> > On Wed, Jan 23 2013 at 10:59:28AM -0500, Willem de Bruijn wrote:
>>> >> >> b) provide a separate utility to generate the BPF filter in text-based
>>> >> >> format from some utility that accepts tcpdump-like syntax. The utility
>>> >> >> can be distributed in the utils directory and it would not be
>>> >> >> mandatory to compile it if libpcap is not present.
>>> > [...]
>>> >> > I would go with b) for now; we can always move to a) later on, but not
>>> >> > the other way around (would kill backwards compatibility).
>>> >>
>>> >> This sounds like the consensus (for the record, I also prefer this less
>>> >> disruptive approach). In that case, I can submit a revised libxt_bpf with your
>>> >> suggested changes right away, Pablo, and we can leave the separate
>>> >> userspace tool for a later commit.
>>> >
>>> > Either way is fine, but please we should have that utility compiler
>>> > integrated in the iptables tree by when 3.9-rc1 is released.
>>>
>>> Okay. I'll prepare a separate patch with the pcap-based utility, then.
>
> Just sent the patch. I'm no expert at autoconf and automake, so the
> build logic can conceivably be shorter, but it works for me and the
> logic is straightforward. I forgot to mention in the commit message
> which versions of the tools I used: tested on a ubuntu 12.04 with
> autoconf 2.68, automake 1.9.6 and libtool 2.4.2.
>
>>> Since utils is built as part of the root make invocation, I think it's
>>> better to test for pcap.h in the root configure.ac and add a test in
>>> utils/Makefile.am to build this tool if found, as opposed to creating
>>> a separate configure.ac under utils. We can also discuss these
>>> details after the first version of the patch, of course.
>>
>> That's fine by now, and it's way less bloat.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
