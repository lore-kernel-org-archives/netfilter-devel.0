From: Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH next] utils: bpf_compile
Date: Wed, 3 Apr 2013 11:32:13 -0400
Message-ID: <CA+FuTSd4hAGmeC4Z726x7hOJxnqbpf2_pKkCTQxfAvan11W33Q@mail.gmail.com>
References: <51262486.40905@redhat.com> <1363103052-5529-1-git-send-email-willemb@google.com>
 <20130401222053.GB26928@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Daniel Borkmann <dborkman@redhat.com>,
	=?ISO-8859-2?Q?Maciej_=AFenczykowski?= <zenczykowski@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38925 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761060Ab3DCPie (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:38:34 -0400
Received: by mail-wi0-f178.google.com with SMTP id ez12so1665698wid.17
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Apr 2013 08:38:33 -0700 (PDT)
In-Reply-To: <20130401222053.GB26928@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 1, 2013 at 6:20 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Mar 12, 2013 at 11:44:12AM -0400, Willem de Bruijn wrote:
>> V2
>> - update build process to
>>   - succeed without bpf_compiler when --enable-bpf-compiler is not set
>>   - succeed with bpf_compiler when this flag is set and libpcap is found
>>   - fail when this flag is set but libpcap is absent
>> - release memory allocated by pcap on exit
>
> Applied with changes:

Thanks, Pablo.

> * renamed utility to add the `nf' prefix.
>
> * the output of the utility is now exactly what iptables -m bpf --bytecode
>   needs, just to make it easier to everyone.
>
> Still missing a hard fail if --enable-bpf-compiler is set and libpcap
> is not available in the system,

Compilation and linking will both fail hard:

if gcc -DHAVE_CONFIG_H -I. -I. -I..  -D_LARGEFILE_SOURCE=1
-D_LARGE_FILES -D_FILE_OFFSET_BITS=64 -D_REENTRANT
-DXTABLES_LIBDIR=\"/usr/local/lib/xtables\" -DXTABLES_INTERNAL
-I../include -I../include   -Wall -Waggregate-return
-Wmissing-declarations -Wmissing-prototypes -Wredundant-decls -Wshadow
-Wstrict-prototypes -Winline -pipe -g -O2 -MT nfbpf_compile.o -MD -MP
-MF ".deps/nfbpf_compile.Tpo" -c -o nfbpf_compile.o nfbpf_compile.c; \
then mv -f ".deps/nfbpf_compile.Tpo" ".deps/nfbpf_compile.Po"; else rm
-f ".deps/nfbpf_compile.Tpo"; exit 1; fi
nfbpf_compile.c:12:18: fatal error: pcap.h: No such file or directory
compilation terminated.
make: *** [nfbpf_compile.o] Error 1

Do you want the configure script itself to fail before that step?

> I'd appreciate if you send me a follow
> up patch to address this. You may want to have a look at how ulogd2
> does this in its configure fail as reference.

That skips compilation if HAVE_PCAP is false, but it does not fail
hard during configure, either. At least, that's what I gather from
reading and running

https://git.netfilter.org/ulogd2/tree/configure.ac#n23
