Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7AAC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 May 2022 11:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241486AbiETLQv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 May 2022 07:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348302AbiETLQv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 May 2022 07:16:51 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8769369289
        for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2022 04:16:49 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id 3so5372663ily.2
        for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2022 04:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=wVS+xiOuHay31eIatDmLEnLxeMYUNI+1ij3HLmI60O0=;
        b=b0P7WfpY91KSd0jBs9yYdkAdzdBA5ZhhhaTZaTjwsXjbzJEQ2+N41o1II9lue2c2bN
         Tpg9UEvLw1l8eOeYXzYNEPgADPzXcmGCW51vqzxiugP9RluSaLbfexqlgqYUNTvP6OdN
         SM4+42qgsii31w03W6HLlkLmIcq9ytHf5EfXoF9C28X2Vhky0kYh9mg3fsZDBN7wcM5y
         6f0IJztpW5YRvTdt8BR0CCwS5sUnueq8ElSTJmRddLrdg8MkPzvdWRTwnIoFFTvyfiPJ
         ABw453pF+ZY4k+MXeEEoE/URVpPa/DS2k5h2S4VRKUSjy2ecNG9NN/RAWmT8j55evwbv
         yrTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=wVS+xiOuHay31eIatDmLEnLxeMYUNI+1ij3HLmI60O0=;
        b=SuiojDtw33hKO5qwn1AUvcSjJzlq+DM8raN2fhkDhOfhcJUK59SUM3Zjp8HRbI3Ct2
         tZuhIhurhU7NBD/uRpoMwNVjsWg9F5guPkKQEtuHlW+INGK12Buq912QN1NHfp+PG+Az
         x2m/U4MmKDoQE69VfNB8hhBdWGG3Xm071mqKY5XscfX915J23pphMrnhiWobNkWyOlNi
         /oK1oEaIE5P475FzoHNBlqhHi/reHI30TAy4fguDi6VBxra2O7wTtaH3Yd2whO+M/NOQ
         kJ5H6quIdq0MReliIqXtG/RKe+tjpycJ10iNgiwMmAlz4qWTy7gSnygPGiEil1Rblmoz
         /Law==
X-Gm-Message-State: AOAM533tg2Sofo3l2FpCvrLXIM4ck87HxAm00sl9jxCtChSrBAQuTEBO
        U62DZ7g28DAxAwHTFVfnEpLjypxMgW17eevl7cOXFg==
X-Google-Smtp-Source: ABdhPJytVG5rby/0aDbBkmFbZ2A5EmOrtbCAJ4VblTca+0dt5EPDn6n+bhl+CatV4Ce67zufo+PpjDZxEqvpILkLFZA=
X-Received: by 2002:a92:d24e:0:b0:2d0:e923:5427 with SMTP id
 v14-20020a92d24e000000b002d0e9235427mr5092747ilg.287.1653045408742; Fri, 20
 May 2022 04:16:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220518142046.21881-1-phil@nwl.cc> <YoZmTRRCGOVhVQA0@orbyte.nwl.cc>
In-Reply-To: <YoZmTRRCGOVhVQA0@orbyte.nwl.cc>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 20 May 2022 04:16:37 -0700
Message-ID: <CANP3RGdo0z3VhE0z1RS2=5bdigsvdSydNBpWnBLqcyqYS89SQw@mail.gmail.com>
Subject: Re: [iptables PATCH] Revert "fix build for missing ETH_ALEN definition"
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Nick Hainke <vincent@systemli.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 19, 2022 at 8:46 AM Phil Sutter <phil@nwl.cc> wrote:
> Nick, Maciej, does this patch work for you?

Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>

It builds locally, I've also uploaded to:
  https://android-review.googlesource.com/c/platform/external/iptables/+/21=
01317
and we'll see if TreeHugger is happy with it, but I don't see how it
could not be.

---

Note: AOSP is still only at v1.8.7 baseline, with minimal modifications:

diff --stat f485d324e99fc9a9a7fe310b97e1ebf8114b36c6..HEAD
 .gitignore                          |   2 +-
 Android.bp                          |  70 ++++++++++++++++++++++++++++
 METADATA                            |  17 +++++++
 MODULE_LICENSE_GPL                  |   0
 NOTICE                              |   1 +
 OWNERS                              |   2 +
 TEST_MAPPING                        |   9 ++++
 config.h                            |  86 ++++++++++++++++++++++++++++++++=
++
 extensions/Android.bp               | 139
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
 extensions/filter_init              |   7 +++
 extensions/gen_init                 |  36 +++++++++++++++
 extensions/libxt_IDLETIMER.c        |   9 ++++
 extensions/libxt_IDLETIMER.man      |   4 ++
 extensions/libxt_quota2.c           | 141
++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 extensions/libxt_quota2.man         |  37 +++++++++++++++
 include/linux/netfilter/xt_quota2.h |  25 ++++++++++
 include/xtables-version.h           |   2 +
 iptables/Android.bp                 |  87 ++++++++++++++++++++++++++++++++=
++
 iptables/NOTICE                     |   1 +
 iptables/iptables-standalone.c      |   3 ++
 iptables/xtables.lock               |   0
 libiptc/Android.bp                  |  31 +++++++++++++
 libxtables/Android.bp               |  36 +++++++++++++++
 libxtables/xtables.c                |   5 ++
 24 files changed, 749 insertions(+), 1 deletion(-)

I still need to sit down for real and figure out how to upstream the
IDLETIMER/quota2 deviations.
Just never have enough time to figure out what they really do and
which parts are actually truly required...
(there's no documentation or real tests... and some tests that do
exist actively appear to test that stuff *doesn't* work due to bad
assumptions in the test code... see
https://android-review.googlesource.com/c/platform/system/netd/+/1728122
)

I also don't see us switching to nftables any time soon because we
still need to support 4.14 kernels pretty much indefinitely as I've
just learnt.
(I'd also like to switch over from iptables to ebpf for everything
eventually... but that also feels like a pipe dream).

> On Wed, May 18, 2022 at 04:20:46PM +0200, Phil Sutter wrote:
> > This reverts commit c5d9a723b5159a28f547b577711787295a14fd84 as it brok=
e
> > compiling against musl libc. Might be a bug in the latter, but for the
> > time being try to please both by avoiding the include and instead
> > defining ETH_ALEN if unset.
> >
> > While being at it, move netinet/ether.h include up.
> >
> > Fixes: 1bdb5535f561a ("libxtables: Extend MAC address printing/parsing =
support")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  libxtables/xtables.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> > index 96fd783a066cf..0638f9271c601 100644
> > --- a/libxtables/xtables.c
> > +++ b/libxtables/xtables.c
> > @@ -28,6 +28,7 @@
> >  #include <stdlib.h>
> >  #include <string.h>
> >  #include <unistd.h>
> > +#include <netinet/ether.h>
> >  #include <sys/socket.h>
> >  #include <sys/stat.h>
> >  #include <sys/statfs.h>
> > @@ -45,7 +46,6 @@
> >
> >  #include <xtables.h>
> >  #include <limits.h> /* INT_MAX in ip_tables.h/ip6_tables.h */
> > -#include <linux/if_ether.h> /* ETH_ALEN */
> >  #include <linux/netfilter_ipv4/ip_tables.h>
> >  #include <linux/netfilter_ipv6/ip6_tables.h>
> >  #include <libiptc/libxtc.h>
> > @@ -72,6 +72,10 @@
> >  #define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
> >  #endif
> >
> > +#ifndef ETH_ALEN
> > +#define ETH_ALEN 6
> > +#endif
> > +
> >  /* we need this for ip6?tables-restore.  ip6?tables-restore.c sets lin=
e to the
> >   * current line of the input file, in order  to give a more precise er=
ror
> >   * message.  ip6?tables itself doesn't need this, so it is initialized=
 to the
> > @@ -2245,8 +2249,6 @@ void xtables_print_num(uint64_t number, unsigned =
int format)
> >       printf(FMT("%4lluT ","%lluT "), (unsigned long long)number);
> >  }
> >
> > -#include <netinet/ether.h>
> > -
> >  static const unsigned char mac_type_unicast[ETH_ALEN] =3D   {};
> >  static const unsigned char msk_type_unicast[ETH_ALEN] =3D   {1};
> >  static const unsigned char mac_type_multicast[ETH_ALEN] =3D {1};
> > --
> > 2.34.1
> >
> >Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
