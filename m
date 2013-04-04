From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] utils: bpf_compile
Date: Thu, 4 Apr 2013 11:34:47 +0200
Message-ID: <20130404093447.GA4615@localhost>
References: <51262486.40905@redhat.com>
 <1363103052-5529-1-git-send-email-willemb@google.com>
 <20130401222053.GB26928@localhost>
 <CA+FuTSd4hAGmeC4Z726x7hOJxnqbpf2_pKkCTQxfAvan11W33Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Daniel Borkmann <dborkman@redhat.com>,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
To: Willem de Bruijn <willemb@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33382 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757512Ab3DDJe4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:34:56 -0400
Content-Disposition: inline
In-Reply-To: <CA+FuTSd4hAGmeC4Z726x7hOJxnqbpf2_pKkCTQxfAvan11W33Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 03, 2013 at 11:32:13AM -0400, Willem de Bruijn wrote:
[...]
> > Still missing a hard fail if --enable-bpf-compiler is set and libpcap
> > is not available in the system,
> 
> Compilation and linking will both fail hard:
> 
> if gcc -DHAVE_CONFIG_H -I. -I. -I..  -D_LARGEFILE_SOURCE=1
> -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 -D_REENTRANT
> -DXTABLES_LIBDIR=\"/usr/local/lib/xtables\" -DXTABLES_INTERNAL
> -I../include -I../include   -Wall -Waggregate-return
> -Wmissing-declarations -Wmissing-prototypes -Wredundant-decls -Wshadow
> -Wstrict-prototypes -Winline -pipe -g -O2 -MT nfbpf_compile.o -MD -MP
> -MF ".deps/nfbpf_compile.Tpo" -c -o nfbpf_compile.o nfbpf_compile.c; \
> then mv -f ".deps/nfbpf_compile.Tpo" ".deps/nfbpf_compile.Po"; else rm
> -f ".deps/nfbpf_compile.Tpo"; exit 1; fi
> nfbpf_compile.c:12:18: fatal error: pcap.h: No such file or directory
> compilation terminated.
> make: *** [nfbpf_compile.o] Error 1
> 
> Do you want the configure script itself to fail before that step?

Yes. It should hard fail if --enable-bpf-compiler is set and libpcap
is not available.

> > I'd appreciate if you send me a follow
> > up patch to address this. You may want to have a look at how ulogd2
> > does this in its configure fail as reference.
> 
> That skips compilation if HAVE_PCAP is false, but it does not fail
> hard during configure, either. At least, that's what I gather from
> reading and running
> 
> https://git.netfilter.org/ulogd2/tree/configure.ac#n23

Just pointed to that chunk of code so you can use it as base, you'll
have to adapt it to achieve the behaviour we want, of course.

Thanks.
