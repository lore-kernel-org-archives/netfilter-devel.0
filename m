From: Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH next v3] iptables: add xt_bpf match
Date: Wed, 27 Feb 2013 15:39:50 -0500
Message-ID: <CA+FuTSfaf1E1qkB6DEPqZQeUZcYv1DxHdprzrKG528N3zkuO4g@mail.gmail.com>
References: <1357776502-21555-1-git-send-email-willemb@google.com>
 <1357776944-28805-1-git-send-email-willemb@google.com> <20130117235328.GA16224@1984>
 <CA+FuTSeU8m8Hect+2cT6QOmfNH3oJ8mASOat-zn3-3WwJxJNZg@mail.gmail.com>
 <20130121134434.GA12865@1984> <20130122084657.GE8541@breakpoint.cc>
 <CA+FuTSfUvDqUOh2f8Z2NJC+ouy_=7UPEhXObz0ZS4mGLxpeQog@mail.gmail.com>
 <20130123162125.GA27000@1984> <CA+FuTSdZ=e99f16WKusOr=0KAHq+s8xJbMRQj2tWL3j2bre3MQ@mail.gmail.com>
 <20130123185620.GA6251@1984> <CA+FuTScWmRddTC4kOKqF9+4Ama3NJZ5uv=jHVREq5jARU5897w@mail.gmail.com>
 <CAHo-OowT=DBJ5vFjv1wt4kaaM-pMWMh5_dLWxxuod3to-nHA1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: =?ISO-8859-2?Q?Maciej_=AFenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:59512 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533Ab3B0UkV convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2013 15:40:21 -0500
Received: by mail-ie0-f179.google.com with SMTP id k11so1149070iea.24
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Feb 2013 12:40:21 -0800 (PST)
In-Reply-To: <CAHo-OowT=DBJ5vFjv1wt4kaaM-pMWMh5_dLWxxuod3to-nHA1Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Feb 23, 2013 at 9:15 PM, Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
> at a guess, there should be a --with/without option for it, and if
> --with=3Dtool is specified build/configure should fail if support
> libraries are missing

Agreed on the fail hard.

After a brief offline discussion on --enable vs --with, will respin
with optional --enable-bpf-compiler. The option is disabled by
default. If it is enabled and pcap cannot be found, build fails.

If no further comments, I'll respin shortly.

>
> On Sun, Feb 17, 2013 at 7:52 PM, Willem de Bruijn <willemb@google.com=
> wrote:
>> On Wed, Jan 23, 2013 at 1:56 PM, Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>>> On Wed, Jan 23, 2013 at 11:38:20AM -0500, Willem de Bruijn wrote:
>>>> On Wed, Jan 23, 2013 at 11:21 AM, Pablo Neira Ayuso <pablo@netfilt=
er.org> wrote:
>>>> > On Wed, Jan 23 2013 at 10:59:28AM -0500, Willem de Bruijn wrote:
>>>> >> >> b) provide a separate utility to generate the BPF filter in =
text-based
>>>> >> >> format from some utility that accepts tcpdump-like syntax. T=
he utility
>>>> >> >> can be distributed in the utils directory and it would not b=
e
>>>> >> >> mandatory to compile it if libpcap is not present.
>>>> > [...]
>>>> >> > I would go with b) for now; we can always move to a) later on=
, but not
>>>> >> > the other way around (would kill backwards compatibility).
>>>> >>
>>>> >> This sounds like the consensus (for the record, I also prefer t=
his less
>>>> >> disruptive approach). In that case, I can submit a revised libx=
t_bpf with your
>>>> >> suggested changes right away, Pablo, and we can leave the separ=
ate
>>>> >> userspace tool for a later commit.
>>>> >
>>>> > Either way is fine, but please we should have that utility compi=
ler
>>>> > integrated in the iptables tree by when 3.9-rc1 is released.
>>>>
>>>> Okay. I'll prepare a separate patch with the pcap-based utility, t=
hen.
>>
>> Just sent the patch. I'm no expert at autoconf and automake, so the
>> build logic can conceivably be shorter, but it works for me and the
>> logic is straightforward. I forgot to mention in the commit message
>> which versions of the tools I used: tested on a ubuntu 12.04 with
>> autoconf 2.68, automake 1.9.6 and libtool 2.4.2.
>>
>>>> Since utils is built as part of the root make invocation, I think =
it's
>>>> better to test for pcap.h in the root configure.ac and add a test =
in
>>>> utils/Makefile.am to build this tool if found, as opposed to creat=
ing
>>>> a separate configure.ac under utils. We can also discuss these
>>>> details after the first version of the patch, of course.
>>>
>>> That's fine by now, and it's way less bloat.
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter-=
devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
